"""Parse SMS-style payloads into canonical ingress messages."""

from __future__ import annotations

from typing import Any, Mapping
from uuid import uuid4

from models.contracts import MessageSource, ParsedInboundMessage


class SMSParser:
    """Support raw text and Twilio-compatible SMS payloads."""

    def parse(self, payload: str | Mapping[str, Any]) -> ParsedInboundMessage:
        if isinstance(payload, str):
            return ParsedInboundMessage(
                source=MessageSource.SMS,
                sender_phone=None,
                body=payload,
                provider_message_id=f"sms-{uuid4()}",
            )

        return ParsedInboundMessage(
            source=MessageSource.SMS,
            sender_phone=self._normalize_sender(payload.get("From") or payload.get("from")),
            body=str(payload.get("Body") or payload.get("body") or payload.get("text") or ""),
            provider_message_id=str(
                payload.get("MessageSid")
                or payload.get("message_sid")
                or payload.get("provider_message_id")
                or f"sms-{uuid4()}"
            ),
            metadata={"raw_payload": dict(payload)},
        )

    def _normalize_sender(self, sender: Any) -> str | None:
        if sender is None:
            return None
        normalized = str(sender).strip()
        return normalized or None
