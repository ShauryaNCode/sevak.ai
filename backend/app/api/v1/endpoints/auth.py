"""Authentication endpoints for development OTP flows."""

from __future__ import annotations

import logging
import secrets
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Final
from uuid import uuid4

from fastapi import APIRouter, Header, Request, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from app.core.security.rbac import Role


logger = logging.getLogger(__name__)
router = APIRouter(prefix="/auth", tags=["auth"])

_OTP_EXPIRY_SECONDS: Final[int] = 300
_ACCESS_TOKEN_EXPIRY_SECONDS: Final[int] = 3600
_OTP_REQUEST_LIMIT_SECONDS: Final[int] = 60
_DEV_OTP: Final[str] = "123456"
_DEV_ADMIN_PHONE: Final[str] = "+919404417174"


@dataclass
class _OtpSession:
    phone: str
    otp: str
    expires_at: datetime
    requested_at: datetime
    attempts: int = 0


@dataclass
class _RefreshSession:
    phone: str
    user_id: str
    role: Role
    issued_at: datetime


_otp_sessions: dict[str, _OtpSession] = {}
_refresh_sessions: dict[str, _RefreshSession] = {}


class OtpRequestPayload(BaseModel):
    """Request body for OTP delivery."""

    phone: str = Field(min_length=13, max_length=13)


class OtpRequestResponse(BaseModel):
    """Success response for OTP requests."""

    message: str
    expires_in_seconds: int


class ErrorResponse(BaseModel):
    """Error response payload used by auth endpoints."""

    error: str
    retry_after_seconds: int | None = None


class VerifyOtpPayload(BaseModel):
    """Request body for OTP verification."""

    phone: str = Field(min_length=13, max_length=13)
    otp: str = Field(min_length=6, max_length=6)


class AuthUserResponse(BaseModel):
    """Authenticated user payload returned to the client."""

    id: str
    name: str
    role: Role
    zone_id: str
    phone: str
    language_preference: str


class VerifyOtpResponse(BaseModel):
    """Success response for OTP verification."""

    access_token: str
    refresh_token: str
    expires_in: int
    user: AuthUserResponse


class RefreshTokenPayload(BaseModel):
    """Refresh token request payload."""

    refresh_token: str


class RefreshTokenResponse(BaseModel):
    """Refresh token success payload."""

    access_token: str
    expires_in: int


def _utc_now() -> datetime:
    return datetime.now(timezone.utc)


def _is_valid_indian_phone(phone: str) -> bool:
    return (
        len(phone) == 13
        and phone.startswith("+91")
        and phone[3:].isdigit()
        and phone[3] in {"6", "7", "8", "9"}
    )


async def _resolve_role_for_phone(request: Request, phone: str) -> Role:
    if phone == _DEV_ADMIN_PHONE:
        return Role.NATIONAL_ADMIN

    store = request.app.state.document_store
    volunteers = await store.list_documents("volunteer")
    matched_volunteer_id: str | None = None
    for volunteer in volunteers:
        if phone not in {
            volunteer.get("phone_number"),
            volunteer.get("whatsapp_number"),
            volunteer.get("alternate_number"),
        }:
            continue
        matched_volunteer_id = volunteer.get("id") or volunteer.get("_id")
        raw_role = volunteer.get("auth_role")
        if raw_role:
            try:
                resolved_role = Role(raw_role)
                if resolved_role != Role.VOLUNTEER:
                    return resolved_role
            except ValueError:
                logger.warning("Unknown volunteer auth_role %s for %s", raw_role, phone)
        break

    if matched_volunteer_id is not None:
        camps = await store.list_documents("camp")
        for camp in camps:
            managers = camp.get("managers") or []
            for manager in managers:
                if manager.get("volunteer_id") == matched_volunteer_id:
                    return Role.ZONE_COORDINATOR

    return Role.VOLUNTEER


async def _build_user(request: Request, phone: str) -> AuthUserResponse:
    suffix = phone[-4:]
    role = await _resolve_role_for_phone(request, phone)
    return AuthUserResponse(
        id=str(uuid4()),
        name=("Admin " if role != Role.VOLUNTEER else "Volunteer ") + suffix,
        role=role,
        zone_id="MH-04-PUNE",
        phone=phone,
        language_preference="en",
    )


def _create_access_token(user: AuthUserResponse) -> str:
    return f"dev-access-{user.id}-{secrets.token_urlsafe(24)}"


def _create_refresh_token(user: AuthUserResponse) -> str:
    return f"dev-refresh-{user.id}-{secrets.token_urlsafe(24)}"


