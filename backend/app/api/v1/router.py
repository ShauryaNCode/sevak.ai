"""API router registration."""

from fastapi import APIRouter

from app.api.v1.endpoints.auth import router as auth_router
from app.api.v1.endpoints.camps import router as camps_router
from app.api.v1.endpoints.needs import assignment_router, router as needs_router
from app.api.v1.endpoints.volunteers import match_router, router as volunteers_router
from app.api.v1.endpoints.webhooks import router as webhooks_router


api_router = APIRouter()
api_router.include_router(auth_router)
api_router.include_router(camps_router)
api_router.include_router(needs_router)
api_router.include_router(volunteers_router)
api_router.include_router(match_router)
api_router.include_router(assignment_router)
api_router.include_router(webhooks_router)
