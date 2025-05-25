from typing import List, Optional

from crud.memotag import add_memotags_by_tags, update_memo_tags
from crud.query.build_memo_by_id_query import build_memo_by_id_query
from crud.query.filter_memos_by_tags import filter_memos_by_tags
from crud.tag import fetch_tags_by_names, upsert_tags
from llm.clean_transcript import clean_transcript
from llm.generate_title import generate_title
from llm.summarize_text import summarize_text
from models.memo import Memos
from schemas.memo import MemoSortOrder
from sqlalchemy import asc, desc, select
from sqlalchemy.orm import Session, joinedload
from utils.exceptions import raise_if_none

sort_mapping = {
    MemoSortOrder.CREATED_AT_ASC: asc(Memos.created_at),
    MemoSortOrder.CREATED_AT_DESC: desc(Memos.created_at),
    MemoSortOrder.UPDATED_AT_ASC: asc(Memos.updated_at),
    MemoSortOrder.UPDATED_AT_DESC: desc(Memos.updated_at),
}


def create_memo(
    db: Session, user_id: str, raw: str, tag_names: List[str], need_proofreading: bool
):
    if need_proofreading:
        raw = clean_transcript(raw)

    body = summarize_text(raw)
    title = generate_title(body)

    upsert_tags(db, tag_names)
    tags = fetch_tags_by_names(db, tag_names)
    tag_ids = {tag.id for tag in tags}

    new_memo = Memos(title=title, user_id=user_id, body=body, raw=raw)

    db.add(new_memo)

    if tag_names:
        db.commit()
        add_memotags_by_tags(db, new_memo.id, tag_ids)

    db.commit()
    db.refresh(new_memo)

    return new_memo, tags


def fetch_memos(
    db: Session,
    user_id: str,
    search_word: Optional[str] = None,
    tags: Optional[List[str]] = None,
    sort: Optional[MemoSortOrder] = None,
):
    query = select(Memos)
    query = query.filter(Memos.user_id == user_id)

    if search_word:
        query = query.filter(Memos.title.ilike(f"%{search_word}%"))

    if tags:
        query = filter_memos_by_tags(query, tags)

    query = query.distinct()

    if sort in sort_mapping:
        query = query.order_by(sort_mapping[sort])

    result = db.execute(query)
    return result.scalars().all()


def fetch_memo_by_ids(db: Session, user_id: str, memo_id: int):
    query = build_memo_by_id_query(user_id, memo_id)

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

    if title:
        memo.title = title

    if body:
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
