# Phase 4.4: Firebase Auth as Default Provider

## Overview

Firebase Email/Password authentication is now the **default** authentication provider in Flutter, while Supabase auth remains fully intact for rollback purposes.

## Configuration

### Environment Variables

**Default changed in Phase 4.4:**
```bash
# Auth Provider Selection
AUTH_PROVIDER=firebase  # ← Now defaults to 'firebase' instead of 'supabase'
```

### Manual Override
```bash
# Force Supabase (rollback)
AUTH_PROVIDER=supabase

# Use Firebase (default)
AUTH_PROVIDER=firebase
# or omit entirely for default Firebase behavior
```

## Auth Provider Behavior

### Default Behavior (AUTH_PROVIDER=firebase)
- ✅ **Firebase Email/Password** authentication active
- ✅ **Firebase ID tokens** sent to backend
- ✅ **Backend logs**: `issuer=google, fallback=false`
- ✅ **Full end-to-end** Firebase auth flow

### Rollback Behavior (AUTH_PROVIDER=supabase)
- ✅ **Supabase JWT** authentication active
- ✅ **Supabase tokens** sent to backend
- ✅ **Backend logs**: `issuer=supabase`
- ✅ **Original behavior** restored

## Safety & Rollback

### Zero Breaking Changes
- ✅ **Supabase auth code** completely preserved
- ✅ **All existing infrastructure** intact
- ✅ **UI/UX identical** regardless of provider
- ✅ **Database unchanged**
- ✅ **Backend unchanged**

### Instant Rollback
```bash
# Switch back to Supabase instantly
echo "AUTH_PROVIDER=supabase" >> .env
# Restart app - Supabase auth active again
```

## Implementation Details

### Files Changed
- `lib/core/config/environment.dart` - Default changed to 'firebase'

### Startup Behavior
```dart
// App initialization (main.dart)
await SupabaseConfig.initialize();  // Always initialized (inactive if firebase default)
await Firebase.initializeApp();     // Always initialized

// Auth service routing
if (Environment.authProvider == 'firebase') {
  // Use Firebase auth (now default)
} else {
  // Use Supabase auth (rollback)
}
```

### API Integration
```dart
// Headers include appropriate tokens automatically
final headers = await authService.getAuthHeaders();
// Firebase: Authorization: Bearer <firebase_id_token>
// Supabase: Authorization: Bearer <supabase_jwt>
```

## Testing & Validation

### Default Firebase Flow
1. **App starts** → Firebase initialized as primary
2. **User signs up/signs in** → Firebase Email/Password
3. **API calls** → Firebase ID tokens sent to backend
4. **Backend accepts** → `issuer=google` in logs

### Rollback Validation
1. **Set AUTH_PROVIDER=supabase**
2. **Restart app** → Supabase auth active
3. **API calls** → Supabase JWTs sent to backend
4. **Backend logs** → `issuer=supabase`

## Current Status

**"Flutter uses Firebase auth by default, but Supabase remains available for instant rollback."** ✅

## Next Steps (Phase 4.5+)

- Hybrid mode activation in backend
- Google Sign-In enablement
- User migration capabilities
- Production readiness checks
