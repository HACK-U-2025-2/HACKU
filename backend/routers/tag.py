from typing import Annotated, List

from crud.auth import get_cuurent_user
from crud.tag import fetch_tags
from database import get_db
from fastapi import APIRouter, Depends
from schemas.auth import DecodedToken
from schemas.tag import TagResponse
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_cuurent_user)]

router = APIRouter(prefix="/tags", tags=["Tags"])


@router.get("", response_model=List[TagResponse], status_code=status.HTTP_200_OK)
async def get_tags(
    db: DbDependency,
    user: UserDependency,
):
    return fetch_tags(db=db, user_id=user.user_id)
