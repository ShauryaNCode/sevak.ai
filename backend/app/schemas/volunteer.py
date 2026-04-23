"""Volunteer schemas."""

from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel, Field

from app.schemas.need import LocationInfo


class VolunteerCreate(BaseModel):
    """Register a volunteer."""

    id: str | None = None
    name: str = Field(min_length=2, max_length=120)
    skills: list[str] = Field(default_factory=list)
    location: LocationInfo
    availability: bool = True


class VolunteerDocument(BaseModel):
    """Persisted volunteer document."""

    id: str
    name: str
    skills: list[str]
    location: LocationInfo
    availability: bool
    created_at: datetime
    updated_at: datetime
    revision: str
    document_type: str = "volunteer"


class VolunteerMatch(BaseModel):
    """Volunteer plus matching metadata."""

    volunteer: VolunteerDocument
    skill_score: float
    proximity_km: float | None = None
    total_score: float
