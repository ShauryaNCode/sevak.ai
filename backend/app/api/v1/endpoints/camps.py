"""Camp endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Header, Query

from app.api.v1.dependencies.db import get_camp_service
from app.schemas.camp import CampCreate, CampDocument, CampManagersUpdate
from app.schemas.common import Envelope
from app.services.camp_service import CampService


router = APIRouter(prefix="/camps", tags=["camps"])


@router.post("", response_model=Envelope[CampDocument])
async def create_camp(
    payload: CampCreate,
    idempotency_key: str | None = Header(default=None, alias="Idempotency-Key"),
    service: CampService = Depends(get_camp_service),
) -> Envelope[CampDocument]:
    """Create a new relief camp."""

    return Envelope(data=await service.create_camp(payload, idempotency_key))


@router.get("", response_model=Envelope[list[CampDocument]])
async def list_camps(
    zone_id: str | None = Query(default=None),
    service: CampService = Depends(get_camp_service),
) -> Envelope[list[CampDocument]]:
    """List camps with an optional zone filter."""

    return Envelope(data=await service.list_camps(zone_id=zone_id))


@router.patch("/{camp_id}/managers", response_model=Envelope[CampDocument])
async def update_camp_managers(
    camp_id: str,
    payload: CampManagersUpdate,
    service: CampService = Depends(get_camp_service),
) -> Envelope[CampDocument]:
    """Replace the manager list for a camp."""

    return Envelope(data=await service.update_managers(camp_id, payload.managers))
