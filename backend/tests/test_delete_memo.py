from models.memo import Memos
from models.memoembeddings import MemoEmbeddings
from models.memotag import MemoTags
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memoembedding import EMPTY_MEMOEMBEDDINGS, SHORT_MEMOEMBEDDINGS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, SHORT_TAGS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# 指定したメモが正常に削除されるか
def test_normal_delete(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    memo_id = 1

    has_memotags = test_db.query(MemoTags).filter_by(memo_id=memo_id).all()

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 204

    deleted_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )

    deleted_memoembeddings = (
        test_db.query(MemoEmbeddings).filter_by(id=memo_id).one_or_none()
    )

    deleted_memotags = test_db.query(MemoTags).filter_by(memo_id=memo_id).all()

    assert deleted_memo is None
    assert deleted_memoembeddings is None
    assert deleted_memotags == []

    all_memotags = test_db.query(MemoTags).all()

    assert len(all_memotags) == len(SHORT_MEMOTAGS) - len(has_memotags)


# 存在しないメモを指定した場合に正常に通信が行われるか
def test_empty_memo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS, EMPTY_MEMOEMBEDDINGS)

    memo_id = 1

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 404


# 異なるユーザのメモを指定した場合に正常に通信が行われるか
def test_failure_id(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)

    memo_id = 1

    response = client.delete(f"/memos/{memo_id}", headers=headers)
    assert response.status_code == 404
