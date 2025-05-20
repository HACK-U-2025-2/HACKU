from typing import Annotated, List

from crud.auth import get_cuurent_user
from crud.memo import fetch_memos
from database import get_db
from fastapi import APIRouter, Depends
from schemas.auth import DecodedToken
from schemas.memo import MemoResponse
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_cuurent_user)]

router = APIRouter(tags=["Memos"])


@router.get("/", response_model=List[MemoResponse], status_code=status.HTTP_200_OK)
async def read_root(
    db: DbDependency,
    user: UserDependency,
):
    return fetch_memos(db=db, user_id=user.user_id)
