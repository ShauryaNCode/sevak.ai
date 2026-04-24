"""End-to-end SevakAI pipeline orchestration."""

from __future__ import annotations

from time import perf_counter
from typing import Any

from ingestion.normalizers.message_normalizer import MessageNormalizer
from ingestion.parsers.sms_parser import SMSParser
from ingestion.parsers.voice_transcript_parser import VoiceTranscriptParser
from ingestion.parsers.whatsapp_parser import WhatsAppParser
from ingestion.validators.dedup_engine import DedupEngine
from ingestion.validators.message_validator import MessageValidator
from models.cloud.gemini_client import GeminiClient
from models.cloud.model_router import ModelRouter
from models.contracts import (
    DisasterType,
    Intent,
    LocationResolution,
    MessageSource,
    NormalizedMessage,
    ParsedInboundMessage,
    ProcessingMode,
    RouteDecision,
    TriagedMessage,
)
from models.offline.offline_triage_model import OfflineTriageModel
from processing.classification.disaster_type_tagger import DisasterTypeTagger
from processing.classification.intent_classifier import IntentClassifier
from processing.classification.priority_scorer import PriorityScorer
from processing.extraction.entity_extractor import EntityExtractor
from processing.nlp.language_detector import LanguageDetector
from prompts.registry import PromptRegistry


