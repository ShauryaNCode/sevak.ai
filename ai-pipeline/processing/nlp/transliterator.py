"""Lightweight canonicalization for Hinglish-style disaster messages."""

from __future__ import annotations

import re


class Transliterator:
    """Normalize frequent Hinglish variants into canonical English tokens."""

    REPLACEMENTS = [
        (r"\bpaani bhar gaya\b", "flooded"),
        (r"\bpani bhar gaya\b", "flooded"),
        (r"\bdoctor chahiye\b", "medical need"),
        (r"\bfas gaye\b", "trapped"),
        (r"\bphans gaye\b", "trapped"),
        (r"\bphase gaye\b", "trapped"),
        (r"\batke hue\b", "trapped"),
        (r"\bzaroorat\b", "need"),
        (r"\bzarrorat\b", "need"),
        (r"\bbachche\b", "children"),
        (r"\bbaache\b", "children"),
        (r"\bbacche\b", "children"),
        (r"\bdawaiyan\b", "medicine"),
        (r"\bpaani\b", "water"),
        (r"\bpani\b", "water"),
        (r"\bkhana\b", "food"),
        (r"\bbhookh\b", "hungry"),
        (r"\bmadad\b", "help"),
        (r"\bchahiye\b", "need"),
        (r"\bbuzurg\b", "elderly"),
        (r"\bdawai\b", "medicine"),
        (r"\baarish\b", "rain"),
    ]

    def to_canonical_text(self, text: str) -> str:
        canonical = f" {(text or '').lower()} "
        for pattern, replacement in self.REPLACEMENTS:
            canonical = re.sub(pattern, replacement, canonical, flags=re.IGNORECASE)
        canonical = re.sub(r"\s+", " ", canonical).strip()
        return canonical
