# SevakAI — AI Pipeline

## Purpose

The AI pipeline transforms **unstructured, noisy human messages** (WhatsApp texts, SMS, voice transcripts) into **structured, actionable disaster data** — tagged needs, prioritized alerts, volunteer match suggestions, and resource allocation signals.

The pipeline must work across two operating modes:
- **Cloud mode** (Gemini): Full NLP, rich classification, multi-turn reasoning
- **Offline/Edge mode**: Lightweight local models for basic triage when connectivity is unavailable

---

## 🗂️ Directory Structure

```
ai-pipeline/
├── ingestion/
│   ├── parsers/             # Format-specific parsers (WhatsApp, SMS, voice transcript)
│   │   ├── whatsapp_parser.py
│   │   ├── sms_parser.py
│   │   └── voice_transcript_parser.py
│   ├── validators/          # Input validation, deduplication, spam detection
│   │   ├── message_validator.py
│   │   └── dedup_engine.py
│   └── normalizers/         # Canonical NormalizedMessage format conversion
│       └── message_normalizer.py
│
├── processing/
│   ├── nlp/                 # Core NLP operations
│   │   ├── language_detector.py   # Detect Hindi/English/regional
│   │   ├── transliterator.py      # Hinglish → Hindi or English
│   │   └── tokenizer.py
│   ├── classification/      # Message intent and priority classification
│   │   ├── intent_classifier.py   # NEED / OFFER / STATUS / NOISE
│   │   ├── priority_scorer.py     # Urgency 1-5 scoring
│   │   └── disaster_type_tagger.py
│   └── extraction/          # Entity extraction from classified messages
│       ├── entity_extractor.py    # People count, location, resource type
│       ├── location_extractor.py  # Resolve vague location refs to coordinates
│       └── needs_extractor.py     # Extract specific need types
│
├── models/
│   ├── offline/             # Lightweight models for edge/no-connectivity use
│   │   ├── tflite/          # TensorFlow Lite model files
│   │   ├── onnx/            # ONNX model files
│   │   └── vocab/           # Tokenizer vocab files
│   └── cloud/               # Cloud model clients and prompt orchestration
│       ├── gemini_client.py
│       └── model_router.py  # Decides offline vs cloud based on connectivity
│
├── prompts/
│   ├── templates/           # Jinja2 prompt templates
│   │   ├── triage.j2
│   │   ├── entity_extraction.j2
│   │   ├── needs_classification.j2
│   │   └── priority_scoring.j2
│   └── versioned/           # Immutable versioned prompt snapshots
│       └── v1/
│
└── evaluation/
    ├── benchmarks/          # Benchmark scripts against labeled datasets
    │   └── run_benchmark.py
    ├── metrics/             # Precision, recall, F1, latency trackers
    │   └── metrics_reporter.py
    └── datasets/            # Labeled evaluation datasets (anonymized)
        └── sample_messages.jsonl
```

---

## 🧠 AI Split: Offline vs Cloud

### Design Principle
**AI must degrade gracefully, not fail completely**, when internet is unavailable.

```
Message arrives
      ↓
  model_router.py
      ↓
[Online?]──YES──→ Gemini API (full pipeline)
      │
      NO
      ↓
  Local TFLite model (basic classification only)
      ↓
  Queue message for cloud processing when online
```

### Online Mode (Gemini)
- Full multi-step pipeline: language detection → classification → entity extraction → priority scoring
- Handles Hinglish, regional scripts, voice transcripts
- Can ask clarifying follow-up questions via WhatsApp
- 95%+ accuracy target for need classification

### Offline Mode (TFLite/ONNX)
- Binary classification only: URGENT / NON-URGENT
- No entity extraction (too expensive offline)
- Messages tagged `PENDING_CLOUD_PROCESSING`
- Model size target: < 10MB to bundle in mobile app

---

## 🔄 NLP Extraction Pipeline

For a message like:
> "Bhai 50 log phase gaye hai, khana nahi hai, 3 baache hain, kaafi paani bhar gaya — Lal Chowk ke pass"

The pipeline produces:

```json
{
  "intent": "NEED",
  "priority": 5,
  "disaster_type": "FLOOD",
  "needs": ["FOOD", "RESCUE"],
  "affected_count": 50,
  "vulnerable": ["CHILDREN"],
  "location_raw": "Lal Chowk ke pass",
  "location_resolved": { "lat": 34.083, "lng": 74.797, "confidence": 0.82 },
  "language": "HINGLISH",
  "source": "WHATSAPP"
}
```

### Pipeline Steps

1. **Language Detection** — identify script and language
2. **Transliteration** — Romanized Hindi → Devanagari (if needed)
3. **Intent Classification** — NEED | OFFER | STATUS | NOISE
4. **Priority Scoring** — 1 (low) to 5 (immediate life threat)
5. **Entity Extraction** — people count, needs, location, vulnerabilities
6. **Location Resolution** — fuzzy string to lat/lng via geocoding + local landmark DB
7. **Output Structuring** — emit `TriagedMessage` event to backend

---

## 🤖 Gemini Usage Strategy

- Use **Gemini 1.5 Flash** for high-throughput triage (cost-efficient)
- Use **Gemini 1.5 Pro** for complex multi-entity messages requiring reasoning
- All prompts are **versioned** and **templated** — never hardcoded strings
- Implement a **prompt registry** that maps pipeline step → prompt version
- Log all Gemini calls with: input tokens, output tokens, latency, model version, prompt version

### Rate Limiting & Cost Control
- Batch messages in 500ms windows before calling Gemini
- Cache identical message hashes (spam/flood scenario)
- Hard budget cap via GCP billing alerts

---

## 📊 Evaluation Framework

Every prompt change and model update must be evaluated before deployment:

```bash
# Run evaluation benchmark
python evaluation/benchmarks/run_benchmark.py \
  --dataset evaluation/datasets/sample_messages.jsonl \
  --model gemini-1.5-flash \
  --prompt-version v2

# Expected output:
# Intent Classification: P=0.94 R=0.91 F1=0.92
# Priority Scoring: MAE=0.31
# Entity Extraction (location): P=0.87 R=0.84
```

A **minimum F1 score gate** must be passed before any prompt version is promoted to production.

---

## 🔮 Future Extensibility

| Phase | Capability                                    |
|-------|-----------------------------------------------|
| V2    | Satellite image analysis (flood extent mapping)|
| V2    | Voice message transcription (Whisper or Gemini)|
| V3    | Predictive resource allocation (ML model)      |
| V3    | Cross-incident pattern detection               |
| V4    | Autonomous volunteer dispatch suggestions      |

---

## 🧪 Testing

```bash
# Install deps
pip install -r requirements.txt

# Run unit tests
pytest tests/

# Run evaluation benchmark
python evaluation/benchmarks/run_benchmark.py
```

---

## 🔑 Environment Variables

```
GEMINI_API_KEY=...
GEMINI_MODEL_TRIAGE=gemini-1.5-flash
GEMINI_MODEL_COMPLEX=gemini-1.5-pro
OFFLINE_MODEL_PATH=models/offline/tflite/sevakai_triage_v1.tflite
GEOCODING_API_KEY=...
```
