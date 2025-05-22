from models.memo import Memos
from models.memotag import MemoTags
from models.tag import Tags


def create_test_memos(test_db, memo_list):
    for data in memo_list:
        memo = Memos(
            title=data["title"],
            user_id=data["user_id"],
            body=data["body"],
            raw=data["raw"],
            created_at=data["created_at"],
            updated_at=data["updated_at"],
        )
        test_db.add(memo)

    test_db.commit()


def create_test_tags(test_db, tag_list):
    for data in tag_list:
        tag = Tags(
            name=data["name"],
        )
        test_db.add(tag)

    test_db.commit()


def create_test_memotags(test_db, memotag_list):
    for data in memotag_list:
        memotag = MemoTags(memo_id=data["memo_id"], tag_id=data["tag_id"])
        test_db.add(memotag)

    test_db.commit()
