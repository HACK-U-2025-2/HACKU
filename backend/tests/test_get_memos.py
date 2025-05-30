import pytest
from schemas.memo import MemoSortOrder
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
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    memo = data[0]

    assert isinstance(data, list)
    assert isinstance(memo["id"], int)
    assert isinstance(memo["title"], str)
    assert isinstance(memo["body"], str)
    assert isinstance(memo["user_id"], str)
    assert isinstance(memo["is_favorite"], bool)
    assert isinstance(memo["created_at"], str)
    assert isinstance(memo["updated_at"], str)


# 指定されたユーザのメモのみが返ってくるか
def test_normal_get(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 3

    for memo in data:
        assert memo["user_id"] == "a"


# ユーザのメモが存在しない場合に正常に通信が行われるか
def test_empty_data(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# キーワード検索が正常に行われているか
def test_normal_keyword_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers, params={"keyword": "メモ"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 2

    for memo in data:
        assert "メモ" in memo["title"]


# 対象のキーワードを含むメモが存在しない場合検索が正常に行われているか
def test_empty_keyword_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers, params={"keyword": "3"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# タグ検索が正常に行われているか
def test_normal_tags_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    response = client.get("/memos/", headers=headers, params={"tags": ["タグ1"]})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 2

    response = client.get(
        "/memos/", headers=headers, params={"tags": ["タグ1", "Tag 2"]}
    )
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 1


# 対象のキーワードを含むメモが存在しない場合検索が正常に行われているか
def test_empty_tags_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, EMPTY_TAGS, EMPTY_MEMOEMBEDDINGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    response = client.get("/memos/", headers=headers, params={"tags": ["タグ1"]})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# ソート順が正常に機能するか
@pytest.mark.parametrize(
    "sort_key",
    [item.value for item in MemoSortOrder],
)
def test_sort_order(test_db, client, sort_key):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers, params={"sort": sort_key})
    assert response.status_code == 200
    data = response.json()

    key = "created_at" if "created" in sort_key else "updated_at"
    timestamps = [memo[key] for memo in data]

    if "desc" in sort_key:
        assert timestamps == sorted(timestamps, reverse=True)
    else:
        assert timestamps == sorted(timestamps)


# ソート方式が不正な場合に正常に機能するか
def test_sort_order_invalid(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos/", headers=headers, params={"sort": "error"})
    assert response.status_code == 422
