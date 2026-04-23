"""SMS outbound stub client."""

from __future__ import annotations

import logging
from urllib.parse import quote

import httpx

from app.core.config.settings import Settings
from app.integrations.base import BaseOutboundProvider
from app.schemas.communication import OutboundMessageRequest, OutboundMessageResult, ProviderName


logger = logging.getLogger(__name__)


class SMSClient(BaseOutboundProvider):
    """Stub outbound client that logs sends for sandbox or local mode."""

    def __init__(self, provider: ProviderName, settings: Settings) -> None:
        self.provider = provider
        self.settings = settings

    async def send_message(self, payload: OutboundMessageRequest) -> OutboundMessageResult:
        if (
            self.provider == ProviderName.twilio
            and self.settings.twilio_account_sid
            and self.settings.twilio_auth_token
            and self.settings.twilio_sms_number
        ):
            url = (
                "https://api.twilio.com/2010-04-01/Accounts/"
                f"{quote(self.settings.twilio_account_sid)}/Messages.json"
            )
            form_payload = {
                "From": self.settings.twilio_sms_number,
                "To": payload.to,
                "Body": payload.message,
            }
            async with httpx.AsyncClient(timeout=self.settings.request_timeout_seconds) as client:
                response = await client.post(
                    url,
                    data=form_payload,
                    auth=(self.settings.twilio_account_sid, self.settings.twilio_auth_token),
                )
                response.raise_for_status()
            return OutboundMessageResult(
                channel=payload.channel,
                provider=self.provider,
                to=payload.to,
                message=payload.message,
                status="sent",
            )

        logger.info("Outbound SMS message stub", extra={"to": payload.to})
        return OutboundMessageResult(
            channel=payload.channel,
            provider=self.provider,
            to=payload.to,
            message=payload.message,
            status="logged_only",
        )
