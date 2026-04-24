"""Application entry point for SevakAI backend."""

from __future__ import annotations

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.v1.router import api_router
from app.api.v1.endpoints.webhooks import router as webhooks_router
from app.core.config.settings import get_settings
from app.core.logging.setup import configure_logging
from app.core.middleware.error_handler import global_exception_handler
from app.core.middleware.rate_limit import RateLimitMiddleware
from app.core.middleware.request_id import RequestIDMiddleware
from app.db.couchdb import (
    DocumentConflictError,
    DocumentNotFoundError,
    JsonDocumentStore,
    build_document_store,
)
from app.services.ai_triage_service import AITriageService
from app.schemas.common import DebugAITriageRequest, DebugAITriageResponse
from app.utils.datetime import utc_now


logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize logging and storage backends."""

    settings = get_settings()
    configure_logging(settings.log_level)
    document_store = build_document_store(settings)
    try:
        await document_store.initialize()
    except Exception:
        logger.exception("Primary storage backend unavailable, falling back to JSON storage")
        document_store = JsonDocumentStore(settings.storage_path)
        await document_store.initialize()

    app.state.settings = settings
    app.state.document_store = document_store
    app.state.ai_triage_service = AITriageService()
    app.state.last_webhook_payload = None
    logger.info("Application startup complete")
    yield
    logger.info("Application shutdown complete")


async def not_found_handler(request: Request, exc: DocumentNotFoundError) -> JSONResponse:
    """Map missing documents to HTTP 404."""

    return JSONResponse(status_code=404, content={"detail": str(exc)})


async def conflict_handler(request: Request, exc: DocumentConflictError) -> JSONResponse:
    """Map revision conflicts to HTTP 409."""

    return JSONResponse(status_code=409, content={"detail": str(exc)})


def create_application() -> FastAPI:
    """Create the FastAPI application."""

    settings = get_settings()
    app = FastAPI(
        title=settings.app_name,
        version="1.0.0",
        description="Offline-first disaster response backend",
        lifespan=lifespan,
    )
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_allow_origins,
        allow_origin_regex=settings.cors_allow_origin_regex,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )
    app.add_middleware(RequestIDMiddleware)
    app.add_middleware(
        RateLimitMiddleware,
        max_requests=settings.rate_limit_max_requests,
        window_seconds=settings.rate_limit_window_seconds,
    )
    app.add_exception_handler(Exception, global_exception_handler)
    app.add_exception_handler(DocumentNotFoundError, not_found_handler)
    app.add_exception_handler(DocumentConflictError, conflict_handler)
    app.include_router(api_router, prefix=settings.api_v1_prefix)
    app.include_router(webhooks_router)

    @app.get("/health")
    async def health(request: Request) -> JSONResponse:
        store = request.app.state.document_store
        public_base_url = settings.public_base_url.rstrip("/") if settings.public_base_url else None
        return JSONResponse(
            content={
                "status": "ok",
                "storage_backend": store.backend_name,
                "ai_pipeline": request.app.state.ai_triage_service.health_snapshot(),
                "timestamp": utc_now().isoformat(),
                "public_base_url": public_base_url,
                "webhook_paths": {
                    "whatsapp": "/webhook/whatsapp",
                    "sms": "/webhook/sms",
                },
                "public_webhook_urls": {
                    "whatsapp": f"{public_base_url}/webhook/whatsapp" if public_base_url else None,
                    "sms": f"{public_base_url}/webhook/sms" if public_base_url else None,
                },
            }
        )

    @app.get("/debug/webhook-last")
    async def debug_webhook_last(request: Request) -> JSONResponse:
        payload = request.app.state.last_webhook_payload
        return JSONResponse(
            status_code=200 if payload is not None else 404,
            content=payload or {"detail": "No webhook received yet."},
        )

    @app.post("/debug/ai-triage", response_model=DebugAITriageResponse)
    async def debug_ai_triage(
        payload: DebugAITriageRequest,
        request: Request,
    ) -> DebugAITriageResponse:
        triage_service: AITriageService = request.app.state.ai_triage_service
        parsed = triage_service.debug_parse_text(
            raw_text=payload.raw_text,
            source=payload.source.upper(),
            connectivity_available=payload.connectivity_available,
        )
        return DebugAITriageResponse(
            source=payload.source.upper(),
            pipeline=triage_service.health_snapshot(),
            parsed=parsed,
        )

    return app


app = create_application()
