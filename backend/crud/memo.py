from typing import List, Optional

from models.memo import Memos
from models.memotag import MemoTags
from sqlalchemy.orm import Session, joinedload


def fetch_memos(db: Session, user_id: str, search_word: Optional[str] = None):
    query = db.query(Memos)
    query = query.filter(Memos.user_id == user_id)

    if search_word:
        query = query.filter(Memos.title.ilike(f"%{search_word}%"))

    return query.all()


def fetch_memo_by_id(db: Session, user_id: str, memo_id: int):
    query = db.query(Memos)
    query = query.filter(Memos.user_id == user_id)
    query = query.filter(Memos.id == memo_id)
    query = query.options(joinedload(Memos.tags).joinedload(MemoTags.tag))
    return query.one_or_none()
