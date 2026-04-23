"""Persistence access for volunteers."""

from __future__ import annotations

from typing import Any

from app.db.couchdb import AbstractDocumentStore


class VolunteerRepository:
    """Repository for volunteer documents."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def list(self) -> list[dict[str, Any]]:
        return await self.store.list_documents("volunteer")

    async def get(self, volunteer_id: str) -> dict[str, Any] | None:
        return await self.store.get_document(volunteer_id)

    async def save(
        self,
        volunteer_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        return await self.store.save_document(volunteer_id, payload, expected_revision)
