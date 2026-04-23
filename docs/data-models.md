# SevakAI - Data Models Outline

> Status: Blueprint outline only. Final schemas should be validated against sync, analytics, and compliance requirements before implementation.

## Purpose

This document defines SevakAI's conceptual data model, storage boundaries, and ownership rules. It exists before migrations so teams can agree on lifecycle, sync scope, and cross-system responsibilities.

## Modeling Principles

- Model operational truth close to real disaster workflows, not around UI screens
- Keep sync-eligible documents denormalized enough for offline reads
- Keep audit and analytics records append-friendly where practical
- Separate sensitive identity data from broad operational distribution paths when feasible
- Treat role, zone, and source channel as first-class dimensions on critical records

## Storage Topology

### CouchDB

Use for sync-eligible operational documents:
- needs
- volunteers
- incidents
- resources
- alerts

### Relational Store

Use for strongly relational and control-plane metadata:
- user accounts
- auth sessions
- audit logs
- communication logs
- AI processing traces

### Object Storage

Use for large binary artifacts:
- incident media
- attachment originals
- model artifacts
- evaluation datasets

## Core Entities To Define

- User
- Need
- Volunteer
- Incident
- Resource
- Alert
- Assignment
- NormalizedMessage
- TriagedMessage
- AuditLog
- CommunicationLog
- DeviceSyncSession

## Future Expansion

- JSON schema snapshots
- ER diagrams and document relationship diagrams
- Field-level validation rules
- Sample payloads for every core entity
- Index and partition strategy per store
