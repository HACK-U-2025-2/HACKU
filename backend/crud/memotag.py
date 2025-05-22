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


def add_memotags_by_tags(db: Session, memo_id: int, tags_to_add: set):
    new_tags_list = [{"memo_id": memo_id, "tag_id": tag_id} for tag_id in tags_to_add]
    db.bulk_insert_mappings(MemoTags, new_tags_list)
    db.commit()
