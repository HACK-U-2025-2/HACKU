from models.memo import Memos
from models.memoTag import MemoTags
from models.tag import Tags
from sqlalchemy.orm import Session


def fetch_tags(db: Session, user_id: str):
    query = db.query(Tags)
    query = query.select_from(Memos)
    query = query.join(MemoTags, Tags.id == MemoTags.tag_id)
    query = query.join(Memos, Memos.id == MemoTags.memo_id)
    query = query.filter(Memos.user_id == user_id)
    query = query.distinct()
    return query.all()
