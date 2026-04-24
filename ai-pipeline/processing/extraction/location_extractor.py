"""Extract and resolve locations from relief messages."""

from __future__ import annotations

import re

from models.contracts import LocationResolution


class LocationExtractor:
    """Use local landmark tables before any external geocoding."""

    KNOWN_LOCATIONS = {
        "sangli": {"lat": 16.8524, "lng": 74.5815, "pincode": "416416", "accuracy_meters": 1200},
        "solapur": {"lat": 17.6599, "lng": 75.9064, "pincode": "413001", "accuracy_meters": 1500},
        "kolhapur": {"lat": 16.7050, "lng": 74.2433, "pincode": "416003", "accuracy_meters": 1300},
        "kolhapur bus stand": {"lat": 16.7048, "lng": 74.2439, "pincode": "416003", "accuracy_meters": 250},
        "miraj": {"lat": 16.8221, "lng": 74.6429, "pincode": "416410", "accuracy_meters": 1400},
        "islampur": {"lat": 17.0380, "lng": 74.2691, "pincode": "415409", "accuracy_meters": 1300},
        "lal chowk": {"lat": 34.0722, "lng": 74.8090, "pincode": "190001", "accuracy_meters": 350},
        "wayanad": {"lat": 11.6854, "lng": 76.1320, "pincode": "673121", "accuracy_meters": 2500},
        "chennai": {"lat": 13.0827, "lng": 80.2707, "pincode": "600001", "accuracy_meters": 2400},
        "ward 7": {"lat": 16.7050, "lng": 74.2433, "pincode": None, "accuracy_meters": 800},
    }

    PINCODE_MAP = {
        "416416": "sangli",
        "413001": "solapur",
        "416003": "kolhapur",
        "416410": "miraj",
        "415409": "islampur",
        "190001": "lal chowk",
    }

    LOCATION_PATTERNS = [
        r"\bnear\s+([a-z0-9\s-]{3,40})",
        r"\bin\s+([a-z0-9\s-]{3,40})",
        r"\bat\s+([a-z0-9\s-]{3,40})",
        r"\baround\s+([a-z0-9\s-]{3,40})",
        r"\b([a-z0-9\s-]{3,40})\s+ke\s+paas\b",
        r"\b([a-z0-9\s-]{3,40})\s+ke\s+pass\b",
    ]

    STOP_WORDS = {
        "urgent",
        "immediately",
        "asap",
        "please",
        "help",
        "need",
        "now",
        "camp",
        "zone",
        "area",
    }
    BREAK_WORDS = {
        "for",
        "after",
        "with",
        "because",
        "where",
        "there",
    }

    def extract(self, text: str) -> tuple[str | None, LocationResolution | None]:
        lowered = (text or "").lower()

        pincode_match = re.search(r"\b\d{6}\b", lowered)
        if pincode_match:
            pincode = pincode_match.group(0)
            mapped_location = self.PINCODE_MAP.get(pincode)
            if mapped_location:
                resolution = self._resolve(mapped_location)
                if resolution is not None:
                    resolution.raw = pincode
                    resolution.pincode = pincode
                    resolution.confidence = max(resolution.confidence, 0.76)
                    return (pincode, resolution)

        raw_location = self._extract_raw_location(lowered)
        if raw_location:
            resolution = self._resolve(raw_location)
            if resolution is not None:
                resolution.raw = raw_location
                return (raw_location, resolution)
            return (raw_location, LocationResolution(raw=raw_location, confidence=0.36))

        for known_location in sorted(self.KNOWN_LOCATIONS, key=len, reverse=True):
            if known_location in lowered:
                resolution = self._resolve(known_location)
                if resolution is not None:
                    resolution.raw = known_location
                    return (known_location, resolution)

        return (None, None)

    def _extract_raw_location(self, lowered_text: str) -> str | None:
        for pattern in self.LOCATION_PATTERNS:
            match = re.search(pattern, lowered_text, flags=re.IGNORECASE)
            if not match:
                continue
            candidate = self._clean_candidate(match.group(1))
            if candidate:
                return candidate
        return None

    def _clean_candidate(self, candidate: str) -> str | None:
        cleaned_parts: list[str] = []
        for part in candidate.split():
            if part in self.BREAK_WORDS or part.isdigit():
                break
            if part in self.STOP_WORDS:
                continue
            cleaned_parts.append(part)
        cleaned = " ".join(cleaned_parts).strip(" ,.-")
        return cleaned or None

    def _resolve(self, location_text: str) -> LocationResolution | None:
        normalized = location_text.strip().lower()
        if not normalized:
            return None

        if normalized in self.KNOWN_LOCATIONS:
            matched = self.KNOWN_LOCATIONS[normalized]
            return LocationResolution(
                raw=normalized,
                lat=matched["lat"],
                lng=matched["lng"],
                confidence=0.83,
                landmark=normalized.title(),
                pincode=matched["pincode"],
                accuracy_meters=matched["accuracy_meters"],
            )

        for label, matched in self.KNOWN_LOCATIONS.items():
            if label in normalized or normalized in label:
                return LocationResolution(
                    raw=normalized,
                    lat=matched["lat"],
                    lng=matched["lng"],
                    confidence=0.69,
                    landmark=label.title(),
                    pincode=matched["pincode"],
                    accuracy_meters=matched["accuracy_meters"],
                )

        return None
