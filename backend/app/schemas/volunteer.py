"""Volunteer schemas."""

from __future__ import annotations

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field

from app.core.security.rbac import Role
from app.schemas.need import LocationInfo


class VolunteerStatus(str, Enum):
    """Volunteer operational state."""

    available = "available"
    assigned = "assigned"
    off_duty = "off_duty"


class VolunteerCreate(BaseModel):
    """Register a volunteer."""

    id: str | None = None
    name: str = Field(min_length=2, max_length=120)
    phone_number: str | None = Field(default=None, max_length=32)
    whatsapp_number: str | None = Field(default=None, max_length=32)
    alternate_number: str | None = Field(default=None, max_length=32)
    gender: str | None = Field(default=None, max_length=32)
    qualification: str | None = Field(default=None, max_length=120)
    designation: str | None = Field(default=None, max_length=120)
    zone_id: str | None = Field(default=None, max_length=64)
    camp_id: str | None = Field(default=None, max_length=120)
    auth_role: Role = Role.VOLUNTEER
    skills: list[str] = Field(default_factory=list)
    notes: str | None = Field(default=None, max_length=1000)
    location: LocationInfo
    availability: bool = True
    status: VolunteerStatus = VolunteerStatus.available


class VolunteerDocument(BaseModel):
    """Persisted volunteer document."""

    id: str
    name: str
    phone_number: str | None = None
    whatsapp_number: str | None = None
    alternate_number: str | None = None
    gender: str | None = None
    qualification: str | None = None
    designation: str | None = None
    zone_id: str | None = None
    camp_id: str | None = None
    auth_role: Role = Role.VOLUNTEER
    skills: list[str]
    notes: str | None = None
    location: LocationInfo
    availability: bool
    status: VolunteerStatus = VolunteerStatus.available
    current_assignment_need_id: str | None = None
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


class VolunteerRoleUpdate(BaseModel):
    """Role update payload for a volunteer auth profile."""

    auth_role: Role


class VolunteerProfileUpdate(BaseModel):
    """Editable volunteer profile fields."""

    name: str | None = Field(default=None, min_length=2, max_length=120)
    whatsapp_number: str | None = Field(default=None, max_length=32)
    alternate_number: str | None = Field(default=None, max_length=32)
    gender: str | None = Field(default=None, max_length=32)
    qualification: str | None = Field(default=None, max_length=120)
    designation: str | None = Field(default=None, max_length=120)
    notes: str | None = Field(default=None, max_length=1000)
    skills: list[str] | None = None
    location: LocationInfo | None = None


class VolunteerCampAssignment(BaseModel):
    """Assign or remove a volunteer from a camp."""

    camp_id: str | None = Field(default=None, max_length=120)
