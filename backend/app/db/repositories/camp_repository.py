"""Persistence access for camps."""

from __future__ import annotations

from typing import Any

from app.db.couchdb import AbstractDocumentStore


class CampRepository:
    """Repository for camp documents."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def list(self) -> list[dict[str, Any]]:
        return await self.store.list_documents("camp")

    async def get(self, camp_id: str) -> dict[str, Any] | None:
        return await self.store.get_document(camp_id)

    async def save(
        self,
        camp_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        return await self.store.save_document(camp_id, payload, expected_revision)
