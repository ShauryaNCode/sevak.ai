# Backend Database Architecture

## Purpose

This module defines SevakAI's persistence boundaries, data access contracts, and sync-store integration. It must support a mixed storage model in which operational documents replicate through CouchDB while relational metadata, audit trails, and control-plane records live in a relational store.

## Responsibilities

- Define storage clients and repository abstractions
- Isolate CouchDB access from service orchestration
- Isolate relational access from endpoint code
- Document indexing and partition expectations
- Preserve durability and traceability for disaster-critical records

## Storage Strategy

Use this folder to separate two persistence concerns:
- CouchDB-oriented document access for sync-eligible entities
- Relational metadata access for users, auth, audit, and control records

## Future Implementation Plan

- Add CouchDB client wrapper and replication session helpers
- Add repository interfaces for needs, volunteers, incidents, and resources
- Add relational repositories for users, sessions, and audit logs
- Document index strategy and partitioning before high-volume rollout
