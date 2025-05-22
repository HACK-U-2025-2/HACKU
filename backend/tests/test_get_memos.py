import pytest
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, SHORT_TAGS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# データ型の確認
def test_format(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/memos/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    memo = data[0]

    assert isinstance(data, list)
    assert isinstance(memo["id"], int)
    assert isinstance(memo["title"], str)
    assert isinstance(memo["body"], str)
    assert isinstance(memo["user_id"], str)
    assert isinstance(memo["created_at"], str)
    assert isinstance(memo["updated_at"], str)


# 指定されたユーザのメモのみが返ってくるか
def test_normal_get(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

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
    create_test_memos(test_db, EMPTY_MEMOS)

    response = client.get("/memos/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# キーワード検索が正常に行われているか
def test_normal_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/memos/", headers=headers, params={"keyword": "メモ"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 2

    for memo in data:
        assert "メモ" in memo["title"]


# 対象のキーワードを含むメモが存在しない場合検索が正常に行われているか
def test_empty_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    response = client.get("/memos/", headers=headers, params={"keyword": "3"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# タグ検索が正常に行われているか
def test_normal_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
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
def test_empty_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, EMPTY_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    response = client.get("/memos/", headers=headers, params={"tags": ["タグ1"]})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# ソート順が正常に機能するか(作成日時昇順)
def test_sort_order_created_asc(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/memos/", headers=headers, params={"sort": "created_at_asc"})
    assert response.status_code == 200
    data = response.json()

    created_times = [memo["created_at"] for memo in data]
    assert created_times == sorted(created_times)


# ソート順が正常に機能するか(作成日時降順)
def test_sort_order_created_desc(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get(
        "/memos/", headers=headers, params={"sort": "created_at_desc"}
    )
    assert response.status_code == 200
    data = response.json()

    created_times = [memo["created_at"] for memo in data]
    assert created_times == sorted(created_times, reverse=True)


# ソート順が正常に機能するか(更新日時昇順)
def test_sort_order_updated_asc(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/memos/", headers=headers, params={"sort": "updated_at_asc"})
    assert response.status_code == 200
    data = response.json()

    updated_times = [memo["updated_at"] for memo in data]
    assert updated_times == sorted(updated_times)


# ソート順が正常に機能するか(更新日時降順)
def test_sort_order_updated_desc(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get(
        "/memos/", headers=headers, params={"sort": "updated_at_desc"}
    )
    assert response.status_code == 200
    data = response.json()

    updated_times = [memo["updated_at"] for memo in data]
    assert updated_times == sorted(updated_times, reverse=True)


# ソート方式が不正な場合に正常に機能するか
def test_sort_order_updated_desc(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/memos/", headers=headers, params={"sort": "error"})
    assert response.status_code == 422
