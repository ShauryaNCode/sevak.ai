"""Communication channel schemas."""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Any
from uuid import uuid4

from pydantic import BaseModel, Field


class ProviderName(str, Enum):
    """Supported messaging providers."""

    twilio = "twilio"
    gupshup = "gupshup"
    mock = "mock"


class ChannelName(str, Enum):
    """Supported inbound communication channels."""

    whatsapp = "whatsapp"
    sms = "sms"


class ProcessingStatus(str, Enum):
    """Inbound processing lifecycle."""

    received = "received"
    processed = "processed"
    duplicate = "duplicate"
    ignored = "ignored"
    failed = "failed"


class InboundMessage(BaseModel):
    """Canonical inbound message normalized from provider payloads."""

    id: str = Field(default_factory=lambda: str(uuid4()))
    provider: ProviderName
    channel: ChannelName
    sender: str
    raw_text: str
    timestamp: datetime
    provider_message_id: str
    metadata: dict[str, Any] = Field(default_factory=dict)
    dedup_hash: str | None = None


class InboundMessageDocument(InboundMessage):
    """Persisted inbound communication record."""

    processing_status: ProcessingStatus = ProcessingStatus.received
    linked_need_id: str | None = None
    duplicate_of_inbound_id: str | None = None
    revision: str
    document_type: str = "inbound_message"
    created_at: datetime
    updated_at: datetime


class AuditLogDocument(BaseModel):
    """Simple audit log event document."""

    id: str = Field(default_factory=lambda: str(uuid4()))
    document_type: str = "audit_log"
    event_type: str
    channel: ChannelName
    provider: ProviderName
    message_id: str
    provider_message_id: str
    details: dict[str, Any] = Field(default_factory=dict)
    created_at: datetime


class OutboundMessageRequest(BaseModel):
    """Outbound message intent."""

    channel: ChannelName
    to: str
    message: str = Field(min_length=1, max_length=1600)
    metadata: dict[str, Any] = Field(default_factory=dict)


class OutboundMessageResult(BaseModel):
    """Outbound stub result."""

    channel: ChannelName
    provider: ProviderName
    to: str
    message: str
    status: str
