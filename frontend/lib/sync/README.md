# Frontend Sync Architecture

## Purpose

This module owns the client-side offline-first contract for SevakAI. It is responsible for ensuring that field workflows remain operational even in low or no-connectivity environments, and that local state converges with the backend safely once connectivity returns.

## Responsibilities

- Maintain the local source of truth for sync-eligible documents
- Record local mutations into a durable outbox
- Coordinate replication with backend or CouchDB-compatible sync targets
- Surface sync health, lag, and conflict state to presentation layers
- Preserve deterministic behavior during app restarts or network flapping

## PouchDB and Local Storage Strategy

SevakAI's architectural target is a PouchDB-compatible local document workflow backed by CouchDB replication semantics. Because Flutter may use a Dart-native document store or adapter instead of direct browser PouchDB, the blueprint centers on the contract rather than a fixed package choice.

What matters:
- local writes succeed before remote writes are attempted
- revision metadata is preserved for sync decisions
- queued mutations survive app restart and device reboot
- push and pull flows resume from persisted checkpoints

## Conflict Resolution Strategy

The frontend should not silently invent conflict outcomes. Instead it should:
- detect revision rejection or conflict markers
- preserve pending local intent for inspection or retry
- accept authoritative backend outcomes when returned
- expose sync state clearly to users

Authoritative merge rules belong on the backend and remain auditable.

## Offline-First Guarantees

- A field user can capture critical data fully offline
- The UI reads from local state even when remote systems are unreachable
- Mutation intent is durable and replayable
- Connectivity loss does not corrupt local operational state

## Recommended Internal Components

- `sync_engine.dart`
- `outbox_repository.dart`
- `replication_client.dart`
- `sync_status_service.dart`
