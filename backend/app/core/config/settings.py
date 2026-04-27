"""Application settings for SevakAI backend."""

from functools import lru_cache
from pathlib import Path
from typing import Literal

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Environment-driven backend settings."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    app_name: str = "SevakAI Backend"
    environment: Literal["development", "test", "staging", "production"] = "development"
    log_level: str = "INFO"
    api_v1_prefix: str = "/api/v1"
    public_base_url: str | None = None
    whatsapp_provider: Literal["twilio", "gupshup", "mock"] = "twilio"
    sms_provider: Literal["twilio", "mock"] = "mock"
    validate_provider_signatures: bool = False
    twilio_account_sid: str | None = None
    twilio_auth_token: str | None = None
    twilio_whatsapp_number: str | None = None
    twilio_sms_number: str | None = None

    use_firestore: bool = False
    firebase_project_id: str | None = None
    firebase_credentials_path: Path | None = None
    firestore_collection_name: str = "sevakai_documents"
    use_couchdb: bool = False
    couchdb_url: str | None = None
    couchdb_db_name: str = "sevakai"
    storage_path: Path = Field(default=Path("data/mock_db.json"))
    default_distance_km: float = 25.0

    priority_weight_vulnerability: float = 0.5
    priority_weight_proximity: float = 0.3
    priority_weight_time: float = 0.2

    rate_limit_window_seconds: int = 60
    rate_limit_max_requests: int = 120

    request_timeout_seconds: float = 10.0
    cors_allow_origins: list[str] = Field(
        default_factory=lambda: [
            "http://localhost",
            "http://127.0.0.1",
            "http://localhost:3000",
            "http://127.0.0.1:3000",
            "http://localhost:5000",
            "http://127.0.0.1:5000",
            "http://localhost:8000",
            "http://127.0.0.1:8000",
        ]
    )
    cors_allow_origin_regex: str = r".*"


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return cached settings."""

    return Settings()
