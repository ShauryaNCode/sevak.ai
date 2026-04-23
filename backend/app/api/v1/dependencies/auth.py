"""Minimal auth dependency placeholders."""

from __future__ import annotations

from pydantic import BaseModel


class CurrentUser(BaseModel):
    """Placeholder authenticated principal."""

    user_id: str = "system"
    role: str = "NATIONAL_ADMIN"


async def get_current_user() -> CurrentUser:
    """Return a placeholder user for future expansion."""

    return CurrentUser()
