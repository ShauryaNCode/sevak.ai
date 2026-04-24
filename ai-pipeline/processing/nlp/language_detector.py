"""Heuristic language detection for multilingual relief messages."""

from __future__ import annotations

import re

from processing.nlp.tokenizer import Tokenizer


class LanguageDetector:
    """Estimate language family and script from message text."""

    DEVANAGARI_PATTERN = re.compile(r"[\u0900-\u097F]")
    HINGLISH_MARKERS = {
        "paani",
        "pani",
        "khana",
        "madad",
        "chahiye",
        "phase",
        "gaye",
        "bacche",
        "buzurg",
        "zaroorat",
    }

    def __init__(self) -> None:
        self.tokenizer = Tokenizer()

    def detect(self, text: str) -> tuple[str, float]:
        tokens = set(self.tokenizer.tokenize(text))
        devanagari_chars = len(self.DEVANAGARI_PATTERN.findall(text or ""))

        if devanagari_chars:
            return ("HINDI_DEVANAGARI", 0.94)

        if tokens & self.HINGLISH_MARKERS:
            return ("HINGLISH", 0.84)

        if tokens:
            return ("ENGLISH", 0.78)

        return ("UNKNOWN", 0.2)
