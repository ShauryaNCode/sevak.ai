"""Persistence access for idempotency records."""

from __future__ import annotations

from typing import Any

from app.db.couchdb import AbstractDocumentStore


class IdempotencyRepository:
    """Repository for idempotency entries."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def get(self, key: str) -> dict[str, Any] | None:
        return await self.store.get_document(key)

    async def save(self, key: str, payload: dict[str, Any]) -> dict[str, Any]:
        return await self.store.save_document(key, payload)
