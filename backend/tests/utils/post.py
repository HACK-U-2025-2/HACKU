from models.memo import Memos
from models.memoembeddings import MemoEmbeddings
from models.memotag import MemoTags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings


def create_test_memos(test_db, memo_list, memoembedding_list):
    for i in range(len(memo_list)):
        data = memo_list[i]
        memo = Memos(
            title=data["title"],
            user_id=data["user_id"],
            body=data["body"],
            raw=data["raw"],
            is_favorite=data["is_favorite"],
            is_archive=data["is_archive"],
            simple_embedding=data["simple_embedding"],
            created_at=data["created_at"],
            updated_at=data["updated_at"],
        )
        test_db.add(memo)
        test_db.flush()

        data = memoembedding_list[i]
        memoembeddings = MemoEmbeddings(id=memo.id, embedding=data["embedding"])
        test_db.add(memoembeddings)

    test_db.commit()


def create_test_tags(test_db, tag_list, tagembedding_list):
    for i in range(len(tag_list)):
        data = tag_list[i]
        tag = Tags(
            name=data["name"],
        )
        test_db.add(tag)
        test_db.flush()

        data = tagembedding_list[i]
        tagembeddings = TagEmbeddings(id=tag.id, embedding=data["embedding"])
        test_db.add(tagembeddings)

    test_db.commit()


def create_test_memotags(test_db, memotag_list):
    for data in memotag_list:
        memotag = MemoTags(memo_id=data["memo_id"], tag_id=data["tag_id"])
        test_db.add(memotag)

    test_db.commit()
