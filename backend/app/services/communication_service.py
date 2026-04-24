"""Shared communication ingestion and outbound orchestration."""

from __future__ import annotations

import logging
from typing import Any

from app.db.repositories.audit_log_repository import AuditLogRepository
from app.db.repositories.inbound_message_repository import InboundMessageRepository
from app.schemas.communication import (
    AuditLogDocument,
    ChannelName,
    InboundMessage,
    InboundMessageDocument,
    OutboundMessageRequest,
    OutboundMessageResult,
    ProcessingStatus,
)
from app.schemas.need import ContactInfo, LocationInfo, NeedCreate, NeedType, UrgencyLevel
from app.services.ai_triage_service import AITriageService
from app.services.need_service import NeedService
from app.utils.datetime import utc_now


logger = logging.getLogger(__name__)


class CommunicationService:
    """Channel-agnostic communication processing pipeline."""

    def __init__(
        self,
        inbound_repository: InboundMessageRepository,
        audit_repository: AuditLogRepository,
        need_service: NeedService,
        triage_service: AITriageService,
        outbound_providers: dict[str, object],
    ) -> None:
        self.inbound_repository = inbound_repository
        self.audit_repository = audit_repository
        self.need_service = need_service
        self.triage_service = triage_service
        self.outbound_providers = outbound_providers

    async def process_inbound_message(self, inbound: InboundMessage) -> dict[str, Any]:
        """Normalize, deduplicate, parse, and persist inbound communications."""

        existing_by_provider_id = await self.inbound_repository.find_by_provider_message_id(
            inbound.provider_message_id
        )
        if existing_by_provider_id:
            return await self._build_duplicate_response(existing_by_provider_id)

        if inbound.dedup_hash:
            duplicate_inbound = await self.inbound_repository.find_recent_by_dedup_hash(inbound.dedup_hash)
            if duplicate_inbound and duplicate_inbound.get("linked_need_id"):
                await self._store_inbound_record(
                    inbound=inbound,
                    status=ProcessingStatus.duplicate,
                    linked_need_id=duplicate_inbound.get("linked_need_id"),
                    duplicate_of_inbound_id=duplicate_inbound.get("id"),
                )
                await self._audit_event(
                    inbound,
                    "duplicate_inbound_message",
                    {"duplicate_of_inbound_id": duplicate_inbound.get("id")},
                )
                existing_need = await self.need_service.get_need_or_raise(duplicate_inbound["linked_need_id"])
                return {
                    "inbound_message": inbound.model_dump(mode="json"),
                    "dedup_hash": inbound.dedup_hash,
                    "parsed": None,
                    "stored": True,
                    "duplicate": True,
                    "need": existing_need.model_dump(mode="json"),
                }

        parsed = self.triage_service.parse_inbound_message(inbound)
        if parsed.intent and parsed.intent.upper() != "NEED":
            await self._store_inbound_record(inbound=inbound, status=ProcessingStatus.ignored)
            await self._audit_event(
                inbound,
                "inbound_message_ignored",
                {"reason": f"Intent {parsed.intent} is not currently converted into a need"},
            )
            return {
                "inbound_message": inbound.model_dump(mode="json"),
                "dedup_hash": inbound.dedup_hash,
                "parsed": parsed.model_dump(mode="json"),
                "stored": False,
                "duplicate": False,
                "reason": f"Intent {parsed.intent} is not currently converted into a need",
            }

        if not parsed.need_type:
            await self._store_inbound_record(inbound=inbound, status=ProcessingStatus.ignored)
            await self._audit_event(
                inbound,
                "inbound_message_ignored",
                {"reason": "Unable to determine need type from message"},
            )
            return {
                "inbound_message": inbound.model_dump(mode="json"),
                "dedup_hash": inbound.dedup_hash,
                "parsed": parsed.model_dump(mode="json"),
                "stored": False,
                "duplicate": False,
                "reason": "Unable to determine need type from message",
            }

        need_payload = NeedCreate(
            location=LocationInfo(
                pincode=parsed.pincode,
                lat=parsed.lat,
                lng=parsed.lng,
                label=parsed.location_name,
            ),
            need_type=NeedType(parsed.need_type),
            urgency=UrgencyLevel(parsed.urgency or "medium"),
            vulnerability_score=parsed.vulnerability_score,
            dedup_hash=inbound.dedup_hash,
            contact_info=ContactInfo(
                phone=inbound.sender,
                notes=inbound.raw_text,
            ),
        )
        created_need = await self.need_service.create_need(need_payload)
        await self._store_inbound_record(
            inbound=inbound,
            status=ProcessingStatus.processed,
            linked_need_id=created_need.id,
        )
        await self._audit_event(
            inbound,
            "inbound_message_processed",
            {"linked_need_id": created_need.id},
        )
        return {
            "inbound_message": inbound.model_dump(mode="json"),
            "dedup_hash": inbound.dedup_hash,
            "parsed": parsed.model_dump(mode="json"),
            "stored": True,
            "duplicate": False,
            "need": created_need.model_dump(mode="json"),
        }

    async def send_message(self, payload: OutboundMessageRequest) -> OutboundMessageResult:
        """Delegate outbound sends to the configured provider stub."""

        provider_key = payload.channel.value
        provider = self.outbound_providers[provider_key]
        return await provider.send_message(payload)

    async def _store_inbound_record(
        self,
        inbound: InboundMessage,
        status: ProcessingStatus,
        linked_need_id: str | None = None,
        duplicate_of_inbound_id: str | None = None,
    ) -> InboundMessageDocument:
        now = utc_now()
        document = InboundMessageDocument(
            **inbound.model_dump(),
            processing_status=status,
            linked_need_id=linked_need_id,
            duplicate_of_inbound_id=duplicate_of_inbound_id,
            revision="pending",
            created_at=now,
            updated_at=now,
        )
        stored_payload = document.model_dump(mode="json")
        stored_payload.pop("revision", None)
        stored = await self.inbound_repository.save(document.id, stored_payload)
        stored["revision"] = stored.pop("_rev")
        stored.pop("_id", None)
        return InboundMessageDocument.model_validate(stored)

    async def _audit_event(
        self,
        inbound: InboundMessage,
        event_type: str,
        details: dict[str, Any],
    ) -> None:
        audit = AuditLogDocument(
            event_type=event_type,
            channel=inbound.channel,
            provider=inbound.provider,
            message_id=inbound.id,
            provider_message_id=inbound.provider_message_id,
            details=details,
            created_at=utc_now(),
        )
        await self.audit_repository.save(audit.id, audit.model_dump(mode="json"))

    async def _build_duplicate_response(self, existing_inbound: dict[str, Any]) -> dict[str, Any]:
        need = None
        linked_need_id = existing_inbound.get("linked_need_id")
        if linked_need_id:
            need = await self.need_service.get_need_or_raise(linked_need_id)
            need = need.model_dump(mode="json")

        return {
            "inbound_message": {
                key: value
                for key, value in existing_inbound.items()
                if key not in {"_id", "_rev"}
            },
            "dedup_hash": existing_inbound.get("dedup_hash"),
            "parsed": None,
            "stored": bool(need),
            "duplicate": True,
            "need": need,
        }
