"""Camp schemas."""

from __future__ import annotations

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field

from app.schemas.need import LocationInfo


class CampStatus(str, Enum):
    """Operational camp lifecycle state."""

    planned = "planned"
    active = "active"
    full = "full"
    closed = "closed"


class CampCreate(BaseModel):
    """Create request for a relief camp."""

    id: str | None = None
    name: str = Field(min_length=2, max_length=160)
    zone_id: str = Field(min_length=2, max_length=64)
    location: LocationInfo
    capacity: int = Field(default=0, ge=0, le=100000)
    current_occupancy: int = Field(default=0, ge=0, le=100000)
    status: CampStatus = CampStatus.active
    notes: str | None = Field(default=None, max_length=1000)
    manager_name: str | None = Field(default=None, max_length=120)
    manager_phone: str | None = Field(default=None, max_length=32)


class CampDocument(CampCreate):
    """Persisted camp document."""

    id: str
    created_at: datetime
    updated_at: datetime
    revision: str
    document_type: str = "camp"
