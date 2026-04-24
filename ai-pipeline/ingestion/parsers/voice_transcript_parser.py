"""Parse voice transcript payloads into canonical ingress messages."""

from __future__ import annotations

from typing import Any, Mapping
from uuid import uuid4

from models.contracts import MessageSource, ParsedInboundMessage


class VoiceTranscriptParser:
    """Accept raw transcripts or provider payloads."""

    def parse(self, payload: str | Mapping[str, Any]) -> ParsedInboundMessage:
        if isinstance(payload, str):
            return ParsedInboundMessage(
                source=MessageSource.VOICE_TRANSCRIPT,
                sender_phone=None,
                body=payload,
                provider_message_id=f"voice-{uuid4()}",
            )

        transcript = payload.get("transcript") or payload.get("body") or payload.get("text") or ""
        sender = payload.get("speaker_phone") or payload.get("from")
        metadata = dict(payload)
        return ParsedInboundMessage(
            source=MessageSource.VOICE_TRANSCRIPT,
            sender_phone=str(sender).strip() or None if sender else None,
            body=str(transcript),
            provider_message_id=str(payload.get("provider_message_id") or f"voice-{uuid4()}"),
            metadata=metadata,
        )
