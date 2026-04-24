"""Volunteer endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Header

from app.api.v1.dependencies.db import get_volunteer_service
from app.schemas.common import Envelope, MatchRequest
from app.schemas.volunteer import VolunteerCreate, VolunteerDocument, VolunteerMatch, VolunteerRoleUpdate
from app.services.volunteer_service import VolunteerService


router = APIRouter(prefix="/volunteers", tags=["volunteers"])
match_router = APIRouter(tags=["volunteers"])


@router.post("", response_model=Envelope[VolunteerDocument])
async def register_volunteer(
    payload: VolunteerCreate,
    idempotency_key: str | None = Header(default=None, alias="Idempotency-Key"),
    service: VolunteerService = Depends(get_volunteer_service),
) -> Envelope[VolunteerDocument]:
    """Register a volunteer."""

    return Envelope(data=await service.register_volunteer(payload, idempotency_key))


@router.get("", response_model=Envelope[list[VolunteerDocument]])
async def list_volunteers(
    zone_id: str | None = None,
    camp_id: str | None = None,
    service: VolunteerService = Depends(get_volunteer_service),
) -> Envelope[list[VolunteerDocument]]:
    """List volunteers with optional zone and camp filters."""

    return Envelope(data=await service.list_volunteers(zone_id=zone_id, camp_id=camp_id))


@router.patch("/{volunteer_id}/role", response_model=Envelope[VolunteerDocument])
async def update_volunteer_role(
    volunteer_id: str,
    payload: VolunteerRoleUpdate,
    service: VolunteerService = Depends(get_volunteer_service),
) -> Envelope[VolunteerDocument]:
    """Update the auth role associated with a volunteer profile."""

    return Envelope(data=await service.update_auth_role(volunteer_id, payload.auth_role))


@match_router.post("/match", response_model=Envelope[list[VolunteerMatch]])
async def match_volunteers(
    payload: MatchRequest,
    service: VolunteerService = Depends(get_volunteer_service),
) -> Envelope[list[VolunteerMatch]]:
    """Return best volunteer matches for a need."""

    return Envelope(data=await service.match_volunteers(payload.need_id, payload.limit))
