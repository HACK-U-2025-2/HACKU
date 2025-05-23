from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags
from sqlalchemy import select
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

    response = client.patch(
        f"/memos/{memo_id}/title", headers=headers, json={"title": title}
    )
    assert response.status_code == 200

    query = select(Memos).where(Memos.id == memo_id, Memos.user_id == user_id)
    updated_memo = test_db.execute(query).scalar_one_or_none()

    assert updated_memo is not None

    assert updated_memo.title == title


# 存在しないメモを指定した場合に正常に通信が行われるか(title)
def test_empty_memo_title(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    title = "失敗"

    response = client.patch(
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

    response = client.patch(
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

    response = client.patch(
        f"/memos/{memo_id}/body", headers=headers, json={"body": body}
    )
    assert response.status_code == 200

    query = select(Memos).where(Memos.id == memo_id, Memos.user_id == user_id)
    updated_memo = test_db.execute(query).scalar_one_or_none()

    assert updated_memo is not None

    assert updated_memo.body == body


# 存在しないメモを指定した場合に正常に通信が行われるか(body)
def test_empty_memo_body(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    body = "失敗"

    response = client.patch(
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

    response = client.patch(
        f"/memos/{memo_id}/body", headers=headers, json={"body": body}
    )
    assert response.status_code == 404


# 指定したメモが正常に変更されるか(tags)
def test_normal_update_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    memo_id = 1
    tag_names = ["成功", "タグ1", "タグ3"]

    response = client.patch(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 200

    query = select(MemoTags).where(MemoTags.memo_id == memo_id)
    updated_memotags = test_db.execute(query).scalars().all()

    query = select(Tags).where(Tags.name.in_(tag_names))
    connected_tag_ids = {tag.id for tag in test_db.execute(query).scalars().all()}

    assert len(updated_memotags) == 3
    for updated_memotag in updated_memotags:
        assert updated_memotag.tag_id in connected_tag_ids

    query = (
        select(Tags)
        .join(MemoTags, MemoTags.tag_id == Tags.id)
        .where(MemoTags.memo_id == memo_id)
    )
    updated_tags = test_db.execute(query).scalars().all()

    assert len(updated_tags) == 3

    for tag in updated_tags:
        assert tag.name in tag_names
        assert tag.name != "Tag 2"


# タグ名が重複する際に正常に通信が行われるか(tags)
def test_failure_id_duplicate_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    tag_names = ["成功", "成功"]

    response = client.patch(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 200

    query = select(MemoTags).where(MemoTags.memo_id == memo_id)
    updated_memotags = test_db.execute(query).scalars().all()

    assert len(updated_memotags) == 1

    query = select(Tags)
    updated_tags = test_db.execute(query).scalars().all()

    assert len(updated_tags) == 1


# 存在しないメモを指定した場合に正常に通信が行われるか(tags)
def test_empty_memo_tags(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    tag_names = ["失敗"]

    response = client.patch(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(tags)
def test_failure_id_tags(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    tag_names = ["失敗"]

    response = client.patch(
        f"/memos/{memo_id}/tags", headers=headers, json={"tag_names": tag_names}
    )
    assert response.status_code == 404


# 指定したメモが正常に変更されるか(all)
def test_normal_update_all(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    memo_id = 1
    title = "成功"
    body = "成功"
    tag_names = ["成功", "タグ1", "タグ3"]

    response = client.put(
        f"/memos/{memo_id}",
        headers=headers,
        json={
            "title": title,
            "body": body,
            "tag_names": tag_names,
        },
    )
    assert response.status_code == 200

    query_memo = select(Memos).where(Memos.id == memo_id, Memos.user_id == user_id)
    updated_memo = test_db.execute(query_memo).scalar_one_or_none()

    assert updated_memo is not None
    assert updated_memo.title == title
    assert updated_memo.body == body

    query_memotags = select(MemoTags).where(MemoTags.memo_id == memo_id)
    updated_memotags = test_db.execute(query_memotags).scalars().all()

    assert len(updated_memotags) == 3

    query_tags = (
        select(Tags)
        .join(MemoTags, MemoTags.tag_id == Tags.id)
        .where(MemoTags.memo_id == memo_id)
    )
    updated_tags = test_db.execute(query_tags).scalars().all()
    tag_names_in_db = [tag.name for tag in updated_tags]

    for name in tag_names:
        assert name in tag_names_in_db


# 存在しないメモを指定した場合に正常に通信が行われるか(all)
def test_empty_memo_all(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    response = client.put(
        f"/memos/{memo_id}",
        headers=headers,
        json={
            "title": "失敗",
            "body": "失敗",
            "tag_names": ["失敗"],
        },
    )
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(all)
def test_update_all_fields_wrong_user(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    response = client.put(
        f"/memos/{memo_id}",
        headers=headers,
        json={
            "title": "失敗",
            "body": "失敗",
            "tag_names": ["失敗"],
        },
    )
    assert response.status_code == 404
