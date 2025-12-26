# Google Sign-In Workaround for Nonce Error

## The Problem
Supabase's `signInWithIdToken` has a persistent nonce validation issue with Google Sign-In:
```
Exception: Passed nonce and nonce in id_token should either both exist or not.
```

## The Workaround

Instead of using Supabase's Google authentication, we'll:
1. Get Google tokens from GoogleSignIn
2. Authenticate directly with FastAPI backend using Google tokens
3. Backend validates tokens and creates user/session
4. Use backend tokens for API calls (skip Supabase for Google auth)

## Implementation

### Backend Endpoint Needed

Your FastAPI backend needs a Google authentication endpoint:

```python
# In your FastAPI backend (apps/backend/route/)
from fastapi import APIRouter, HTTPException
from google.oauth2 import id_token
from google.auth.transport import requests

router = APIRouter()

@router.post("/auth/google")
async def google_auth(data: dict):
    """
    Authenticate user with Google ID token
    """
    try:
        google_id_token = data.get("id_token")
        
        # Verify the Google ID token
        idinfo = id_token.verify_oauth2_token(
            google_id_token,
            requests.Request(),
            "575820802106-akqd9u3ksb51fqi7ibojbgkgsjjobm7g.apps.googleusercontent.com"
        )
        
        # Extract user info
        email = idinfo['email']
        name = idinfo.get('name', '')
        picture = idinfo.get('picture', '')
        
        # Create or get user from database
        user = get_or_create_user(email, name, picture, provider="google")
        
        # Generate JWT token for the user
        access_token = create_access_token(user.id)
        refresh_token = create_refresh_token(user.id)
        
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "user": {
                "id": user.id,
                "email": user.email,
                "name": user.name,
                "role": user.role
            }
        }
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Invalid Google token: {str(e)}")
```

### Flutter Implementation

```dart
// In lib/core/services/auth_service.dart

Future<User> signInWithGoogle() async {
  print('🔐 AuthService: Starting Google Sign-In process...');

  try {
    // Get Google authentication credentials
    final googleAuth = await GoogleSignInService.signInWithGoogle();
    
    if (googleAuth == null) {
      throw Exception('Google sign in was cancelled');
    }

    print('🔐 AuthService: Authenticating with backend using Google token...');
    
    // Authenticate with FastAPI backend instead of Supabase
    final response = await http.post(
      Uri.parse('${Environment.apiBaseUrl}/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_token': googleAuth.idToken,
        'access_token': googleAuth.accessToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Backend authentication failed: ${response.body}');
    }

    final data = json.decode(response.body);
    
    // Save tokens from backend
    await _tokenManager.saveTokens(
      data['access_token'],
      data['refresh_token'] ?? '',
    );

    // Convert backend user data to User model
    final user = User(
      id: data['user']['id'],
      email: data['user']['email'],
      name: data['user']['name'],
      role: _parseRole(data['user']['role']),
    );

    return user;
  } catch (e) {
    await GoogleSignInService.signOut();
    throw _handleAuthError(e);
  }
}
```

## Benefits

✅ Bypasses Supabase nonce validation issue
✅ Direct control over authentication flow
✅ Can add custom logic in backend
✅ Works with existing FastAPI backend
✅ No changes needed to Supabase configuration

## Trade-offs

⚠️ Can't use Supabase's built-in Google auth
⚠️ Need to implement backend endpoint
⚠️ Need to manage JWT tokens manually

## Alternative: Disable Google, Use Email/Password

If implementing backend endpoint is too complex, consider:
- Remove Google Sign-In temporarily
- Use only email/password authentication
- Add Google Sign-In later when Supabase fixes the nonce issue

## Status

- **Current**: Nonce error blocks Google Sign-In
- **Workaround**: Authenticate through FastAPI backend
- **Long-term**: Wait for Supabase package update or use different auth method

---

**Recommendation**: Implement backend Google authentication endpoint as the most reliable solution.

