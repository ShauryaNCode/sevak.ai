"""
SevakAI Backend — Role-Based Access Control (RBAC)

Defines the role hierarchy and permission enforcement decorators.
All role checks are enforced at the FastAPI dependency layer.
Services and repositories assume the caller is already authorized.

Role Hierarchy (highest to lowest):
    NATIONAL_ADMIN > DISTRICT_ADMIN > ZONE_COORDINATOR > VOLUNTEER > AI_SYSTEM

Key Principle:
    Higher roles inherit all permissions of lower roles.
    AI_SYSTEM has write-only access to specific endpoints only.
"""

from enum import Enum
from typing import List

# TODO: from fastapi import Depends, HTTPException, status
# TODO: from app.api.v1.dependencies.auth import get_current_user
# TODO: from app.schemas.user import UserSchema


class Role(str, Enum):
    """
    User role enumeration.

    Stored as string in JWT claim 'role'.
    Stored as string in PostgreSQL users table.
    """
    VOLUNTEER = "VOLUNTEER"
    ZONE_COORDINATOR = "ZONE_COORDINATOR"
    DISTRICT_ADMIN = "DISTRICT_ADMIN"
    NATIONAL_ADMIN = "NATIONAL_ADMIN"
    AI_SYSTEM = "AI_SYSTEM"


# Role hierarchy — index = privilege level (higher = more access)
ROLE_HIERARCHY: List[Role] = [
    Role.VOLUNTEER,
    Role.ZONE_COORDINATOR,
    Role.DISTRICT_ADMIN,
    Role.NATIONAL_ADMIN,
]


def has_minimum_role(user_role: Role, minimum_role: Role) -> bool:
    """
    Check if a user's role meets the minimum required role.

    AI_SYSTEM is not in the hierarchy — it has fixed, specific permissions.

    TODO: Implement using ROLE_HIERARCHY index comparison.
    """
    # TODO: Implement
    raise NotImplementedError


def require_role(allowed_roles: List[Role]):
    """
    FastAPI dependency factory for role-based access control.

    Usage:
        @router.patch("/needs/{id}")
        async def update_need(
            need_id: UUID,
            current_user: UserSchema = Depends(require_role([Role.ZONE_COORDINATOR, Role.DISTRICT_ADMIN]))
        ):
            ...

    TODO: Implement as FastAPI dependency.
    """
    # TODO: Implement
    raise NotImplementedError


def require_zone_access(zone_id: str):
    """
    FastAPI dependency factory that ensures the current user
    has access to the specified zone.

    - NATIONAL_ADMIN: access to all zones
    - DISTRICT_ADMIN: access to all zones in their district
    - ZONE_COORDINATOR: access to their zone only
    - VOLUNTEER: access to their zone only (read-limited)

    TODO: Implement as FastAPI dependency.
    """
    # TODO: Implement
    raise NotImplementedError