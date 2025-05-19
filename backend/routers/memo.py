from typing import List

from crud.memo import fetch_memos
from database import get_db
from fastapi import APIRouter, Depends
from schemas.memo import MemoResponse
from sqlalchemy.orm import Session
from starlette import status

router = APIRouter(tags=["Memos"])


@router.get("/", response_model=List[MemoResponse], status_code=status.HTTP_200_OK)
async def read_root(
    db: Session = Depends(get_db),
):
    user_id = "a"  # ログインに成功していると仮定
    return fetch_memos(db=db, user_id=user_id)
