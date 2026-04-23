"""Validation helpers."""

from __future__ import annotations

import re


PINCODE_PATTERN = re.compile(r"^\d{6}$")


def normalize_skill(skill: str) -> str:
    """Normalize a skill string for comparisons."""

    return skill.strip().lower().replace("-", "_").replace(" ", "_")


def is_valid_pincode(value: str | None) -> bool:
    """Validate an Indian pincode string."""

    if value is None:
        return True
    return bool(PINCODE_PATTERN.match(value))
