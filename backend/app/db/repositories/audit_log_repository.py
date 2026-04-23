"""Persistence access for audit log records."""

from __future__ import annotations

from typing import Any

from app.db.couchdb import AbstractDocumentStore


class AuditLogRepository:
    """Repository for audit log documents."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def save(self, log_id: str, payload: dict[str, Any]) -> dict[str, Any]:
        return await self.store.save_document(log_id, payload)
