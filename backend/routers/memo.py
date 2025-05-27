from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.memo import (
    create_memo,
    delete_memo_by_id,
    fetch_memo_by_ids,
    fetch_memos,
    update_memo_by_id,
)
from database import get_db
from fastapi import APIRouter, Depends, Query, Response, status
from schemas.auth import DecodedToken
from schemas.memo import (
    MemoAllUpdateRequest,
    MemoBodyUpdateRequest,
    MemoCreateRequest,
    MemoPreviewResponse,
    MemoResponse,
    MemoSortOrder,
    MemoTagsUpdateRequest,
    MemoTitleUpdateRequest,
)
from schemas.tag import TagResponse
from sqlalchemy.orm import Session
from utils.exceptions import raise_if_none

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_current_user)]

router = APIRouter(prefix="/memos", tags=["Memos"])


@router.get(
    "/", response_model=List[MemoPreviewResponse], status_code=status.HTTP_200_OK
)
async def handle_read_memos(
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
async def hangle_read_memo_by_id(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = fetch_memo_by_ids(db=db, user_id=user.user_id, memo_id=memo_id)

    raise_if_none(memo, "Memo")

    tag_response = [TagResponse.model_validate(memo_tag.tag) for memo_tag in memo.tags]
    return MemoResponse.model_validate({**memo.__dict__, "tags": tag_response})

@router.get("/embeddings", response_model=List[MemoEmbeddingResponse], status_code=status.HTTP_200_OK)
async def hangle_read_memo_embeddings(
    db: DbDependency,
    user: UserDependency,
):
    
    return MemoResponse.

@router.post("/", response_model=MemoResponse, status_code=status.HTTP_201_CREATED)
async def handle_create_memo(
    db: DbDependency,
    user: UserDependency,
    request: MemoCreateRequest,
):
    memo, tags = create_memo(
        db=db,
        user_id=user.user_id,
        raw=request.raw,
        tag_names=request.tag_names,
        need_proofreading=request.need_proofreading,
    )

    tag_response = [TagResponse.model_validate(tag) for tag in tags]
    return MemoResponse.model_validate({**memo.__dict__, "tags": tag_response})


@router.put("/{memo_id}", status_code=status.HTTP_200_OK)
async def handle_update_tags(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoAllUpdateRequest,
):
    memo = update_memo_by_id(
        db=db,
        user_id=user.user_id,
        memo_id=memo_id,
        title=request.title,
        body=request.body,
        tag_names=request.tag_names,
    )

    raise_if_none(memo, "Memo")

    return Response(status_code=status.HTTP_200_OK)


@router.patch("/{memo_id}/title", status_code=status.HTTP_200_OK)
async def handle_update_title(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTitleUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, title=request.title
    )

    raise_if_none(memo, "Memo")

    return Response(status_code=status.HTTP_200_OK)


@router.patch("/{memo_id}/body", status_code=status.HTTP_200_OK)
async def handle_update_body(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoBodyUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, body=request.body
    )

    raise_if_none(memo, "Memo")

    return Response(status_code=status.HTTP_200_OK)


@router.patch("/{memo_id}/tags", status_code=status.HTTP_200_OK)
async def handle_update_tags(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTagsUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, tag_names=request.tag_names
    )

    raise_if_none(memo, "Memo")

    return Response(status_code=status.HTTP_200_OK)


@router.delete("/{memo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def handle_delete_memo(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = delete_memo_by_id(db=db, user_id=user.user_id, memo_id=memo_id)

    raise_if_none(memo, "Memo")
