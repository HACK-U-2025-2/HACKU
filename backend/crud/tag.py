from typing import List, Optional, Sequence

from crud.query.filter_tags_by_user_id import filter_tags_by_user_id_query
from embedding.embedding import get_embedding
from llm.generate_tags import generate_tags
from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings
from sqlalchemy import delete, desc, func, select
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

cosine_distance = TagEmbeddings.embedding.cosine_distance


def fetch_tags(db: Session, user_id: str, search_word: Optional[str] = None):
    query = select(Tags)
    query = filter_tags_by_user_id_query(query, user_id)

    if search_word:
        query = query.where(Tags.name.ilike(f"%{search_word}%"))

    result = db.execute(query)

    return result.scalars().all()


def fetch_tags_by_memo_id(db: Session, memo_id: int):
    query = select(Tags)
    query = query.join(MemoTags, Tags.id == MemoTags.tag_id)
    query = query.where(MemoTags.memo_id == memo_id)

    result = db.execute(query)

    return result.scalars().all()


def fetch_tags_with_count(db: Session, user_id: str, search_word: Optional[str] = None):
    sub_query = select(MemoTags.tag_id, func.count(MemoTags.memo_id).label("used_num"))
    sub_query = sub_query.join(Memos, Memos.id == MemoTags.memo_id)
    sub_query = sub_query.where(Memos.user_id == user_id)
    sub_query = sub_query.group_by(MemoTags.tag_id)
    sub_query = sub_query.subquery()

    query = select(Tags, func.coalesce(sub_query.c.used_num, 0).label("used_num"))
    query = query.outerjoin(sub_query, Tags.id == sub_query.c.tag_id)
    query = filter_tags_by_user_id_query(query, user_id)

    if search_word:
        query = query.where(Tags.name.ilike(f"%{search_word}%"))

    query = query.order_by(desc("used_num"))

    result = db.execute(query)

    return result.all()


def upsert_tags(db: Session, tag_names: List[str]):
    if not tag_names:
        return

    query = insert(Tags)
    query = query.values([{"name": name} for name in tag_names])
    query = query.on_conflict_do_nothing(index_elements=["name"])

    db.execute(query)

    query = select(Tags)
    query = query.where(Tags.name.in_(tag_names))
    query = query.where(~Tags.id.in_(select(TagEmbeddings.id)))

    result = db.execute(query).scalars().all()

    if not result:
        return

    embeddings_to_insert = [
        {"id": tag.id, "embedding": get_embedding(tag.name)} for tag in result
    ]

    db.execute(insert(TagEmbeddings).values(embeddings_to_insert))


def fetch_tags_by_names(db: Session, tag_names: List[str]):
    query = select(Tags)
    query = query.where(Tags.name.in_(tag_names))

    result = db.execute(query)

    return result.scalars().all()


def delete_unconnected_tags(db: Session):
    sub_query = select(MemoTags.tag_id)

    query = delete(Tags)
    query = query.where(Tags.id.not_in(sub_query))

    db.execute(query)

    db.commit()
    return


def add_generate_tags(
    db: Session,
    body: str,
    tag_names: List[str],
    relate_memos: List[Memos],
):
    if not relate_memos:
        ai_generate_tags = generate_tags(body, tag_names)
    else:
        relate_memo = relate_memos[0]
        relate_tags = fetch_tags_by_memo_id(db, relate_memo.id)
        relate_tag_names = [tag.name for tag in relate_tags]

        generate_tag_names = generate_tags(
            body, tag_names, relate_memo.body, relate_tag_names
        )

        ai_generate_tags = list(set(generate_tag_names) - set(tag_names))

    modified_generate_tags = replace_with_similar_tags(db, ai_generate_tags)
    return list(dict.fromkeys(tag_names + modified_generate_tags))


def replace_with_similar_tags(db: Session, target_tags: List[str]):
    replaced_tags = []

    for tag in target_tags:
        embedding = get_embedding(tag)
        similar_tag = fetch_tags_relate_by_embedding(db, embedding)

        result_tag = similar_tag.name if similar_tag else tag
        replaced_tags.append(result_tag)

    return replaced_tags


def fetch_tags_relate_by_embedding(
    db: Session,
    target_tag_embedding: Sequence[float],
):
    cosine_distance_query = cosine_distance(target_tag_embedding).label(
        "cosine_distance"
    )

    query = select(Tags)
    query = query.join(TagEmbeddings, Tags.id == TagEmbeddings.id)

    query = query.where(cosine_distance_query <= 0.1)  # 値は適当
    query = query.order_by(cosine_distance_query)

    result = db.execute(query)
    tag = result.unique().scalars().first()

    return tag
