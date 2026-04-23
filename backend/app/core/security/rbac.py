"""RBAC contract placeholder.

TODO: Move role and authorization helpers here as part of backend package normalization.
"""

from enum import Enum


class Role(str, Enum):
    """Blueprint role enumeration."""

    VOLUNTEER = "VOLUNTEER"
    ZONE_COORDINATOR = "ZONE_COORDINATOR"
    DISTRICT_ADMIN = "DISTRICT_ADMIN"
    NATIONAL_ADMIN = "NATIONAL_ADMIN"
    AI_SYSTEM = "AI_SYSTEM"
