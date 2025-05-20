import pytest
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos


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


# 指定されたユーザのメモのみが帰ってくるか
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
