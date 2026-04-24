"""Unit tests for backend to ai-pipeline integration."""

from __future__ import annotations

import sys
import types
import unittest
from datetime import datetime, timezone

from pydantic import BaseModel

if "httpx" not in sys.modules:
    httpx_stub = types.ModuleType("httpx")

    class AsyncClient:  # pragma: no cover - test import shim only
        def __init__(self, *args, **kwargs) -> None:
            pass

    httpx_stub.AsyncClient = AsyncClient
    sys.modules["httpx"] = httpx_stub

if "pydantic_settings" not in sys.modules:
    settings_stub = types.ModuleType("pydantic_settings")

    class BaseSettings(BaseModel):  # pragma: no cover - test import shim only
        pass

    def SettingsConfigDict(**kwargs):  # pragma: no cover - test import shim only
        return dict(**kwargs)

    settings_stub.BaseSettings = BaseSettings
    settings_stub.SettingsConfigDict = SettingsConfigDict
    sys.modules["pydantic_settings"] = settings_stub

from app.schemas.communication import ChannelName, InboundMessage, ProviderName
from app.services.ai_triage_service import AITriageService
from app.services.communication_service import CommunicationService


class InMemoryInboundRepository:
    def __init__(self) -> None:
        self.by_id: dict[str, dict] = {}

    async def save(self, message_id: str, payload: dict, expected_revision: str | None = None) -> dict:
        revision = str(int(self.by_id.get(message_id, {}).get("_rev", "0")) + 1)
        stored = dict(payload)
        stored["_id"] = message_id
        stored["_rev"] = revision
        self.by_id[message_id] = stored
        return dict(stored)

    async def find_by_provider_message_id(self, provider_message_id: str) -> dict | None:
        for payload in self.by_id.values():
            if payload.get("provider_message_id") == provider_message_id:
                return dict(payload)
        return None

    async def find_recent_by_dedup_hash(self, dedup_hash: str, hours: int = 24) -> dict | None:
        for payload in reversed(list(self.by_id.values())):
            if payload.get("dedup_hash") == dedup_hash:
                return dict(payload)
        return None


class InMemoryAuditRepository:
    def __init__(self) -> None:
        self.saved: list[dict] = []

    async def save(self, log_id: str, payload: dict) -> dict:
        stored = dict(payload)
        stored["_id"] = log_id
        stored["_rev"] = str(len(self.saved) + 1)
        self.saved.append(stored)
        return stored


class FakeNeedDocument:
    def __init__(self, need_id: str, need_type: str) -> None:
        self.id = need_id
        self.need_type = need_type

    def model_dump(self, mode: str = "json") -> dict:
        return {"id": self.id, "need_type": self.need_type}


class FakeNeedService:
    def __init__(self) -> None:
        self.created_payloads: list[object] = []

    async def create_need(self, payload, idempotency_key: str | None = None):
        self.created_payloads.append(payload)
        return FakeNeedDocument("need-1", payload.need_type.value)

    async def get_need_or_raise(self, need_id: str):
        return FakeNeedDocument(need_id, "water")


class AIPipelineBridgeTests(unittest.IsolatedAsyncioTestCase):
    def setUp(self) -> None:
        self.triage_service = AITriageService()

    async def test_triage_service_uses_ai_pipeline_for_need_messages(self) -> None:
        parsed = self.triage_service.parse_whatsapp_message(
            "Bhai 50 log phase gaye hai, khana nahi hai, paani bhar gaya near Lal Chowk urgent"
        )

        self.assertEqual(parsed.intent, "NEED")
        self.assertEqual(parsed.need_type, "rescue")
        self.assertEqual(parsed.urgency, "high")
        self.assertEqual(parsed.location_name, "Lal Chowk")
        self.assertEqual(parsed.disaster_type, "FLOOD")
        self.assertIn("FOOD", parsed.needs)
        self.assertIn("RESCUE", parsed.needs)

    async def test_communication_service_ignores_offer_intents(self) -> None:
        inbound_repository = InMemoryInboundRepository()
        audit_repository = InMemoryAuditRepository()
        need_service = FakeNeedService()
        communication_service = CommunicationService(
            inbound_repository=inbound_repository,
            audit_repository=audit_repository,
            need_service=need_service,
            triage_service=self.triage_service,
            outbound_providers={},
        )
        inbound = InboundMessage(
            provider=ProviderName.mock,
            channel=ChannelName.whatsapp,
            sender="+919876543210",
            raw_text="Doctor available in Solapur camp for 20 patients",
            timestamp=datetime.now(timezone.utc),
            provider_message_id="wa-offer-1",
            metadata={},
            dedup_hash="offer-hash",
        )

        result = await communication_service.process_inbound_message(inbound)

        self.assertFalse(result["stored"])
        self.assertEqual(result["parsed"]["intent"], "OFFER")
        self.assertIn("not currently converted into a need", result["reason"])
        self.assertEqual(len(need_service.created_payloads), 0)

    async def test_communication_service_creates_need_from_ai_pipeline_result(self) -> None:
        inbound_repository = InMemoryInboundRepository()
        audit_repository = InMemoryAuditRepository()
        need_service = FakeNeedService()
        communication_service = CommunicationService(
            inbound_repository=inbound_repository,
            audit_repository=audit_repository,
            need_service=need_service,
            triage_service=self.triage_service,
            outbound_providers={},
        )
        inbound = InboundMessage(
            provider=ProviderName.mock,
            channel=ChannelName.sms,
            sender="+919876543210",
            raw_text="Need water in Sangli urgent",
            timestamp=datetime.now(timezone.utc),
            provider_message_id="sms-need-1",
            metadata={},
            dedup_hash="need-hash",
        )

        result = await communication_service.process_inbound_message(inbound)

        self.assertTrue(result["stored"])
        self.assertFalse(result["duplicate"])
        self.assertEqual(result["parsed"]["intent"], "NEED")
        self.assertEqual(result["parsed"]["need_type"], "water")
        self.assertEqual(len(need_service.created_payloads), 1)
        self.assertEqual(need_service.created_payloads[0].need_type.value, "water")


if __name__ == "__main__":
    unittest.main()
