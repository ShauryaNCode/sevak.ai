# Frontend Library Structure

## Purpose

`lib/` contains the Flutter application source organized around clean architecture and offline-first execution.

## Responsibilities

- Host domain-driven feature modules
- Isolate shared platform concerns in `core/`
- Centralize sync orchestration in `sync/`
- Expose shared presentation primitives in `ui/`

## Design Decisions

- Keep feature modules self-contained and independently testable
- Avoid direct cross-feature imports except through stable interfaces
- Keep sync logic separate from UI state management

## Future Plan

Populate features with entities, repositories, use cases, BLoC state objects, and UI shells once implementation begins.
