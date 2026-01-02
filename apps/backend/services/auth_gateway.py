"""
Centralized authentication gateway for MediMinder.

This module provides a single entry point for all authentication operations,
routing requests based on the AUTH_MODE environment variable.
"""

import os
import time
import logging
from typing import Dict, Any, Optional
from fastapi import HTTPException, status, Request, Depends

import jwt
import requests

from .auth import get_current_user as _supabase_get_current_user_with_db
from utils.auth import get_current_user as _supabase_get_current_user_jwt

logger = logging.getLogger(__name__)

# Firebase JWKS cache
_firebase_jwks_cache = None
_firebase_jwks_cache_time = 0
JWKS_CACHE_DURATION = 3600  # 1 hour


def _get_firebase_jwks() -> Dict[str, Any]:
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


def _verify_google_token(token: str) -> Dict[str, Any]:
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

        # Get expected audience (configurable, but not enforced if unknown)
        expected_audience = os.getenv("GOOGLE_CLIENT_ID")

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
                "verify_aud": expected_audience is not None,
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

        # Verify audience if configured
        if expected_audience:
            audience = decoded.get("aud")
            if audience != expected_audience:
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


def verify_auth_token(token: str) -> Dict[str, Any]:
    """
    Central authentication gateway that verifies tokens based on AUTH_MODE.

    Supports multiple authentication modes:
    - supabase: Supabase JWT only
    - hybrid: Try Google ID token first, fallback to Supabase JWT
    - google: Google ID token only

    Args:
        token: JWT token from Authorization header (without 'Bearer ' prefix)

    Returns:
        Dict containing decoded JWT claims

    Raises:
        HTTPException: If token is invalid or AUTH_MODE is unsupported
    """
    auth_mode = os.getenv("AUTH_MODE", "supabase")

    # Log authentication attempt (minimal, safe logging)
    logger.info(f"Auth attempt", extra={
        "auth_mode": auth_mode,
        "token_prefix": token[:10] if len(token) > 10 else token
    })

    try:
        if auth_mode == "supabase":
            # Use existing Supabase JWT verification logic only
            result = _verify_supabase_token(token)
            logger.info("Auth success", extra={"issuer": "supabase"})
            return result

        elif auth_mode == "hybrid":
            # Try Google first, fallback to Supabase
            try:
                result = _verify_google_token(token)
                logger.info("Auth success", extra={"issuer": "google"})
                return result
            except HTTPException:
                # Fallback to Supabase
                result = _verify_supabase_token(token)
                logger.info("Auth success", extra={"issuer": "supabase", "fallback": True})
                return result

        elif auth_mode == "google":
            # Google ID token only
            result = _verify_google_token(token)
            logger.info("Auth success", extra={"issuer": "google"})
            return result

        else:
            logger.warning(f"Unsupported auth mode: {auth_mode}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Authentication mode not supported"
            )

    except HTTPException:
        logger.warning("Auth failure", extra={"auth_mode": auth_mode})
        raise


def _verify_supabase_token(token: str) -> Dict[str, Any]:
    """
    Verify Supabase JWT token using existing logic.

    This wraps the existing utils/auth.py verification logic
    to return decoded JWT claims.
    """
    try:
        # Import here to avoid circular imports
        import jwt
        from fastapi.security import HTTPAuthorizationCredentials

        # Create fake credentials object to reuse existing logic
        credentials = HTTPAuthorizationCredentials(scheme="Bearer", credentials=token)

        # Call existing Supabase verification logic
        return _supabase_get_current_user_jwt(credentials)
    except Exception as e:
        # Re-raise as HTTPException to maintain API contract
        if isinstance(e, HTTPException):
            raise
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token"
        )


def get_current_user_with_db_lookup(token: str) -> str:
    """
    Get current user with full database lookup.

    This provides the same functionality as the original services/auth.py
    get_current_user function, but routed through the auth gateway.

    Args:
        token: JWT token from Authorization header (without 'Bearer ' prefix)

    Returns:
        Internal user ID string
    """
    # First verify the token
    decoded_token = verify_auth_token(token)

    # Extract auth_uid from JWT sub claim
    auth_uid = decoded_token.get("sub")
    if not auth_uid:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token: missing subject claim"
        )

    # Perform database lookup using existing Supabase logic
    # This is extracted from the original services/auth.py logic
    from .supabase_client import supabase

    try:
        user_data = supabase.table("users").select("id,email,role").eq("auth_uid", auth_uid).single().execute()

        if user_data.data:
            return user_data.data["id"]

        # User not found, create new record (same logic as original)
        user_email = decoded_token.get("email")
        if not user_email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token: missing email claim"
            )

        new_user = {
            "auth_uid": auth_uid,
            "email": user_email,
            "role": "user"  # Default role - matches database constraint
        }
        create_result = supabase.table("users").insert(new_user).execute()

        if create_result.data:
            return create_result.data[0]["id"]
        else:
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to create user record"
            )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Authentication error: {str(e)}"
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


def get_current_user_jwt(request: Request) -> Dict[str, Any]:
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
