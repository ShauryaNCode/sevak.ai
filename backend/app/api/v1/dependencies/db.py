"""Dependency providers for repositories and services."""

from __future__ import annotations

from fastapi import Depends, Request

from app.core.config.settings import Settings, get_settings
from app.db.couchdb import AbstractDocumentStore
from app.db.repositories.idempotency_repository import IdempotencyRepository
from app.db.repositories.need_repository import NeedRepository
from app.db.repositories.volunteer_repository import VolunteerRepository
from app.services.ai_triage_service import AITriageService
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


def get_ai_triage_service() -> AITriageService:
    """Return the rule-based parser service."""

    return AITriageService()


def get_need_service(
    repository: NeedRepository = Depends(get_need_repository),
    idempotency_repository: IdempotencyRepository = Depends(get_idempotency_repository),
    settings: Settings = Depends(get_settings),
) -> NeedService:
    """Build a need service."""

    return NeedService(repository, idempotency_repository, settings)


def get_volunteer_service(
    volunteer_repository: VolunteerRepository = Depends(get_volunteer_repository),
    need_repository: NeedRepository = Depends(get_need_repository),
    idempotency_repository: IdempotencyRepository = Depends(get_idempotency_repository),
) -> VolunteerService:
    """Build a volunteer service."""

    return VolunteerService(volunteer_repository, need_repository, idempotency_repository)
