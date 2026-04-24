"""Best-effort Gemini client with graceful local fallback."""

from __future__ import annotations

import json
import os
import re
from time import perf_counter
from typing import Any
from urllib import error, request

from models.contracts import GeminiGeneration


class GeminiClient:
    """Invoke Gemini via HTTP when credentials are available."""

    API_TEMPLATE = "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"

    def __init__(
        self,
        api_key: str | None = None,
        triage_model: str | None = None,
        complex_model: str | None = None,
        timeout_seconds: int = 15,
    ) -> None:
        self.api_key = api_key or os.getenv("GEMINI_API_KEY")
        self.triage_model = triage_model or os.getenv("GEMINI_MODEL_TRIAGE", "gemini-1.5-flash")
        self.complex_model = complex_model or os.getenv("GEMINI_MODEL_COMPLEX", "gemini-1.5-pro")
        self.timeout_seconds = timeout_seconds

    def is_configured(self) -> bool:
        return bool(self.api_key)

    def generate_structured_triage(self, prompt: str, model: str | None = None) -> GeminiGeneration:
        selected_model = model or self.triage_model
        started = perf_counter()

        if not self.api_key:
            return GeminiGeneration(
                model=selected_model,
                text="",
                parsed_json=None,
                latency_ms=0,
                used_network=False,
                error="missing_api_key",
            )

        payload = {
            "contents": [{"role": "user", "parts": [{"text": prompt}]}],
            "generationConfig": {"temperature": 0.2},
        }
        endpoint = self.API_TEMPLATE.format(model=selected_model, api_key=self.api_key)
        request_bytes = json.dumps(payload).encode("utf-8")
        http_request = request.Request(
            endpoint,
            data=request_bytes,
            headers={"Content-Type": "application/json"},
            method="POST",
        )

        try:
            with request.urlopen(http_request, timeout=self.timeout_seconds) as response:
                response_body = response.read().decode("utf-8")
                response_json = json.loads(response_body)
        except (OSError, ValueError, error.URLError, error.HTTPError) as exc:
            return GeminiGeneration(
                model=selected_model,
                text="",
                parsed_json=None,
                latency_ms=int((perf_counter() - started) * 1000),
                used_network=False,
                error=str(exc),
            )

        text = self._extract_text(response_json)
        parsed_json = self._extract_json_object(text)
        return GeminiGeneration(
            model=selected_model,
            text=text,
            parsed_json=parsed_json,
            latency_ms=int((perf_counter() - started) * 1000),
            used_network=True,
            error=None if parsed_json is not None else "unparseable_json_response",
        )

    def select_model(self, complexity_score: int) -> str:
        return self.complex_model if complexity_score >= 3 else self.triage_model

    def _extract_text(self, response_json: dict[str, Any]) -> str:
        candidates = response_json.get("candidates") or []
        if not candidates:
            return ""
        parts = (((candidates[0].get("content") or {}).get("parts")) or [])
        texts = [part.get("text", "") for part in parts if isinstance(part, dict)]
        return "\n".join(text for text in texts if text).strip()

    def _extract_json_object(self, response_text: str) -> dict[str, Any] | None:
        cleaned = response_text.strip()
        if not cleaned:
            return None

        fenced_match = re.search(r"```(?:json)?\s*(\{.*\})\s*```", cleaned, flags=re.DOTALL)
        if fenced_match:
            cleaned = fenced_match.group(1)
        elif not cleaned.startswith("{"):
            bare_match = re.search(r"(\{.*\})", cleaned, flags=re.DOTALL)
            cleaned = bare_match.group(1) if bare_match else cleaned

        try:
            parsed = json.loads(cleaned)
        except json.JSONDecodeError:
            return None
        return parsed if isinstance(parsed, dict) else None
