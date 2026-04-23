"""Shared pytest fixtures for backend tests."""

from __future__ import annotations

from pathlib import Path
import sys

import pytest
import pytest_asyncio
from httpx import ASGITransport, AsyncClient

BACKEND_ROOT = Path(__file__).resolve().parents[1]
if str(BACKEND_ROOT) not in sys.path:
    sys.path.insert(0, str(BACKEND_ROOT))

from app.core.config.settings import get_settings
from app.db.couchdb import build_document_store
from app.main import create_application


@pytest.fixture
def test_storage_path(tmp_path: Path) -> Path:
    """Return an isolated storage path for each test."""

    return tmp_path / "test_db.json"


@pytest_asyncio.fixture
async def app(monkeypatch: pytest.MonkeyPatch, test_storage_path: Path):
    """Create an initialized application backed by a temporary JSON store."""

    monkeypatch.setenv("USE_COUCHDB", "false")
    monkeypatch.setenv("STORAGE_PATH", str(test_storage_path))
    monkeypatch.setenv("API_V1_PREFIX", "/api/v1")
    monkeypatch.setenv("RATE_LIMIT_MAX_REQUESTS", "1000")
    monkeypatch.setenv("RATE_LIMIT_WINDOW_SECONDS", "60")
    monkeypatch.setenv("WHATSAPP_PROVIDER", "twilio")
    monkeypatch.setenv("SMS_PROVIDER", "mock")
    monkeypatch.setenv("VALIDATE_PROVIDER_SIGNATURES", "false")

    get_settings.cache_clear()
    application = create_application()
    settings = get_settings()
    store = build_document_store(settings)
    await store.initialize()

    application.state.settings = settings
    application.state.document_store = store
    return application


@pytest_asyncio.fixture
async def client(app):
    """Create an async HTTP client bound to the test app."""

    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as async_client:
        yield async_client
