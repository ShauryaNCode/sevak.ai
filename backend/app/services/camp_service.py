"""Camp workflows."""

from __future__ import annotations

from uuid import uuid4

from app.db.couchdb import DocumentNotFoundError
from app.db.repositories.camp_repository import CampRepository
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.schemas.camp import CampCreate, CampDocument, CampManager
from app.utils.datetime import utc_now


class CampService:
    """Handle camp creation and listing."""

    def __init__(
        self,
        camp_repository: CampRepository,
        idempotency_repository: IdempotencyRepository,
    ) -> None:
        self.camp_repository = camp_repository
        self.idempotency_repository = idempotency_repository

    async def create_camp(
        self,
        payload: CampCreate,
        idempotency_key: str | None = None,
    ) -> CampDocument:
        """Create or idempotently return a camp document."""

        if idempotency_key:
            existing_key = await self.idempotency_repository.get(
                f"idempotency:camp:{idempotency_key}"
            )
            if existing_key:
                existing_document = await self.camp_repository.get(existing_key["resource_id"])
                if existing_document:
                    return self._to_schema(existing_document)

        now = utc_now()
        camp_id = payload.id or str(uuid4())
        existing = await self.camp_repository.get(camp_id)
        revision = existing.get("_rev") if existing else None

        stored = {
            "_id": camp_id,
            "_rev": revision,
            "id": camp_id,
            "document_type": "camp",
            "name": payload.name,
            "zone_id": payload.zone_id,
            "location": payload.location.model_dump(),
            "capacity": payload.capacity,
            "current_occupancy": payload.current_occupancy,
            "status": payload.status.value,
            "notes": payload.notes,
            "manager_name": payload.manager_name or (payload.managers[0].name if payload.managers else None),
            "manager_phone": payload.manager_phone or (payload.managers[0].phone if payload.managers else None),
            "managers": [manager.model_dump() for manager in payload.managers],
            "created_at": existing.get("created_at", now.isoformat()) if existing else now.isoformat(),
            "updated_at": now.isoformat(),
        }
        saved = await self.camp_repository.save(camp_id, stored, expected_revision=revision)

        if idempotency_key:
            await self.idempotency_repository.save(
                f"idempotency:camp:{idempotency_key}",
                {
                    "document_type": "idempotency",
                    "resource_id": camp_id,
                    "created_at": now.isoformat(),
                },
            )

        return self._to_schema(saved)

    async def list_camps(self, zone_id: str | None = None) -> list[CampDocument]:
        """List camps with an optional zone filter."""

        documents = [self._to_schema(doc) for doc in await self.camp_repository.list()]
        if zone_id is None:
            return documents
        return [document for document in documents if document.zone_id == zone_id]

    async def get_camp_or_raise(self, camp_id: str) -> CampDocument:
        """Return a camp or raise when missing."""

        document = await self.camp_repository.get(camp_id)
        if not document:
            raise DocumentNotFoundError(f"Camp {camp_id} not found")
        return self._to_schema(document)

    async def update_managers(
        self,
        camp_id: str,
        managers: list[CampManager],
    ) -> CampDocument:
        """Replace camp managers while preserving the rest of the document."""

        existing = await self.camp_repository.get(camp_id)
        if not existing:
            raise DocumentNotFoundError(f"Camp {camp_id} not found")

        updated = dict(existing)
        updated["managers"] = [manager.model_dump() for manager in managers]
        updated["manager_name"] = managers[0].name if managers else None
        updated["manager_phone"] = managers[0].phone if managers else None
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.camp_repository.save(
            camp_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    def _to_schema(self, document: dict) -> CampDocument:
        payload = dict(document)
        payload["revision"] = payload.pop("_rev")
        payload.pop("_id", None)
        return CampDocument.model_validate(payload)
