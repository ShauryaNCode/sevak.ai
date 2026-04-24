"""Tokenization helpers for multilingual heuristic NLP."""

from __future__ import annotations

import re


class Tokenizer:
    """Extract simple alphanumeric and Devanagari tokens."""

    TOKEN_PATTERN = re.compile(r"[a-z0-9']+|[\u0900-\u097F]+", re.IGNORECASE)

    def tokenize(self, text: str) -> list[str]:
        return self.TOKEN_PATTERN.findall((text or "").lower())
