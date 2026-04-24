"""Convert parsed inbound payloads into canonical pipeline messages."""

from __future__ import annotations

import hashlib
from uuid import uuid4

from models.contracts import NormalizedMessage, ParsedInboundMessage, ProcessingStatus


class MessageNormalizer:
    """Normalize sender ids, text, and metadata into a stable shape."""

    def normalize(self, message: ParsedInboundMessage, cleaned_text: str | None = None) -> NormalizedMessage:
        normalized_sender = self._normalize_sender(message.sender_phone)
        clean_body = cleaned_text or self._normalize_body(message.body)
        message_hash = self._fingerprint(normalized_sender, clean_body)

        return NormalizedMessage(
            id=message.provider_message_id or str(uuid4()),
            source=message.source,
            sender_phone=normalized_sender,
            body=message.body,
            clean_body=clean_body,
            received_at=message.received_at,
            provider_message_id=message.provider_message_id,
            media_urls=list(message.media_urls),
            language_hint=str(message.metadata.get("language_hint")) if message.metadata.get("language_hint") else None,
            metadata=dict(message.metadata),
            message_hash=message_hash,
            processing_status=ProcessingStatus.QUEUED,
        )

    def _normalize_sender(self, sender_phone: str | None) -> str | None:
        if sender_phone is None:
            return None
        normalized = sender_phone.strip()
        if normalized.lower().startswith("whatsapp:"):
            normalized = normalized.split(":", maxsplit=1)[1]
        return normalized or None

    def _normalize_body(self, body: str) -> str:
        return " ".join((body or "").split()).strip()

    def _fingerprint(self, sender_phone: str | None, body: str) -> str:
        normalized_sender = (sender_phone or "").lower()
        return hashlib.sha256(f"{normalized_sender}:{body.lower()}".encode("utf-8")).hexdigest()
