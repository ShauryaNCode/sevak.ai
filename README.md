# SevakAI — Disaster Response Platform

> *Sevak* (सेवक) means **servant** or **one who serves** in Hindi. SevakAI is a disaster-critical, offline-first platform that coordinates relief efforts at scale — from field volunteer to national command center.

---

## 🧭 Project Vision

SevakAI is a production-grade, multi-tier disaster management system designed to function in **zero-connectivity environments** while seamlessly syncing when connectivity is restored. Built to scale from a single district hackathon MVP to a nationwide deployment serving millions of relief workers, coordinators, and citizens.

---
## 🔗 Project Links & Deployment
|Resource|Link|Description|
|---------|--------|------|
|📺 Demo Video| **[Watch on Youtube](https://youtu.be/0WhDkdsfNGQ?si=3ICJNzikKzsyMQ_M)** | A full walkthrough of the project architecture and features.|
|✨ Landing Page | **[Landing Page](https://sevak-ai-pied.vercel.app/prototype)** | The official landing page and dashboard deployed on Render.|
|⚙️ Backend API| **[Wake up Backend](https://sevak-ai-backend.onrender.com/demo)** | Note: Please open this link first to wake the server from its sleep cycle.|
|🚀 Live MVP| **[Open App](https://sevak-ai-pied.vercel.app)** | Working Deployed Frontend linked to backend| 
---

## 🗂️ Repository Structure

```
sevakai/
├── frontend/          # Flutter app (mobile + web, offline-first)
├── backend/           # FastAPI server (async, role-based, sync-aware)
├── ai-pipeline/       # NLP ingestion, Gemini integration, offline models
├── infra/             # Docker, Terraform (GCP), Helm, CI/CD
├── docs/              # Architecture, API spec, data models, roadmap
└── scripts/           # Developer utilities, seed data, local bootstrap
```

---
## 🗂️ Detailed Structure

```
sevakai/
├─ README.md
├─ frontend/
│  ├─ README.md
│  ├─ assets/
│  │  ├─ README.md
│  │  ├─ fonts/README.md
│  │  ├─ icons/README.md
│  │  ├─ images/README.md
│  │  └─ translations/README.md
│  ├─ lib/
│  │  ├─ README.md
│  │  ├─ core/
│  │  │  ├─ README.md
│  │  │  ├─ config/README.md
│  │  │  ├─ constants/README.md
│  │  │  ├─ errors/README.md
│  │  │  └─ utils/README.md
│  │  ├─ features/
│  │  │  ├─ README.md
│  │  │  ├─ authentication/
│  │  │  │  ├─ README.md
│  │  │  │  ├─ data/README.md
│  │  │  │  ├─ domain/
│  │  │  │  │  ├─ README.md
│  │  │  │  │  └─ auth_repository.dart
│  │  │  │  └─ presentation/README.md
│  │  │  ├─ needs/
│  │  │  │  ├─ README.md
│  │  │  │  ├─ data/README.md
│  │  │  │  ├─ domain/
│  │  │  │  │  ├─ README.md
│  │  │  │  │  └─ need_repository.dart
│  │  │  │  └─ presentation/README.md
│  │  │  ├─ volunteers/
│  │  │  │  ├─ README.md
│  │  │  │  ├─ data/README.md
│  │  │  │  ├─ domain/README.md
│  │  │  │  └─ presentation/README.md
│  │  │  └─ dashboard/
│  │  │     ├─ README.md
│  │  │     ├─ data/README.md
│  │  │     ├─ domain/README.md
│  │  │     └─ presentation/README.md
│  │  ├─ services/
│  │  │  ├─ README.md
│  │  │  └─ connectivity_service.dart
│  │  ├─ sync/
│  │  │  ├─ README.md
│  │  │  ├─ sync_engine.dart
│  │  │  ├─ outbox_repository.dart
│  │  │  └─ replication_client.dart
│  │  └─ ui/
│  │     ├─ README.md
│  │     ├─ components/README.md
│  │     ├─ themes/README.md
│  │     └─ widgets/README.md
│  └─ test/
│     ├─ README.md
│     ├─ unit/README.md
│     ├─ widget/README.md
│     └─ integration/README.md
├─ backend/
│  ├─ README.md
│  ├─ app/
│  │  ├─ README.md
│  │  ├─ main.py
│  │  ├─ api/
│  │  │  ├─ README.md
│  │  │  ├─ api-spec.md
│  │  │  ├─ main.py
│  │  │  ├─ RBAC.py
│  │  │  ├─ settings.py
│  │  │  └─ v1/
│  │  │     ├─ README.md
│  │  │     ├─ router.py
│  │  │     ├─ dependencies/
│  │  │     │  ├─ README.md
│  │  │     │  ├─ auth.py
│  │  │     │  ├─ db.py
│  │  │     │  └─ pagination.py
│  │  │     └─ endpoints/
│  │  │        ├─ README.md
│  │  │        ├─ auth.py
│  │  │        ├─ needs.py
│  │  │        ├─ volunteers.py
│  │  │        ├─ incidents.py
│  │  │        ├─ resources.py
│  │  │        ├─ alerts.py
│  │  │        └─ webhooks.py
│  │  ├─ core/
│  │  │  ├─ README.md
│  │  │  ├─ config/
│  │  │  │  ├─ README.md
│  │  │  │  └─ settings.py
│  │  │  ├─ logging/README.md
│  │  │  ├─ middleware/README.md
│  │  │  └─ security/
│  │  │     ├─ README.md
│  │  │     └─ rbac.py
│  │  ├─ db/
│  │  │  ├─ README.md
│  │  │  ├─ base.py
│  │  │  ├─ couchdb.py
│  │  │  └─ repositories/
│  │  │     ├─ README.md
│  │  │     └─ base_repository.py
│  │  ├─ integrations/
│  │  │  ├─ README.md
│  │  │  ├─ whatsapp/
│  │  │  │  ├─ README.md
│  │  │  │  ├─ webhook_handler.py
│  │  │  │  ├─ message_parser.py
│  │  │  │  └─ client.py
│  │  │  └─ sms/
│  │  │     ├─ README.md
│  │  │     ├─ webhook_handler.py
│  │  │     ├─ message_parser.py
│  │  │     └─ client.py
│  │  ├─ models/
│  │  │  ├─ README.md
│  │  │  └─ user.py
│  │  ├─ schemas/
│  │  │  ├─ README.md
│  │  │  └─ common.py
│  │  ├─ services/
│  │  │  ├─ README.md
│  │  │  ├─ need_service.py
│  │  │  ├─ volunteer_service.py
│  │  │  └─ ai_triage_service.py
│  │  ├─ sync/README.md
│  │  └─ utils/README.md
│  ├─ tests/
│  │  ├─ README.md
│  │  ├─ unit/README.md
│  │  ├─ integration/README.md
│  │  └─ e2e/README.md
│  ├─ migrations/README.md
│  └─ scripts/README.md
├─ ai-pipeline/
│  ├─ README.md
│  ├─ ingestion/
│  │  ├─ README.md
│  │  ├─ parsers/README.md
│  │  ├─ validators/README.md
│  │  └─ normalizers/
│  │     ├─ README.md
│  │     └─ message_normalizer.py
│  ├─ processing/
│  │  ├─ README.md
│  │  ├─ nlp/README.md
│  │  ├─ classification/
│  │  │  ├─ README.md
│  │  │  └─ intent_classifier.py
│  │  └─ extraction/
│  │     ├─ README.md
│  │     └─ entity_extractor.py
│  ├─ models/
│  │  ├─ README.md
│  │  ├─ data-models.md
│  │  ├─ offline/README.md
│  │  └─ cloud/
│  │     ├─ README.md
│  │     ├─ gemini_client.py
│  │     └─ model_router.py
│  ├─ prompts/
│  │  ├─ README.md
│  │  ├─ templates/
│  │  │  ├─ README.md
│  │  │  └─ triage.j2
│  │  └─ versioned/
│  │     ├─ README.md
│  │     └─ v1/README.md
│  └─ evaluation/
│     ├─ README.md
│     ├─ benchmarks/
│     │  ├─ README.md
│     │  └─ run_benchmark.py
│     ├─ datasets/README.md
│     └─ metrics/README.md
├─ infra/
│  ├─ README.md
│  ├─ docker/
│  │  ├─ README.md
│  │  ├─ compose/README.md
│  │  └─ services/README.md
│  ├─ terraform/
│  │  ├─ README.md
│  │  ├─ environments/
│  │  │  ├─ README.md
│  │  │  ├─ staging/README.md
│  │  │  └─ production/README.md
│  │  └─ modules/
│  │     ├─ README.md
│  │     ├─ cloudsql/README.md
│  │     ├─ gke/README.md
│  │     ├─ networking/README.md
│  │     └─ pubsub/README.md
│  └─ deployment/
│     ├─ README.md
│     ├─ configs/README.md
│     ├─ helm/README.md
│     └─ scripts/README.md
├─ docs/
│  ├─ README.md
│  ├─ architecture.md
│  ├─ api-spec.md
│  ├─ data-models.md
│  ├─ roadmap.md
│  ├─ adr/README.md
│  ├─ diagrams/README.md
│  └─ runbooks/README.md
└─ scripts/
   ├─ README.md
   ├─ bootstrap/README.md
   ├─ quality/README.md
   ├─ data/README.md
   └─ ops/README.md

```

---

## 🧱 System Architecture Summary

| Layer              | Technology                              | Purpose                                       |
|--------------------|------------------------------------------|-----------------------------------------------|
| Mobile/Web Frontend| Flutter (Dart)                           | Offline-first UI for field workers & admins  |
| Local DB           | PouchDB (embedded in Flutter via Hive)  | Local document store with sync queue          |
| Sync Protocol      | PouchDB ↔ CouchDB replication           | Bidirectional conflict-aware data sync        |
| Backend API        | FastAPI (Python, async)                 | Business logic, auth, coordination API        |
| Primary DB         | CouchDB                                 | Distributed document store (sync target)      |
| AI Pipeline        | Gemini (cloud) + local NLP models       | Message triage, needs extraction, tagging     |
| Communication      | Twilio / Gupshup webhooks               | WhatsApp + SMS ingestion from field workers   |
| Infrastructure     | GCP: GKE, Cloud Run, Cloud SQL          | Scalable, managed deployment                  |
| Observability      | Cloud Logging, Prometheus, Grafana      | Metrics, alerting, log aggregation            |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- Python ≥ 3.11
- Docker + Docker Compose
- GCP project (for production deployments)
- Node.js ≥ 18 (for scripts)

### Local Development Bootstrap

```bash
# 1. Clone the repo
git clone https://github.com/your-org/sevakai.git && cd sevakai

# 2. Start backing services (CouchDB, Redis)
docker compose -f infra/docker/compose/docker-compose.dev.yml up -d

# 3. Start the backend
cd backend && pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000

# 4. Start the frontend
cd frontend && flutter pub get
flutter run -d chrome   # web
flutter run             # mobile emulator
```

> See `scripts/bootstrap.sh` for a fully automated local dev setup.

---

## 🌐 Offline-First Guarantee

SevakAI is designed so that **every critical workflow operates fully offline**:

- Volunteers can log needs, update status, and submit reports without connectivity
- Coordinators can view cached dashboards and assign resources offline
- All mutations queue locally (PouchDB) and sync when connectivity resumes
- Conflict resolution is deterministic and auditable

---

## 🔐 Security & Access

| Role              | Access Level                                   |
|-------------------|------------------------------------------------|
| Field Volunteer   | Own submissions, local read-only of assignments|
| Zone Coordinator  | Read/write within assigned zone                |
| District Admin    | Read/write all data in district                |
| National Admin    | Full system access                             |
| AI System         | Write-only ingestion endpoints                 |

---

## 📚 Documentation

| Document                    | Location                        |
|-----------------------------|---------------------------------|
| Architecture Overview       | `docs/architecture.md`          |
| API Specification           | `docs/api-spec.md`              |
| Data Models                 | `docs/data-models.md`           |
| Product Roadmap             | `docs/roadmap.md`               |
| Architecture Decision Records| `docs/adr/`                    |
| Runbooks                    | `docs/runbooks/`                |

---

## 👥 Team

| Contributor | Role | Responsibilities |
|------------|------|------------------|
| **[Shaurya Naik](https://github.com/ShauryaNCode)** | Team Lead & Lead Dev | Designed the core project architecture and directory structure. Developed the Flutter-based Admin and Volunteer dashboards. Managed the main backend logic and recorded the project demo video. |
| **[Siddhant Kerkar](https://github.com/Siddhantdev404)** | AI & Backend Engineer | Engineered the AI pipeline using Gemini 1.5 Flash and Pro. Integrated the AI models into the backend and developed the Admin Heatmap feature for real-time volunteer tracking. |
| **[Gaurav Parker](https://github.com/DeltaG06)** | DevOps & Presentation | Managed the deployment of the AI pipeline and backend services on Render. Crafted the final presentation and built a dedicated Judge's Demo Page for simulating real-world needs and volunteer actions. |
| **[Gaurang Khanolkar](https://github.com/gaurang0410)** | Product & UI/UX | Developed the project wireframes, UI color scale, and workflow architecture. Built the official Product Landing Page and managed the frontend deployment on Vercel. |

---

