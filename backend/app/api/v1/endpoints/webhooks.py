"""Webhook simulation endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends

from app.api.v1.dependencies.db import get_ai_triage_service, get_need_service
from app.schemas.common import Envelope, WebhookParseResult, WhatsAppWebhookRequest
from app.schemas.need import ContactInfo, LocationInfo, NeedCreate, NeedType, UrgencyLevel
from app.services.ai_triage_service import AITriageService
from app.services.need_service import NeedService


router = APIRouter(prefix="/webhook", tags=["webhooks"])


@router.post("/whatsapp", response_model=Envelope[dict[str, object]])
async def simulate_whatsapp_webhook(
    payload: WhatsAppWebhookRequest,
    triage_service: AITriageService = Depends(get_ai_triage_service),
    need_service: NeedService = Depends(get_need_service),
) -> Envelope[dict[str, object]]:
    """Parse a raw message and store a structured need in the background."""

    parse_result = triage_service.parse_whatsapp_message(payload.raw_text_message)
    if not parse_result.need_type:
        return Envelope(
            data={
                "parsed": parse_result.model_dump(),
                "stored": False,
                "reason": "Unable to determine need type from message",
            }
        )

    dedup_hash = triage_service.build_message_fingerprint(
        sender_number=payload.sender_phone,
        raw_text=payload.raw_text_message,
    )
    create_payload = _build_need_from_parse(payload, parse_result, dedup_hash)
    created_need = await need_service.create_need(create_payload)
    return Envelope(
        data={
            "parsed": parse_result.model_dump(),
            "dedup_hash": dedup_hash,
            "stored": True,
            "need": created_need.model_dump(),
        }
    )


def _build_need_from_parse(
    payload: WhatsAppWebhookRequest,
    parse_result: WebhookParseResult,
    dedup_hash: str,
) -> NeedCreate:
    return NeedCreate(
        location=LocationInfo(
            pincode=parse_result.pincode,
            lat=parse_result.lat,
            lng=parse_result.lng,
            label=parse_result.location_name,
        ),
        need_type=NeedType(parse_result.need_type),
        urgency=UrgencyLevel(parse_result.urgency or "medium"),
        vulnerability_score=parse_result.vulnerability_score,
        dedup_hash=dedup_hash,
        contact_info=ContactInfo(
            name=payload.sender_name,
            phone=payload.sender_phone,
            notes=payload.raw_text_message,
        ),
    )
