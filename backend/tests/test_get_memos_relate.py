import pytest
from schemas.memo import MemoSortOrder
from tests.mock_data.memo import EMPTY_MEMOS, LONG_MEMOS, SHORT_MEMOS
from tests.mock_data.memoembedding import (
    EMPTY_MEMOEMBEDDINGS,
    LONG_MEMOEMBEDDINGS,
    SHORT_MEMOEMBEDDINGS,
)
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# データ型の確認
def test_format(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}/relate", headers=headers)
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

    memo_id = 1

    response = client.get(f"/memos/{memo_id}/relate", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 2


# ユーザのメモが存在しない場合に正常に通信が行われるか
def test_empty_data(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}/relate", headers=headers)
    assert response.status_code == 404


# メモが最大3件のみ取得されるか
def test_limit_data(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, LONG_MEMOS, LONG_MEMOEMBEDDINGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}/relate", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 3
