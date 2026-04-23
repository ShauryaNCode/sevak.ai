# SevakAI — Communication Integrations (WhatsApp & SMS)

## Purpose

This module handles all **inbound and outbound communication** with field workers and citizens via WhatsApp and SMS. It is a critical ingestion point — many field reporters will never use the app directly, instead sending updates via existing familiar channels.

---

## 🗂️ Structure

```
integrations/
├── whatsapp/
│   ├── webhook_handler.py   # Receives and validates Gupshup/Twilio webhooks
│   ├── message_parser.py    # Extracts normalized message from raw payload
│   └── client.py            # Sends outbound WhatsApp messages
│
└── sms/
    ├── webhook_handler.py   # Receives and validates SMS delivery webhooks
    ├── message_parser.py    # Parses SMS body, handles multipart
    └── client.py            # Sends outbound SMS via provider
```

---

## 📨 Supported Providers

| Channel   | Primary Provider | Fallback Provider |
|-----------|-----------------|-------------------|
| WhatsApp  | Gupshup         | Twilio            |
| SMS       | Twilio          | MSG91             |

Provider selection is controlled via `WHATSAPP_PROVIDER` and `SMS_PROVIDER` environment variables. Both are interchangeable via the same normalized interface.

---

## 🔄 Inbound Message Pipeline

```
WhatsApp/SMS Provider
       │
       ▼ HTTP POST (webhook)
webhook_handler.py
   ├── Validate HMAC signature (reject if invalid — prevents spoofing)
   ├── Return HTTP 200 immediately (< 200ms — SLA requirement)
   └── Enqueue raw payload to task queue (Redis/Pub-Sub)

       ↓ (async, background)
message_parser.py
   ├── Extract: sender_phone, timestamp, body, media_url
   ├── Map to: NormalizedMessage
   └── Emit to AI Pipeline

       ↓
AI Triage (ai-pipeline/)
   └── Returns: TriagedMessage

       ↓
need_service.py / alert_service.py
   └── Create structured record in CouchDB
```

### Why Async?
WhatsApp (Gupshup) and Twilio **require a 200 OK within 5 seconds** or they retry. Heavy processing (AI triage, DB writes) must happen asynchronously. The webhook handler's only job is: validate → acknowledge → enqueue.

---

## 📤 Outbound Message Flow

SevakAI sends outbound messages for:
- Acknowledgement ("We received your report — Help is coming to Lal Chowk")
- Status updates ("Your request #4521 has been assigned to team Alpha")
- Broadcast alerts ("Flash flood warning: Evacuate Zone 3 immediately")

Outbound messages are sent via `client.py` which wraps the provider API. All outbound sends are:
- Logged to `communication_log` table
- Retried up to 3 times with exponential backoff
- Failed sends are escalated to coordinator dashboard

---

## 🔒 Security

### Webhook Signature Validation

**Gupshup:** Validates `X-Gupshup-Signature` header (HMAC-SHA256 of payload + API key)

**Twilio:** Validates `X-Twilio-Signature` header using Twilio's request validator

Never process a webhook payload without signature validation. Forged webhooks could inject false disaster reports.

### Phone Number Handling
- Phone numbers are stored in E.164 format: `+919876543210`
- Numbers are hashed (SHA-256) for analytics/dedup — raw numbers only in authorized lookup
- GDPR/DPDP compliant: field reporters can request data deletion

---

## 📉 Failover Strategy

```
Primary provider down?
    ↓
1. Detect via health check ping (every 60s)
2. Switch to fallback provider (environment variable swap)
3. Alert ops team via PagerDuty
4. Replay queued messages via fallback
5. Log all affected message IDs for audit
```

Failover is **automatic for inbound** (providers push to our webhook — we don't pull).
Failover for **outbound** is triggered by 3 consecutive 5xx responses from primary.

---

## 🌐 Multi-language Support

Inbound messages arrive in any language. The AI pipeline handles translation/transliteration.

Outbound messages:
- Sent in the **language preference** stored on the sender's profile
- Default: Hindi for unknown users
- Template messages (WhatsApp Business API) are pre-registered in Hindi + English

---

## ⚙️ Environment Configuration

```bash
# WhatsApp
WHATSAPP_PROVIDER=gupshup           # or: twilio
GUPSHUP_API_KEY=...
GUPSHUP_APP_NAME=...
GUPSHUP_WEBHOOK_SECRET=...
TWILIO_WHATSAPP_SID=...
TWILIO_WHATSAPP_TOKEN=...

# SMS
SMS_PROVIDER=twilio
TWILIO_SMS_SID=...
TWILIO_SMS_TOKEN=...
TWILIO_SMS_FROM=+1...
MSG91_AUTH_KEY=...

# Shared
COMM_QUEUE_URL=redis://...
```

---

## 🧪 Testing

All webhook handlers must be testable without hitting real provider APIs.

```python
# Example test pattern (to be implemented)
async def test_whatsapp_webhook_creates_need():
    payload = load_fixture("whatsapp_need_report.json")
    response = await client.post("/webhooks/whatsapp", json=payload, headers=valid_sig)
    assert response.status_code == 200
    # Assert message was enqueued for processing
```

Fixtures for all supported message formats are in `tests/fixtures/integrations/`.
