from typing import List, Optional

from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session


def fetch_tags(db: Session, user_id: str, search_word: Optional[str] = None):
    query = db.query(Tags)

    if search_word:
        query = query.filter(Tags.name.ilike(f"%{search_word}%"))

    query = query.join(MemoTags, Tags.id == MemoTags.tag_id)
    query = query.join(Memos, Memos.id == MemoTags.memo_id)
    query = query.filter(Memos.user_id == user_id)
    query = query.distinct()

    return query.all()


def upsert_tags(db: Session, tag_names: List[str]):
    query = insert(Tags)
    query = query.values([{"name": name} for name in tag_names])
    query = query.on_conflict_do_nothing(index_elements=["name"])
    db.execute(query)
    db.flush()


def fetch_tag_ids_by_names(db: Session, tag_names: List[str]):
    query = db.query(Tags.id)
    query = query.filter(Tags.name.in_(tag_names))
    query = query.scalars()
    return set(query.all())
