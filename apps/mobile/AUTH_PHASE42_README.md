# Phase 4.2: Firebase Email/Password Authentication

## Overview

Firebase Email/Password authentication has been added alongside Supabase auth. This is a **parallel setup** - both auth systems coexist without affecting each other.

## Configuration

### Environment Variables

Add to your `.env` file:

```bash
# Auth Provider Selection
AUTH_PROVIDER=supabase  # Use 'firebase' to test Firebase auth
```

### Firebase Console Setup (Already Done)

- ✅ Email/Password provider enabled
- ✅ iOS app: `com.remiminder.app`
- ✅ Android app: `com.remiminder.app`
- ✅ Configuration files downloaded and placed

## Auth Provider Behavior

### When `AUTH_PROVIDER=supabase` (Default)
- Uses existing Supabase authentication
- Full backend integration
- All existing functionality works unchanged
- Tokens sent to backend for API calls

### When `AUTH_PROVIDER=firebase`
- Uses Firebase Email/Password authentication
- **Phase 4.2: Firebase tokens NOT sent to backend**
- No backend API calls made
- Authentication isolated for testing
- User data stored locally only

## Switching Between Providers

Change the `AUTH_PROVIDER` environment variable:

```bash
# Test Supabase (existing behavior)
AUTH_PROVIDER=supabase

# Test Firebase (isolated)
AUTH_PROVIDER=firebase
```

## Code Architecture

### New Files
- `lib/core/services/firebase_auth_service.dart` - Firebase auth implementation

### Modified Files
- `lib/core/config/environment.dart` - Added `authProvider` getter
- `lib/core/services/auth_service.dart` - Added provider routing logic

### Auth Service Methods

All methods now route based on `AUTH_PROVIDER`:

- `signUp()` - Firebase or Supabase account creation
- `signIn()` - Firebase or Supabase authentication
- `signOut()` - Firebase or Supabase sign out
- `getCurrentUser()` - Firebase or Supabase user retrieval
- `resetPassword()` - Firebase or Supabase password reset

## Safety Features

### No Breaking Changes
- ✅ Supabase auth works exactly as before
- ✅ `AUTH_MODE=supabase` is default
- ✅ All existing UI/UX preserved
- ✅ Rollback trivial (change env var)

### Phase 4.2 Isolation
- ✅ Firebase tokens not sent to backend
- ✅ No database schema changes
- ✅ No route modifications
- ✅ Google Sign-In remains disabled

## Testing Firebase Auth

1. Set `AUTH_PROVIDER=firebase` in `.env`
2. Restart the app
3. Use sign up/sign in with email/password
4. Firebase authentication works independently
5. Switch back to `AUTH_PROVIDER=supabase` to restore normal operation

## Next Steps (Phase 4.3+)

- Send Firebase tokens to backend
- Enable hybrid mode in auth gateway
- Add Google Sign-In support
- Migrate users between providers

## Current Status

**"Flutter supports Firebase Email/Password auth in parallel with Supabase, but Supabase remains the active path by default."** ✅
