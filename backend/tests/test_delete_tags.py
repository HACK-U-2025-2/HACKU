from crud.tag import delete_invalid_tags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings
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


# 何も紐づいていないタグが正常に削除されるか
def test_normal_delete(test_db, client):
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, LONG_TAGS, LONG_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    delete_invalid_tags(test_db)

    all_tags = test_db.query(Tags).all()

    assert len(all_tags) == len(LONG_TAGS) - 1

    all_tagembeddings = test_db.query(TagEmbeddings).all()

    assert len(all_tagembeddings) == len(LONG_TAGEMBEDDINGS) - 1


# 全てのタグが紐づけられている場合に何も削除されないか
def test_no_memo(test_db, client):
    create_test_memos(test_db, SHORT_MEMOS, SHORT_MEMOEMBEDDINGS)
    create_test_tags(test_db, SHORT_TAGS, SHORT_TAGEMBEDDINGS)
    create_test_memotags(test_db, SHORT_MEMOTAGS)

    delete_invalid_tags(test_db)

    all_tags = test_db.query(Tags).all()

    assert len(all_tags) == len(SHORT_TAGS)

    all_tagembeddings = test_db.query(TagEmbeddings).all()

    assert len(all_tagembeddings) == len(SHORT_TAGEMBEDDINGS)
