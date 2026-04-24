"""Runtime contracts for the SevakAI pipeline."""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from enum import StrEnum
from typing import Any


def utc_now_iso() -> str:
    """Return a stable UTC timestamp string."""

    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


class MessageSource(StrEnum):
    WHATSAPP = "WHATSAPP"
    SMS = "SMS"
    VOICE_TRANSCRIPT = "VOICE_TRANSCRIPT"
    UNKNOWN = "UNKNOWN"


class ProcessingStatus(StrEnum):
    QUEUED = "QUEUED"
    PROCESSING = "PROCESSING"
    DONE = "DONE"
    FAILED = "FAILED"


class Intent(StrEnum):
    NEED = "NEED"
    OFFER = "OFFER"
    STATUS = "STATUS"
    NOISE = "NOISE"


class DisasterType(StrEnum):
    FLOOD = "FLOOD"
    FIRE = "FIRE"
    LANDSLIDE = "LANDSLIDE"
    CYCLONE = "CYCLONE"
    HEATWAVE = "HEATWAVE"
    EARTHQUAKE = "EARTHQUAKE"
    OTHER = "OTHER"


class ProcessingMode(StrEnum):
    CLOUD = "CLOUD"
    OFFLINE = "OFFLINE"
    LOCAL_FALLBACK = "LOCAL_FALLBACK"


class OfflinePriorityBand(StrEnum):
    URGENT = "URGENT"
    NON_URGENT = "NON_URGENT"


@dataclass(slots=True)
class ParsedInboundMessage:
    source: MessageSource
    sender_phone: str | None
    body: str
    provider_message_id: str | None
    received_at: str = field(default_factory=utc_now_iso)
    media_urls: list[str] = field(default_factory=list)
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass(slots=True)
class ValidationResult:
    is_valid: bool
    normalized_text: str
    errors: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)


@dataclass(slots=True)
class LabelPrediction:
    label: str
    confidence: float
    evidence: list[str] = field(default_factory=list)


@dataclass(slots=True)
class LocationResolution:
    raw: str | None = None
    lat: float | None = None
    lng: float | None = None
    confidence: float = 0.0
    landmark: str | None = None
    pincode: str | None = None
    accuracy_meters: int | None = None


@dataclass(slots=True)
class NormalizedMessage:
    id: str
    source: MessageSource
    sender_phone: str | None
    body: str
    clean_body: str
    received_at: str
    provider_message_id: str | None = None
    media_urls: list[str] = field(default_factory=list)
    language_hint: str | None = None
    metadata: dict[str, Any] = field(default_factory=dict)
    message_hash: str | None = None
    processing_status: ProcessingStatus = ProcessingStatus.QUEUED


@dataclass(slots=True)
class RouteDecision:
    mode: ProcessingMode
    reason: str
    pending_cloud_processing: bool = False


@dataclass(slots=True)
class GeminiGeneration:
    model: str
    text: str
    parsed_json: dict[str, Any] | None
    latency_ms: int
    used_network: bool
    error: str | None = None


@dataclass(slots=True)
class TriagedMessage:
    normalized_message_id: str
    intent: Intent
    priority: int
    disaster_type: DisasterType
    needs: list[str]
    affected_count: int | None
    vulnerable_groups: list[str]
    location_raw: str | None
    location_resolved: LocationResolution | None
    language: str
    ai_model: str
    ai_prompt_version: str
    confidence: float
    processing_ms: int
    summary: str
    recommended_skills: list[str] = field(default_factory=list)
    resource_signals: list[str] = field(default_factory=list)
    requires_follow_up: bool = False
    pending_cloud_processing: bool = False
    route: ProcessingMode = ProcessingMode.LOCAL_FALLBACK
    validation_warnings: list[str] = field(default_factory=list)
    duplicate_suspected: bool = False
    metadata: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    def to_json(self) -> str:
        return json.dumps(self.to_dict(), indent=2, ensure_ascii=False)
