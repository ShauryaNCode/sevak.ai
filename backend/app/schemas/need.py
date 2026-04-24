"""Need schemas."""

from __future__ import annotations

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field, field_validator

from app.utils.validators import is_valid_pincode


class NeedType(str, Enum):
    """Supported need categories."""

    medical = "medical"
    food = "food"
    water = "water"
    shelter = "shelter"
    rescue = "rescue"


class UrgencyLevel(str, Enum):
    """Urgency levels."""

    low = "low"
    medium = "medium"
    high = "high"


class NeedStatus(str, Enum):
    """Need lifecycle status."""

    pending = "pending"
    assigned = "assigned"
    completed = "completed"


class LocationInfo(BaseModel):
    """Document-friendly location payload."""

    pincode: str | None = None
    lat: float | None = Field(default=None, ge=-90, le=90)
    lng: float | None = Field(default=None, ge=-180, le=180)
    label: str | None = None

    @field_validator("pincode")
    @classmethod
    def validate_pincode(cls, value: str | None) -> str | None:
        if not is_valid_pincode(value):
            raise ValueError("pincode must be a valid 6 digit code")
        return value


class ContactInfo(BaseModel):
    """Reporter contact details."""

    name: str | None = None
    phone: str | None = None
    notes: str | None = None


class NeedBase(BaseModel):
    """Shared need fields."""

    location: LocationInfo
    need_type: NeedType
    urgency: UrgencyLevel
    contact_info: ContactInfo
    vulnerability_score: float = Field(default=0.5, ge=0.0, le=1.0)
    dedup_hash: str | None = None


class NeedCreate(NeedBase):
    """Create request for a need."""

    id: str | None = None
    timestamp: datetime | None = None


class NeedDocument(NeedBase):
    """Persisted need document."""

    id: str
    timestamp: datetime
    status: NeedStatus = NeedStatus.pending
    assigned_volunteer_id: str | None = None
    created_at: datetime
    updated_at: datetime
    revision: str
    document_type: str = "need"


class NeedPriorityItem(BaseModel):
    """Need with computed priority score."""

    need: NeedDocument
    vulnerability_component: float
    proximity_component: float
    time_component: float
    priority_score: float
