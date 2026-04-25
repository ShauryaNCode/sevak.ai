"""Need workflows."""

from __future__ import annotations

import logging
from uuid import uuid4

from app.core.config.settings import Settings
from app.db.couchdb import DocumentNotFoundError
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.db.repositories.need_repository import NeedRepository
from app.schemas.need import (
    NeedCreate,
    NeedDocument,
    NeedPriorityItem,
    NeedStatus,
    UrgencyLevel,
)
from app.utils.datetime import elapsed_hours, utc_now
from app.utils.geo import haversine_distance_km


logger = logging.getLogger(__name__)


class NeedService:
    """Handle creation, retrieval, prioritization, and assignment for needs."""

    URGENCY_SCORES = {
        UrgencyLevel.low: 0.3,
        UrgencyLevel.medium: 0.6,
        UrgencyLevel.high: 1.0,
    }

    def __init__(
        self,
        repository: NeedRepository,
        idempotency_repository: IdempotencyRepository,
        settings: Settings,
    ) -> None:
        self.repository = repository
        self.idempotency_repository = idempotency_repository
        self.settings = settings

    async def create_need(
        self,
        payload: NeedCreate,
        idempotency_key: str | None = None,
    ) -> NeedDocument:
        """Create or idempotently return a need document."""

        if idempotency_key:
            existing_key = await self.idempotency_repository.get(f"idempotency:need:{idempotency_key}")
            if existing_key:
                existing_document = await self.repository.get(existing_key["resource_id"])
                if existing_document:
                    return self._to_schema(existing_document)

        if payload.dedup_hash:
            existing_document = await self.repository.find_recent_by_dedup_hash(payload.dedup_hash)
            if existing_document:
                return self._to_schema(existing_document)

        now = utc_now()
        need_id = payload.id or str(uuid4())
        existing = await self.repository.get(need_id)
        revision = existing.get("_rev") if existing else None

        stored = {
            "_id": need_id,
            "_rev": revision,
            "id": need_id,
            "document_type": "need",
            "location": payload.location.model_dump(),
            "need_type": payload.need_type.value,
            "urgency": payload.urgency.value,
            "timestamp": (payload.timestamp or now).isoformat(),
            "status": NeedStatus.pending.value,
            "contact_info": payload.contact_info.model_dump(),
            "camp_id": payload.camp_id,
            "title": payload.title,
            "description": payload.description,
            "affected_count": payload.affected_count,
            "source": payload.source,
            "vulnerability_score": payload.vulnerability_score,
            "dedup_hash": payload.dedup_hash,
            "assigned_volunteer_id": existing.get("assigned_volunteer_id") if existing else None,
            "created_at": existing.get("created_at", now.isoformat()) if existing else now.isoformat(),
            "updated_at": now.isoformat(),
        }
        saved = await self.repository.save(need_id, stored, expected_revision=revision)

        if idempotency_key:
            await self.idempotency_repository.save(
                f"idempotency:need:{idempotency_key}",
                {
                    "document_type": "idempotency",
                    "resource_id": need_id,
                    "created_at": now.isoformat(),
                },
            )

        logger.info("Need stored", extra={"request_id": "", "need_id": need_id})
        return self._to_schema(saved)

    async def list_needs(
        self,
        urgency: str | None = None,
        location: str | None = None,
        status: str | None = None,
    ) -> list[NeedDocument]:
        """List needs with simple field filters."""

        documents = [self._to_schema(doc) for doc in await self.repository.list()]
        results = documents
        if urgency:
            results = [doc for doc in results if doc.urgency.value == urgency]
        if status:
            results = [doc for doc in results if doc.status.value == status]
        if location:
            query = location.strip().lower()
            results = [
                doc
                for doc in results
                if (doc.location.pincode and query in doc.location.pincode.lower())
                or (doc.location.label and query in doc.location.label.lower())
            ]
        return results

    async def get_need_or_raise(self, need_id: str) -> NeedDocument:
        """Return a single need or raise a 404-style error."""

        existing = await self.repository.get(need_id)
        if not existing:
            raise DocumentNotFoundError(f"Need {need_id} not found")
        return self._to_schema(existing)

    async def assign_need(
        self,
        need_id: str,
        volunteer_id: str,
        expected_revision: str | None = None,
    ) -> NeedDocument:
        """Assign a volunteer and mark the need as assigned."""

        existing = await self.repository.get(need_id)
        if not existing:
            raise DocumentNotFoundError(f"Need {need_id} not found")
        if existing.get("status") == NeedStatus.completed.value:
            raise ValueError("Completed needs cannot be assigned again")
        if existing.get("assigned_volunteer_id") and existing.get("assigned_volunteer_id") != volunteer_id:
            raise ValueError("Need is already assigned to another volunteer")

        updated = dict(existing)
        updated["status"] = NeedStatus.assigned.value
        updated["assigned_volunteer_id"] = volunteer_id
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.repository.save(
            need_id,
            updated,
            expected_revision=expected_revision or existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def update_need_status(
        self,
        need_id: str,
        status: NeedStatus,
        expected_revision: str | None = None,
    ) -> NeedDocument:
        """Update a need status while preserving the rest of the document."""

        existing = await self.repository.get(need_id)
        if not existing:
            raise DocumentNotFoundError(f"Need {need_id} not found")

        updated = dict(existing)
        updated["status"] = status.value
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.repository.save(
            need_id,
            updated,
            expected_revision=expected_revision or existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def prioritized_needs(
        self,
        reference_lat: float | None = None,
        reference_lng: float | None = None,
    ) -> list[NeedPriorityItem]:
        """Return needs sorted by computed priority."""

        needs = [self._to_schema(doc) for doc in await self.repository.list()]
        prioritized: list[NeedPriorityItem] = []

        for need in needs:
            urgency_score = self.URGENCY_SCORES[need.urgency]
            vulnerability_component = need.vulnerability_score
            distance_km = haversine_distance_km(
                need.location.lat,
                need.location.lng,
                reference_lat,
                reference_lng,
            )

            if distance_km is None:
                proximity_component = 0.5
            else:
                proximity_component = max(
                    0.0,
                    1.0 - min(distance_km / max(self.settings.default_distance_km, 1.0), 1.0),
                )

            time_component = min(elapsed_hours(need.timestamp) / 24.0, 1.0)
            priority_score = (
                self.settings.priority_weight_vulnerability * vulnerability_component
                + self.settings.priority_weight_proximity * proximity_component
                + self.settings.priority_weight_time * time_component
            )

            prioritized.append(
                NeedPriorityItem(
                    need=need,
                    vulnerability_component=vulnerability_component,
                    proximity_component=proximity_component,
                    time_component=time_component,
                    priority_score=priority_score,
                )
            )

        return sorted(prioritized, key=lambda item: item.priority_score, reverse=True)

    def _to_schema(self, document: dict) -> NeedDocument:
        payload = dict(document)
        payload["revision"] = payload.pop("_rev")
        payload.pop("_id", None)
        return NeedDocument.model_validate(payload)
