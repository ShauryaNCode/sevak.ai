"""Validation and sanitization for inbound messages."""

from __future__ import annotations

import re

from models.contracts import ParsedInboundMessage, ValidationResult


class MessageValidator:
    """Guard the pipeline from empty and obviously invalid inputs."""

    NOISE_MARKERS = {"hi", "hello", "ok", "okay", "test", "ping"}

    def validate(self, message: ParsedInboundMessage) -> ValidationResult:
        normalized_text = self.sanitize_text(message.body)
        errors: list[str] = []
        warnings: list[str] = []

        if not normalized_text:
            errors.append("empty_message")

        alnum_count = sum(character.isalnum() for character in normalized_text)
        if normalized_text and alnum_count == 0:
            errors.append("no_meaningful_text")

        lowered = normalized_text.lower()
        if lowered in self.NOISE_MARKERS:
            warnings.append("low_signal_message")

        if len(normalized_text) > 1500:
            warnings.append("message_truncated_for_processing")
            normalized_text = normalized_text[:1500]

        if re.search(r"https?://", lowered):
            warnings.append("contains_url")

        if re.search(r"(.)\1{8,}", normalized_text):
            warnings.append("high_character_repetition")

        return ValidationResult(
            is_valid=not errors,
            normalized_text=normalized_text,
            errors=errors,
            warnings=warnings,
        )

    def sanitize_text(self, text: str) -> str:
        compact = re.sub(r"\s+", " ", (text or "").replace("\x00", " ")).strip()
        return compact
