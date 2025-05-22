from typing import List

from crud.tag import fetch_tag_ids_by_names, upsert_tags
from models.memotag import MemoTags
from sqlalchemy import delete, select
from sqlalchemy.orm import Session


def fetch_tag_ids_by_memo_id(db: Session, memo_id: int):
    query = select(MemoTags.tag_id)
    query = query.where(MemoTags.memo_id == memo_id)
    result = db.execute(query)
    tag_ids = result.scalars()
    return set(tag_ids.all())


def delete_memotags_by_tags(db: Session, memo_id: int, tags_to_delete: set):
    query = delete(MemoTags)
    query = query.where(MemoTags.memo_id == memo_id)
    query = query.where(MemoTags.tag_id.in_(tags_to_delete))

    db.execute(query)
    db.flush()


def add_memotags_by_tags(db: Session, memo_id: int, tags_to_add: set):
    insert_tags_list = [
        {"memo_id": memo_id, "tag_id": tag_id} for tag_id in tags_to_add
    ]
    db.bulk_insert_mappings(MemoTags, insert_tags_list)
    db.flush()


def update_memo_tags(db: Session, memo_id: int, tag_names: List[str]):
    upsert_tags(db, tag_names)
    new_tag_ids = fetch_tag_ids_by_names(db, tag_names)
    current_tag_ids = fetch_tag_ids_by_memo_id(db, memo_id)

    tags_to_delete = set(current_tag_ids) - set(new_tag_ids)
    tags_to_add = set(new_tag_ids) - set(current_tag_ids)

    if tags_to_delete:
        delete_memotags_by_tags(db, memo_id, tags_to_delete)

    if tags_to_add:
        add_memotags_by_tags(db, memo_id, tags_to_add)