class TriagePipeline:
    """Parse, validate, route, and triage disaster messages."""

    RESPONSE_SCHEMA = {
        "intent": "NEED | OFFER | STATUS | NOISE",
        "priority": "integer 1-5",
        "disaster_type": "FLOOD | FIRE | LANDSLIDE | CYCLONE | HEATWAVE | EARTHQUAKE | OTHER",
        "needs": ["FOOD", "WATER", "SHELTER", "MEDICAL", "RESCUE", "CLOTHING", "SANITATION"],
        "affected_count": "integer | null",
        "vulnerable_groups": ["CHILDREN", "ELDERLY", "PREGNANT", "DISABLED"],
        "location_raw": "string | null",
        "language": "string",
        "confidence": "float 0-1",
    }

    def __init__(self) -> None:
        self.whatsapp_parser = WhatsAppParser()
        self.sms_parser = SMSParser()
        self.voice_parser = VoiceTranscriptParser()
        self.validator = MessageValidator()
        self.normalizer = MessageNormalizer()
        self.dedup_engine = DedupEngine()
        self.language_detector = LanguageDetector()
        self.intent_classifier = IntentClassifier()
        self.disaster_tagger = DisasterTypeTagger()
        self.priority_scorer = PriorityScorer()
        self.entity_extractor = EntityExtractor()
        self.prompt_registry = PromptRegistry()
        self.gemini_client = GeminiClient()
        self.model_router = ModelRouter(self.gemini_client)
        self.offline_model = OfflineTriageModel()

    def process_payload(
        self,
        source: str,
        payload: str | dict[str, Any],
        connectivity_available: bool | None = None,
    ) -> TriagedMessage:
        parsed_message = self._parse_payload(source, payload)
        return self.process_message(parsed_message, connectivity_available=connectivity_available)

    def process_text(
        self,
        body: str,
        source: str = "WHATSAPP",
        sender_phone: str | None = None,
        provider_message_id: str | None = None,
        connectivity_available: bool | None = None,
    ) -> TriagedMessage:
        parsed_message = ParsedInboundMessage(
            source=MessageSource(source.upper()),
            sender_phone=sender_phone,
            body=body,
            provider_message_id=provider_message_id,
        )
        return self.process_message(parsed_message, connectivity_available=connectivity_available)

    def process_message(
        self,
        parsed_message: ParsedInboundMessage,
        connectivity_available: bool | None = None,
    ) -> TriagedMessage:
        started = perf_counter()

        validation = self.validator.validate(parsed_message)
        if not validation.is_valid:
            raise ValueError(f"Invalid message for triage: {', '.join(validation.errors)}")

        normalized = self.normalizer.normalize(parsed_message, cleaned_text=validation.normalized_text)
        duplicate_suspected = bool(normalized.message_hash and self.dedup_engine.is_duplicate(normalized.message_hash))
        if normalized.message_hash:
            self.dedup_engine.remember(normalized.message_hash)

        route = self.model_router.route(normalized, connectivity_available=connectivity_available)
        if route.mode == ProcessingMode.OFFLINE:
            offline_result = self.offline_model.predict(normalized)
            offline_result.processing_ms = int((perf_counter() - started) * 1000)
            offline_result.validation_warnings = validation.warnings
            offline_result.duplicate_suspected = duplicate_suspected
            offline_result.metadata["route_reason"] = route.reason
            return offline_result

        heuristic = self._run_heuristic_pipeline(normalized)
        cloud_generation = None
        selected_model = "local-rule-triage-v1"
        prompt_version = "local-fallback-v1"

        if route.mode == ProcessingMode.CLOUD:
            prompt_version = "v1"
            selected_model = self.model_router.select_cloud_model(normalized)
            prompt = self.prompt_registry.render(
                "triage",
                {
                    "source": normalized.source.value,
                    "received_at": normalized.received_at,
                    "language_hint": normalized.language_hint or heuristic["language"],
                    "body": normalized.clean_body,
                    "response_schema": self.RESPONSE_SCHEMA,
                },
                prompt_version=prompt_version,
            )
            cloud_generation = self.gemini_client.generate_structured_triage(prompt, model=selected_model)
            heuristic = self._merge_cloud_result(heuristic, cloud_generation.parsed_json)

        triaged = self._build_triaged_message(
            normalized=normalized,
            heuristic=heuristic,
            route=route,
            ai_model=selected_model if route.mode == ProcessingMode.CLOUD else "local-rule-triage-v1",
            prompt_version=prompt_version,
            processing_ms=int((perf_counter() - started) * 1000),
            validation_warnings=validation.warnings,
            duplicate_suspected=duplicate_suspected,
            cloud_generation=cloud_generation,
        )
        return triaged

    def _parse_payload(self, source: str, payload: str | dict[str, Any]) -> ParsedInboundMessage:
        source_name = source.upper()
        if source_name == MessageSource.WHATSAPP.value:
            return self.whatsapp_parser.parse(payload)
        if source_name == MessageSource.SMS.value:
            return self.sms_parser.parse(payload)
        if source_name == MessageSource.VOICE_TRANSCRIPT.value:
            return self.voice_parser.parse(payload)
        raise ValueError(f"Unsupported source: {source}")

    def _run_heuristic_pipeline(self, normalized: NormalizedMessage) -> dict[str, Any]:
        language, language_confidence = self.language_detector.detect(normalized.clean_body)
        intent_prediction = self.intent_classifier.classify(normalized.clean_body)
        disaster_prediction = self.disaster_tagger.tag(normalized.clean_body)
        entities = self.entity_extractor.extract(normalized.clean_body)
        priority, priority_reasons = self.priority_scorer.score(
            text=normalized.clean_body,
            intent=intent_prediction.label,
            disaster_type=disaster_prediction.label,
            needs=entities["needs"],
            affected_count=entities["affected_count"],
            vulnerable_groups=entities["vulnerable_groups"],
        )

        recommended_skills, resource_signals = self._build_recommendations(
            entities["needs"],
            disaster_prediction.label,
        )
        confidence = self._combine_confidence(
            language_confidence,
            intent_prediction.confidence,
            disaster_prediction.confidence,
            entities["location_resolved"].confidence if entities["location_resolved"] else 0.35,
            0.76 if entities["needs"] else 0.4,
        )

        return {
            "intent": intent_prediction.label,
            "priority": priority,
            "disaster_type": disaster_prediction.label,
            "needs": entities["needs"],
            "affected_count": entities["affected_count"],
            "vulnerable_groups": entities["vulnerable_groups"],
            "location_raw": entities["location_raw"],
            "location_resolved": entities["location_resolved"],
            "language": language,
            "confidence": confidence,
            "recommended_skills": recommended_skills,
            "resource_signals": resource_signals,
            "requires_follow_up": self._requires_follow_up(
                intent=intent_prediction.label,
                needs=entities["needs"],
                location_resolved=entities["location_resolved"],
            ),
            "summary": self._build_summary(
                intent=intent_prediction.label,
                needs=entities["needs"],
                location_raw=entities["location_raw"],
                affected_count=entities["affected_count"],
                priority=priority,
            ),
            "evidence": {
                "intent": intent_prediction.evidence,
                "disaster": disaster_prediction.evidence,
                "priority": priority_reasons,
            },
        }

    def _build_triaged_message(
        self,
        normalized: NormalizedMessage,
        heuristic: dict[str, Any],
        route: RouteDecision,
        ai_model: str,
        prompt_version: str,
        processing_ms: int,
        validation_warnings: list[str],
        duplicate_suspected: bool,
        cloud_generation: Any,
    ) -> TriagedMessage:
        intent = self._coerce_intent(heuristic["intent"])
        disaster_type = self._coerce_disaster_type(heuristic["disaster_type"])
        location_resolved = heuristic.get("location_resolved")
        if isinstance(location_resolved, dict):
            location_resolved = LocationResolution(**location_resolved)

        metadata = {
            "route_reason": route.reason,
            "evidence": heuristic.get("evidence", {}),
            "cloud_used": bool(cloud_generation and cloud_generation.used_network),
            "cloud_error": cloud_generation.error if cloud_generation else None,
        }
        if cloud_generation:
            metadata["cloud_latency_ms"] = cloud_generation.latency_ms

        return TriagedMessage(
            normalized_message_id=normalized.id,
            intent=intent,
            priority=int(heuristic["priority"]),
            disaster_type=disaster_type,
            needs=list(heuristic["needs"]),
            affected_count=heuristic["affected_count"],
            vulnerable_groups=list(heuristic["vulnerable_groups"]),
            location_raw=heuristic["location_raw"],
            location_resolved=location_resolved,
            language=str(heuristic["language"]),
            ai_model=ai_model,
            ai_prompt_version=prompt_version,
            confidence=float(heuristic["confidence"]),
            processing_ms=processing_ms,
            summary=str(heuristic["summary"]),
            recommended_skills=list(heuristic["recommended_skills"]),
            resource_signals=list(heuristic["resource_signals"]),
            requires_follow_up=bool(heuristic["requires_follow_up"]),
            pending_cloud_processing=route.pending_cloud_processing,
            route=route.mode,
            validation_warnings=list(validation_warnings),
            duplicate_suspected=duplicate_suspected,
            metadata=metadata,
        )

    def _merge_cloud_result(self, heuristic: dict[str, Any], cloud_result: dict[str, Any] | None) -> dict[str, Any]:
        if not cloud_result:
            return heuristic

        merged = dict(heuristic)
        for key in (
            "intent",
            "priority",
            "disaster_type",
            "needs",
            "affected_count",
            "vulnerable_groups",
            "location_raw",
            "language",
            "confidence",
        ):
            value = cloud_result.get(key)
            if value in (None, "", []):
                continue
            merged[key] = value

        return merged

    def _build_recommendations(self, needs: list[str], disaster_type: str) -> tuple[list[str], list[str]]:
        skill_map = {
            "FOOD": ["LOGISTICS", "COMMUNITY_KITCHEN"],
            "WATER": ["LOGISTICS", "WASH"],
            "SHELTER": ["SHELTER_MANAGEMENT", "LOGISTICS"],
            "MEDICAL": ["MEDICAL", "FIRST_AID"],
            "RESCUE": ["SEARCH_RESCUE", "BOAT_OPERATION"],
            "CLOTHING": ["LOGISTICS"],
            "SANITATION": ["WASH"],
        }
        resource_map = {
            "FOOD": ["FOOD_PACKET"],
            "WATER": ["WATER_BOTTLE"],
            "SHELTER": ["TENT", "BLANKET"],
            "MEDICAL": ["MEDICINE", "AMBULANCE"],
            "RESCUE": ["BOAT", "LIFE_JACKET"],
            "CLOTHING": ["CLOTHING_KIT"],
            "SANITATION": ["HYGIENE_KIT"],
        }

        recommended_skills: list[str] = []
        resource_signals: list[str] = []
        for need in needs:
            recommended_skills.extend(skill_map.get(need, []))
            resource_signals.extend(resource_map.get(need, []))

        if disaster_type == DisasterType.FLOOD.value:
            recommended_skills.append("SWIFT_WATER_RESCUE")
            resource_signals.append("WATER_PUMP")
        if disaster_type == DisasterType.FIRE.value:
            recommended_skills.append("FIRE_RESPONSE")
            resource_signals.append("FIRE_ENGINE")

        return (sorted(set(recommended_skills)), sorted(set(resource_signals)))

    def _build_summary(
        self,
        intent: str,
        needs: list[str],
        location_raw: str | None,
        affected_count: int | None,
        priority: int,
    ) -> str:
        parts = [intent.title()]
        if needs:
            parts.append(f"needs {', '.join(needs)}")
        if affected_count:
            parts.append(f"affecting about {affected_count} people")
        if location_raw:
            parts.append(f"near {location_raw}")
        parts.append(f"priority {priority}")
        return "; ".join(parts)

    def _requires_follow_up(
        self,
        intent: str,
        needs: list[str],
        location_resolved: LocationResolution | None,
    ) -> bool:
        if intent != Intent.NEED.value:
            return False
        return not needs or location_resolved is None

    def _combine_confidence(self, *values: float) -> float:
        safe_values = [max(0.0, min(1.0, value)) for value in values]
        return round(sum(safe_values) / len(safe_values), 2)

    def _coerce_intent(self, raw_label: str) -> Intent:
        try:
            return Intent(str(raw_label).upper())
        except ValueError:
            return Intent.NOISE

    def _coerce_disaster_type(self, raw_label: str) -> DisasterType:
        try:
            return DisasterType(str(raw_label).upper())
        except ValueError:
            return DisasterType.OTHER
