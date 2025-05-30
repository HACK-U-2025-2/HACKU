from typing import Annotated, List

from database import get_db
from fastapi import APIRouter, Depends, Query, status
from scheduler.delete_unnecessary_memos import delete_unnecessary_memos
from sqlalchemy.orm import Session

DbDependency = Annotated[Session, Depends(get_db)]


router = APIRouter(prefix="/demos", tags=["Demos"])


@router.get("", response_model=List[str], status_code=status.HTTP_200_OK)
async def demo_get_delete_memos_target(
    db: DbDependency,
):
    return delete_unnecessary_memos(db=db, is_demo=True)
