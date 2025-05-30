from typing import Annotated, List

from crud.demo import *
from database import get_db
from fastapi import APIRouter, Depends, Query, status
from scheduler.delete_unnecessary_memos import delete_unnecessary_memos
from schemas.demo import *
from sqlalchemy.orm import Session

DbDependency = Annotated[Session, Depends(get_db)]


router = APIRouter(prefix="/demos", tags=["Demos"])


@router.get("/get_user_name", response_model=List[str], status_code=status.HTTP_200_OK)
async def demo_get_user_name(
    db: DbDependency,
):
    return demo_get_user(db=db)


@router.get("/get_memos", response_model=List[MemoRead], status_code=status.HTTP_200_OK)
async def demo_get_user_name(
    db: DbDependency,
):
    return demo_get_memo(db=db)


@router.get("/get_tags", response_model=List[TagRead], status_code=status.HTTP_200_OK)
async def demo_get_user_name(
    db: DbDependency,
):
    return demo_get_tag(db=db)


@router.get("/auto_delete", response_model=List[str], status_code=status.HTTP_200_OK)
async def demo_get_delete_memos_target(
    db: DbDependency,
):
    return delete_unnecessary_memos(db=db, is_demo=True)


@router.get("/reset_data", status_code=status.HTTP_200_OK)
async def demo_get_delete_memos_target(db: DbDependency, lock: str):
    if lock == "opensesami":
        return reset_data(db=db)


@router.get("/save_data", status_code=status.HTTP_200_OK)
async def demo_get_delete_memos_target(db: DbDependency, lock: str):
    if lock == "opensesami":
        return save_data(db=db)
