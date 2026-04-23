"""Compatibility module that re-exports the application entrypoint."""

from app.main import app, create_application

__all__ = ["app", "create_application"]
