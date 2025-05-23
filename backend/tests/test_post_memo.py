import pytest
from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, SHORT_TAGS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# データ型の確認
def test_format(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)

    raw = "raw"
    tag_names = ["a", "b"]
    need_proofreading = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
        },
    )
    assert response.status_code == 201
    data = response.json()

    memo = data

    assert isinstance(memo["id"], int)
    assert isinstance(memo["title"], str)
    assert isinstance(memo["body"], str)
    assert isinstance(memo["raw"], str)
    assert isinstance(memo["user_id"], str)
    assert isinstance(memo["tags"], list)
    assert isinstance(memo["created_at"], str)
    assert isinstance(memo["updated_at"], str)

    tag = memo["tags"][0]

    assert isinstance(tag["id"], int)
    assert isinstance(tag["name"], str)


# DBに正しく保存されているか
def test_db_save(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    raw = "raw"
    tag_names = ["タグ1", "add"]
    need_proofreading = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
        },
    )
    assert response.status_code == 201

    memos = test_db.query(Memos).all()
    memotags = test_db.query(MemoTags).all()
    tags = test_db.query(Tags).all()

    assert len(memos) == len(EMPTY_MEMOS) + 1
    assert len(memotags) == len(EMPTY_MEMOTAGS) + len(tag_names)
    assert len(tags) == len(SHORT_TAGS) + 1


# タイトル，要約，校正が行われているか
def test_ai_generate(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)

    raw = "raw"
    tag_names = ["a", "b"]
    need_proofreading = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
        },
    )
    assert response.status_code == 201
    data = response.json()

    assert data["raw"] == "校正原文"
    assert data["body"] == "要約ボディ"
    assert data["title"] == "生成タイトル"


# タグ名が重複する際にDBに正しく保存されているか
def test_db_save_duplicate_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    raw = "raw"
    tag_names = ["add", "add"]
    need_proofreading = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
        },
    )
    assert response.status_code == 201

    tags = test_db.query(Tags).all()

    assert len(tags) == len(SHORT_TAGS) + 1
