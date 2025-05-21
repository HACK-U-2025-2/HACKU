from typing import Annotated, List, Optional

<<<<<<< HEAD
<<<<<<< Updated upstream
from crud.auth import get_cuurent_user
=======
from crud.auth import get_current_user
>>>>>>> sprint1
from crud.memo import fetch_memos
from database import get_db
from fastapi import APIRouter, Depends, Header, Query, status
from schemas.auth import DecodedToken
<<<<<<< HEAD
from schemas.memo import MemoResponse
=======
from crud.auth import get_current_user
from crud.memo import fetch_memo_by_id, fetch_memos
from database import get_db
from fastapi import APIRouter, Depends, Header, HTTPException, Query, status
from schemas.auth import DecodedToken
from schemas.memo import MemoPreviewResponse, MemoResponse
from schemas.tag import TagResponse
>>>>>>> Stashed changes
=======
from schemas.memo import MemoPreviewResponse
>>>>>>> sprint1
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
<<<<<<< HEAD
    return [MemoPreviewResponse.model_validate(memo) for memo in memos]


@router.get("/{memo_id}", response_model=MemoResponse, status_code=status.HTTP_200_OK)
async def read_root(
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
=======
    return [MemoPreviewResponse.model_validate(m) for m in memos]
>>>>>>> sprint1
