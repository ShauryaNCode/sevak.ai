"""Document store implementations with CouchDB and JSON fallback."""

from __future__ import annotations

import asyncio
import json
from pathlib import Path
from typing import Any, Protocol

import httpx

from app.core.config.settings import Settings


class DocumentConflictError(Exception):
    """Raised when a document revision no longer matches storage state."""


class DocumentNotFoundError(Exception):
    """Raised when a document does not exist."""


class AbstractDocumentStore(Protocol):
    """Document store contract."""

    backend_name: str

    async def initialize(self) -> None:
        """Prepare the store."""

    async def list_documents(self, document_type: str) -> list[dict[str, Any]]:
        """List documents by type."""

    async def get_document(self, document_id: str) -> dict[str, Any] | None:
        """Fetch a single document."""

    async def save_document(
        self,
        document_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        """Create or update a document."""

    async def find_recent_need_by_dedup_hash(
        self,
        dedup_hash: str,
        created_after_iso: str,
    ) -> dict[str, Any] | None:
        """Find a recent need by dedup hash."""


class JsonDocumentStore:
    """Local JSON-backed mock database."""

    backend_name = "json"

    def __init__(self, path: Path) -> None:
        self.path = path

    async def initialize(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        if not self.path.exists():
            self.path.write_text("{}", encoding="utf-8")

    async def list_documents(self, document_type: str) -> list[dict[str, Any]]:
        data = self._read_all()
        return [doc for doc in data.values() if doc.get("document_type") == document_type]

    async def get_document(self, document_id: str) -> dict[str, Any] | None:
        return self._read_all().get(document_id)

    async def save_document(
        self,
        document_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        data = self._read_all()
        existing = data.get(document_id)

        if expected_revision is not None:
            current_revision = existing.get("_rev") if existing else None
            if current_revision != expected_revision:
                raise DocumentConflictError("Document revision mismatch")

        revision_number = 1
        if existing and existing.get("_rev"):
            revision_number = int(str(existing["_rev"]).split("-", maxsplit=1)[0]) + 1

        stored = dict(payload)
        stored["_id"] = document_id
        stored["_rev"] = f"{revision_number}-{document_id}"
        data[document_id] = stored
        self._write_all(data)
        return stored

    async def find_recent_need_by_dedup_hash(
        self,
        dedup_hash: str,
        created_after_iso: str,
    ) -> dict[str, Any] | None:
        data = self._read_all()
        candidates: list[dict[str, Any]] = []
        for document in data.values():
            if document.get("document_type") != "need":
                continue
            if document.get("dedup_hash") != dedup_hash:
                continue
            created_at = document.get("created_at") or document.get("timestamp")
            if not created_at or created_at < created_after_iso:
                continue
            candidates.append(document)

        candidates.sort(key=lambda item: item.get("created_at", ""), reverse=True)
        return candidates[0] if candidates else None

    def _read_all(self) -> dict[str, dict[str, Any]]:
        raw = self.path.read_text(encoding="utf-8")
        payload = json.loads(raw) if raw.strip() else {}
        return payload if isinstance(payload, dict) else {}

    def _write_all(self, data: dict[str, dict[str, Any]]) -> None:
        self.path.write_text(json.dumps(data, indent=2, sort_keys=True), encoding="utf-8")


class CouchDBDocumentStore:
    """Minimal CouchDB-backed document store."""

    backend_name = "couchdb"

    def __init__(self, base_url: str, db_name: str, timeout_seconds: float) -> None:
        self.base_url = base_url.rstrip("/")
        self.db_name = db_name
        self.timeout_seconds = timeout_seconds

    async def initialize(self) -> None:
        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.put(f"{self.base_url}/{self.db_name}")
            if response.status_code not in (201, 202, 412):
                response.raise_for_status()

    async def list_documents(self, document_type: str) -> list[dict[str, Any]]:
        body = {
            "selector": {"document_type": {"$eq": document_type}},
            "limit": 5000,
        }
        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.post(f"{self.base_url}/{self.db_name}/_find", json=body)
            response.raise_for_status()
            return response.json().get("docs", [])

    async def get_document(self, document_id: str) -> dict[str, Any] | None:
        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.get(f"{self.base_url}/{self.db_name}/{document_id}")
            if response.status_code == 404:
                return None
            response.raise_for_status()
            return response.json()

    async def save_document(
        self,
        document_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        document = dict(payload)
        if expected_revision is not None:
            document["_rev"] = expected_revision
        elif "_rev" in document and document["_rev"] is None:
            document.pop("_rev")

        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.put(
                f"{self.base_url}/{self.db_name}/{document_id}",
                json=document,
            )
            if response.status_code == 409:
                raise DocumentConflictError("Document revision mismatch")
            response.raise_for_status()
            result = response.json()
            document["_id"] = document_id
            document["_rev"] = result["rev"]
            return document

    async def find_recent_need_by_dedup_hash(
        self,
        dedup_hash: str,
        created_after_iso: str,
    ) -> dict[str, Any] | None:
        body = {
            "selector": {
                "document_type": {"$eq": "need"},
                "dedup_hash": {"$eq": dedup_hash},
                "created_at": {"$gte": created_after_iso},
            },
            "limit": 50,
        }
        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.post(f"{self.base_url}/{self.db_name}/_find", json=body)
            response.raise_for_status()
            docs = response.json().get("docs", [])
            docs.sort(key=lambda item: item.get("created_at", ""), reverse=True)
            return docs[0] if docs else None


class FirestoreDocumentStore:
    """Firebase/Firestore-backed document store using the Admin SDK."""

    backend_name = "firestore"

    def __init__(
        self,
        project_id: str | None,
        credentials_path: Path | None,
        collection_name: str,
    ) -> None:
        self.project_id = project_id
        self.credentials_path = credentials_path
        self.collection_name = collection_name
        self._client: Any | None = None

    async def initialize(self) -> None:
        await asyncio.to_thread(self._initialize_sync)

    async def list_documents(self, document_type: str) -> list[dict[str, Any]]:
        documents = await asyncio.to_thread(self._stream_all_sync)
        return [doc for doc in documents if doc.get("document_type") == document_type]

    async def get_document(self, document_id: str) -> dict[str, Any] | None:
        return await asyncio.to_thread(self._get_document_sync, document_id)

    async def save_document(
        self,
        document_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        return await asyncio.to_thread(
            self._save_document_sync,
            document_id,
            payload,
            expected_revision,
        )

    async def find_recent_need_by_dedup_hash(
        self,
        dedup_hash: str,
        created_after_iso: str,
    ) -> dict[str, Any] | None:
        documents = await self.list_documents("need")
        candidates = [
            document
            for document in documents
            if document.get("dedup_hash") == dedup_hash
            and (document.get("created_at") or document.get("timestamp") or "") >= created_after_iso
        ]
        candidates.sort(key=lambda item: item.get("created_at", ""), reverse=True)
        return candidates[0] if candidates else None

    def _initialize_sync(self) -> None:
        from firebase_admin import credentials, firestore, get_app, initialize_app

        try:
            app = get_app()
        except ValueError:
            options: dict[str, Any] = {}
            if self.project_id:
                options["projectId"] = self.project_id

            if self.credentials_path:
                app = initialize_app(
                    credentials.Certificate(str(self.credentials_path)),
                    options=options or None,
                )
            else:
                app = initialize_app(options=options or None)

        self._client = firestore.client(app=app)

    def _collection(self):
        if self._client is None:
            raise RuntimeError("Firestore client has not been initialized")
        return self._client.collection(self.collection_name)

    def _stream_all_sync(self) -> list[dict[str, Any]]:
        documents: list[dict[str, Any]] = []
        for snapshot in self._collection().stream():
            document = snapshot.to_dict() or {}
            document.setdefault("_id", snapshot.id)
            document.setdefault("_rev", f"1-{snapshot.id}")
            documents.append(document)
        return documents

    def _get_document_sync(self, document_id: str) -> dict[str, Any] | None:
        snapshot = self._collection().document(document_id).get()
        if not snapshot.exists:
            return None
        document = snapshot.to_dict() or {}
        document.setdefault("_id", snapshot.id)
        document.setdefault("_rev", f"1-{snapshot.id}")
        return document

    def _save_document_sync(
        self,
        document_id: str,
        payload: dict[str, Any],
        expected_revision: str | None = None,
    ) -> dict[str, Any]:
        document_ref = self._collection().document(document_id)
        snapshot = document_ref.get()
        existing = snapshot.to_dict() if snapshot.exists else None

        if expected_revision is not None:
            current_revision = existing.get("_rev") if existing else None
            if current_revision != expected_revision:
                raise DocumentConflictError("Document revision mismatch")

        revision_number = 1
        if existing and existing.get("_rev"):
            revision_number = int(str(existing["_rev"]).split("-", maxsplit=1)[0]) + 1

        stored = dict(payload)
        stored["_id"] = document_id
        stored["_rev"] = f"{revision_number}-{document_id}"
        document_ref.set(stored)
        return stored


def build_document_store(settings: Settings) -> AbstractDocumentStore:
    """Choose the preferred storage backend."""

    if settings.use_firestore:
        return FirestoreDocumentStore(
            project_id=settings.firebase_project_id,
            credentials_path=settings.firebase_credentials_path,
            collection_name=settings.firestore_collection_name,
        )
    if settings.use_couchdb and settings.couchdb_url:
        return CouchDBDocumentStore(
            base_url=settings.couchdb_url,
            db_name=settings.couchdb_db_name,
            timeout_seconds=settings.request_timeout_seconds,
        )
    return JsonDocumentStore(settings.storage_path)
