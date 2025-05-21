from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.memo import fetch_memos, update_memo_by_id
from database import get_db
from fastapi import APIRouter, Depends, Header, HTTPException, Query, status
from schemas.auth import DecodedToken
from schemas.memo import (
    MemoBodyUpdateRequest,
    MemoPreviewResponse,
    MemoTagsUpdateRequest,
    MemoTitleUpdateRequest,
)
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
    tag: Optional[str] = Query(None, description="タグでの絞り込み(別issue)"),
    sort: Optional[str] = Query(None, description="ソート順(別issue)"),
):
    memos = fetch_memos(db=db, user_id=user.user_id, search_word=keyword)
    return [MemoPreviewResponse.model_validate(m) for m in memos]


@router.put("/{memo_id}/title", status_code=status.HTTP_200_OK)
async def read_root(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTitleUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, title=request.title
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return


@router.put("/{memo_id}/body", status_code=status.HTTP_200_OK)
async def read_root(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoBodyUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, body=request.body
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return


@router.put("/{memo_id}/tags", status_code=status.HTTP_200_OK)
async def read_root(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTagsUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, tag_names=request.tag_names
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return
