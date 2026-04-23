"""Shared communication provider abstractions."""

from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Any

from app.schemas.communication import InboundMessage, OutboundMessageRequest, OutboundMessageResult


class BaseProvider(ABC):
    """Thin inbound provider adapter."""

    @abstractmethod
    def parse_inbound(self, payload: dict[str, Any]) -> InboundMessage:
        """Normalize provider payload into canonical inbound model."""


class BaseOutboundProvider(ABC):
    """Thin outbound provider interface."""

    @abstractmethod
    async def send_message(self, payload: OutboundMessageRequest) -> OutboundMessageResult:
        """Send or simulate an outbound message."""
