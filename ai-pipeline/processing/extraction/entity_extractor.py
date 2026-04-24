"""Extract structured entities from relief messages."""

from __future__ import annotations

import re

from processing.extraction.location_extractor import LocationExtractor
from processing.extraction.needs_extractor import NeedsExtractor
from processing.nlp.transliterator import Transliterator


class EntityExtractor:
    """Pull out counts, needs, vulnerabilities, and location hints."""

    VULNERABLE_GROUP_KEYWORDS = {
        "CHILDREN": {"children", "child", "kids", "infant"},
        "ELDERLY": {"elderly", "senior", "old age", "buzurg"},
        "PREGNANT": {"pregnant", "pregnancy"},
        "DISABLED": {"disabled", "divyang", "wheelchair"},
    }

    PEOPLE_PATTERNS = [
        r"\b(\d{1,4})\s*(?:people|persons|families|households|villagers|log|jan)\b",
        r"\b(\d{1,4})\s*(?:children|kids|patients|elders)\b",
    ]

    def __init__(self) -> None:
        self.needs_extractor = NeedsExtractor()
        self.location_extractor = LocationExtractor()
        self.transliterator = Transliterator()

    def extract(self, text: str) -> dict[str, object]:
        canonical = self.transliterator.to_canonical_text(text)
        affected_count = self._extract_affected_count(canonical)
        vulnerable_groups = self._extract_vulnerable_groups(canonical)
        location_raw, location_resolved = self.location_extractor.extract(text)

        return {
            "needs": self.needs_extractor.extract(canonical),
            "affected_count": affected_count,
            "vulnerable_groups": vulnerable_groups,
            "location_raw": location_raw,
            "location_resolved": location_resolved,
        }

    def _extract_affected_count(self, text: str) -> int | None:
        for pattern in self.PEOPLE_PATTERNS:
            match = re.search(pattern, text, flags=re.IGNORECASE)
            if match:
                return int(match.group(1))

        all_numbers = [int(match.group(0)) for match in re.finditer(r"\b\d{1,4}\b", text)]
        if any(keyword in text for keyword in ("trapped", "rescue", "injured")) and all_numbers:
            return max(all_numbers)
        return None

    def _extract_vulnerable_groups(self, text: str) -> list[str]:
        matched_groups: list[str] = []
        for group, keywords in self.VULNERABLE_GROUP_KEYWORDS.items():
            if any(keyword in text for keyword in keywords):
                matched_groups.append(group)
        return matched_groups
