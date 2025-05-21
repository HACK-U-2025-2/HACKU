from typing import List, Optional

from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import func
from sqlalchemy.orm import Session


def fetch_memos(
    db: Session,
    user_id: str,
    search_word: Optional[str] = None,
    tags: Optional[List[str]] = None,
):
    query = db.query(Memos)
    query = query.filter(Memos.user_id == user_id)

    if search_word:
        query = query.filter(Memos.title.ilike(f"%{search_word}%"))
    if tags:
        query = query.join(MemoTags, Memos.id == MemoTags.memo_id)
        query = query.join(Tags, Tags.id == MemoTags.tag_id)
        query = query.filter(Tags.name.in_(tags))
        query = query.group_by(Memos.id)
        query = query.having(func.count(func.distinct(Tags.name)) == len(tags))
    else:
        query = query.distinct()

    return query.all()
