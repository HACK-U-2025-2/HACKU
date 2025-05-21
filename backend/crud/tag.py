from typing import Optional

from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
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
