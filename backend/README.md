# SevakAI Backend

Production-style FastAPI backend for offline-first disaster intake, volunteer coordination, and communication-driven need creation.

## What This Backend Supports

- Need submission, filtering, prioritization, matching, and assignment
- WhatsApp webhook ingestion
- SMS webhook ingestion
- Twilio WhatsApp Sandbox compatibility
- Mock SMS payloads that mirror real provider structure
- JSON local storage fallback when CouchDB is not available
- Debug endpoint for the last webhook received

## API Summary

- `GET /health`
- `GET /debug/webhook-last`
- `POST /webhook/whatsapp`
- `POST /webhook/sms`
- `POST /api/v1/needs`
- `GET /api/v1/needs`
- `GET /api/v1/needs/prioritized`
- `POST /api/v1/volunteers`
- `POST /api/v1/match`
- `POST /api/v1/assign`

## Local Setup Guide

### Step 1: Install dependencies

From the `backend/` directory:

```bash
pip install -r requirements.txt -r requirements-dev.txt
```

### Step 2: Configure environment

Copy the example file:

```bash
copy .env.example .env
```

Recommended local values:

```env
ENVIRONMENT=development
LOG_LEVEL=INFO
API_V1_PREFIX=/api/v1
PUBLIC_BASE_URL=

WHATSAPP_PROVIDER=twilio
SMS_PROVIDER=mock
VALIDATE_PROVIDER_SIGNATURES=false

TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
TWILIO_SMS_NUMBER=

USE_COUCHDB=false
STORAGE_PATH=data/mock_db.json
```

Notes:
- `PUBLIC_BASE_URL` should be set after ngrok starts.
- Leave `VALIDATE_PROVIDER_SIGNATURES=false` for quick local testing.
- Turn it on only when you are ready to validate Twilio signatures using your real auth token.

### Step 3: Run backend

From the `backend/` directory:

```bash
uvicorn main:app --reload --port 8000
```

The app will be available locally on:

```text
http://127.0.0.1:8000
```

## Start ngrok

Expose the backend publicly:

```bash
ngrok http 8000
```

ngrok will show an HTTPS forwarding URL such as:

```text
https://abcd-1234.ngrok-free.app
```

Copy that URL and set it in `.env`:

```env
PUBLIC_BASE_URL=https://abcd-1234.ngrok-free.app
```

Restart the backend after updating `.env`.

## Twilio WhatsApp Sandbox Setup

### Step 4: Configure Twilio Sandbox

1. Open the Twilio WhatsApp Sandbox console.
2. Join the sandbox from your phone by sending the provided join message to the sandbox number.
3. Set the inbound webhook URL to:

```text
https://abcd-1234.ngrok-free.app/webhook/whatsapp
```

4. Save the Twilio credentials into `.env`:

```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

Optional:
- Set `VALIDATE_PROVIDER_SIGNATURES=true` once the webhook is stable and credentials are correct.

## Test the WhatsApp Flow

### Step 5: Send a message

From the sandbox-joined WhatsApp account, send:

```text
Need water in Sangli urgent
```

Expected flow:
- Twilio sends a form-encoded webhook to `/webhook/whatsapp`
- Backend normalizes it into a canonical inbound message
- Parser extracts need type, urgency, and known location details
- Need is created or deduplicated if already seen recently
- Record becomes visible through:
  - `GET /debug/webhook-last`
  - `GET /api/v1/needs`

## SMS Simulation

SMS is mock-first but shaped like a real provider.

POST to:

```text
/webhook/sms
```

Example payload:

```json
{
  "From": "+919876543210",
  "Body": "Need food urgent",
  "MessageSid": "SM123"
}
```

Example using PowerShell:

```powershell
Invoke-RestMethod `
  -Uri "http://127.0.0.1:8000/webhook/sms" `
  -Method Post `
  -ContentType "application/json" `
  -Body '{"From":"+919876543210","Body":"Need food urgent","MessageSid":"SM123"}'
```

This flows through the same backend pipeline as WhatsApp:
- normalize inbound message
- deduplicate
- parse
- create need

## Health and Debug Endpoints

### Health

```text
GET /health
```

Returns:
- backend status
- storage backend in use
- current timestamp
- configured public base URL
- resolved webhook paths

### Last Webhook Debug

```text
GET /debug/webhook-last
```

Returns:
- last received webhook payload
- which channel hit the system
- path used
- content type information

This is useful for verifying that ngrok, Twilio, and payload parsing are all aligned.

## Stable Webhook Paths

Use these public paths in local-demo or sandbox setups:

- `/webhook/whatsapp`
- `/webhook/sms`

The versioned API paths still exist internally, but for external providers use the stable root paths above.

## Outbound Messaging Behavior

The backend exposes outbound provider stubs behind a provider-agnostic interface.

Current behavior:
- if Twilio credentials and the required sending number exist, the backend can send through Twilio
- otherwise it logs the outbound message in fallback mode

This keeps local demos free-tier friendly while preserving a production-ready interface.

## Debugging Tips

- Check `GET /health`
- Check `GET /debug/webhook-last`
- Ensure ngrok is forwarding to port `8000`
- Ensure the Twilio webhook URL exactly matches the current ngrok HTTPS URL
- Restart the backend after editing `.env`
- If Twilio messages are not arriving, keep `VALIDATE_PROVIDER_SIGNATURES=false` first, then enable it later
- If storage seems wrong, delete `data/mock_db.json` and restart for a clean local state

## Running Tests

```bash
pytest tests -q
```

Focused communication test run:

```bash
pytest tests/e2e/test_backend_features.py -q
```
