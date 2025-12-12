# Shared Constants & Configuration

This directory contains constants and configuration shared across the MediMinder ecosystem.

## Current Files:
- `README.md` - This documentation

## Planned Files to Add:

### API Configuration
- `api_endpoints.dart` - API endpoint URLs for Flutter mobile
- `api_endpoints.py` - API endpoint URLs for FastAPI backend
- `environment.dart` - Environment configuration (dev/staging/prod)

### UI Constants
- `ui_constants.dart` - Colors, fonts, spacing, dimensions
- `strings.dart` - Localized text strings
- `icons.dart` - Custom icon definitions

### Business Logic Constants
- `reminder_types.dart` - Reminder type definitions
- `validation_rules.dart` - Input validation rules
- `notification_templates.dart` - Push notification templates

### Feature Flags
- `feature_flags.dart` - Feature toggle configuration
- `app_config.dart` - Application-wide settings

## Usage Examples:

```dart
// Flutter
import 'package:mediminder_shared/constants/api_endpoints.dart';
final url = ApiEndpoints.baseUrl;

// Python
from shared.constants.api_endpoints import API_BASE_URL
```

## Adding New Constants:

1. Add the constant file here
2. Update both mobile and backend to import from this location
3. Ensure cross-platform compatibility