"""Extract need categories from unstructured text."""

from __future__ import annotations

from processing.nlp.transliterator import Transliterator


class NeedsExtractor:
    """Map free text to canonical need labels."""

    KEYWORDS = {
        "FOOD": {"food", "meal", "ration", "hungry"},
        "WATER": {"water", "drinking water", "thirsty"},
        "SHELTER": {"shelter", "tent", "blanket", "roof", "camp"},
        "MEDICAL": {"medical", "medicine", "doctor", "ambulance", "injured", "first aid"},
        "RESCUE": {"rescue", "trapped", "boat", "evacuate", "stranded"},
        "CLOTHING": {"clothes", "clothing", "dress", "garments"},
        "SANITATION": {"toilet", "sanitation", "hygiene", "sanitary"},
    }

    def __init__(self) -> None:
        self.transliterator = Transliterator()

    def extract(self, text: str) -> list[str]:
        canonical = self.transliterator.to_canonical_text(text)
        needs: list[str] = []
        for need_type, keywords in self.KEYWORDS.items():
            if any(keyword in canonical for keyword in keywords):
                needs.append(need_type)
        return needs
