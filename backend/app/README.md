# Backend Application Package

## Purpose

Contains the FastAPI service source code and all backend architectural layers.

## Responsibilities

- Expose HTTP APIs and webhook endpoints
- Enforce RBAC and tenant boundaries
- Orchestrate CouchDB sync and backend-side effects
- Integrate with AI and communication providers
- Surface observability hooks and operational health

## Design Decisions

- Thin API layer, service-oriented orchestration
- Async-first I/O throughout the stack
- Clear separation of schemas, models, services, and repositories
- Sync and integrations treated as explicit subdomains, not utility code
