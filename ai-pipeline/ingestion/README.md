# AI Pipeline - Ingestion

## Purpose

Owns the first stage of AI processing by turning noisy provider payloads into safe, normalized inputs for downstream triage.

## Responsibilities

- Parse inbound sources
- Validate payload shape and provenance
- Normalize into a canonical message contract
- Reject duplicates, spam, or malformed content where appropriate
