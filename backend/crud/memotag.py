from models.memotag import MemoTags
from sqlalchemy.orm import Session


def fetch_tag_ids_by_memo_id(db: Session, memo_id: int):
    query = db.query(MemoTags.tag_id)
    query = query.filter(MemoTags.memo_id == memo_id)
    query = query.scalars()
    return set(query.all())


def delete_memotags_by_tags(db: Session, memo_id: int, tags_to_delete: set):
    query = db.query(MemoTags)
    query = query.filter(MemoTags.memo_id == memo_id)
    query = query.filter(MemoTags.tag_id.in_(tags_to_delete))
    query.delete(synchronize_session=False)


def add_memotags_by_tags(db: Session, memo_id: int, tags_to_add: set):
    new_tags_list = [{"memo_id": memo_id, "tag_id": tag_id} for tag_id in tags_to_add]
    db.bulk_insert_mappings(MemoTags, new_tags_list)
