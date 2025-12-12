# MediMinder Web App (Phase 1)

This is the Phase 1 React web application for MediMinder.

## Getting Started

```bash
npm install
npm start
```

## Project Structure

```
src/
├── components/     # Reusable UI components
├── caregiver/      # Caregiver-specific pages
├── patient/        # Patient-specific pages
├── assets/         # Images and media files
└── services/       # API integration
```

## Key Components

### Reusable Components:
- **AudioRecorder**: Voice recording functionality
- **LandingPage**: Marketing landing page
- **SignIn/SignUp**: Authentication forms

### Patient Features:
- Dashboard, reminders, visit history
- Audio recording for doctor visits
- Medication management

### Caregiver Features:
- Patient monitoring dashboard
- Invitation system
- Visit summaries

## Deployment

This app is configured for Vercel deployment with the included `vercel.json`.