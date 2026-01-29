"""
Firebase authentication gateway for MediMinder.

This module provides Firebase ID token verification and user resolution.
"""

import os
import time
import logging
from fastapi import HTTPException, status, Request

import jwt
import requests
from sqlalchemy import text

logger = logging.getLogger(__name__)

# Firebase JWKS cache
_firebase_jwks_cache = None
_firebase_jwks_cache_time = 0
JWKS_CACHE_DURATION = 3600  # 1 hour in seconds


def _get_firebase_jwks() -> dict:
    """
    Fetch and cache Firebase JWKS (JSON Web Key Set).

    Returns cached keys if still valid, otherwise fetches fresh keys
    from Firebase Auth endpoint.
    """
    global _firebase_jwks_cache, _firebase_jwks_cache_time

    current_time = time.time()
    if (_firebase_jwks_cache is not None and
        current_time - _firebase_jwks_cache_time < JWKS_CACHE_DURATION):
        return _firebase_jwks_cache

    try:
        # Use Firebase Auth JWKS endpoint for Firebase ID tokens
        response = requests.get(
            "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
            timeout=10
        )
        response.raise_for_status()
        _firebase_jwks_cache = response.json()
        _firebase_jwks_cache_time = current_time
        return _firebase_jwks_cache
    except Exception as e:
        logger.warning(f"Failed to fetch Firebase JWKS: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Authentication service temporarily unavailable"
        )


def _verify_google_token(token: str) -> dict:
    """
    Verify Firebase/Google Identity Platform ID token using JWKS.

    Performs RS256 signature verification and standard OIDC claim validation
    using Firebase Auth JWKS endpoint.

    Args:
        token: JWT token string

    Returns:
        Dict containing decoded JWT claims

    Raises:
        HTTPException: If token verification fails
    """
    try:
        # Get Firebase public keys for RS256 verification
        jwks = _get_firebase_jwks()

        # Decode without verification first to check header
        header = jwt.get_unverified_header(token)
        kid = header.get("kid")

        if not kid:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: missing key ID"
            )

        # Find the correct key
        public_key = None
        for key in jwks.get("keys", []):
            if key.get("kid") == kid:
                public_key = jwt.algorithms.RSAAlgorithm.from_jwk(key)
                break

        if not public_key:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: unknown key ID"
            )

        # First decode to check issuer (Firebase uses project-specific issuers)
        decoded = jwt.decode(
            token,
            public_key,
            algorithms=["RS256"],
            options={
                "verify_exp": True,
                "verify_iat": True,
                "verify_nbf": True,
                "verify_signature": True,
                "verify_aud": False,  # We'll check audience manually after issuer check
                "verify_iss": False,  # We'll check issuer manually
            }
        )

        # Manually verify issuer for Firebase/Google Identity Platform tokens
        issuer = decoded.get("iss")
        if not issuer:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: missing issuer"
            )

        # Accept Firebase Auth tokens (https://securetoken.google.com/<project_id>)
        # or Google Identity Platform tokens (https://accounts.google.com)
        if not (issuer.startswith("https://securetoken.google.com/") or
                issuer == "https://accounts.google.com"):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token issuer"
            )

        # Verify audience based on issuer type
        audience = decoded.get("aud")
        if not audience:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: missing audience"
            )

        # Determine expected audience based on issuer
        expected_audience = None
        if issuer.startswith("https://securetoken.google.com/"):
            # Firebase ID token - audience should be Firebase project ID
            expected_audience = os.getenv("FIREBASE_PROJECT_ID")
        else:
            # Google OAuth token - audience should be Google OAuth client ID
            expected_audience = os.getenv("GOOGLE_CLIENT_ID")

        # Verify audience if we have an expected value
        if expected_audience and audience != expected_audience:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token audience"
            )

        return decoded

    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired"
        )
    except jwt.InvalidIssuerError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token issuer"
        )
    except jwt.InvalidAudienceError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token audience"
        )
    except Exception as e:
        logger.warning(f"Google token verification failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


def verify_auth_token(token: str) -> dict:
    """
    Central authentication gateway for Firebase ID token verification.

    Supports Firebase authentication only.

    Environment variable: AUTH_MODE
    Default: google (Firebase only)

    Args:
        token: Firebase ID token from Authorization header (without 'Bearer ' prefix)

    Returns:
        Dict containing decoded JWT claims plus 'auth_provider' key set to 'firebase'.

    Raises:
        HTTPException: If token is invalid or not a Firebase token
    """
    auth_mode = os.getenv("AUTH_MODE", "google")

    # Log authentication attempt (minimal, safe logging)
    logger.info(f"Auth attempt", extra={
        "auth_mode": auth_mode,
        "token_prefix": token[:10] if len(token) > 10 else token
    })

    try:
        if auth_mode == "google":
            result = _verify_google_token(token)
            result["auth_provider"] = "firebase"
            logger.info("Auth success", extra={"auth_provider": "firebase"})
            return result

        else:
            logger.warning(f"Unsupported auth mode: {auth_mode}. Only 'google' (Firebase) is supported.")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Supabase authentication is no longer supported. Please use Firebase authentication."
            )

    except HTTPException:
        logger.warning("Auth failure", extra={"auth_mode": auth_mode})
        raise


