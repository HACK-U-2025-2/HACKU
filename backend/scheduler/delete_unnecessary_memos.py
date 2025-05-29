from datetime import datetime

from crud.memo import delete_memo_by_id, fetch_not_favorite_memos
from llm.predict_archive import predict_archive
from sqlalchemy.orm import Session


def delete_unnecessary_memos(db: Session, is_demo: bool):
    memos = fetch_not_favorite_memos(db)
    deleted_logs = []

    for memo in memos:
        tag_names = [memotag.tag.name for memotag in memo.tags]
        is_delete = predict_archive(
            memo.body, memo.created_at.strftime("%Y-%m-%d %H:%M:%S"), tag_names
        )
        if is_delete:
            log = f"{memo.id}:{memo.title} is deleted."
            deleted_logs.append(log)
            if is_demo:
                continue
            delete_memo_by_id(db, memo.user_id, memo.id)
            print(log)
        else:
            log = f"{memo.id}:{memo.title} is not deleted."
            deleted_logs.append(log)
    return deleted_logs
