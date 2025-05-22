from typing import List, Optional

from crud.memotag import (
    add_memotags_by_tags,
    delete_memotags_by_tags,
    fetch_tag_ids_by_memo_id,
)
from crud.tag import fetch_tag_ids_by_names, upsert_tags
from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import func, select
from sqlalchemy.orm import Session, joinedload


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
        query = query.join(MemoTags, Memos.id == MemoTags.memo_id)
        query = query.join(Tags, Tags.id == MemoTags.tag_id)
        query = query.filter(Tags.name.in_(tags))
        query = query.group_by(Memos.id)
        query = query.having(func.count(func.distinct(Tags.name)) == len(tags))
    else:
        query = query.distinct()

    result = db.execute(query)
    return result.scalars().all()


def fetch_memo_by_id(db: Session, user_id: str, memo_id: int):
    query = db.query(Memos)
    query = query.filter(Memos.user_id == user_id)
    query = query.filter(Memos.id == memo_id)
    query = query.options(joinedload(Memos.tags).joinedload(MemoTags.tag))
    return query.one_or_none()


def update_memo_by_id(
    db: Session,
    user_id: str,
    memo_id: int,
    title: Optional[str] = None,
    body: Optional[str] = None,
    tag_names: Optional[List[str]] = None,
):
    query = select(Memos)
    query = query.where(Memos.user_id == user_id)
    query = query.where(Memos.id == memo_id)

    result = db.execute(query)
    memo = result.scalars().one_or_none()

    if memo is None:
        return None

    if title is not None:
        memo.title = title

    if body is not None:
        memo.body = body

    if tag_names is not None:
        upsert_tags(db, tag_names)
        new_tag_ids = fetch_tag_ids_by_names(db, tag_names)
        current_tag_ids = fetch_tag_ids_by_memo_id(db, memo_id)

        tags_to_delete = current_tag_ids - new_tag_ids
        tags_to_add = new_tag_ids - current_tag_ids

        if tags_to_delete:
            delete_memotags_by_tags(db, memo_id, tags_to_delete)

        if tags_to_add:
            add_memotags_by_tags(db, memo_id, tags_to_add)

    db.commit()
    return memo
