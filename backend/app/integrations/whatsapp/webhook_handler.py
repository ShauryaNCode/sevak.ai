"""WhatsApp webhook validation helpers."""

from __future__ import annotations

import base64
import hashlib
import hmac


def validate_twilio_signature(
    request_url: str,
    payload: dict[str, str],
    provided_signature: str | None,
    auth_token: str | None,
) -> bool:
    """Validate a Twilio webhook signature."""

    if not provided_signature or not auth_token:
        return False

    pieces = [request_url]
    for key in sorted(payload):
        pieces.append(key)
        pieces.append(str(payload[key]))
    signature_input = "".join(pieces).encode("utf-8")
    digest = hmac.new(auth_token.encode("utf-8"), signature_input, hashlib.sha1).digest()
    expected = base64.b64encode(digest).decode("utf-8")
    return hmac.compare_digest(expected, provided_signature)
