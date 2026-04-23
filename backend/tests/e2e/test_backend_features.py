"""Focused end-to-end tests for the SevakAI backend feature set."""

from __future__ import annotations


async def test_need_submission_filters_and_priority(client) -> None:
    """Verify need creation, filtering, and prioritization."""

    need_payload = {
        "location": {
            "pincode": "416416",
            "lat": 16.8524,
            "lng": 74.5815,
            "label": "Sangli",
        },
        "need_type": "water",
        "urgency": "high",
        "contact_info": {
            "name": "Relief Reporter",
            "phone": "+919999999999",
            "notes": "Critical water shortage",
        },
        "vulnerability_score": 0.9,
    }

    create_response = await client.post("/api/v1/needs", json=need_payload)
    assert create_response.status_code == 200
    created = create_response.json()["data"]
    assert created["status"] == "pending"
    assert created["need_type"] == "water"

    filtered_response = await client.get(
        "/api/v1/needs",
        params={"urgency": "high", "status": "pending", "location": "Sangli"},
    )
    assert filtered_response.status_code == 200
    filtered_items = filtered_response.json()["data"]
    assert len(filtered_items) == 1
    assert filtered_items[0]["id"] == created["id"]

    prioritized_response = await client.get(
        "/api/v1/needs/prioritized",
        params={"reference_lat": 16.8524, "reference_lng": 74.5815},
    )
    assert prioritized_response.status_code == 200
    priority_items = prioritized_response.json()["data"]
    assert len(priority_items) == 1
    assert priority_items[0]["need"]["id"] == created["id"]
    assert priority_items[0]["priority_score"] > 0


async def test_volunteer_registration_matching_and_assignment(client) -> None:
    """Verify volunteer registration, matching, and assignment."""

    need_response = await client.post(
        "/api/v1/needs",
        json={
            "location": {
                "pincode": "416416",
                "lat": 16.8524,
                "lng": 74.5815,
                "label": "Sangli",
            },
            "need_type": "medical",
            "urgency": "high",
            "contact_info": {
                "name": "Local Coordinator",
                "phone": "+918888888888",
                "notes": "Immediate first aid required",
            },
            "vulnerability_score": 0.8,
        },
    )
    need_id = need_response.json()["data"]["id"]

    volunteer_good = await client.post(
        "/api/v1/volunteers",
        json={
            "name": "Dr. Asha",
            "skills": ["medical", "triage"],
            "location": {
                "pincode": "416416",
                "lat": 16.8530,
                "lng": 74.5820,
                "label": "Sangli Base",
            },
            "availability": True,
        },
    )
    assert volunteer_good.status_code == 200
    volunteer_id = volunteer_good.json()["data"]["id"]

    volunteer_other = await client.post(
        "/api/v1/volunteers",
        json={
            "name": "Rahul",
            "skills": ["food_distribution"],
            "location": {
                "pincode": "416003",
                "lat": 16.7050,
                "lng": 74.2433,
                "label": "Kolhapur",
            },
            "availability": True,
        },
    )
    assert volunteer_other.status_code == 200

    match_response = await client.post(
        "/api/v1/match",
        json={"need_id": need_id, "limit": 5},
    )
    assert match_response.status_code == 200
    matches = match_response.json()["data"]
    assert len(matches) >= 1
    assert matches[0]["volunteer"]["id"] == volunteer_id

    assign_response = await client.post(
        "/api/v1/assign",
        json={"need_id": need_id, "volunteer_id": volunteer_id},
    )
    assert assign_response.status_code == 200
    assigned = assign_response.json()["data"]
    assert assigned["status"] == "assigned"
    assert assigned["assigned_volunteer_id"] == volunteer_id


async def test_whatsapp_webhook_dedup_and_geographic_extraction(client) -> None:
    """Verify WhatsApp parsing, geolocation enrichment, and deduplication."""

    webhook_payload = {
        "raw_text_message": "Need water in Sangli community center urgent",
        "sender_name": "Field Reporter",
        "sender_phone": "+917777777777",
    }

    first_response = await client.post("/api/v1/webhook/whatsapp", json=webhook_payload)
    assert first_response.status_code == 200
    first_body = first_response.json()["data"]
    first_need = first_body["need"]

    assert first_body["stored"] is True
    assert first_body["parsed"]["need_type"] == "water"
    assert first_body["parsed"]["urgency"] == "high"
    assert first_need["location"]["label"] is not None
    assert first_need["location"]["lat"] is not None
    assert first_need["location"]["lng"] is not None
    assert first_need["dedup_hash"] == first_body["dedup_hash"]

    second_response = await client.post("/api/v1/webhook/whatsapp", json=webhook_payload)
    assert second_response.status_code == 200
    second_body = second_response.json()["data"]
    second_need = second_body["need"]

    assert second_body["dedup_hash"] == first_body["dedup_hash"]
    assert second_need["id"] == first_need["id"]

    all_needs_response = await client.get("/api/v1/needs")
    assert all_needs_response.status_code == 200
    all_needs = all_needs_response.json()["data"]
    assert len(all_needs) == 1


async def test_twilio_whatsapp_form_payload_is_normalized(client) -> None:
    """Verify Twilio-style WhatsApp form payloads are accepted."""

    response = await client.post(
        "/api/v1/webhook/whatsapp",
        data={
            "From": "whatsapp:+917111111111",
            "Body": "Need shelter near Kolhapur bus stand urgent",
            "MessageSid": "SM-WA-001",
        },
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["stored"] is True
    assert body["inbound_message"]["provider"] == "twilio"
    assert body["inbound_message"]["channel"] == "whatsapp"
    assert body["inbound_message"]["provider_message_id"] == "SM-WA-001"
    assert body["need"]["location"]["lat"] is not None
    assert body["need"]["location"]["lng"] is not None


async def test_sms_mock_webhook_uses_same_pipeline(client) -> None:
    """Verify SMS mock payloads flow through the shared ingestion path."""

    response = await client.post(
        "/api/v1/webhook/sms",
        json={
            "From": "+919876543210",
            "Body": "Need food in Solapur urgent",
            "MessageSid": "SM123456",
        },
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["stored"] is True
    assert body["duplicate"] is False
    assert body["inbound_message"]["channel"] == "sms"
    assert body["inbound_message"]["provider"] == "mock"
    assert body["inbound_message"]["provider_message_id"] == "SM123456"
    assert body["need"]["need_type"] == "food"


async def test_whatsapp_unparsed_message_does_not_create_need(client) -> None:
    """Verify unknown webhook text does not create a malformed need."""

    response = await client.post(
        "/api/v1/webhook/whatsapp",
        json={
            "raw_text_message": "Hello checking signal only",
            "sender_name": "Unknown",
            "sender_phone": "+916666666666",
        },
    )
    assert response.status_code == 200
    body = response.json()["data"]
    assert body["stored"] is False
    assert "Unable to determine need type" in body["reason"]
