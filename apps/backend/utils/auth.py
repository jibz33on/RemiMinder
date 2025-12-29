import logging
import os
from typing import Dict, Any

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer

logger = logging.getLogger(__name__)
security = HTTPBearer()

def get_current_user(credentials=Depends(security)) -> Dict[str, Any]:
    """Verify Supabase JWT token and return decoded user data."""
    token = credentials.credentials

    # Get JWT secret at runtime (not import time) for reload compatibility
    jwt_secret = os.getenv("SUPABASE_JWT_SECRET")
    if not jwt_secret:
        logger.error("SUPABASE_JWT_SECRET not set")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Server configuration error"
        )

    try:
        decoded_token = jwt.decode(
            token,
            jwt_secret,
            algorithms=["HS256"],
            audience="authenticated"
        )
        return decoded_token
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired"
        )
    except jwt.InvalidAudienceError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token audience"
        )
    except Exception as e:
        logger.warning(f"JWT validation failed: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token"
        )