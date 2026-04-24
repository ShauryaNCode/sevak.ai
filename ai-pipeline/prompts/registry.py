"""Prompt loading and minimal template rendering."""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


class PromptRegistry:
    """Load versioned prompts without bringing in heavy templating deps."""

    def __init__(self) -> None:
        self.base_path = Path(__file__).resolve().parent

    def render(self, prompt_name: str, context: dict[str, Any], prompt_version: str = "v1") -> str:
        template = self._load_template(prompt_name, prompt_version)
        cleaned = re.sub(r"\{#.*?#\}", "", template, flags=re.DOTALL)

        rendered = cleaned
        for key, value in context.items():
            placeholder_pattern = re.compile(r"\{\{\s*" + re.escape(key) + r"\s*\}\}")
            if isinstance(value, str):
                replacement = value
            else:
                replacement = json.dumps(value, ensure_ascii=False)
            rendered = placeholder_pattern.sub(replacement, rendered)

        return rendered.strip()

    def _load_template(self, prompt_name: str, prompt_version: str) -> str:
        versioned_path = self.base_path / "versioned" / prompt_version / f"{prompt_name}.j2"
        template_path = versioned_path if versioned_path.exists() else self.base_path / "templates" / f"{prompt_name}.j2"
        return template_path.read_text(encoding="utf-8")
