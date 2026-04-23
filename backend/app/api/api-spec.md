# SevakAI — API Specification

> Status: OUTLINE — Full OpenAPI spec auto-generated at `/docs` when backend is running.

## Conventions

- Base URL: `https://api.sevakai.in/api/v1/`
- Auth: `Authorization: Bearer <jwt>` on all endpoints except `/auth/*` and `/webhooks/*`
- Response envelope:
  ```json
  {
    "data": {},
    "meta": { "request_id": "...", "timestamp": "..." },
    "errors": []
  }
  ```
- Pagination: Cursor-based. `?limit=50&after=cursor_string`
- Errors follow RFC 7807 Problem Details format

---

## Authentication

### POST /auth/otp/request
Request OTP to phone number.
```json
{ "phone": "+919876543210" }
```

### POST /auth/otp/verify
Verify OTP, receive JWT pair.
```json
{ "phone": "+919876543210", "otp": "123456" }
```
Response: `{ "access_token": "...", "refresh_token": "...", "role": "..." }`

### POST /auth/refresh
Exchange refresh token for new access token.

### POST /auth/logout
Revoke refresh token.

---

## Needs

### GET /needs
List needs. Filtered to user's zone. Supports: `?status=OPEN&priority_gte=4&type=FOOD`

### POST /needs
Create a new need. Body: Need schema (without `_id`, `_rev`, AI fields).

### GET /needs/{id}
Get single need.

### PATCH /needs/{id}
Update need fields (status, assignment, etc.). Role-based field restrictions apply.

### DELETE /needs/{id}
Soft-delete. Sets `deleted: true`. Requires COORDINATOR or above.

---

## Volunteers

### GET /volunteers
List volunteers in zone. Supports: `?status=AVAILABLE&skill=MEDICAL`

### POST /volunteers
Register as a volunteer.

### GET /volunteers/{id}
Get volunteer profile.

### PATCH /volunteers/{id}/status
Update availability status.

### POST /volunteers/{id}/assign
Assign volunteer to a need. Requires COORDINATOR+.

---

## Incidents

### GET /incidents
List active incidents.

### POST /incidents
Declare a new incident. Requires DISTRICT_ADMIN+.

### GET /incidents/{id}
Get incident details including aggregated need/volunteer stats.

### PATCH /incidents/{id}
Update incident status, severity, geofence.

---

## Resources

### GET /resources
List available resources in zone.

### POST /resources
Register resources (food packets, medicines, etc.).

### PATCH /resources/{id}
Update quantity or allocation.

---

## Alerts

### GET /alerts
List active alerts for user's scope.

### POST /alerts
Broadcast alert. Requires DISTRICT_ADMIN+.

---

## Sync

### POST /sync/push
Push local document mutations to server.
```json
{
  "documents": [ { "_id": "...", "_rev": "...", ...doc } ],
  "client_id": "device-uuid"
}
```

### GET /sync/changes
Long-poll or SSE stream of changes since sequence.
`?since=1234&filter=zone&zone_id=MH-04-PUNE`

### POST /sync/resolve
Manually trigger conflict resolution for a document.

---

## Webhooks

### POST /webhooks/whatsapp
Gupshup/Twilio inbound WhatsApp webhook. No auth (uses HMAC signature).

### POST /webhooks/sms
Inbound SMS webhook. No auth (uses HMAC signature).

---

## Admin

### GET /admin/stats
System-wide statistics. NATIONAL_ADMIN only.

### POST /admin/incidents/{id}/burst-mode
Enable burst scaling for an active incident. NATIONAL_ADMIN only.

---

## Rate Limits

| Endpoint Group    | Rate Limit                 |
|-------------------|---------------------------|
| /auth/*           | 10 req/min per IP         |
| /needs POST       | 60 req/min per user       |
| /sync/push        | 100 req/min per device    |
| /webhooks/*       | No limit (provider-sourced)|
| Everything else   | 300 req/min per user      |
