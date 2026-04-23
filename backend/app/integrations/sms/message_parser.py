"""SMS provider adapters."""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any
from uuid import uuid4

from app.integrations.base import BaseProvider
from app.schemas.communication import ChannelName, InboundMessage, ProviderName
from app.services.ai_triage_service import AITriageService


class SMSProvider(BaseProvider):
    """Parse inbound SMS payloads into canonical messages."""

    def __init__(self, provider_name: ProviderName) -> None:
        self.provider_name = provider_name
        self.triage_service = AITriageService()

    def parse_inbound(self, payload: dict[str, Any]) -> InboundMessage:
        sender = payload.get("From") or payload.get("from") or payload.get("sender") or ""
        raw_text = payload.get("Body") or payload.get("body") or payload.get("raw_text_message") or ""
        provider_message_id = (
            payload.get("MessageSid")
            or payload.get("message_sid")
            or payload.get("provider_message_id")
            or f"sms-{uuid4()}"
        )

        return InboundMessage(
            provider=self.provider_name,
            channel=ChannelName.sms,
            sender=self.triage_service.normalize_sender(sender),
            raw_text=raw_text,
            timestamp=datetime.now(timezone.utc),
            provider_message_id=provider_message_id,
            metadata={"raw_payload": payload},
            dedup_hash=self.triage_service.build_message_fingerprint(sender, raw_text),
        )
