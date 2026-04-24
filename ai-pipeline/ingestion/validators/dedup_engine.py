"""Simple in-memory deduplication for bursty inbound traffic."""

from __future__ import annotations

import hashlib
import time


class DedupEngine:
    """Track recent message fingerprints in memory."""

    def __init__(self, ttl_seconds: int = 6 * 60 * 60) -> None:
        self.ttl_seconds = ttl_seconds
        self._seen: dict[str, float] = {}

    def fingerprint(self, sender_phone: str | None, body: str) -> str:
        normalized_sender = (sender_phone or "").strip().lower()
        normalized_body = " ".join((body or "").strip().lower().split())
        return hashlib.sha256(f"{normalized_sender}:{normalized_body}".encode("utf-8")).hexdigest()

    def is_duplicate(self, fingerprint: str) -> bool:
        self._purge_expired()
        return fingerprint in self._seen

    def remember(self, fingerprint: str) -> None:
        self._purge_expired()
        self._seen[fingerprint] = time.time()

    def _purge_expired(self) -> None:
        cutoff = time.time() - self.ttl_seconds
        expired = [fingerprint for fingerprint, seen_at in self._seen.items() if seen_at < cutoff]
        for fingerprint in expired:
            self._seen.pop(fingerprint, None)
