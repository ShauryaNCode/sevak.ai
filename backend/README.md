# SevakAI — Backend (FastAPI)

## Purpose

The backend is a **FastAPI application** serving as the authoritative coordination layer. It handles business logic, enforces access control, manages the CouchDB sync target, routes AI pipeline requests, and processes communication channel webhooks (WhatsApp/SMS).

It is designed for **horizontal scalability** and **async-first I/O** — critical when handling burst traffic during active disaster events.

---

## 🗂️ Directory Structure

```
backend/
├── app/
│   ├── main.py                      # Application factory, lifespan handlers
│   ├── api/
│   │   └── v1/
│   │       ├── router.py            # Master API router (aggregates all endpoints)
│   │       ├── endpoints/           # One file per resource
│   │       │   ├── needs.py
│   │       │   ├── volunteers.py
│   │       │   ├── incidents.py
│   │       │   ├── auth.py
│   │       │   ├── resources.py
│   │       │   ├── alerts.py
│   │       │   └── webhooks.py
│   │       └── dependencies/        # FastAPI Depends() providers
│   │           ├── auth.py          # JWT decode, current_user injection
│   │           ├── db.py            # DB session/connection injection
│   │           └── pagination.py    # Common pagination params
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── settings.py          # Pydantic BaseSettings (env-driven)
│   │   ├── security/
│   │   │   ├── jwt.py               # Token creation, validation
│   │   │   ├── hashing.py           # Password hashing (bcrypt)
│   │   │   └── rbac.py              # Role-based access control logic
│   │   ├── logging/
│   │   │   └── setup.py             # Structured JSON logging config
│   │   └── middleware/
│   │       ├── request_id.py        # Inject X-Request-ID header
│   │       ├── rate_limit.py        # Token bucket rate limiter
│   │       └── error_handler.py     # Global exception → HTTP response mapper
│   │
│   ├── models/                      # SQLAlchemy ORM models (for relational data)
│   │   ├── user.py
│   │   ├── incident.py
│   │   ├── need.py
│   │   ├── volunteer.py
│   │   ├── resource.py
│   │   └── audit_log.py
│   │
│   ├── schemas/                     # Pydantic request/response schemas
│   │   ├── user.py
│   │   ├── need.py
│   │   ├── volunteer.py
│   │   ├── incident.py
│   │   ├── resource.py
│   │   └── common.py                # Pagination, envelope, error schemas
│   │
│   ├── services/                    # Business logic layer
│   │   ├── need_service.py
│   │   ├── volunteer_service.py
│   │   ├── incident_service.py
│   │   ├── resource_service.py
│   │   ├── notification_service.py
│   │   └── ai_triage_service.py     # Calls AI pipeline APIs
│   │
│   ├── db/
│   │   ├── base.py                  # SQLAlchemy engine + session factory
│   │   ├── couchdb.py               # CouchDB async client wrapper
│   │   └── repositories/            # Data access objects (per model)
│   │       ├── base_repository.py
│   │       ├── need_repository.py
│   │       ├── volunteer_repository.py
│   │       └── incident_repository.py
│   │
│   ├── sync/
│   │   ├── couch_replicator.py      # Manages CouchDB replication sessions
│   │   ├── conflict_resolver.py     # Deterministic conflict resolution logic
│   │   └── sync_router.py           # Routes sync traffic per user/zone
│   │
│   ├── integrations/
│   │   ├── whatsapp/
│   │   │   ├── webhook_handler.py   # Gupshup/Twilio webhook receiver
│   │   │   ├── message_parser.py    # Raw WhatsApp → NormalizedMessage
│   │   │   └── client.py            # Outbound WhatsApp API client
│   │   └── sms/
│   │       ├── webhook_handler.py
│   │       ├── message_parser.py
│   │       └── client.py
│   │
│   └── utils/
│       ├── geo.py                   # Coordinate helpers, zone detection
│       ├── datetime.py              # IST-aware datetime utilities
│       └── validators.py            # Custom field validators (phone, Aadhaar)
│
├── tests/
│   ├── unit/                        # Service and utility tests (no DB)
│   ├── integration/                 # Tests against real DB (via testcontainers)
│   └── e2e/                         # Full HTTP round-trip tests
│
├── migrations/                      # Alembic migration scripts
├── scripts/                         # DB seed, fixture generation, admin CLI
├── requirements.txt
├── requirements-dev.txt
├── Dockerfile
└── pyproject.toml
```

