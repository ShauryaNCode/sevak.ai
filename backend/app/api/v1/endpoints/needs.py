"""Need endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Header, HTTPException, Query

from app.api.v1.dependencies.db import get_need_service, get_volunteer_service
from app.schemas.common import AssignmentRequest, Envelope
from app.schemas.need import NeedCreate, NeedDocument, NeedPriorityItem
from app.services.need_service import NeedService
from app.services.volunteer_service import VolunteerService


router = APIRouter(prefix="/needs", tags=["needs"])
assignment_router = APIRouter(tags=["needs"])


@router.post("", response_model=Envelope[NeedDocument])
async def submit_need(
    payload: NeedCreate,
    idempotency_key: str | None = Header(default=None, alias="Idempotency-Key"),
    service: NeedService = Depends(get_need_service),
) -> Envelope[NeedDocument]:
    """Submit a new need."""

    return Envelope(data=await service.create_need(payload, idempotency_key))


@router.get("", response_model=Envelope[list[NeedDocument]])
async def get_needs(
    urgency: str | None = Query(default=None),
    location: str | None = Query(default=None),
    status: str | None = Query(default=None),
    service: NeedService = Depends(get_need_service),
) -> Envelope[list[NeedDocument]]:
    """Retrieve needs with optional filters."""

    return Envelope(data=await service.list_needs(urgency=urgency, location=location, status=status))


@router.get("/prioritized", response_model=Envelope[list[NeedPriorityItem]])
async def get_prioritized_needs(
    reference_lat: float | None = Query(default=None, ge=-90, le=90),
    reference_lng: float | None = Query(default=None, ge=-180, le=180),
    service: NeedService = Depends(get_need_service),
) -> Envelope[list[NeedPriorityItem]]:
    """Return priority-ranked needs."""

    return Envelope(data=await service.prioritized_needs(reference_lat, reference_lng))


@assignment_router.post("/assign", response_model=Envelope[NeedDocument])
async def assign_need(
    payload: AssignmentRequest,
    service: NeedService = Depends(get_need_service),
    volunteer_service: VolunteerService = Depends(get_volunteer_service),
) -> Envelope[NeedDocument]:
    """Assign a volunteer to a need."""

    volunteer = await volunteer_service.get_volunteer_or_raise(payload.volunteer_id)
    if not volunteer.availability:
        raise HTTPException(status_code=400, detail="Volunteer is not currently available")

    return Envelope(
        data=await service.assign_need(
            need_id=payload.need_id,
            volunteer_id=payload.volunteer_id,
            expected_revision=payload.expected_revision,
        )
    )
