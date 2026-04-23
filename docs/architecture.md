# SevakAI — Architecture Overview

> Status: OUTLINE — To be completed by Lead Architect before sprint 1.

## 1. System Context

[Diagram: C4 Level 1 — System Context]
TODO: Add PlantUML or Mermaid diagram showing SevakAI's external actors and systems.

Actors:
- Field Volunteer (mobile app, offline-capable)
- Zone Coordinator (mobile/web app)
- District Administrator (web dashboard)
- National Command (web dashboard, read-heavy)
- Field Reporter (WhatsApp/SMS only — no app)
- AI System (internal automated actor)

External Systems:
- Gupshup / Twilio (WhatsApp, SMS gateway)
- Google Gemini API (AI processing)
- GCP Infrastructure (hosting)
- NDMA / State Disaster APIs (future phase — satellite data feeds)

---

## 2. Container Architecture (C4 Level 2)

[Diagram: C4 Level 2 — Containers]
TODO: Add container diagram.

Containers:
- Flutter App (mobile + web)
- FastAPI Backend
- CouchDB Cluster
- PostgreSQL (Cloud SQL)
- Redis (Memorystore)
- AI Pipeline Workers
- Pub/Sub Event Bus

---

## 3. Key Architecture Decisions

See `docs/adr/` for full ADR documents. Summary:

| Decision                        | Choice           | Rationale                                        |
|---------------------------------|-----------------|--------------------------------------------------|
| Offline sync protocol           | CouchDB/PouchDB | Battle-tested, conflict resolution built-in     |
| Primary AI model                | Gemini 1.5 Flash| Cost/performance, multilingual, multimodal      |
| Frontend framework              | Flutter          | Single codebase for mobile + web                |
| Backend framework               | FastAPI          | Async-native, excellent OpenAPI support         |
| Primary cloud                   | GCP              | India region, compliance, Gemini integration    |
| Local storage (client)          | Hive             | Fast, typed, no native dependency               |
| State management                | BLoC             | Testable, auditable, mature                     |

---

## 4. Data Flow: Need Registration (Core Flow)

```
[Field Worker] types need into Flutter app
       ↓
[PouchDB/Hive] writes locally (instant, offline-safe)
       ↓
[SyncEngine] detects pending mutation
       ↓ (if online)
[FastAPI /sync/push] receives document batch
       ↓
[CouchDB] stores document
       ↓
[Pub/Sub] emits NeedCreated event
       ↓
[AI Pipeline] classifies and enriches need
       ↓
[FastAPI] updates need with AI enrichment
       ↓
[Coordinator Dashboard] sees enriched need in real-time
```

---

## 5. Data Flow: WhatsApp Ingestion

TODO: Diagram the WhatsApp → AI → CouchDB → dashboard flow.

---

## 6. Offline Guarantee Analysis

TODO: Complete analysis of which operations work offline and which require connectivity.

---

## 7. Security Architecture

TODO: Detail JWT flow, RBAC enforcement points, CouchDB credentials lifecycle.

---

## 8. Multi-Tenancy Model

TODO: Describe zone-based data isolation, cross-zone queries for admins.

---

## 9. Performance Targets

| Metric                     | Target         | Measurement Method                |
|----------------------------|----------------|-----------------------------------|
| API response time (P95)    | < 500ms        | Cloud Trace percentile            |
| AI triage latency          | < 3s           | Pipeline step instrumentation     |
| Sync push latency (1 doc)  | < 200ms        | Client-side timing                |
| Dashboard refresh rate     | < 5s           | WebSocket event → render          |
| Offline write latency      | < 50ms         | Local Hive write timing           |
| Cold start (mobile app)    | < 3s           | Flutter DevTools profiling        |

---

## 10. Future Architecture Phases

| Phase | Timeline  | Additions                                              |
|-------|-----------|--------------------------------------------------------|
| V1    | Hackathon | Core need/volunteer flow, WhatsApp ingestion           |
| V2    | Month 3   | Satellite imagery analysis, predictive allocation      |
| V3    | Month 6   | Multi-state deployment, NDMA API integration           |
| V4    | Month 12  | Full national deployment, edge node architecture       |