---

## 🏗️ Architecture Philosophy

### Async-First
Every I/O operation is `async`. The application uses:
- `asyncpg` for PostgreSQL (audit/metadata store)
- `aiohttp` / `httpx` for external HTTP calls
- `motor` or native async driver for CouchDB
- `aio-pika` for RabbitMQ/Pub-Sub event emission

### Layered Architecture

```
HTTP Request
     ↓
  Router (FastAPI)
     ↓
  Dependencies (auth, db injection)
     ↓
  Endpoint (thin controller — validates input, calls service)
     ↓
  Service (business logic, orchestration)
     ↓
  Repository (data access, DB queries)
     ↓
  DB / External API
```

**Services never import from endpoints. Repositories never contain business logic.**

### API Design
- RESTful, versioned under `/api/v1/`
- Consistent envelope response: `{ data, meta, errors }`
- Cursor-based pagination for all list endpoints
- HATEOAS links for related resources (future phase)
- OpenAPI schema auto-generated via FastAPI

---

## 🔐 Role-Based Access Control (RBAC)

Roles are stored on the JWT claim `role`. The `rbac.py` module provides a declarative permission decorator:

```python
# Example (placeholder — do not implement yet)
@require_role([Role.COORDINATOR, Role.ADMIN])
async def update_need_status(need_id: UUID, ...):
    ...
```

Roles: `VOLUNTEER`, `ZONE_COORDINATOR`, `DISTRICT_ADMIN`, `NATIONAL_ADMIN`, `AI_SYSTEM`

All role checks are enforced at the **dependency layer**, not in services. Services assume the caller is authorized.

---

## 🔄 CouchDB Sync Integration

The backend serves two functions in the sync architecture:

1. **Sync Target**: CouchDB is the master store for all documents that need offline sync. The backend API writes to CouchDB for all sync-eligible models.

2. **Conflict Arbiter**: When the `/sync/resolve` endpoint is called (or via background job), `conflict_resolver.py` applies deterministic rules:
   - Higher-role edits win in overlap
   - For same-role conflicts: latest `_rev` with highest `updated_at` wins
   - Conflicts are **always logged** to the audit trail — never silently discarded

See `/backend/app/sync/README.md` for protocol details.

---

## 📡 Communication Webhooks

Inbound messages from WhatsApp/SMS arrive as webhooks and flow through:

```
Webhook HTTP POST
     ↓
webhook_handler.py  (validates signature, acknowledges 200 immediately)
     ↓
message_parser.py   (extracts sender, content, media)
     ↓
NormalizedMessage   (canonical schema)
     ↓
AI Triage Service   (sends to ai-pipeline for NLP processing)
     ↓
Need / Alert created in DB
```

Webhook handlers must **respond within 5 seconds** (Twilio/Gupshup requirement). All heavy processing is async via task queue.

---

## ⚙️ Configuration

All configuration is environment-driven via `core/config/settings.py` using Pydantic `BaseSettings`.

```
# Required env vars (see .env.example)
DATABASE_URL=postgresql+asyncpg://...
COUCHDB_URL=http://admin:password@localhost:5984
REDIS_URL=redis://localhost:6379
SECRET_KEY=...
GEMINI_API_KEY=...
TWILIO_AUTH_TOKEN=...
GUPSHUP_API_KEY=...
```

Never hardcode secrets. Use GCP Secret Manager in production.

---

## 🧪 Testing Strategy

| Type        | Framework              | Target                                    |
|-------------|------------------------|-------------------------------------------|
| Unit        | `pytest` + `pytest-asyncio` | Services, utilities, parsers         |
| Integration | `pytest` + `testcontainers` | Repositories, DB queries             |
| E2E         | `pytest` + `httpx.AsyncClient` | Full request cycles               |

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run only unit tests
pytest tests/unit/
```

---

## 🚀 Running Locally

```bash
# Install dependencies
pip install -r requirements.txt -r requirements-dev.txt

# Run migrations
alembic upgrade head

# Start the server
uvicorn app.main:app --reload --port 8000

# API docs
open http://localhost:8000/docs
```
