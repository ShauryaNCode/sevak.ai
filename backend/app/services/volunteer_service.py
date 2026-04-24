"""Volunteer workflows."""

from __future__ import annotations

from uuid import uuid4

from app.db.couchdb import DocumentNotFoundError
from app.db.repositories.camp_repository import CampRepository
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.db.repositories.need_repository import NeedRepository
from app.db.repositories.volunteer_repository import VolunteerRepository
from app.core.security.rbac import Role
from app.schemas.need import NeedDocument
from app.schemas.volunteer import (
    VolunteerCreate,
    VolunteerDocument,
    VolunteerMatch,
    VolunteerProfileUpdate,
)
from app.utils.datetime import utc_now
from app.utils.geo import haversine_distance_km
from app.utils.validators import normalize_skill


class VolunteerService:
    """Handle volunteer registration and need matching."""

    def __init__(
        self,
        volunteer_repository: VolunteerRepository,
        need_repository: NeedRepository,
        camp_repository: CampRepository,
        idempotency_repository: IdempotencyRepository,
    ) -> None:
        self.volunteer_repository = volunteer_repository
        self.need_repository = need_repository
        self.camp_repository = camp_repository
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
            "phone_number": payload.phone_number,
            "whatsapp_number": payload.whatsapp_number,
            "alternate_number": payload.alternate_number,
            "gender": payload.gender,
            "qualification": payload.qualification,
            "designation": payload.designation,
            "zone_id": payload.zone_id,
            "camp_id": payload.camp_id,
            "auth_role": payload.auth_role.value,
            "skills": payload.skills,
            "notes": payload.notes,
            "location": payload.location.model_dump(),
            "availability": payload.availability,
            "status": payload.status.value,
            "current_assignment_need_id": existing.get("current_assignment_need_id") if existing else None,
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

    async def list_volunteers(
        self,
        zone_id: str | None = None,
        camp_id: str | None = None,
    ) -> list[VolunteerDocument]:
        """List volunteers with optional zone and camp filters."""

        documents = [self._to_schema(doc) for doc in await self.volunteer_repository.list()]
        if zone_id is not None:
            documents = [document for document in documents if document.zone_id == zone_id]
        if camp_id is not None:
            documents = [document for document in documents if document.camp_id == camp_id]
        return documents

    async def update_auth_role(
        self,
        volunteer_id: str,
        auth_role: Role,
    ) -> VolunteerDocument:
        """Update the login role granted to a volunteer profile."""

        existing = await self.volunteer_repository.get(volunteer_id)
        if not existing:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")

        updated = dict(existing)
        updated["auth_role"] = auth_role.value
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.volunteer_repository.save(
            volunteer_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def update_profile(
        self,
        volunteer_id: str,
        payload: VolunteerProfileUpdate,
    ) -> VolunteerDocument:
        """Update volunteer profile details without changing auth/session state."""

        existing = await self.volunteer_repository.get(volunteer_id)
        if not existing:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")

        updated = dict(existing)
        if payload.name is not None:
            updated["name"] = payload.name
        if payload.whatsapp_number is not None:
            updated["whatsapp_number"] = payload.whatsapp_number
        if payload.alternate_number is not None:
            updated["alternate_number"] = payload.alternate_number
        if payload.gender is not None:
            updated["gender"] = payload.gender
        if payload.qualification is not None:
            updated["qualification"] = payload.qualification
        if payload.designation is not None:
            updated["designation"] = payload.designation
        if payload.notes is not None:
            updated["notes"] = payload.notes
        if payload.skills is not None:
            updated["skills"] = payload.skills
        if payload.location is not None:
            updated["location"] = payload.location.model_dump()
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.volunteer_repository.save(
            volunteer_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def assign_to_need(
        self,
        volunteer_id: str,
        need_id: str,
    ) -> VolunteerDocument:
        """Mark a volunteer as assigned to a live need."""

        existing = await self.volunteer_repository.get(volunteer_id)
        if not existing:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")

        updated = dict(existing)
        updated["availability"] = False
        updated["status"] = "assigned"
        updated["current_assignment_need_id"] = need_id
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.volunteer_repository.save(
            volunteer_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def release_from_need(
        self,
        volunteer_id: str,
        location: dict | None = None,
    ) -> VolunteerDocument:
        """Mark a volunteer as available after a need is completed."""

        existing = await self.volunteer_repository.get(volunteer_id)
        if not existing:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")

        updated = dict(existing)
        updated["availability"] = True
        updated["status"] = "available"
        updated["current_assignment_need_id"] = None
        updated["camp_id"] = None
        if location is not None:
            updated["location"] = location
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.volunteer_repository.save(
            volunteer_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    async def assign_to_camp(
        self,
        volunteer_id: str,
        camp_id: str | None,
    ) -> VolunteerDocument:
        """Assign a volunteer to a camp and sync the volunteer location to the camp."""

        existing = await self.volunteer_repository.get(volunteer_id)
        if not existing:
            raise DocumentNotFoundError(f"Volunteer {volunteer_id} not found")
        if existing.get("current_assignment_need_id"):
            raise ValueError("Volunteer still has an active assigned need")

        updated = dict(existing)
        updated["camp_id"] = camp_id
        updated["availability"] = True
        updated["status"] = "available"
        updated["current_assignment_need_id"] = None
        if camp_id is not None:
            camp = await self.camp_repository.get(camp_id)
            if not camp:
                raise DocumentNotFoundError(f"Camp {camp_id} not found")
            updated["location"] = camp.get("location", updated.get("location"))
        updated["updated_at"] = utc_now().isoformat()
        saved = await self.volunteer_repository.save(
            volunteer_id,
            updated,
            expected_revision=existing.get("_rev"),
        )
        return self._to_schema(saved)

    def _to_schema(self, document: dict) -> VolunteerDocument:
        payload = dict(document)
        payload["revision"] = payload.pop("_rev")
        payload.pop("_id", None)
        return VolunteerDocument.model_validate(payload)
