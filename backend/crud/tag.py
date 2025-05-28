from typing import List, Optional

from crud.query.filter_tags_by_user_id import filter_tags_by_user_id_query
from embedding.embedding import get_embedding
from models.memotag import MemoTags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings
from sqlalchemy import func, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session


def fetch_tags(db: Session, user_id: str, search_word: Optional[str] = None):
    query = select(Tags)
    query = filter_tags_by_user_id_query(query, user_id)

    if search_word:
        query = query.where(Tags.name.ilike(f"%{search_word}%"))

    result = db.execute(query)

    return result.scalars().all()


def fetch_tags_with_count(db: Session, user_id: str, search_word: Optional[str] = None):
    sub_query = select(MemoTags, func.count(MemoTags.memo_id).label("used_num"))
    sub_query = sub_query.group_by(MemoTags.tag_id)
    sub_query = sub_query.subquery()

    query = select(Tags, func.coalesce(sub_query.c.used_num, 0).label("used_num"))
    query = query.outerjoin(sub_query, Tags.id == sub_query.c.tag_id)
    query = filter_tags_by_user_id_query(query, user_id)

    if search_word:
        query = query.where(Tags.name.ilike(f"%{search_word}%"))

    result = db.execute(query)

    return result.all()


def upsert_tags(db: Session, tag_names: List[str]):
    if not tag_names:
        return

    query = insert(Tags)
    query = query.values([{"name": name} for name in tag_names])
    query = query.on_conflict_do_nothing(index_elements=["name"])

    db.execute(query)

    query = select(Tags)
    query = query.where(Tags.name.in_(tag_names))
    query = query.where(~Tags.id.in_(select(TagEmbeddings.id)))

    result = db.execute(query).scalars().all()

    if not result:
        return

    embeddings_to_insert = [
        {"id": tag.id, "embedding": get_embedding(tag.name)} for tag in result
    ]

    db.execute(insert(TagEmbeddings).values(embeddings_to_insert))


def fetch_tags_by_names(db: Session, tag_names: List[str]):
    query = select(Tags)
    query = query.where(Tags.name.in_(tag_names))

    result = db.execute(query)

    return result.scalars().all()