def _error_response(
    status_code: int,
    error: str,
    retry_after_seconds: int | None = None,
) -> JSONResponse:
    payload: dict[str, int | str] = {"error": error}
    if retry_after_seconds is not None:
        payload["retry_after_seconds"] = retry_after_seconds
    return JSONResponse(status_code=status_code, content=payload)


@router.post(
    "/otp/request",
    response_model=OtpRequestResponse,
    responses={
        400: {"model": ErrorResponse},
        429: {"model": ErrorResponse},
    },
)
async def request_otp(payload: OtpRequestPayload) -> OtpRequestResponse:
    """Issue a development OTP for a valid Indian mobile number."""

    if not _is_valid_indian_phone(payload.phone):
        return _error_response(
            status_code=status.HTTP_400_BAD_REQUEST,
            error="INVALID_PHONE",
        )

    now = _utc_now()
    existing = _otp_sessions.get(payload.phone)
    if existing is not None and (now - existing.requested_at).total_seconds() < _OTP_REQUEST_LIMIT_SECONDS:
        retry_after = _OTP_REQUEST_LIMIT_SECONDS - int((now - existing.requested_at).total_seconds())
        return _error_response(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            error="RATE_LIMIT",
            retry_after_seconds=retry_after,
        )

    session = _OtpSession(
        phone=payload.phone,
        otp=_DEV_OTP,
        expires_at=now + timedelta(seconds=_OTP_EXPIRY_SECONDS),
        requested_at=now,
    )
    _otp_sessions[payload.phone] = session

    logger.info("Development OTP issued for %s: %s", payload.phone, _DEV_OTP)

    return OtpRequestResponse(
        message="OTP sent",
        expires_in_seconds=_OTP_EXPIRY_SECONDS,
    )


@router.post(
    "/otp/verify",
    response_model=VerifyOtpResponse,
    responses={
        400: {"model": ErrorResponse},
        429: {"model": ErrorResponse},
    },
)
async def verify_otp(payload: VerifyOtpPayload, request: Request) -> VerifyOtpResponse:
    """Verify a development OTP and return token/user data."""

    session = _otp_sessions.get(payload.phone)
    if session is None:
        return _error_response(
            status_code=status.HTTP_400_BAD_REQUEST,
            error="OTP_EXPIRED",
        )

    now = _utc_now()
    if now > session.expires_at:
        _otp_sessions.pop(payload.phone, None)
        return _error_response(
            status_code=status.HTTP_400_BAD_REQUEST,
            error="OTP_EXPIRED",
        )

    if session.attempts >= 5:
        return _error_response(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            error="TOO_MANY_ATTEMPTS",
        )

    if payload.otp != session.otp:
        session.attempts += 1
        return _error_response(
            status_code=status.HTTP_400_BAD_REQUEST,
            error="INVALID_OTP",
        )

    user = await _build_user(request, payload.phone)
    access_token = _create_access_token(user)
    refresh_token = _create_refresh_token(user)
    _refresh_sessions[refresh_token] = _RefreshSession(
        phone=payload.phone,
        user_id=user.id,
        role=user.role,
        issued_at=now,
    )
    _otp_sessions.pop(payload.phone, None)

    return VerifyOtpResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=_ACCESS_TOKEN_EXPIRY_SECONDS,
        user=user,
    )


@router.post(
    "/refresh",
    response_model=RefreshTokenResponse,
    responses={400: {"model": ErrorResponse}},
)
async def refresh_token(payload: RefreshTokenPayload) -> RefreshTokenResponse:
    """Exchange a valid refresh token for a new access token."""

    session = _refresh_sessions.get(payload.refresh_token)
    if session is None:
        return _error_response(
            status_code=status.HTTP_400_BAD_REQUEST,
            error="INVALID_REFRESH_TOKEN",
        )

    user = AuthUserResponse(
        id=session.user_id,
        name=f"Volunteer {session.phone[-4:]}",
        role=session.role,
        zone_id="MH-04-PUNE",
        phone=session.phone,
        language_preference="en",
    )
    return RefreshTokenResponse(
        access_token=_create_access_token(user),
        expires_in=_ACCESS_TOKEN_EXPIRY_SECONDS,
    )


@router.post("/logout", status_code=status.HTTP_200_OK)
async def logout(authorization: str | None = Header(default=None)) -> dict[str, str]:
    """Best-effort logout endpoint for development clients."""

    if authorization is None or not authorization.startswith("Bearer "):
        return _error_response(
            status_code=status.HTTP_401_UNAUTHORIZED,
            error="UNAUTHORIZED",
        )

    return {"message": "Logged out"}
