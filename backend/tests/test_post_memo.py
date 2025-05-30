import pytest
from models.memo import Memos
from models.memoembeddings import MemoEmbeddings
from models.memotag import MemoTags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memoembedding import EMPTY_MEMOEMBEDDINGS, SHORT_MEMOEMBEDDINGS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, SHORT_TAGS
from tests.mock_data.tagembedding import EMPTY_TAGEMBEDDINGS, SHORT_TAGEMBEDDINGS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# データ型の確認
def test_format(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)

    raw = "raw"
    tag_names = ["a", "b"]
    need_proofreading = False
    need_generate_tags = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
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
    assert isinstance(memo["is_favorite"], bool)
    assert isinstance(memo["created_at"], str)
    assert isinstance(memo["updated_at"], str)

    tag = memo["tags"][0]

    assert isinstance(tag["id"], int)
    assert isinstance(tag["name"], str)


# DBに正しく保存されているか
def test_db_save(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    raw = "raw"
    tag_names = ["タグ1", "add"]
    need_proofreading = False
    need_generate_tags = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201

    memos = test_db.query(Memos).all()
    memotags = test_db.query(MemoTags).all()
    memoembeddings = test_db.query(MemoEmbeddings).all()
    tags = test_db.query(Tags).all()
    tagembeddings = test_db.query(TagEmbeddings).all()

    assert len(memos) == len(SHORT_MEMOS) + 1
    assert len(memotags) == len(EMPTY_MEMOTAGS) + len(tag_names)
    assert len(memoembeddings) == len(SHORT_MEMOEMBEDDINGS) + 1
    assert len(tags) == len(SHORT_TAGS) + 1
    assert len(tagembeddings) == len(SHORT_TAGEMBEDDINGS) + 1


# タイトル，要約，校正が行われているか
def test_ai_generate(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)

    raw = "raw"
    tag_names = ["a", "b"]
    need_proofreading = True
    need_generate_tags = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    assert data["raw"] == "校正原文"
    assert data["body"] == "要約ボディ"
    assert data["title"] == "生成タイトル"


# タグが存在しない場合、適切にタグが生成されるか
def test_tag_generate_without_tag(test_db, client):
    user_id = "c"
    headers = get_headers(user_id, client)

    raw = "raw"
    tag_names = []
    need_proofreading = False
    need_generate_tags = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    tags = data["tags"]

    assert tags

    assert all("mock" in tag["name"] for tag in tags)


# 関連メモが存在しない場合、適切にタグが生成されるか
def test_tag_generate_without_memo(test_db, client):
    user_id = "c"
    headers = get_headers(user_id, client)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)

    raw = "raw"
    tag_names = []
    need_proofreading = False
    need_generate_tags = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    tags = data["tags"]

    assert tags

    assert all("mock" not in tag["name"] for tag in tags)


# 関連メモが存在する場合、適切にタグが生成されるか
def test_tag_generate_with_memo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    raw = "raw"
    tag_names = []
    need_proofreading = False
    need_generate_tags = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    tags = data["tags"]

    assert tags

    assert all("mock" not in tag["name"] for tag in tags)


# 関連メモが存在せず、ユーザ生成のタグが存在する場合、適切にタグが生成されるか
def test_add_tag_generate_without_memo(test_db, client):
    user_id = "c"
    headers = get_headers(user_id, client)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)

    raw = "raw"
    tag_names = ["成功"]
    need_proofreading = False
    need_generate_tags = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    tags = data["tags"]

    assert tags

    assert any("成功" in tag["name"] for tag in tags)
    assert all("mock" not in tag["name"] for tag in tags)


# 関連メモが存在し、ユーザ生成のタグが存在する場合、適切にタグが生成されるか
def test_add_tag_generate_with_memo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    raw = "raw"
    tag_names = ["成功"]
    need_proofreading = False
    need_generate_tags = True

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201
    data = response.json()

    tags = data["tags"]

    assert tags

    assert any("成功" in tag["name"] for tag in tags)
    assert all("mock" not in tag["name"] for tag in tags)


# タグ名が重複する際にDBに正しく保存されているか
def test_db_save_duplicate_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    raw = "raw"
    tag_names = ["add", "add"]
    need_proofreading = False
    need_generate_tags = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201

    tags = test_db.query(Tags).all()
    tagembeddings = test_db.query(TagEmbeddings).all()

    assert len(tags) == len(SHORT_TAGS) + 1
    assert len(tagembeddings) == len(SHORT_TAGEMBEDDINGS) + 1


# タグが空の場合にDBに正しく保存されているか
def test_db_save_empty_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)
    create_test_tags(test_db, EMPTY_TAGS, EMPTY_MEMOEMBEDDINGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    raw = "raw"
    tag_names = []
    need_proofreading = False
    need_generate_tags = False

    response = client.post(
        "/memos/",
        headers=headers,
        json={
            "raw": raw,
            "tag_names": tag_names,
            "need_proofreading": need_proofreading,
            "need_generate_tags": need_generate_tags,
        },
    )
    assert response.status_code == 201

    tags = test_db.query(Tags).all()

    assert len(tags) == 0

    memotags = test_db.query(MemoTags).all()

    assert len(memotags) == 0