def get_current_user_with_db_lookup(token: str) -> str:
    """
    Get current user with full database lookup for Firebase authentication.

    This provides the same functionality as the original services/auth.py
    get_current_user function, but for Firebase authentication only.

    Args:
        token: Firebase ID token from Authorization header (without 'Bearer ' prefix)

    Returns:
        Internal user ID string

    Raises:
        HTTPException: If token is invalid or user lookup fails
    """
    # First verify the token (will only accept Firebase tokens now)
    decoded_token = verify_auth_token(token)

    # Map auth provider subject -> external_auth_id
    external_auth_id = decoded_token.get("sub")
    user_email = decoded_token.get("email")

    if not external_auth_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Firebase token: missing subject claim"
        )

    # Perform database lookup for Firebase user
    from infra.db.cloud_sql_engine import get_cloud_sql_engine
    from sqlalchemy import text

    engine = get_cloud_sql_engine()
    try:
        return _get_or_create_external_user(engine, external_auth_id, user_email)

    except Exception as e:
        logger.error(f"Database lookup failed for Firebase user {external_auth_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication error: {str(e)}"
        )


def _get_or_create_external_user(engine, external_auth_id: str, email: str) -> str:
    """
    Get or create user using external_auth_id as the canonical identifier.

    Args:
        engine: SQLAlchemy engine instance
        external_auth_id: Provider auth subject string
        email: User email from token

    Returns:
        Internal user ID string

    Raises:
        HTTPException: For creation failures
    """
    # 1. Try direct external_auth_id lookup
    try:
        with engine.connect() as conn:
            result = conn.execute(
                text("SELECT id, email FROM users WHERE external_auth_id = :external_auth_id LIMIT 1"),
                {"external_auth_id": external_auth_id}
            )
            row = result.fetchone()
            if row:
                logger.info(
                    "Auth user resolved",
                    extra={
                        "auth_provider": "firebase",
                        "user_resolved": True,
                        "linked_existing": False,
                        "external_auth_id": external_auth_id,
                    },
                )
                return str(row[0])
    except Exception:
        pass

    # 2. Create new user
    if not email:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Firebase token: missing email claim"
        )

    try:
        with engine.connect() as conn:
            result = conn.execute(
                text("""
                    INSERT INTO users (external_auth_id, email, role)
                    VALUES (:external_auth_id, :email, :role)
                    RETURNING id
                """),
                {
                    "external_auth_id": external_auth_id,
                    "email": email,
                    "role": "user",
                }
            )
            new_user_row = result.fetchone()
            if new_user_row:
                new_user_id = str(new_user_row[0])
                conn.commit()
                logger.info(
                    "New auth user created",
                    extra={
                        "auth_provider": "firebase",
                        "user_resolved": True,
                        "linked_existing": False,
                        "external_auth_id": external_auth_id,
                        "email": email,
                    },
                )
                return new_user_id
            else:
                raise HTTPException(
                    status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail="Failed to create Firebase user record"
                )
    except Exception as e:
        logger.error(f"Failed to create Firebase user {external_auth_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create user record"
        )


# FastAPI Dependency Functions
# These provide the same interface as the original functions but route through the gateway

def get_current_user(request: Request) -> str:
    """
    FastAPI dependency that returns authenticated user ID.

    This replaces services.auth.get_current_user and maintains the same interface.
    """
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing or invalid token"
        )

    token = auth_header.split(" ")[1]
    return get_current_user_with_db_lookup(token)


def get_current_user_jwt(request: Request) -> dict:
    """
    FastAPI dependency that returns decoded JWT claims.

    This replaces utils.auth.get_current_user and maintains the same interface.
    """
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing or invalid token"
        )

    token = auth_header.split(" ")[1]
    return verify_auth_token(token)
