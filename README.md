# RemiMinder

RemiMinder records doctor-patient visits on mobile, transcribes the audio with Google Speech-to-Text, and uses Gemini to extract a schema-validated clinical JSON record — giving patients a structured, searchable account of every visit and giving caregivers real-time visibility into adherence and follow-up actions.

## AI Pipeline

The core of the product is a two-stage async extraction pipeline triggered on every audio upload:

**Stage 1 — Speech-to-Text**: GCS audio is passed through Google Speech-to-Text. The raw transcript, confidence score, detected language, and STT engine name are persisted to Cloud SQL.

**Stage 2 — Structured Extraction (STT-2)**: The raw transcript is sent to Gemini at temperature 0.0 with a clinical scribe prompt. Gemini returns a strict JSON record. Every field is validated before storage — missing required keys or unexpected extra keys cause the job to retry once, then fail with a logged error.

**Stage 3 — Human-readable Summary**: A second Gemini pass converts the structured record into a 2–3 sentence patient-friendly summary.

**Downstream**: Tasks, medication reminders, and caregiver alerts are generated from the structured record by `process_downstream_for_visit`.

## How It Works

```
Flutter App
    │  records audio
    ▼
Google Cloud Storage
    │  audio blob uploaded (m4a / wav)
    ▼
FastAPI  ──  process_audio_visit()
    │
    ▼
Google Speech-to-Text
    │  raw transcript + confidence + language + stt_engine
    ▼
Cloud SQL
    │  raw transcript row saved
    ▼
Job Queue
    │  stt2_extraction job enqueued
    ▼
STT-2 Extraction  ──  Gemini @ temperature=0.0
    │  JSON validated field-by-field against fixed schema
    │  retry once on validation failure
    ▼
Cloud SQL
    │  structured clinical record stored
    │  run logged: prompt_version, model, latency_ms, cost_usd
    ▼
Downstream consumers
    │  reminder generation, task creation, caregiver projection
    ▼
Firebase (FCM)
    patient + caregiver push notifications
```

## Sample Output

STT-2 produces a validated JSON record for every visit. All nine fields are required; missing values are stored as empty strings or empty arrays — never null or omitted.

```json
{
  "visit_display_title": "Type 2 Diabetes Management Review",
  "doctor_name": "Dr. Sarah Chen",
  "specialty": "Endocrinology",
  "key_diagnoses": [
    "Type 2 diabetes mellitus — suboptimal glycaemic control",
    "Stage 1 hypertension"
  ],
  "summary": "Patient presents for 3-month diabetes review. HbA1c has risen from 7.1% to 8.4% since last visit. Current metformin dose is being increased and a GLP-1 agonist is being added. Blood pressure is elevated; lifestyle modification discussed before considering pharmacotherapy.",
  "medications": [
    "Metformin 1000mg — twice daily with meals",
    "Semaglutide 0.25mg — subcutaneous injection once weekly",
    "Lisinopril 10mg — once daily (existing, no change)"
  ],
  "action_items": [
    "Increase metformin to 1000mg twice daily starting tomorrow",
    "Begin semaglutide 0.25mg weekly injection; titrate to 0.5mg after 4 weeks",
    "Monitor fasting blood glucose daily and log results",
    "Reduce sodium intake; target under 2g/day"
  ],
  "actions": [
    "Start semaglutide injection regimen",
    "Schedule HbA1c retest in 12 weeks",
    "Book dietitian referral for low-sodium meal planning"
  ],
  "questions_next_visit": [
    "Has HbA1c improved with new regimen?",
    "Any side effects from semaglutide (nausea, GI upset)?",
    "Has blood pressure responded to lifestyle changes?"
  ]
}
```

The raw STT transcript row additionally stores `confidence` (0.0–1.0), `language` (BCP-47), and `stt_engine` for auditability. Every STT-2 run is logged separately with `prompt_version`, `model_name`, `latency_ms`, `tokens_in`, `tokens_out`, and `cost_usd`.

## Privacy & Compliance

RemiMinder is designed around HIPAA-aligned controls:

| Control | Implementation |
|---|---|
| Encryption at rest | GCS with Google-managed CMEK; Cloud SQL storage encryption enabled |
| Encryption in transit | TLS 1.2+ on all Cloud Run endpoints and GCS transfers |
| Access control | Firebase Auth JWTs validated on every request before any patient data is accessed |
| Network isolation | Cloud SQL on private IP only — no public database endpoint |
| PII in logs | Structured logging via `get_logger()`; user IDs are logged, transcript content and clinical data are not |
| Caregiver access | Role-scoped: caregivers receive read-only visit projections; raw audio and transcripts are patient-scoped |
| Audit trail | Every STT-2 run row in `stt2_summary_runs` captures prompt version, model, latency, cost, and error text |

Audio files are never retained in application memory beyond the STT call. Gemini prompts contain transcript text only — no patient name, date of birth, or other identifiers are injected into prompts.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (iOS / Android), Google ML Kit (OCR) |
| Backend | FastAPI (Python), Cloud Run |
| Database | Cloud SQL — PostgreSQL, private IP |
| Auth | Firebase Auth |
| STT | Google Speech-to-Text |
| AI / Extraction | Google Gemini via Vertex AI |
| Storage | Google Cloud Storage |

## Project Structure

```
RemiMinder/
├── apps/
│   ├── web/                   # React web app (Phase 1, archived)
│   ├── mobile/                # Flutter app (iOS / Android)
│   └── backend/               # FastAPI backend
│       ├── domain/            # Business logic and ports
│       │   ├── stt2/          # STT-2 pipeline: schema, extraction service, repo, job service
│       │   ├── visits/        # Visit CRUD and metadata
│       │   ├── transcripts/   # Raw STT transcript storage
│       │   ├── downstream/    # Reminder and task generation consumers
│       │   └── users/         # User and caregiver management
│       ├── workflows/         # Pipeline orchestration (visit_processing, ocr_processing)
│       ├── infra/             # DB engine, LLM client, env config, wiring
│       └── utils/             # Prompts, shared utilities
├── packages/                  # Shared cross-platform utilities
├── infrastructure/
│   └── deployment/            # GCP Cloud Run deployment configs
├── phase1/                    # Archived Phase 1 (React + Supabase)
└── docker-compose.yml         # Local development
```

## Quick Start

### Local Development

```bash
docker-compose up
```

### Mobile App

```bash
cd apps/mobile
flutter pub get
flutter run
```

### Backend

```bash
cd apps/backend
pip install -r requirements.txt
python main.py
```

### Web App (Phase 1 — archived)

```bash
cd apps/web
npm install
npm start
```

## Status

| Phase | Description | Status |
|---|---|---|
| Phase 1 | React web app, Supabase backend | Archived (`phase1/`) |
| Phase 2 | Flutter mobile, GCP backend, AI pipeline | Active |
