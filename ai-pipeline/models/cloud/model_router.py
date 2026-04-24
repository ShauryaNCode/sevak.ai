"""Route messages between cloud, offline, and local-fallback execution."""

from __future__ import annotations

import os

from models.cloud.gemini_client import GeminiClient
from models.contracts import MessageSource, NormalizedMessage, ProcessingMode, RouteDecision


class ModelRouter:
    """Choose the best execution mode based on connectivity and config."""

    def __init__(self, gemini_client: GeminiClient | None = None) -> None:
        self.gemini_client = gemini_client or GeminiClient()

    def route(
        self,
        message: NormalizedMessage,
        connectivity_available: bool | None = None,
    ) -> RouteDecision:
        connected = self._resolve_connectivity(connectivity_available)
        if not connected:
            return RouteDecision(
                mode=ProcessingMode.OFFLINE,
                reason="connectivity_unavailable",
                pending_cloud_processing=True,
            )

        if self.gemini_client.is_configured():
            return RouteDecision(
                mode=ProcessingMode.CLOUD,
                reason="gemini_configured",
                pending_cloud_processing=False,
            )

        return RouteDecision(
            mode=ProcessingMode.LOCAL_FALLBACK,
            reason="gemini_not_configured",
            pending_cloud_processing=False,
        )

    def select_cloud_model(self, message: NormalizedMessage) -> str:
        complexity = 0
        body = message.clean_body.lower()
        if len(body) > 160:
            complexity += 1
        if message.source == MessageSource.VOICE_TRANSCRIPT:
            complexity += 1
        if sum(character.isdigit() for character in body) >= 2:
            complexity += 1
        if "," in body or ";" in body or " and " in body:
            complexity += 1
        return self.gemini_client.select_model(complexity)

    def _resolve_connectivity(self, override: bool | None) -> bool:
        if override is not None:
            return override
        forced_offline = os.getenv("SEVAK_FORCE_OFFLINE", "").strip().lower()
        return forced_offline not in {"1", "true", "yes", "on"}
