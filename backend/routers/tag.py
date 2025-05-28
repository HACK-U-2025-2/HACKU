from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.tag import fetch_tags_with_count
from database import get_db
from fastapi import APIRouter, Depends, Query, status
from schemas.auth import DecodedToken
from schemas.tag import TagCountResponse
from sqlalchemy.orm import Session

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_current_user)]

router = APIRouter(prefix="/tags", tags=["Tags"])


@router.get("", response_model=List[TagCountResponse], status_code=status.HTTP_200_OK)
async def handle_get_tags(
    db: DbDependency,
    user: UserDependency,
    keyword: Optional[str] = Query(None, description="検索キーワード"),
):
    tags = fetch_tags_with_count(db=db, user_id=user.user_id, search_word=keyword)
    return [
        TagCountResponse(**{**tag.__dict__, "used_num": used_num})
        for tag, used_num in tags
    ]
