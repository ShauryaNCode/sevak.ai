"""Volunteer workflows."""

from __future__ import annotations

from uuid import uuid4

from app.db.couchdb import DocumentNotFoundError
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.db.repositories.need_repository import NeedRepository
from app.db.repositories.volunteer_repository import VolunteerRepository
from app.schemas.need import NeedDocument
from app.schemas.volunteer import VolunteerCreate, VolunteerDocument, VolunteerMatch
from app.utils.datetime import utc_now
from app.utils.geo import haversine_distance_km
from app.utils.validators import normalize_skill


class VolunteerService:
    """Handle volunteer registration and need matching."""

    def __init__(
        self,
        volunteer_repository: VolunteerRepository,
        need_repository: NeedRepository,
        idempotency_repository: IdempotencyRepository,
    ) -> None:
        self.volunteer_repository = volunteer_repository
        self.need_repository = need_repository
        self.idempotency_repository = idempotency_repository

    async def register_volunteer(
        self,
        payload: VolunteerCreate,
        idempotency_key: str | None = None,
    ) -> VolunteerDocument:
        """Create or idempotently return a volunteer document."""

        if idempotency_key:
            existing_key = await self.idempotency_repository.get(
                f"idempotency:volunteer:{idempotency_key}"
            )
            if existing_key:
                existing_document = await self.volunteer_repository.get(existing_key["resource_id"])
                if existing_document:
                    return self._to_schema(existing_document)

        now = utc_now()
        volunteer_id = payload.id or str(uuid4())
        existing = await self.volunteer_repository.get(volunteer_id)
        revision = existing.get("_rev") if existing else None

        stored = {
            "_id": volunteer_id,
            "_rev": revision,
            "id": volunteer_id,
            "document_type": "volunteer",
            "name": payload.name,
            "skills": payload.skills,
            "location": payload.location.model_dump(),
            "availability": payload.availability,
            "created_at": existing.get("created_at", now.isoformat()) if existing else now.isoformat(),
            "updated_at": now.isoformat(),
        }
        saved = await self.volunteer_repository.save(
            volunteer_id,
            stored,
            expected_revision=revision,
        )

        if idempotency_key:
            await self.idempotency_repository.save(
                f"idempotency:volunteer:{idempotency_key}",
                {
                    "document_type": "idempotency",
                    "resource_id": volunteer_id,
                    "created_at": now.isoformat(),
                },
            )

        return self._to_schema(saved)

    async def match_volunteers(self, need_id: str, limit: int = 5) -> list[VolunteerMatch]:
        """Return the best available volunteers for a need."""

        need_document = await self.need_repository.get(need_id)
        if not need_document:
            raise DocumentNotFoundError(f"Need {need_id} not found")

        need = NeedDocument.model_validate(
            {
                **need_document,
                "revision": need_document["_rev"],
            }
        )
        volunteers = [self._to_schema(doc) for doc in await self.volunteer_repository.list()]
        scored: list[VolunteerMatch] = []

        need_skill = normalize_skill(need.need_type.value)
        for volunteer in volunteers:
            if not volunteer.availability:
                continue

            skill_score = 1.0 if need_skill in {normalize_skill(skill) for skill in volunteer.skills} else 0.25
            proximity_km = haversine_distance_km(
                need.location.lat,
                need.location.lng,
                volunteer.location.lat,
                volunteer.location.lng,
            )
            proximity_score = 0.4 if proximity_km is None else max(0.0, 1.0 - min(proximity_km / 50.0, 1.0))
            total_score = 0.7 * skill_score + 0.3 * proximity_score

            scored.append(
                VolunteerMatch(
                    volunteer=volunteer,
                    skill_score=skill_score,
                    proximity_km=proximity_km,
                    total_score=total_score,
                )
            )

        return sorted(scored, key=lambda item: item.total_score, reverse=True)[:limit]

    async def get_volunteer_or_raise(self, volunteer_id: str) -> VolunteerDocument:
        """Return a volunteer or raise when missing."""

        document = await self.volunteer_repository.get(volunteer_id)
        if not document:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")
        return self._to_schema(document)

    def _to_schema(self, document: dict) -> VolunteerDocument:
        payload = dict(document)
        payload["revision"] = payload.pop("_rev")
        payload.pop("_id", None)
        return VolunteerDocument.model_validate(payload)
