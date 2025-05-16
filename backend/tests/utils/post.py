from models.memo import Memos


def create_test_memos(test_db, memo_list):
    for data in memo_list:
        memo = Memos(
            title=data["title"],
            user_id=data["user_id"],
            body=data["body"],
            created_at=data["created_at"],
            updated_at=data["updated_at"],
        )
        test_db.add(memo)

    test_db.commit()
