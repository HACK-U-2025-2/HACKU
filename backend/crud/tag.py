from typing import List, Optional

from crud.query.filter_tags_by_user_id import filter_tags_by_user_id_query
from models.tag import Tags
from sqlalchemy import select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session


def fetch_tags(db: Session, user_id: str, search_word: Optional[str] = None):
    query = select(Tags)
    query = filter_tags_by_user_id_query(query, user_id)

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
