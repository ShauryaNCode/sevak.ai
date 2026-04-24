"""Heuristic intent classification for disaster communication."""

from __future__ import annotations

from models.contracts import Intent, LabelPrediction
from processing.nlp.tokenizer import Tokenizer
from processing.nlp.transliterator import Transliterator


class IntentClassifier:
    """Classify inbound text into NEED, OFFER, STATUS, or NOISE."""

    NEED_KEYWORDS = {
        "need",
        "help",
        "urgent",
        "emergency",
        "rescue",
        "trapped",
        "stuck",
        "hungry",
        "injured",
        "medical",
        "water",
        "food",
        "shelter",
        "ambulance",
        "evacuate",
    }
    OFFER_KEYWORDS = {
        "available",
        "can provide",
        "we have",
        "we can send",
        "ready to help",
        "donate",
        "supply",
        "doctor available",
        "volunteers available",
        "boats available",
    }
    STATUS_KEYWORDS = {
        "reached",
        "completed",
        "delivered",
        "distributed",
        "updated",
        "camp open",
        "camp running",
        "resolved",
        "done",
    }
    NOISE_KEYWORDS = {"hello", "hi", "ping", "test", "thanks"}

    def __init__(self) -> None:
        self.tokenizer = Tokenizer()
        self.transliterator = Transliterator()

    def classify(self, text: str) -> LabelPrediction:
        canonical_text = self.transliterator.to_canonical_text(text)
        tokens = set(self.tokenizer.tokenize(canonical_text))
        evidence: list[str] = []

        scores = {
            Intent.NEED: self._score_keywords(canonical_text, tokens, self.NEED_KEYWORDS, evidence, "need"),
            Intent.OFFER: self._score_keywords(canonical_text, tokens, self.OFFER_KEYWORDS, evidence, "offer"),
            Intent.STATUS: self._score_keywords(canonical_text, tokens, self.STATUS_KEYWORDS, evidence, "status"),
            Intent.NOISE: self._score_keywords(canonical_text, tokens, self.NOISE_KEYWORDS, evidence, "noise"),
        }

        if not tokens:
            return LabelPrediction(label=Intent.NOISE.value, confidence=0.99, evidence=["empty_token_stream"])

        best_intent, best_score = max(scores.items(), key=lambda item: item[1])
        total_score = sum(scores.values()) or 1.0

        if best_score <= 0:
            return LabelPrediction(label=Intent.NOISE.value, confidence=0.55, evidence=["no_relief_signal"])

        confidence = min(0.98, round(best_score / total_score + 0.34, 2))
        filtered_evidence = [item for item in evidence if item.startswith(best_intent.value.lower())]
        return LabelPrediction(label=best_intent.value, confidence=confidence, evidence=filtered_evidence)

    def _score_keywords(
        self,
        canonical_text: str,
        tokens: set[str],
        keywords: set[str],
        evidence: list[str],
        category: str,
    ) -> float:
        score = 0.0
        for keyword in keywords:
            token_match = keyword in tokens
            phrase_match = keyword in canonical_text
            if token_match or phrase_match:
                weight = 1.5 if " " in keyword else 1.0
                score += weight
                evidence.append(f"{category}:{keyword}")
        return score
