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

    response = client.get("/memos/embeddings", headers=headers)
    assert response.status_code == 200
    data = response.json()

    memo = data[0]

    assert isinstance(data, list)
    assert isinstance(memo["id"], int)
    assert isinstance(memo["title"], str)
    assert isinstance(memo["simple_embedding"], list)


# 指定されたユーザのメモのみが返ってくるか
def test_normal_get(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    response = client.get("/memos/embeddings", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 3


# ユーザのメモが存在しない場合に正常に通信が行われるか
def test_empty_data(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)

    response = client.get("/memos/embeddings", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0
