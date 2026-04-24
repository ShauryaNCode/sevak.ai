"""Offline-first fallback triage for no-connectivity mode."""

from __future__ import annotations

import os

from models.contracts import (
    DisasterType,
    Intent,
    NormalizedMessage,
    OfflinePriorityBand,
    ProcessingMode,
    TriagedMessage,
)
from processing.classification.disaster_type_tagger import DisasterTypeTagger
from processing.classification.intent_classifier import IntentClassifier
from processing.nlp.language_detector import LanguageDetector


class OfflineTriageModel:
    """Cheap heuristic classifier used when cloud inference is unavailable."""

    URGENT_KEYWORDS = {"urgent", "emergency", "rescue", "trapped", "ambulance", "immediately", "now"}

    def __init__(self, model_path: str | None = None) -> None:
        self.model_path = model_path or os.getenv(
            "OFFLINE_MODEL_PATH",
            "models/offline/tflite/sevakai_triage_v1.tflite",
        )
        self.intent_classifier = IntentClassifier()
        self.language_detector = LanguageDetector()
        self.disaster_tagger = DisasterTypeTagger()

    def predict(self, message: NormalizedMessage) -> TriagedMessage:
        language, _ = self.language_detector.detect(message.clean_body)
        intent_prediction = self.intent_classifier.classify(message.clean_body)
        disaster_prediction = self.disaster_tagger.tag(message.clean_body)

        urgent = any(keyword in message.clean_body.lower() for keyword in self.URGENT_KEYWORDS)
        priority_band = OfflinePriorityBand.URGENT if urgent else OfflinePriorityBand.NON_URGENT
        priority = 5 if urgent else 2
        intent = self._coerce_intent(intent_prediction.label)
        disaster_type = self._coerce_disaster_type(disaster_prediction.label)

        return TriagedMessage(
            normalized_message_id=message.id,
            intent=intent,
            priority=priority,
            disaster_type=disaster_type,
            needs=[],
            affected_count=None,
            vulnerable_groups=[],
            location_raw=None,
            location_resolved=None,
            language=language,
            ai_model="offline-rule-triage-v1",
            ai_prompt_version="offline-v1",
            confidence=round(max(intent_prediction.confidence - 0.1, 0.45), 2),
            processing_ms=0,
            summary=f"Offline triage marked message as {priority_band.value.lower()} with intent {intent.value.lower()}.",
            pending_cloud_processing=True,
            requires_follow_up=intent == Intent.NEED,
            route=ProcessingMode.OFFLINE,
            metadata={
                "offline_priority_band": priority_band.value,
                "offline_model_path": self.model_path,
                "intent_evidence": intent_prediction.evidence,
                "disaster_evidence": disaster_prediction.evidence,
            },
        )

    def _coerce_intent(self, raw_label: str) -> Intent:
        try:
            return Intent(raw_label)
        except ValueError:
            return Intent.NOISE

    def _coerce_disaster_type(self, raw_label: str) -> DisasterType:
        try:
            return DisasterType(raw_label)
        except ValueError:
            return DisasterType.OTHER
