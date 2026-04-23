"""
SevakAI Backend — Application Settings

All configuration is environment-driven. No secrets are hardcoded.
In production, secrets are sourced from GCP Secret Manager via
environment variable injection by Workload Identity.

Usage:
    from app.core.config.settings import get_settings
    settings = get_settings()
    print(settings.database_url)
"""

from functools import lru_cache
from typing import Literal

# TODO: from pydantic_settings import BaseSettings, Field


class Settings:
    """
    Application settings loaded from environment variables.

    TODO: Replace this placeholder with Pydantic BaseSettings.

    Required environment variables:
        DATABASE_URL            PostgreSQL connection string (asyncpg)
        COUCHDB_URL             CouchDB base URL with credentials
        REDIS_URL               Redis connection URL
        SECRET_KEY              JWT signing key (min 32 bytes)
        GEMINI_API_KEY          Google Gemini API key
        TWILIO_AUTH_TOKEN       Twilio authentication token
        TWILIO_ACCOUNT_SID      Twilio account SID
        GUPSHUP_API_KEY         Gupshup API key
        GUPSHUP_WEBHOOK_SECRET  Gupshup webhook HMAC secret

    Optional environment variables:
        ENVIRONMENT             "development" | "staging" | "production" (default: development)
        LOG_LEVEL               "DEBUG" | "INFO" | "WARNING" | "ERROR" (default: INFO)
        CORS_ORIGINS            Comma-separated list of allowed origins
        MAX_SYNC_BATCH_SIZE     Maximum documents per sync push (default: 500)
        AI_PROVIDER             "gemini" | "local" (default: gemini)
        BURST_MODE              "true" | "false" (default: false)
    """

    # TODO: Implement using Pydantic BaseSettings
    # Example structure:

    # Database
    # database_url: str = Field(..., env="DATABASE_URL")
    # couchdb_url: str = Field(..., env="COUCHDB_URL")
    # redis_url: str = Field(..., env="REDIS_URL")

    # Security
    # secret_key: str = Field(..., env="SECRET_KEY")
    # jwt_algorithm: str = "HS256"
    # access_token_expire_minutes: int = 60
    # refresh_token_expire_days: int = 30

    # AI
    # gemini_api_key: str = Field(..., env="GEMINI_API_KEY")
    # gemini_model_triage: str = "gemini-1.5-flash"
    # gemini_model_complex: str = "gemini-1.5-pro"

    # Communication
    # twilio_auth_token: str = Field(..., env="TWILIO_AUTH_TOKEN")
    # twilio_account_sid: str = Field(..., env="TWILIO_ACCOUNT_SID")
    # gupshup_api_key: str = Field(..., env="GUPSHUP_API_KEY")

    # Sync
    # max_sync_batch_size: int = 500
    # sync_conflict_resolution_window_hours: int = 24

    # Environment
    # environment: Literal["development", "staging", "production"] = "development"
    # log_level: str = "INFO"

    pass


@lru_cache()
def get_settings() -> Settings:
    """
    Returns cached settings instance.
    Use lru_cache to avoid re-parsing env vars on every request.
    """
    # TODO: return Settings()
    return Settings()