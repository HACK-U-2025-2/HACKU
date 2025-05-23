from datetime import datetime, timedelta
from typing import Annotated

from config import get_settings
from fastapi import Depends, HTTPException, WebSocket
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from fastapi.security.utils import get_authorization_scheme_param
from jose import JWTError, jwt
from schemas.auth import DecodedToken
from starlette.status import HTTP_401_UNAUTHORIZED

SECRET_KEY = get_settings().secret_key
SECRET_ALGORITHM = get_settings().secret_algorithm

security = HTTPBearer(auto_error=False)


def create_access_token(user_id: str, expires_delta: timedelta):
    expired = datetime.now() + expires_delta
    payload = {"id": user_id, "exp": expired}
    token = jwt.encode(payload, SECRET_KEY, algorithm=SECRET_ALGORITHM)
    return token, expired


def get_current_user(token: Annotated[HTTPAuthorizationCredentials, Depends(security)]):
    if token is None:
        raise HTTPException(
            status_code=HTTP_401_UNAUTHORIZED, detail="Invalid Authorization"
        )
    return decode_token(token.credentials)


def get_current_user_websocket(websocket: WebSocket):
    auth_header = websocket.headers.get("Authorization")
    if not auth_header:
        raise HTTPException(
            status_code=HTTP_401_UNAUTHORIZED,
            detail="Invalid Authorization",
        )

    scheme, credentials = get_authorization_scheme_param(auth_header)
    if scheme.lower() != "bearer" or not credentials:
        raise HTTPException(
            status_code=HTTP_401_UNAUTHORIZED,
            detail="Invalid Authorization",
        )

    return decode_token(credentials)


def decode_token(credentials: str):
    try:
        payload = jwt.decode(credentials, SECRET_KEY, algorithms=[SECRET_ALGORITHM])
        user_id = payload.get("id")
        if not user_id:
            raise HTTPException(
                status_code=HTTP_401_UNAUTHORIZED,
                detail="Invalid Authorization",
            )
        return DecodedToken(user_id=user_id)
    except JWTError:
        raise HTTPException(
            status_code=HTTP_401_UNAUTHORIZED, detail="Invalid Authorization"
        )
