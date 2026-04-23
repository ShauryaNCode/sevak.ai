# SevakAI — Database & Sync Architecture

## Purpose

This module manages the bidirectional synchronization between **PouchDB instances** (on client devices) and the **CouchDB cluster** (on the backend). It is the backbone of SevakAI's offline-first guarantee.

---

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                       FIELD DEVICE (Mobile)                      │
│                                                                  │
│   Flutter App ──writes──▶ PouchDB (local Hive store)            │
│                               │                                  │
│                         [online?]                                │
│                               │                                  │
│                    Sync Engine (lib/sync/)                       │
└───────────────────────────────┼─────────────────────────────────┘
                                │ HTTPS (filtered replication)
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                       BACKEND LAYER                              │
│                                                                  │
│   CouchDB Cluster ◀──▶ Conflict Resolver ◀──▶ Audit Logger      │
│         │                                                        │
│         ▼                                                        │
│   Sync Router (per-user, per-zone filtered replication)         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Document Storage Strategy

CouchDB stores **all sync-eligible documents** as JSON documents with the following conventions:

### Document ID Format
```
{type}:{zone_id}:{uuid}
```
Examples:
- `need:MH-04-PUNE:01j2k3...`
- `volunteer:GJ-01-AHMD:01j2k4...`
- `incident:KL-09-TVM:01j2k5...`

This prefix structure enables **per-zone filtered replication** — devices only sync documents belonging to their zone.

### Required Fields on All Documents
```json
{
  "_id": "need:MH-04-PUNE:01j2k3...",
  "_rev": "3-abc123...",
  "type": "need",
  "zone_id": "MH-04-PUNE",
  "created_by": "user_uuid",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:35:00Z",
  "updated_by": "user_uuid",
  "role_at_update": "ZONE_COORDINATOR",
  "client_id": "device_uuid",
  "sync_version": 1,
  "deleted": false
}
```

---

## 🔄 Replication Protocol

### Client → Server (Push)
1. Client sync engine detects new/modified local documents
2. Sends batch to `POST /api/v1/sync/push` (custom endpoint wrapping CouchDB protocol)
3. Server validates document schema and authorization
4. Server writes to CouchDB
5. CouchDB emits change event → backend processes side effects (notifications, AI triage)

### Server → Client (Pull)
1. Client opens long-poll or WebSocket to `GET /api/v1/sync/changes?since={seq}`
2. Server returns changes filtered by `zone_id` matching user's zone
3. Client applies changes to local Hive store
4. Client updates local `since` sequence number

### Filtered Replication Rules
A device **only receives documents** where:
- `zone_id` matches the user's assigned zone(s), **OR**
- Document type is in `["alert", "broadcast"]` (global), **OR**
- `created_by` == current user (own submissions, any zone)

---

## ⚔️ Conflict Resolution

CouchDB uses MVCC (Multi-Version Concurrency Control). Every document has a `_rev` field. When two clients modify the same document offline, a conflict arises.

### Resolution Algorithm

```
Given: conflicting revisions A and B for document D

1. Is one revision from a HIGHER-ROLE user?
   → Higher role wins. Lower role revision is archived.

2. Same role? Compare updated_at timestamp.
   → Later timestamp wins.

3. Same timestamp (extremely rare)?
   → Lexicographically higher _rev string wins (deterministic).

4. ALWAYS:
   → Losing revision is stored in audit_log with reason=CONFLICT_LOST
   → Winning revision gets conflict_resolved=true flag
   → Both authors are notified via push notification
```

### What We Never Do
- Silently discard conflicting data
- Merge fields from two conflicting revisions (too complex, error-prone in disaster data)
- Allow conflicts to accumulate unresolved (max 24-hour resolution window enforced)

---

## 🛡️ Offline-First Guarantees

| Guarantee                         | Mechanism                                            |
|-----------------------------------|------------------------------------------------------|
| Writes always succeed locally     | Hive write never fails; sync is separate concern    |
| No data loss on crash             | Hive is ACID; outbox queue is durable               |
| Sync is idempotent                | Document `_rev` prevents duplicate writes           |
| Order is preserved per-device     | Sequence numbers maintained per client_id           |
| Deleted docs stay deleted         | Soft-delete via `deleted: true` (CouchDB tombstone) |

---

## 🔒 Security in Sync

- Per-user CouchDB credentials issued by backend on login (short-lived)
- Zone-level read isolation enforced at the sync router level
- Sync endpoint requires valid JWT; CouchDB credentials rotated every 24h
- All sync traffic is TLS-encrypted

---

## 📊 Sync Health Monitoring

The sync module exposes metrics:
- `sync.push.latency_ms` — time to push a batch
- `sync.pull.lag_seconds` — how far behind a device is from server
- `sync.conflicts.total` — total conflicts detected
- `sync.conflicts.resolved` — total conflicts resolved
- `sync.queue.depth` — pending documents in outbox

Alerts fire when:
- Any device is > 10 minutes behind (during active incident)
- Conflict resolution backlog > 100 documents
- Push failure rate > 5% over 5-minute window
