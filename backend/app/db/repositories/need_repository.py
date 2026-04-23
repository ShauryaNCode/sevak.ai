"""Persistence access for needs."""

from __future__ import annotations

from datetime import timedelta
from typing import Any

from app.db.couchdb import AbstractDocumentStore
from app.utils.datetime import utc_now


class NeedRepository:
    """Repository for need documents."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def list(self) -> list[dict[str, Any]]:
        return await self.store.list_documents("need")

    async def get(self, need_id: str) -> dict[str, Any] | None:
        return await self.store.get_document(need_id)

    async def save(
        self,
        need_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        return await self.store.save_document(need_id, payload, expected_revision)

    async def find_recent_by_dedup_hash(
        self,
        dedup_hash: str,
        hours: int = 24,
    ) -> dict[str, Any] | None:
        created_after = (utc_now() - timedelta(hours=hours)).isoformat()
        return await self.store.find_recent_need_by_dedup_hash(dedup_hash, created_after)
