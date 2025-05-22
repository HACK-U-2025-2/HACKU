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
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 200
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


# 指定されたidのメモが返ってくるか
def test_normal_get(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}", headers=headers)

    assert response.status_code == 200
    data = response.json()

    memo = data

    assert memo["id"] == memo_id

    for tag in memo["tags"]:
        assert tag["id"] in [1, 2]


# メモが存在しない場合に正常に通信が行われるか
def test_empty_memo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}", headers=headers)

    assert response.status_code == 404


# メモに紐づいたタグが存在しない場合に正常に通信が行われるか
def test_empty_tag(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, EMPTY_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}", headers=headers)

    assert response.status_code == 200
    data = response.json()

    memo = data

    assert len(memo["tags"]) == 0


# 異なるユーザのメモを指定した場合に正常に通信が行われるか
def test_failure_id(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, EMPTY_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    memo_id = 1

    response = client.get(f"/memos/{memo_id}", headers=headers)

    assert response.status_code == 404
