from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.memo import fetch_memos
from database import get_db
from fastapi import APIRouter, Depends, Header, Query, status
from schemas.auth import DecodedToken
from schemas.memo import MemoPreviewResponse
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_current_user)]

router = APIRouter(prefix="/memos", tags=["Memos"])


@router.get(
    "/", response_model=List[MemoPreviewResponse], status_code=status.HTTP_200_OK
)
async def read_root(
    db: DbDependency,
    user: UserDependency,
    keyword: Optional[str] = Query(None, description="検索キーワード"),
    tags: Optional[List[str]] = Query(None, description="タグでの絞り込み"),
    sort: Optional[str] = Query(None, description="ソート順(別issue)"),
):
    memos = fetch_memos(db=db, user_id=user.user_id, search_word=keyword, tags=tags)
    return [MemoPreviewResponse.model_validate(m) for m in memos]
