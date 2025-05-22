from datetime import timedelta
from typing import Annotated

from crud.auth import create_access_token
from database import get_db
from fastapi import APIRouter, Depends, status
from schemas.auth import LoginRequest, Token
from sqlalchemy.orm import Session

DbDependency = Annotated[Session, Depends(get_db)]

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("", response_model=Token, status_code=status.HTTP_200_OK)
async def login(request: LoginRequest):
    token, expires_at = create_access_token(
        user_id=request.user_id, expires_delta=timedelta(days=1)
    )
    return Token(access_token=token, token_type="bearer", expires_at=expires_at)
