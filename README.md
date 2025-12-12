# MediMinder - AI Healthcare Companion

MediMinder is an AI-powered healthcare app that helps patients manage medications and allows caregivers to monitor loved ones through intelligent visit recording and smart reminders.

## Current Status

- **Phase 1**: React web app (archived in `phase1/` folder)
- **Phase 2**: Flutter mobile app with GCP backend (actively developing)

## Tech Stack

- **Mobile**: Flutter (iOS/Android) with Google ML Kit (OCR)
- **Backend**: FastAPI (Python)
- **Database**: Google Cloud SQL (PostgreSQL)
- **Authentication**: Firebase Auth
- **AI**: Google Gemini (visit transcription)
- **Deployment**: Google Cloud Run
- **Storage**: Google Cloud Storage

## Quick Start

### Mobile App
```bash
cd mobile
flutter pub get
flutter run
```

### Backend
```bash
cd backend
pip install -r requirements.txt
python main.py
```

## Project Structure

- `mobile/` - Flutter mobile application
- `backend/` - FastAPI backend services
- `shared/` - Common constants and utilities
- `phase1/` - Archived React web app
- `deployment/` - GCP deployment configurations
- `docs/` - Development documentation (local only)

## Key Features

### For Patients
- **Audio Visit Recording**: Record doctor-patient conversations with AI transcription
- **Smart Medication Reminders**: Intelligent scheduling with snooze and skip options
- **RemiScan**: AI-powered scanner for prescriptions, pill bottles, and lab reports - extracts data, generates summaries, and creates smart reminders
- **Health Dashboard**: Track visits, medications, and adherence patterns
- **Visit Summaries**: AI-generated plain-language summaries of medical visits

### For Caregivers
- **Multi-Patient Monitoring**: Manage multiple patients with real-time alerts
- **Adherence Tracking**: Monitor medication compliance and receive alerts
- **Visit Access**: View patient visit recordings and AI-generated summaries
- **Emergency Connections**: Quick access to healthcare providers

### AI-Powered Features
- **Intelligent Reminders**: AI extracts and creates medication/appointment reminders
- **Natural Language Processing**: Friendly, jargon-free communication
- **Smart Scheduling**: Optimal timing for medication reminders
- **Voice Recording**: High-quality audio capture with background processing

## Documentation

- [Technical Architecture](./ARCHITECTURE.md)
- [Migration from Phase 1](./MIGRATION.md)
- [Phase 1 Archive](./phase1/README.md)
