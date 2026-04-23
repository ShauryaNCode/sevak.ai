"""Pagination helpers for future expansion."""

from pydantic import BaseModel, Field


class LimitOffsetParams(BaseModel):
    """Simple pagination parameters."""

    limit: int = Field(default=50, ge=1, le=200)
    offset: int = Field(default=0, ge=0)
