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

    response = client.get("/tags/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    tag = data[0]

    assert isinstance(data, list)
    assert isinstance(tag["name"], str)


# 指定されたユーザのタグのみが返ってくるか
def test_normal_get(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    response = client.get("/tags", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 2

    for tag in data:
        assert tag["name"] in ["タグ1", "Tag 2"]


# ユーザのタグが存在しない場合に正常に通信が行われるか
def test_empty_data(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, EMPTY_MEMOTAGS)

    response = client.get("/tags/", headers=headers)
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0


# キーワード検索が正常に行われているか
def test_normal_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    response = client.get("/tags/", headers=headers, params={"keyword": "タグ"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 1

    tag = data[0]
    assert "タグ" in tag["name"]


# 対象のキーワードを含むタグが存在しない場合検索が正常に行われているか
def test_empty_search(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    response = client.get("/tags/", headers=headers, params={"keyword": "たぐ"})
    assert response.status_code == 200
    data = response.json()

    assert len(data) == 0
