from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.memo import (
    delete_memo_by_id,
    fetch_memo_by_id,
    fetch_memos,
    update_memo_by_id,
)
from database import get_db
from fastapi import APIRouter, Depends, Header, HTTPException, Query, status
from schemas.auth import DecodedToken
from schemas.memo import (
    MemoBodyUpdateRequest,
    MemoPreviewResponse,
    MemoResponse,
    MemoSortOrder,
    MemoTagsUpdateRequest,
    MemoTitleUpdateRequest,
)
from schemas.tag import TagResponse
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_current_user)]

router = APIRouter(prefix="/memos", tags=["Memos"])


@router.get(
    "/", response_model=List[MemoPreviewResponse], status_code=status.HTTP_200_OK
)
async def read_memos(
    db: DbDependency,
    user: UserDependency,
    keyword: Optional[str] = Query(None, description="検索キーワード"),
    tags: Optional[List[str]] = Query(None, description="タグでの絞り込み"),
    sort: Optional[MemoSortOrder] = Query(None, description="ソート順"),
):
    memos = fetch_memos(
        db=db, user_id=user.user_id, search_word=keyword, tags=tags, sort=sort
    )
    return [MemoPreviewResponse.model_validate(m) for m in memos]


@router.get("/{memo_id}", response_model=MemoResponse, status_code=status.HTTP_200_OK)
async def read_memo(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = fetch_memo_by_id(db=db, user_id=user.user_id, memo_id=memo_id)
    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    tag_response = [TagResponse.model_validate(memo_tag.tag) for memo_tag in memo.tags]
    memo_response = MemoResponse.model_validate({**memo.__dict__, "tags": tag_response})

    return memo_response


@router.put("/{memo_id}/title", status_code=status.HTTP_200_OK)
async def write_title(
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
async def write_body(
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
async def write_tags(
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


@router.delete("/{memo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_memo(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = delete_memo_by_id(db=db, user_id=user.user_id, memo_id=memo_id)

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")
    return
