"""Tag likely disaster type from free-form text."""

from __future__ import annotations

from models.contracts import DisasterType, LabelPrediction
from processing.nlp.transliterator import Transliterator


class DisasterTypeTagger:
    """Keyword-based disaster classification."""

    KEYWORDS = {
        DisasterType.FLOOD: {"flood", "flooded", "waterlogging", "water rising", "heavy rain", "submerged"},
        DisasterType.FIRE: {"fire", "smoke", "blaze", "burning", "burn"},
        DisasterType.LANDSLIDE: {"landslide", "hill collapse", "mudslide", "rocks fell"},
        DisasterType.CYCLONE: {"cyclone", "storm", "high winds", "landfall"},
        DisasterType.HEATWAVE: {"heatwave", "heat stroke", "dehydration", "extreme heat"},
        DisasterType.EARTHQUAKE: {"earthquake", "tremor", "aftershock"},
    }

    def __init__(self) -> None:
        self.transliterator = Transliterator()

    def tag(self, text: str) -> LabelPrediction:
        canonical = self.transliterator.to_canonical_text(text)
        best_type = DisasterType.OTHER
        evidence: list[str] = []
        best_score = 0

        for disaster_type, keywords in self.KEYWORDS.items():
            score = sum(1 for keyword in keywords if keyword in canonical)
            if score > best_score:
                best_type = disaster_type
                best_score = score
                evidence = [keyword for keyword in keywords if keyword in canonical]

        if best_score == 0:
            return LabelPrediction(label=DisasterType.OTHER.value, confidence=0.45, evidence=[])

        confidence = min(0.96, 0.55 + best_score * 0.18)
        return LabelPrediction(label=best_type.value, confidence=round(confidence, 2), evidence=evidence)
