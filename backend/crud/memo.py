from typing import List, Optional

from crud.memotag import update_memo_tags
from crud.query.filter_memos_by_tags import filter_memos_by_tags
from models.memo import Memos
from sqlalchemy import select
from sqlalchemy.orm import Session, joinedload
from utils.exceptions import raise_if_none


def fetch_memos(
    db: Session,
    user_id: str,
    search_word: Optional[str] = None,
    tags: Optional[List[str]] = None,
):
    query = select(Memos)
    query = query.filter(Memos.user_id == user_id)

    if search_word:
        query = query.filter(Memos.title.ilike(f"%{search_word}%"))

    if tags:
        query = filter_memos_by_tags(query, tags)

    query = query.distinct()

    result = db.execute(query)
    return result.scalars().all()


def fetch_memo_by_ids(db: Session, user_id: str, memo_id: int):
    query = select(Memos)
    query = query.options(joinedload(Memos.tags))
    query = query.where(Memos.id == memo_id)
    query = query.where(Memos.user_id == user_id)

    result = db.execute(query)
    memo = result.unique().scalars().one_or_none()

    return memo


def update_memo_by_id(
    db: Session,
    user_id: str,
    memo_id: int,
    title: Optional[str] = None,
    body: Optional[str] = None,
    tag_names: Optional[List[str]] = None,
):
    memo = fetch_memo_by_ids(db, user_id, memo_id)

    raise_if_none(memo, "Memo")

    if title is not None:
        memo.title = title

    if body is not None:
        memo.body = body

    if tag_names is not None:
        update_memo_tags(db, memo_id, tag_names)

    db.commit()
    return memo


def delete_memo_by_id(db: Session, user_id: str, memo_id: int):
    memo = fetch_memo_by_ids(db, user_id, memo_id)

    raise_if_none(memo, "Memo")

    db.delete(memo)

    db.commit()
    return memo
