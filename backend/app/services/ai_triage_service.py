"""Rule-based AI-ready triage helpers."""

from __future__ import annotations

import hashlib
import re

from app.schemas.common import WebhookParseResult


class AITriageService:
    """Rule-based parser that can later be replaced by richer AI pipelines."""

    KNOWN_ZONE_COORDINATES = {
        "sangli": {"lat": 16.8524, "lng": 74.5815, "pincode": "416416"},
        "sangli community center": {"lat": 16.8602, "lng": 74.5754, "pincode": "416416"},
        "kolhapur": {"lat": 16.7050, "lng": 74.2433, "pincode": "416003"},
        "kolhapur bus stand": {"lat": 16.7048, "lng": 74.2439, "pincode": "416003"},
        "satara": {"lat": 17.6805, "lng": 74.0183, "pincode": "415001"},
        "miraj": {"lat": 16.8221, "lng": 74.6429, "pincode": "416410"},
        "islampur": {"lat": 17.0380, "lng": 74.2691, "pincode": "415409"},
    }
    NEED_TYPE_KEYWORDS = {
        "medical": {"medical", "medicine", "doctor", "ambulance"},
        "food": {"food", "meal", "ration", "hungry"},
        "water": {"water", "drinking water", "thirsty"},
        "shelter": {"shelter", "tent", "roof", "home"},
    }
    URGENCY_KEYWORDS = {
        "high": {"urgent", "immediately", "asap", "emergency"},
        "medium": {"soon", "needed"},
        "low": {"whenever"},
    }

    def parse_whatsapp_message(self, raw_text: str) -> WebhookParseResult:
        """Convert a raw inbound message into a structured triage result."""

        lowered = raw_text.strip().lower()
        need_type = self._match_keyword(lowered, self.NEED_TYPE_KEYWORDS)
        urgency = self._match_keyword(lowered, self.URGENCY_KEYWORDS) or "medium"
        pincode_match = re.search(r"\b\d{6}\b", lowered)
        location_name = self._extract_location_name(lowered)
        location_match = self._resolve_location(location_name or lowered)

        vulnerability_score = 0.5
        if any(token in lowered for token in ("child", "elderly", "pregnant", "disabled")):
            vulnerability_score = 0.9

        confidence = 0.2
        if need_type:
            confidence += 0.4
        if location_name or pincode_match:
            confidence += 0.2
        if urgency:
            confidence += 0.2

        return WebhookParseResult(
            need_type=need_type,
            urgency=urgency,
            location_name=(location_name or location_match.get("label")) if location_match else location_name,
            pincode=pincode_match.group(0) if pincode_match else (location_match.get("pincode") if location_match else None),
            lat=location_match.get("lat") if location_match else None,
            lng=location_match.get("lng") if location_match else None,
            vulnerability_score=vulnerability_score,
            confidence=min(confidence, 1.0),
        )

    def build_message_fingerprint(self, sender_number: str | None, raw_text: str) -> str:
        """Create a deterministic fingerprint for deduplication."""

        normalized_sender = (sender_number or "").strip().lower()
        normalized_text = " ".join(raw_text.strip().lower().split())
        return hashlib.sha256(f"{normalized_sender}:{normalized_text}".encode("utf-8")).hexdigest()

    def _match_keyword(self, text: str, keyword_map: dict[str, set[str]]) -> str | None:
        for label, keywords in keyword_map.items():
            if any(keyword in text for keyword in keywords):
                return label
        return None

    def _extract_location_name(self, text: str) -> str | None:
        patterns = [
            r"\bin\s+([a-zA-Z\s]+?)(?:\s+(?:urgent|immediately|asap|please|help)|$)",
            r"\bat\s+([a-zA-Z\s]+?)(?:\s+(?:urgent|immediately|asap|please|help)|$)",
            r"\bnear\s+([a-zA-Z\s]+?)(?:\s+(?:urgent|immediately|asap|please|help)|$)",
        ]
        for pattern in patterns:
            match = re.search(pattern, text, flags=re.IGNORECASE)
            if match:
                return match.group(1).strip().title()
        return None

    def _resolve_location(self, text: str) -> dict[str, str | float] | None:
        normalized_text = text.strip().lower()
        if not normalized_text:
            return None

        if normalized_text in self.KNOWN_ZONE_COORDINATES:
            mapped = dict(self.KNOWN_ZONE_COORDINATES[normalized_text])
            mapped["label"] = normalized_text.title()
            return mapped

        for keyword, coordinates in self.KNOWN_ZONE_COORDINATES.items():
            if keyword in normalized_text:
                mapped = dict(coordinates)
                mapped["label"] = keyword.title()
                return mapped

        return None
