"""Dependency providers for repositories, providers, and services."""

from __future__ import annotations

from fastapi import Depends, Request

from app.core.config.settings import Settings, get_settings
from app.db.couchdb import AbstractDocumentStore
from app.db.repositories.audit_log_repository import AuditLogRepository
from app.db.repositories.camp_repository import CampRepository
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.db.repositories.inbound_message_repository import InboundMessageRepository
from app.db.repositories.need_repository import NeedRepository
from app.db.repositories.volunteer_repository import VolunteerRepository
from app.integrations.sms.client import SMSClient
from app.integrations.sms.message_parser import SMSProvider
from app.integrations.whatsapp.client import WhatsAppClient
from app.integrations.whatsapp.message_parser import WhatsAppProvider
from app.schemas.communication import ProviderName
from app.services.ai_triage_service import AITriageService
from app.services.camp_service import CampService
from app.services.communication_service import CommunicationService
from app.services.need_service import NeedService
from app.services.volunteer_service import VolunteerService


def get_document_store(request: Request) -> AbstractDocumentStore:
    """Return the initialized document store."""

    return request.app.state.document_store


def get_need_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> NeedRepository:
    """Build a need repository."""

    return NeedRepository(store)


def get_camp_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> CampRepository:
    """Build a camp repository."""

    return CampRepository(store)


def get_volunteer_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> VolunteerRepository:
    """Build a volunteer repository."""

    return VolunteerRepository(store)


def get_idempotency_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> IdempotencyRepository:
    """Build an idempotency repository."""

    return IdempotencyRepository(store)


def get_inbound_message_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> InboundMessageRepository:
    """Build an inbound message repository."""

    return InboundMessageRepository(store)


def get_audit_log_repository(
    store: AbstractDocumentStore = Depends(get_document_store),
) -> AuditLogRepository:
    """Build an audit log repository."""

    return AuditLogRepository(store)


def get_ai_triage_service(request: Request) -> AITriageService:
    """Return the initialized AI triage bridge."""

    return request.app.state.ai_triage_service


def get_whatsapp_provider(
    settings: Settings = Depends(get_settings),
) -> WhatsAppProvider:
    """Return the configured WhatsApp provider adapter."""

    return WhatsAppProvider(ProviderName(settings.whatsapp_provider))


def get_sms_provider(
    settings: Settings = Depends(get_settings),
) -> SMSProvider:
    """Return the configured SMS provider adapter."""

    return SMSProvider(ProviderName(settings.sms_provider))


def get_outbound_provider(settings: Settings = Depends(get_settings)):
    """Return the configured outbound stub provider."""

    return {
        "whatsapp": WhatsAppClient(ProviderName(settings.whatsapp_provider), settings),
        "sms": SMSClient(ProviderName(settings.sms_provider), settings),
    }


def get_need_service(
    repository: NeedRepository = Depends(get_need_repository),
    idempotency_repository: IdempotencyRepository = Depends(get_idempotency_repository),
    settings: Settings = Depends(get_settings),
) -> NeedService:
    """Build a need service."""

    return NeedService(repository, idempotency_repository, settings)


def get_camp_service(
    repository: CampRepository = Depends(get_camp_repository),
    idempotency_repository: IdempotencyRepository = Depends(get_idempotency_repository),
) -> CampService:
    """Build a camp service."""

    return CampService(repository, idempotency_repository)


def get_volunteer_service(
    volunteer_repository: VolunteerRepository = Depends(get_volunteer_repository),
    need_repository: NeedRepository = Depends(get_need_repository),
    camp_repository: CampRepository = Depends(get_camp_repository),
    idempotency_repository: IdempotencyRepository = Depends(get_idempotency_repository),
) -> VolunteerService:
    """Build a volunteer service."""

    return VolunteerService(
        volunteer_repository,
        need_repository,
        camp_repository,
        idempotency_repository,
    )


def get_communication_service(
    inbound_repository: InboundMessageRepository = Depends(get_inbound_message_repository),
    audit_repository: AuditLogRepository = Depends(get_audit_log_repository),
    need_service: NeedService = Depends(get_need_service),
    triage_service: AITriageService = Depends(get_ai_triage_service),
    outbound_provider=Depends(get_outbound_provider),
) -> CommunicationService:
    """Build the communication service."""

    return CommunicationService(
        inbound_repository=inbound_repository,
        audit_repository=audit_repository,
        need_service=need_service,
        triage_service=triage_service,
        outbound_providers=outbound_provider,
    )
