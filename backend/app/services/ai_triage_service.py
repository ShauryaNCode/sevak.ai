"""Bridge backend webhook ingestion to the standalone ai-pipeline package."""

from __future__ import annotations

import hashlib
import importlib
import logging
import os
import sys
from pathlib import Path
from typing import Any

from app.schemas.communication import ChannelName, InboundMessage
from app.schemas.common import WebhookParseResult


logger = logging.getLogger(__name__)


class AITriageService:
    """Thin adapter that lets the backend consume the ai-pipeline output."""

    NEED_PRIORITY = [
        "RESCUE",
        "MEDICAL",
        "WATER",
        "FOOD",
        "SHELTER",
        "CLOTHING",
        "SANITATION",
    ]
    NEED_TYPE_MAP = {
        "RESCUE": "rescue",
        "MEDICAL": "medical",
        "FOOD": "food",
        "WATER": "water",
        "SHELTER": "shelter",
        "CLOTHING": "shelter",
        "SANITATION": "water",
    }

    def __init__(self) -> None:
        self.pipeline_root = self._resolve_pipeline_root()
        self.pipeline = self._load_pipeline()

    @property
    def is_available(self) -> bool:
        """Whether the standalone ai-pipeline was loaded successfully."""

        return self.pipeline is not None

    def health_snapshot(self) -> dict[str, Any]:
        """Return a lightweight integration snapshot for diagnostics."""

        return {
            "available": self.is_available,
            "pipeline_root": str(self.pipeline_root),
            "pipeline_class": type(self.pipeline).__name__ if self.pipeline is not None else None,
        }

    def parse_message(self, raw_text: str) -> WebhookParseResult:
        """Backward-compatible parser for callers that do not pass channel metadata."""

        return self._parse_with_pipeline(raw_text, source="WHATSAPP")

    def parse_inbound_message(self, inbound: InboundMessage) -> WebhookParseResult:
        """Parse an inbound backend message using the ai-pipeline."""

        source = "SMS" if inbound.channel == ChannelName.sms else "WHATSAPP"
        return self._parse_with_pipeline(inbound.raw_text, source=source)

    def parse_whatsapp_message(self, raw_text: str) -> WebhookParseResult:
        """Backward-compatible wrapper for WhatsApp parsing."""

        return self._parse_with_pipeline(raw_text, source="WHATSAPP")

    def parse_sms_message(self, raw_text: str) -> WebhookParseResult:
        """Backward-compatible wrapper for SMS parsing."""

        return self._parse_with_pipeline(raw_text, source="SMS")

    def debug_parse_text(
        self,
        raw_text: str,
        source: str = "WHATSAPP",
        connectivity_available: bool = True,
    ) -> WebhookParseResult:
        """Parse arbitrary raw text through the same ai-pipeline bridge."""

        if self.pipeline is None:
            raise RuntimeError("AI pipeline could not be initialized")

        triaged = self.pipeline.process_text(
            body=raw_text,
            source=source,
            connectivity_available=connectivity_available,
        )

        location = triaged.location_resolved
        location_name = None
        pincode = None
        lat = None
        lng = None
        if location is not None:
            location_name = location.landmark or (location.raw.title() if location.raw else None)
            pincode = location.pincode
            lat = location.lat
            lng = location.lng
        elif triaged.location_raw:
            location_name = triaged.location_raw.title()

        return WebhookParseResult(
            need_type=self._select_primary_need_type(list(triaged.needs)),
            urgency=self._map_priority_to_urgency(triaged.priority),
            location_name=location_name,
            pincode=pincode,
            lat=lat,
            lng=lng,
            vulnerability_score=self._calculate_vulnerability_score(
                vulnerable_groups=triaged.vulnerable_groups,
                affected_count=triaged.affected_count,
            ),
            confidence=triaged.confidence,
            intent=triaged.intent.value,
            priority=triaged.priority,
            disaster_type=triaged.disaster_type.value,
            needs=list(triaged.needs),
            affected_count=triaged.affected_count,
            vulnerable_groups=list(triaged.vulnerable_groups),
            language=triaged.language,
            route=triaged.route.value,
            summary=triaged.summary,
            ai_model=triaged.ai_model,
            ai_prompt_version=triaged.ai_prompt_version,
            requires_follow_up=triaged.requires_follow_up,
            pending_cloud_processing=triaged.pending_cloud_processing,
            processing_ms=triaged.processing_ms,
        )

    def build_message_fingerprint(self, sender_number: str | None, raw_text: str) -> str:
        """Create a deterministic fingerprint for deduplication."""

        normalized_sender = self.normalize_sender(sender_number)
        normalized_text = " ".join(raw_text.strip().lower().split())
        return hashlib.sha256(f"{normalized_sender}:{normalized_text}".encode("utf-8")).hexdigest()

    def normalize_sender(self, sender_number: str | None) -> str:
        """Normalize sender identifiers across SMS and WhatsApp providers."""

        normalized_sender = (sender_number or "").strip().lower()
        if normalized_sender.startswith("whatsapp:"):
            normalized_sender = normalized_sender.split(":", maxsplit=1)[1]
        return normalized_sender

    def _parse_with_pipeline(self, raw_text: str, source: str) -> WebhookParseResult:
        if self.pipeline is None:
            raise RuntimeError("AI pipeline could not be initialized")

        triaged = self.pipeline.process_text(
            body=raw_text,
            source=source,
            connectivity_available=True,
        )

        location = triaged.location_resolved
        needs = list(triaged.needs)
        location_name = None
        pincode = None
        lat = None
        lng = None
        if location is not None:
            location_name = location.landmark or (location.raw.title() if location.raw else None)
            pincode = location.pincode
            lat = location.lat
            lng = location.lng
        elif triaged.location_raw:
            location_name = triaged.location_raw.title()

        return WebhookParseResult(
            need_type=self._select_primary_need_type(needs),
            urgency=self._map_priority_to_urgency(triaged.priority),
            location_name=location_name,
            pincode=pincode,
            lat=lat,
            lng=lng,
            vulnerability_score=self._calculate_vulnerability_score(
                vulnerable_groups=triaged.vulnerable_groups,
                affected_count=triaged.affected_count,
            ),
            confidence=triaged.confidence,
            intent=triaged.intent.value,
            priority=triaged.priority,
            disaster_type=triaged.disaster_type.value,
            needs=needs,
            affected_count=triaged.affected_count,
            vulnerable_groups=list(triaged.vulnerable_groups),
            language=triaged.language,
            route=triaged.route.value,
            summary=triaged.summary,
            ai_model=triaged.ai_model,
            ai_prompt_version=triaged.ai_prompt_version,
            requires_follow_up=triaged.requires_follow_up,
            pending_cloud_processing=triaged.pending_cloud_processing,
            processing_ms=triaged.processing_ms,
        )

    def _select_primary_need_type(self, needs: list[str]) -> str | None:
        for need in self.NEED_PRIORITY:
            if need in needs:
                return self.NEED_TYPE_MAP[need]
        return None

    def _map_priority_to_urgency(self, priority: int) -> str:
        if priority >= 4:
            return "high"
        if priority >= 2:
            return "medium"
        return "low"

    def _calculate_vulnerability_score(
        self,
        vulnerable_groups: list[str],
        affected_count: int | None,
    ) -> float:
        score = 0.5
        score += min(0.3, 0.12 * len(vulnerable_groups))
        if affected_count is not None and affected_count >= 10:
            score += 0.1
        if affected_count is not None and affected_count >= 50:
            score += 0.1
        return min(score, 1.0)

    def _load_pipeline(self) -> Any:
        if not self.pipeline_root.exists():
            logger.error("Configured ai-pipeline path does not exist: %s", self.pipeline_root)
            return None

        pipeline_root_str = str(self.pipeline_root)
        if pipeline_root_str not in sys.path:
            sys.path.insert(0, pipeline_root_str)

        try:
            pipeline_module = importlib.import_module("pipeline")
        except Exception:
            logger.exception("Unable to import ai-pipeline")
            return None

        module_file = Path(getattr(pipeline_module, "__file__", "")).resolve()
        if module_file.parent != self.pipeline_root.resolve():
            logger.error("Imported unexpected pipeline module from %s", module_file)
            return None

        pipeline_class = getattr(pipeline_module, "TriagePipeline", None)
        if pipeline_class is None:
            logger.error("TriagePipeline class not found in ai-pipeline")
            return None
        return pipeline_class()

    def _resolve_pipeline_root(self) -> Path:
        configured_path = os.getenv("SEVAK_AI_PIPELINE_PATH")
        if configured_path:
            return Path(configured_path).resolve()

        repo_root = Path(__file__).resolve().parents[3]
        return repo_root / "ai-pipeline"
