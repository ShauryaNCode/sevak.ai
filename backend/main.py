"""Local entrypoint for `uvicorn main:app --reload` from backend/."""

from app.main import app, create_application

__all__ = ["app", "create_application"]
