from models.memo import Memos
from models.memotag import MemoTags
from sqlalchemy import select
from sqlalchemy.orm import joinedload


def build_memo_by_id_query(user_id: str, memo_id: int):
    query = select(Memos)
    query = query.options(joinedload(Memos.tags).joinedload(MemoTags.tag))
    query = query.where(Memos.user_id == user_id)
    query = query.where(Memos.id == memo_id)
    return query
