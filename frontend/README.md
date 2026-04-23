# SevakAI — Frontend (Flutter)

## Purpose

The frontend is a **Flutter application** targeting Android, iOS, and Web. It is the primary interface for all human actors in the system: field volunteers, zone coordinators, district administrators, and national command centers.

The app must be fully functional **without any internet connectivity**. Connectivity is treated as an enhancement — not a requirement.

---

## 🗂️ Directory Structure

```
frontend/
├── lib/
│   ├── core/                    # Cross-cutting concerns
│   │   ├── config/              # Environment config, feature flags
│   │   ├── constants/           # App-wide constants (routes, keys, timeouts)
│   │   ├── errors/              # Failure types, error mappers
│   │   └── utils/               # Date helpers, formatters, validators
│   │
│   ├── features/                # Feature modules (domain-driven)
│   │   ├── authentication/      # Login, OTP, role detection
│   │   │   ├── data/            # Auth repository impl, remote/local sources
│   │   │   ├── domain/          # Auth entities, use cases, repo interface
│   │   │   └── presentation/    # Login screen, BLoC/Cubit
│   │   ├── needs/               # Need registration and tracking
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── volunteers/          # Volunteer registration, assignment, status
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── dashboard/           # Real-time coordination dashboard
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   ├── services/                # App-level services (notifications, GPS, etc.)
│   ├── sync/                    # PouchDB/Hive sync engine and queue manager
│   └── ui/
│       ├── components/          # Shared dumb widgets (buttons, cards, badges)
│       ├── themes/              # Color system, typography, spacing tokens
│       └── widgets/             # Composite reusable widgets
│
├── assets/
│   ├── images/                  # Raster images
│   ├── icons/                   # SVG icons
│   ├── fonts/                   # Custom fonts
│   └── translations/            # ARB files for i18n (hi, en, ta, te, bn...)
│
└── test/
    ├── unit/                    # Domain layer tests, use case tests
    ├── widget/                  # Widget tests with mocked dependencies
    └── integration/             # Full app flows (using flutter_driver or patrol)
```

---

## 🏗️ Architecture: Feature-First Clean Architecture

Each feature in `lib/features/` follows a strict 3-layer architecture:

```
feature/
  data/        → Concrete implementations (API clients, Hive adapters, sync sources)
  domain/      → Pure Dart: entities, use cases, repository interfaces
  presentation/→ Flutter: screens, BLoCs/Cubits, UI event/state models
```

**Dependency rule:** `presentation` → `domain` ← `data`

Domain has **zero Flutter dependencies**. This allows unit testing domain logic without any widget or platform setup.

---

## 📡 Offline-First Design

### Core Principle
Every user action is written **locally first**, then synced. The UI always reads from the local store. Remote data flows in via the sync engine.

### Local Storage Strategy

| Data Type         | Storage       | Rationale                                         |
|-------------------|---------------|---------------------------------------------------|
| Structured docs   | Hive boxes    | Fast, type-safe, Flutter-native key-value store  |
| Sync metadata     | Hive          | Tracks sequence numbers, pending mutations       |
| Media (photos)    | File system   | Binary blobs stored as paths, not in DB          |
| Auth tokens       | FlutterSecureStorage | Encrypted at rest                         |

### Sync Queue
Located in `lib/sync/`, the sync engine:
- Maintains an **outbox queue** of all local mutations (FIFO)
- Attempts sync on connectivity change events (via `connectivity_plus`)
- Implements exponential backoff for retries
- Resolves conflicts using **last-write-wins + role-priority** (see `docs/architecture.md`)

---

## 🧠 State Management

**Recommended approach: flutter_bloc (BLoC pattern)**

- Each feature has its own `XxxBloc` or `XxxCubit`
- State is immutable (`freezed` recommended for sealed unions)
- BLoCs communicate via `EventBus` for cross-feature events (e.g., sync completed)

**Why BLoC over Riverpod/Provider?**
- Testability: BLoCs are pure Dart, trivially unit-testable
- Auditability: Explicit event → state transitions are traceable (critical for disaster ops)
- Scale: Mature pattern with strong separation of concerns

---

## 🌏 Internationalization (i18n)

All user-facing strings must be externalized to ARB files in `assets/translations/`.

Priority languages: Hindi (`hi`), English (`en`), Tamil (`ta`), Telugu (`te`), Bengali (`bn`), Marathi (`mr`).

Use `flutter_localizations` + `intl` package. All date/time must be locale-aware.

---

## 🔒 Security Considerations

- Biometric auth for field app re-entry (using `local_auth`)
- JWT stored in `FlutterSecureStorage` (never SharedPreferences)
- All API calls over HTTPS only; certificate pinning for production builds
- Sensitive fields (Aadhaar, phone) must be masked in logs

---

## 📦 Key Dependencies (to be validated)

| Package               | Purpose                              |
|-----------------------|--------------------------------------|
| `flutter_bloc`        | State management                     |
| `hive` + `hive_flutter` | Offline document store             |
| `freezed`             | Immutable data classes & unions      |
| `dio`                 | HTTP client with interceptors        |
| `connectivity_plus`   | Network state detection              |
| `geolocator`          | GPS coordinates for field tagging    |
| `flutter_localizations` | i18n support                       |
| `flutter_secure_storage` | Encrypted token storage           |
| `go_router`           | Declarative routing                  |
| `injectable` + `get_it` | Dependency injection               |

---

## 🧪 Testing Strategy

| Layer        | Tool                    | Target Coverage |
|--------------|-------------------------|-----------------|
| Domain       | `flutter_test` (pure Dart)| ≥ 90%         |
| BLoC/Cubit   | `bloc_test`             | ≥ 85%           |
| Widgets      | `flutter_test`          | ≥ 70%           |
| Integration  | `patrol` or `integration_test` | Key flows  |

All critical paths (need submission, volunteer assignment, sync conflict resolution) must have integration tests.

---

## 🚀 Build & Run

```bash
# Get dependencies
flutter pub get

# Generate code (freezed, injectable, hive adapters)
dart run build_runner build --delete-conflicting-outputs

# Run on emulator
flutter run

# Run on web
flutter run -d chrome

# Run tests
flutter test

# Build release APK
flutter build apk --release --flavor production
```

---

## 📋 Implementation Checklist (for future engineers)

- [ ] Implement `SyncEngine` in `lib/sync/`
- [ ] Implement authentication feature (OTP-based via Firebase or custom)
- [ ] Implement needs feature (CRUD + local queue)
- [ ] Implement volunteers feature
- [ ] Implement dashboard feature (with real-time WebSocket updates)
- [ ] Set up i18n ARB files for all 6 priority languages
- [ ] Write unit tests for all domain use cases
- [ ] Set up CI pipeline for Flutter tests
