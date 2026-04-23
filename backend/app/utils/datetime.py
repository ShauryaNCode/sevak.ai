"""Datetime helpers."""

from __future__ import annotations

from datetime import datetime, timezone


def utc_now() -> datetime:
    """Return current UTC timestamp."""

    return datetime.now(timezone.utc)


def elapsed_hours(from_timestamp: datetime) -> float:
    """Return elapsed hours from a UTC timestamp."""

    delta = utc_now() - from_timestamp
    return max(delta.total_seconds() / 3600.0, 0.0)
