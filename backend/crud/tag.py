from typing import List, Optional

from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import distinct, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session


def fetch_tags(db: Session, user_id: str, search_word: Optional[str] = None):
    query = select(Tags)
    query = query.distinct()
    query = query.join(MemoTags, Tags.id == MemoTags.tag_id)
    query = query.join(Memos, Memos.id == MemoTags.memo_id)
    query = query.where(Memos.user_id == user_id)

    if search_word:
        query = query.where(Tags.name.ilike(f"%{search_word}%"))

    result = db.execute(query)

    return result.scalars().all()


def upsert_tags(db: Session, tag_names: List[str]):
    query = insert(Tags)
    query = query.values([{"name": name} for name in tag_names])
    query = query.on_conflict_do_nothing(index_elements=["name"])

    db.execute(query)
    db.flush()


def fetch_tag_ids_by_names(db: Session, tag_names: List[str]):
    query = select(Tags.id)
    query = query.where(Tags.name.in_(tag_names))

    result = db.execute(query)

    return set(result.scalars().all())
