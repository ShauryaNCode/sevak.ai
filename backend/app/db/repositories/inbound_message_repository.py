"""Persistence access for inbound communication records."""

from __future__ import annotations

from datetime import timedelta
from typing import Any

from app.db.couchdb import AbstractDocumentStore
from app.utils.datetime import utc_now


class InboundMessageRepository:
    """Repository for normalized inbound message records."""

    def __init__(self, store: AbstractDocumentStore) -> None:
        self.store = store

    async def save(
        self,
        message_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        return await self.store.save_document(message_id, payload, expected_revision)

    async def find_by_provider_message_id(self, provider_message_id: str) -> dict[str, Any] | None:
        messages = await self.store.list_documents("inbound_message")
        for message in messages:
            if message.get("provider_message_id") == provider_message_id:
                return message
        return None

    async def find_recent_by_dedup_hash(
        self,
        dedup_hash: str,
        hours: int = 24,
    ) -> dict[str, Any] | None:
        created_after = (utc_now() - timedelta(hours=hours)).isoformat()
        messages = await self.store.list_documents("inbound_message")
        matches = [
            message
            for message in messages
            if message.get("dedup_hash") == dedup_hash
            and (message.get("created_at") or "") >= created_after
        ]
        matches.sort(key=lambda item: item.get("created_at", ""), reverse=True)
        return matches[0] if matches else None
