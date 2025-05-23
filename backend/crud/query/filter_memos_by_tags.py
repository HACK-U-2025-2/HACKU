from typing import List

from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import Select, func


def filter_memos_by_tags(query: Select, tags: List[str]):
    query = query.join(MemoTags, Memos.id == MemoTags.memo_id)
    query = query.join(Tags, Tags.id == MemoTags.tag_id)
    query = query.filter(Tags.name.in_(tags))
    query = query.group_by(Memos.id)
    query = query.having(func.count(func.distinct(Tags.name)) == len(tags))
    return query
