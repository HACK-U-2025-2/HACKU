from datetime import timedelta
from typing import Annotated, List

from crud.auth import create_access_token
from database import get_db
from fastapi import APIRouter, Depends
from schemas.auth import Token
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("", response_model=Token, status_code=status.HTTP_200_OK)
async def login(user_id: str):
    token = create_access_token(user_id, timedelta(days=1))
    return {"access_token": token, "token_type": "bearer"}
