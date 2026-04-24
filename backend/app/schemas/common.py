"""Common response and shared schema models."""

from __future__ import annotations

from datetime import datetime
from typing import Generic, TypeVar

from pydantic import BaseModel, Field


class ErrorResponse(BaseModel):
    """Error payload for predictable failures."""

    detail: str


class AssignmentRequest(BaseModel):
    """Assign a volunteer to a need."""

    need_id: str
    volunteer_id: str
    expected_revision: str | None = None


class MatchRequest(BaseModel):
    """Request matching volunteers for a need."""

    need_id: str
    limit: int = Field(default=5, ge=1, le=25)


class WhatsAppWebhookRequest(BaseModel):
    """Raw WhatsApp webhook simulation payload."""

    raw_text_message: str = Field(min_length=3, max_length=2000)
    sender_name: str | None = None
    sender_phone: str | None = None


class WebhookParseResult(BaseModel):
    """Structured result from rule-based message parsing."""

    need_type: str | None = None
    urgency: str | None = None
    location_name: str | None = None
    pincode: str | None = None
    lat: float | None = None
    lng: float | None = None
    vulnerability_score: float = Field(default=0.5, ge=0.0, le=1.0)
    confidence: float = Field(default=0.0, ge=0.0, le=1.0)
    intent: str | None = None
    priority: int | None = None
    disaster_type: str | None = None
    needs: list[str] = Field(default_factory=list)
    vulnerable_groups: list[str] = Field(default_factory=list)
    language: str | None = None
    route: str | None = None
    summary: str | None = None
    ai_model: str | None = None
    ai_prompt_version: str | None = None
    requires_follow_up: bool = False
    pending_cloud_processing: bool = False
    processing_ms: int | None = None


class HealthResponse(BaseModel):
    """Health endpoint payload."""

    status: str
    storage_backend: str
    timestamp: datetime


DataT = TypeVar("DataT")


class Envelope(BaseModel, Generic[DataT]):
    """Simple consistent API response envelope."""

    data: DataT
