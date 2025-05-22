import pytest
from models.memo import Memos
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos


# 指定したメモが正常に削除されるか
def test_normal_delete(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 204

    deleted_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )
    assert deleted_memo is None


# 存在しないメモを指定した場合に正常に通信が行われるか
def test_empty_memo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか
def test_failure_id(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 404
