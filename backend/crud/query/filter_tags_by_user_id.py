from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import Select


def filter_tags_by_user_id_query(query: Select, user_id: str):
    query = query.distinct()
    query = query.join(MemoTags, Tags.id == MemoTags.tag_id)
    query = query.join(Memos, Memos.id == MemoTags.memo_id)
    query = query.where(Memos.user_id == user_id)

    return query
