# SevakAI - API Specification Outline

> Status: Blueprint outline only. Final contracts should be generated from implementation and curated for critical flows.

## Purpose

This document defines the intended public and internal API surface for SevakAI so frontend, backend, integrations, and AI teams can align before production implementation begins.

## API Design Goals

- Stable, versioned contracts for mobile and web clients
- Thin synchronous APIs with async handoff for long-running work
- Predictable response envelopes and error semantics
- Strong role-aware and zone-aware authorization boundaries
- Sync-aware endpoints that complement CouchDB replication

## Base Conventions

- Base path: `/api/v1`
- Authentication: JWT bearer tokens except public health and signed webhook endpoints
- Time format: ISO 8601 UTC in transport, localized only at presentation layer
- Identifier style: UUID or ULID for service IDs, prefixed document IDs for sync entities

## Planned Endpoint Groups

### Authentication

- OTP request and verify
- token refresh and revocation
- device registration
- session introspection

### Needs Management

- create, list, retrieve, update, and soft-delete needs
- assign resources or volunteers
- fetch event timeline and audit summary

### Volunteer Operations

- register volunteer profile
- update status, capabilities, and location heartbeat
- manage assignment lifecycle actions

### Incident Coordination

- declare incident
- change severity and operational phase
- manage zone scope and escalation state

### Resource Management

- register and allocate resources
- reconcile stock movement
- surface shortages and replenishment signals

### Alerting

- publish district, zone, and national alerts
- retrieve active alert feed
- audit dissemination channel status

### Sync Services

- replication session bootstrap
- conflict visibility and resolution support
- sync health and lag introspection

### Communication Webhooks

- inbound WhatsApp webhooks
- inbound SMS webhooks
- provider delivery status callbacks

## Response Envelope Outline

```json
{
  "data": {},
  "meta": {
    "request_id": "string",
    "timestamp": "2026-04-23T00:00:00Z"
  },
  "errors": []
}
```

## Future Expansion

- Per-endpoint request and response examples
- Role matrix per endpoint
- Idempotency expectations
- Rate limits and SLOs
- Deprecation policy
