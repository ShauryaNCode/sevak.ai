# SevakAI — Data Models

> Status: DRAFT — Finalize before database migrations are written.

## Core Entities

---

### User

```json
{
  "id": "uuid",
  "phone": "+919876543210",
  "name": "string",
  "role": "VOLUNTEER | ZONE_COORDINATOR | DISTRICT_ADMIN | NATIONAL_ADMIN",
  "zone_id": "MH-04-PUNE",
  "language_preference": "hi | en | ta | te | bn | mr",
  "is_active": true,
  "created_at": "ISO8601",
  "last_seen_at": "ISO8601"
}
```

---

### Need

```json
{
  "_id": "need:{zone_id}:{uuid}",
  "_rev": "CouchDB revision",
  "type": "need",
  "zone_id": "string",
  "status": "OPEN | ASSIGNED | IN_PROGRESS | FULFILLED | CLOSED",
  "priority": 1,
  "need_types": ["FOOD", "WATER", "SHELTER", "MEDICAL", "RESCUE", "CLOTHING"],
  "description": "Free text from reporter",
  "affected_count": 50,
  "vulnerable_groups": ["CHILDREN", "ELDERLY", "DISABLED", "PREGNANT"],
  "location": {
    "raw": "Lal Chowk ke paas",
    "lat": 34.083,
    "lng": 74.797,
    "accuracy_meters": 500,
    "landmark": "Lal Chowk"
  },
  "source": "APP | WHATSAPP | SMS | FIELD_REPORT",
  "source_message_id": "uuid",
  "assigned_volunteer_ids": ["uuid"],
  "assigned_resource_ids": ["uuid"],
  "ai_enriched": true,
  "ai_confidence": 0.94,
  "images": ["gs://sevakai-media/..."],
  "created_by": "uuid",
  "created_at": "ISO8601",
  "updated_at": "ISO8601",
  "updated_by": "uuid",
  "deleted": false
}
```

---

### Volunteer

```json
{
  "_id": "volunteer:{zone_id}:{uuid}",
  "type": "volunteer",
  "user_id": "uuid",
  "zone_id": "string",
  "status": "AVAILABLE | ON_TASK | RESTING | OFFLINE",
  "skills": ["MEDICAL", "DRIVING", "BOAT_OPERATION", "SEARCH_RESCUE"],
  "current_location": { "lat": 0.0, "lng": 0.0, "updated_at": "ISO8601" },
  "assigned_need_ids": ["uuid"],
  "active_since": "ISO8601",
  "created_at": "ISO8601",
  "updated_at": "ISO8601"
}
```

---

### Incident

```json
{
  "_id": "incident:{zone_id}:{uuid}",
  "type": "incident",
  "name": "Pune Floods 2025",
  "disaster_type": "FLOOD | EARTHQUAKE | CYCLONE | FIRE | LANDSLIDE | OTHER",
  "severity": "LOW | MEDIUM | HIGH | CRITICAL",
  "status": "ACTIVE | MONITORING | CLOSED",
  "affected_zones": ["MH-04-PUNE", "MH-04-PIMPC"],
  "declared_at": "ISO8601",
  "declared_by": "uuid",
  "closed_at": "ISO8601 | null",
  "geofence": { "type": "Polygon", "coordinates": [[[]]] },
  "metadata": {}
}
```

---

### Resource

```json
{
  "_id": "resource:{zone_id}:{uuid}",
  "type": "resource",
  "resource_type": "FOOD_PACKET | WATER_BOTTLE | MEDICINE | BLANKET | BOAT | VEHICLE",
  "quantity": 500,
  "unit": "packets | liters | units",
  "location": { "lat": 0.0, "lng": 0.0 },
  "zone_id": "string",
  "status": "AVAILABLE | ALLOCATED | DEPLETED",
  "allocated_to_need_id": "uuid | null",
  "created_at": "ISO8601",
  "updated_at": "ISO8601"
}
```

---

### Alert (Broadcast)

```json
{
  "_id": "alert:{uuid}",
  "type": "alert",
  "scope": "NATIONAL | STATE | DISTRICT | ZONE",
  "scope_ids": ["MH-04-PUNE"],
  "title": "Flash flood warning",
  "body": "Evacuate Zone 3 immediately",
  "channels": ["APP_PUSH", "WHATSAPP", "SMS"],
  "sent_at": "ISO8601",
  "sent_by": "uuid",
  "expires_at": "ISO8601"
}
```

---

### NormalizedMessage (Internal — AI Pipeline)

```json
{
  "id": "uuid",
  "source": "WHATSAPP | SMS",
  "sender_phone": "+91...",
  "body": "original message text",
  "media_urls": [],
  "received_at": "ISO8601",
  "provider_message_id": "string",
  "processing_status": "QUEUED | PROCESSING | DONE | FAILED"
}
```

---

### TriagedMessage (Internal — AI Pipeline Output)

```json
{
  "normalized_message_id": "uuid",
  "intent": "NEED | OFFER | STATUS | NOISE",
  "priority": 5,
  "disaster_type": "FLOOD",
  "needs": ["FOOD", "RESCUE"],
  "affected_count": 50,
  "vulnerable_groups": ["CHILDREN"],
  "location_raw": "Lal Chowk ke paas",
  "location_resolved": { "lat": 34.083, "lng": 74.797, "confidence": 0.82 },
  "language": "HINGLISH",
  "ai_model": "gemini-1.5-flash",
  "ai_prompt_version": "v1.2",
  "confidence": 0.94,
  "processing_ms": 1240
}
```

---

## Database Mapping

| Model             | Storage        | Sync-eligible? |
|-------------------|---------------|----------------|
| User              | PostgreSQL     | No             |
| Need              | CouchDB        | Yes            |
| Volunteer         | CouchDB        | Yes            |
| Incident          | CouchDB        | Yes            |
| Resource          | CouchDB        | Yes            |
| Alert             | CouchDB        | Yes (global)   |
| NormalizedMessage | PostgreSQL     | No             |
| TriagedMessage    | PostgreSQL     | No             |
| AuditLog          | PostgreSQL     | No             |
| CommunicationLog  | PostgreSQL     | No             |

---

## Index Strategy (CouchDB)

TODO: Define Mango query indexes required for:
- Needs by zone + status + priority
- Volunteers by zone + status
- Incidents by status
- Changes feed queries

## Index Strategy (PostgreSQL)

TODO: Define B-tree and partial indexes for:
- Users by phone (unique)
- Messages by received_at + processing_status
- AuditLog by entity_id + entity_type
