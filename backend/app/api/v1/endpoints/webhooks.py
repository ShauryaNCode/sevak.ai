"""Webhook ingress endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, Header, HTTPException, Request

from app.api.v1.dependencies.db import (
    get_communication_service,
    get_settings,
    get_sms_provider,
    get_whatsapp_provider,
)
from app.core.config.settings import Settings
from app.integrations.base import BaseProvider
from app.integrations.sms.webhook_handler import validate_twilio_signature as validate_sms_signature
from app.integrations.whatsapp.webhook_handler import validate_twilio_signature as validate_whatsapp_signature
from app.schemas.common import Envelope
from app.services.communication_service import CommunicationService


router = APIRouter(prefix="/webhook", tags=["webhooks"])


@router.post("/whatsapp", response_model=Envelope[dict[str, object]])
async def whatsapp_webhook(
    request: Request,
    x_twilio_signature: str | None = Header(default=None, alias="X-Twilio-Signature"),
    provider: BaseProvider = Depends(get_whatsapp_provider),
    communication_service: CommunicationService = Depends(get_communication_service),
    settings: Settings = Depends(get_settings),
) -> Envelope[dict[str, object]]:
    """Accept WhatsApp sandbox webhooks and local simulations."""

    payload = await _extract_payload(request)
    request.app.state.last_webhook_payload = {
        "channel": "whatsapp",
        "path": str(request.url.path),
        "headers": {"content-type": request.headers.get("content-type", "")},
        "payload": payload,
    }
    if settings.validate_provider_signatures and settings.whatsapp_provider == "twilio":
        if not validate_whatsapp_signature(
            request_url=str(request.url),
            payload={key: str(value) for key, value in payload.items()},
            provided_signature=x_twilio_signature,
            auth_token=settings.twilio_auth_token,
        ):
            raise HTTPException(status_code=403, detail="Invalid WhatsApp webhook signature")

    inbound = provider.parse_inbound(payload)
    return Envelope(data=await communication_service.process_inbound_message(inbound))


@router.post("/sms", response_model=Envelope[dict[str, object]])
async def sms_webhook(
    request: Request,
    x_twilio_signature: str | None = Header(default=None, alias="X-Twilio-Signature"),
    provider: BaseProvider = Depends(get_sms_provider),
    communication_service: CommunicationService = Depends(get_communication_service),
    settings: Settings = Depends(get_settings),
) -> Envelope[dict[str, object]]:
    """Accept SMS webhooks in Twilio-compatible or mock JSON format."""

    payload = await _extract_payload(request)
    request.app.state.last_webhook_payload = {
        "channel": "sms",
        "path": str(request.url.path),
        "headers": {"content-type": request.headers.get("content-type", "")},
        "payload": payload,
    }
    if settings.validate_provider_signatures and settings.sms_provider == "twilio":
        if not validate_sms_signature(
            request_url=str(request.url),
            payload={key: str(value) for key, value in payload.items()},
            provided_signature=x_twilio_signature,
            auth_token=settings.twilio_auth_token,
        ):
            raise HTTPException(status_code=403, detail="Invalid SMS webhook signature")

    inbound = provider.parse_inbound(payload)
    return Envelope(data=await communication_service.process_inbound_message(inbound))


async def _extract_payload(request: Request) -> dict[str, object]:
    """Extract either JSON or form-encoded webhook payloads."""

    content_type = request.headers.get("content-type", "")
    if "application/json" in content_type:
        payload = await request.json()
        return payload if isinstance(payload, dict) else {}

    form = await request.form()
    return dict(form.items())
