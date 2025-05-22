import pytest
from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, SHORT_TAGS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# 指定したメモが正常に変更されるか(title)
def test_normal_update_title(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    title = "成功"

    response = client.put(
        f"/memos/{memo_id}/title", headers=headers, json={"title": title}
    )
    assert response.status_code == 200

    updated_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )
    assert updated_memo is not None

    assert updated_memo.title == title


# 存在しないメモを指定した場合に正常に通信が行われるか(title)
def test_empty_memo_title(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    title = "失敗"

    response = client.put(
        f"/memos/{memo_id}/title", headers=headers, json={"title": title}
    )
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(title)
def test_failure_id_title(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    title = "失敗"

    response = client.put(
        f"/memos/{memo_id}/title", headers=headers, json={"title": title}
    )
    assert response.status_code == 404


# 指定したメモが正常に変更されるか(body)
def test_normal_update_body(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    body = "成功"

    response = client.put(
        f"/memos/{memo_id}/body", headers=headers, json={"body": body}
    )
    assert response.status_code == 200

    updated_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )
    assert updated_memo is not None

    assert updated_memo.body == body


# 存在しないメモを指定した場合に正常に通信が行われるか(body)
def test_empty_memo_body(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    body = "失敗"

    response = client.put(
        f"/memos/{memo_id}/body", headers=headers, json={"body": body}
    )
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(body)
def test_failure_id_body(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    body = "失敗"

    response = client.put(
        f"/memos/{memo_id}/body", headers=headers, json={"body": body}
    )
    assert response.status_code == 404


# 指定したメモが正常に変更されるか(tags)
def test_normal_update_title(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)
    create_test_tags

    memo_id = 1
    tag_names = ["成功", "タグ1", "タグ3"]

    response = client.put(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 200

    updated_memotags = test_db.query(MemoTags).filter_by(memo_id=memo_id).all()
    assert len(updated_memotags) == 3

    updated_tags = (
        test_db.query(Tags)
        .join(MemoTags, MemoTags.tag_id == Tags.id)
        .filter(MemoTags.memo_id == memo_id)
        .all()
    )

    assert len(updated_tags) == 3

    for tag in updated_tags:
        assert tag.name in tag_names
        assert tag.name != "Tag 2"


# 存在しないメモを指定した場合に正常に通信が行われるか(tags)
def test_empty_memo_body(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    tag_names = ["失敗"]

    response = client.put(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(tags)
def test_failure_id_body(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    tag_names = ["失敗"]

    response = client.put(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 404
