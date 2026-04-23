# SevakAI — Infrastructure

## Purpose

This directory contains all infrastructure-as-code, container definitions, and deployment configurations for SevakAI. The target platform is **Google Cloud Platform (GCP)**, optimized for disaster-scenario burst workloads.

---

## 🗂️ Structure

```
infra/
├── docker/
│   ├── services/            # Per-service Dockerfiles
│   │   ├── Dockerfile.backend
│   │   ├── Dockerfile.ai-pipeline
│   │   └── Dockerfile.couchdb
│   └── compose/
│       ├── docker-compose.dev.yml     # Local development stack
│       └── docker-compose.test.yml    # CI/CD test environment
│
├── terraform/
│   ├── modules/             # Reusable Terraform modules
│   │   ├── gke/             # GKE cluster configuration
│   │   ├── cloudsql/        # PostgreSQL (audit/metadata store)
│   │   ├── pubsub/          # Pub/Sub topics and subscriptions
│   │   └── networking/      # VPC, subnets, firewall rules
│   └── environments/
│       ├── staging/         # Staging environment tfvars + backend config
│       └── production/      # Production environment tfvars + backend config
│
└── deployment/
    ├── helm/                # Helm charts for Kubernetes deployment
    │   ├── sevakai-backend/
    │   ├── sevakai-ai-pipeline/
    │   └── couchdb/
    ├── scripts/             # Deployment automation scripts
    │   ├── deploy.sh
    │   ├── rollback.sh
    │   └── health-check.sh
    └── configs/             # Non-secret environment configs per environment
        ├── staging.env
        └── production.env
```

---

## ☁️ GCP Deployment Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         GCP PROJECT: sevakai-prod                    │
│                                                                      │
│  ┌─────────────────────────┐    ┌──────────────────────────────┐   │
│  │   Cloud Load Balancer    │    │     Cloud Armor (WAF)         │   │
│  │   + Cloud CDN            │    │     DDoS Protection           │   │
│  └───────────┬─────────────┘    └──────────────────────────────┘   │
│              │                                                       │
│  ┌───────────▼─────────────────────────────────────────────────┐   │
│  │                    GKE Autopilot Cluster                      │   │
│  │                                                               │   │
│  │  ┌─────────────┐  ┌──────────────┐  ┌───────────────────┐  │   │
│  │  │  Backend     │  │  AI Pipeline │  │  CouchDB Cluster  │  │   │
│  │  │  (FastAPI)   │  │  (Workers)   │  │  (3-node replica) │  │   │
│  │  │  HPA: 3-50  │  │  HPA: 2-20  │  │  StatefulSet      │  │   │
│  │  └──────┬──────┘  └──────┬───────┘  └────────┬──────────┘  │   │
│  │         │                │                    │              │   │
│  │  ┌──────▼────────────────▼────────────────────▼──────────┐  │   │
│  │  │              Cloud Pub/Sub (event bus)                  │  │   │
│  │  └────────────────────────────────────────────────────────┘  │   │
│  └───────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────────┐ │
│  │  Cloud SQL   │  │  Memorystore │  │  Cloud Storage             │ │
│  │  (PostgreSQL)│  │  (Redis)     │  │  (media, model files)      │ │
│  └──────────────┘  └──────────────┘  └───────────────────────────┘ │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Observability: Cloud Logging + Cloud Monitoring + Grafana    │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Container Strategy

Each service is containerized independently:

| Service         | Base Image              | Notes                                       |
|-----------------|------------------------|---------------------------------------------|
| Backend         | `python:3.11-slim`     | Multi-stage build, < 200MB target           |
| AI Pipeline     | `python:3.11-slim`     | Includes torch/tflite for offline models    |
| CouchDB         | `couchdb:3.3`          | Official image + custom init scripts        |

All images are stored in **Artifact Registry** (`asia-south1-docker.pkg.dev/sevakai-prod/sevakai/...`).

---

## ⚖️ Scaling Strategy

### Horizontal Pod Autoscaler (HPA)

