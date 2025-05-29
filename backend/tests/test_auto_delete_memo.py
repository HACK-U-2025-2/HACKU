from models.memo import Memos
from models.memoembeddings import MemoEmbeddings
from models.memotag import MemoTags
from scheduler.delete_unnecessary_memos import delete_unnecessary_memos
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.mock_data.memoembedding import EMPTY_MEMOEMBEDDINGS, SHORT_MEMOEMBEDDINGS
from tests.mock_data.memotag import EMPTY_MEMOTAGS, SHORT_MEMOTAGS
from tests.mock_data.tag import EMPTY_TAGS, LONG_TAGS, SHORT_TAGS
from tests.mock_data.tagembedding import (
    EMPTY_TAGEMBEDDINGS,
    LONG_TAGEMBEDDINGS,
    SHORT_TAGEMBEDDINGS,
)
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos, create_test_memotags, create_test_tags


# favoriteがFalseのメモが正常に削除されるか
def test_normal_delete(test_db, client):
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    safe_memos = test_db.query(Memos).filter(Memos.is_favorite == True).all()
    safe_memo_embeddings = (
        test_db.query(MemoEmbeddings)
        .filter(MemoEmbeddings.id.in_([memo.id for memo in safe_memos]))
        .all()
    )

    safe_memotags = (
        test_db.query(MemoTags)
        .filter(MemoTags.memo_id.in_([memo.id for memo in safe_memos]))
        .all()
    )

    delete_unnecessary_memos(test_db)

    all_memos = test_db.query(Memos).all()
    all_memotags = test_db.query(MemoTags).all()
    all_memo_embeddings = test_db.query(MemoEmbeddings).all()

    assert len(all_memos) == len(safe_memos)
    assert len(all_memotags) == len(safe_memotags)
    assert len(all_memo_embeddings) == len(safe_memo_embeddings)
