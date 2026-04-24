"""Parse WhatsApp-style payloads into canonical ingress messages."""

from __future__ import annotations

from typing import Any, Mapping
from uuid import uuid4

from models.contracts import MessageSource, ParsedInboundMessage


class WhatsAppParser:
    """Support raw text and Twilio-compatible WhatsApp payloads."""

    def parse(self, payload: str | Mapping[str, Any]) -> ParsedInboundMessage:
        if isinstance(payload, str):
            return ParsedInboundMessage(
                source=MessageSource.WHATSAPP,
                sender_phone=None,
                body=payload,
                provider_message_id=f"wa-{uuid4()}",
            )

        media_urls = [
            str(value)
            for key, value in payload.items()
            if str(key).lower().startswith("mediaurl") and value
        ]

        return ParsedInboundMessage(
            source=MessageSource.WHATSAPP,
            sender_phone=self._normalize_sender(payload.get("From") or payload.get("from")),
            body=str(payload.get("Body") or payload.get("body") or payload.get("text") or ""),
            provider_message_id=str(
                payload.get("MessageSid")
                or payload.get("message_sid")
                or payload.get("provider_message_id")
                or f"wa-{uuid4()}"
            ),
            media_urls=media_urls,
            metadata={"raw_payload": dict(payload)},
        )

    def _normalize_sender(self, sender: Any) -> str | None:
        if sender is None:
            return None
        normalized = str(sender).strip()
        if normalized.lower().startswith("whatsapp:"):
            normalized = normalized.split(":", maxsplit=1)[1]
        return normalized or None