| Service        | Min Pods | Max Pods | Scale Trigger              |
|----------------|----------|----------|----------------------------|
| Backend        | 3        | 50       | CPU > 60% or RPS > 1000    |
| AI Pipeline    | 2        | 20       | Queue depth > 500 messages |
| CouchDB        | 3        | 3        | StatefulSet (manual scale) |

### Disaster Burst Mode
When a new disaster event is declared (via admin flag), autoscaler limits are **temporarily raised**:
- Backend: up to 200 pods
- AI Pipeline: up to 100 pods
- This is triggered manually by `scripts/burst-mode.sh`

### Multi-Region (Phase 2)
Phase 1: Single region (`asia-south1` — Mumbai)
Phase 2: Multi-region with GCP Traffic Director for latency-based routing
Phase 3: Edge nodes at state data centers (SDWAN connected)

---

## 🔐 Security Hardening

- All services run as non-root in containers
- Network policies enforce zero-trust between pods
- Workload Identity for GCP API access (no service account key files)
- Secrets stored in GCP Secret Manager, accessed via Workload Identity
- CouchDB admin credentials rotated via Secret Manager rotation + Cloud Run jobs
- VPC-native cluster with private nodes (no public IPs on pods)

---

## 🌐 CDN + Caching

| Asset Type          | Cache Strategy                            | TTL       |
|---------------------|-------------------------------------------|-----------|
| Flutter Web App     | Cloud CDN (versioned, immutable assets)   | 1 year    |
| API responses (GET) | Not cached at CDN (disaster data changes) | No cache  |
| Static media        | Cloud Storage + Cloud CDN                 | 30 days   |
| Offline AI models   | Cloud Storage, versioned                  | Immutable |

---

## 🚀 Deployment Workflow

```bash
# 1. Build and push images
./deployment/scripts/deploy.sh --env staging --version v1.2.3

# 2. Apply Terraform changes
cd terraform/environments/staging
terraform plan -out=tfplan
terraform apply tfplan

# 3. Roll out Kubernetes changes
helm upgrade sevakai-backend deployment/helm/sevakai-backend/ \
  --set image.tag=v1.2.3 \
  --namespace sevakai

# 4. Verify health
./deployment/scripts/health-check.sh --env staging

# 5. Rollback if needed
./deployment/scripts/rollback.sh --env staging --revision previous
```

---

## 🔄 CI/CD Pipeline

Pipeline is defined in `.github/workflows/` (or GCP Cloud Build `cloudbuild.yaml`):

```
Push to main → Run tests → Build Docker image → Push to Artifact Registry
                                    ↓
                              Deploy to staging
                                    ↓
                         Integration tests pass?
                                    ↓
                    Manual approval → Deploy to production
                                    ↓
                         Smoke tests + health check
```

---

## 📊 Observability

| Signal      | Tool                      | Alert Condition                          |
|-------------|---------------------------|------------------------------------------|
| Metrics     | Cloud Monitoring + Grafana| API P99 > 2s, error rate > 1%           |
| Logs        | Cloud Logging             | ERROR log rate spike                     |
| Traces      | Cloud Trace               | Distributed trace for slow requests      |
| Uptime      | Cloud Monitoring uptime   | Any downtime → PagerDuty page            |
| Sync lag    | Custom metric             | Device sync lag > 10 min in active incident |

---

## ⚠️ Disaster Recovery

| Scenario              | RTO      | RPO      | Mechanism                              |
|-----------------------|----------|----------|----------------------------------------|
| Pod crash             | < 30s    | 0        | Kubernetes self-healing                |
| Zone failure          | < 2 min  | 0        | Multi-zone GKE cluster                 |
| Region failure        | < 15 min | < 5 min  | Failover to secondary region (Phase 2) |
| CouchDB data loss     | < 30 min | < 1 min  | Continuous backup to Cloud Storage     |
| Full infra rebuild    | < 2 hours| Last backup| Terraform + Helm from scratch        |
