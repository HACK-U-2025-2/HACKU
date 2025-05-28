from datetime import datetime

from utils.jst_now import JST

SHORT_MEMOS = [
    {
        "title": "メモ1",
        "user_id": "a",
        "body": "sample",
        "raw": "sample",
        "is_favorite": False,
        "is_archive": False,
        "simple_embedding": [0.1] * 3,
        "created_at": datetime(2024, 4, 1, 15, 30, 0, tzinfo=JST),
        "updated_at": datetime(2024, 4, 9, 15, 30, 0, tzinfo=JST),
    },
    {
        "title": "メモ2",
        "user_id": "a",
        "body": "sample",
        "raw": "sample",
        "is_favorite": False,
        "is_archive": False,
        "simple_embedding": [0.1] * 3,
        "created_at": datetime(2024, 4, 4, 15, 30, 0, tzinfo=JST),
        "updated_at": datetime(2024, 4, 8, 15, 30, 0, tzinfo=JST),
    },
    {
        "title": "Memo 3",
        "user_id": "b",
        "body": "sample",
        "raw": "sample",
        "is_favorite": False,
        "is_archive": False,
        "simple_embedding": [0.1] * 3,
        "created_at": datetime(2024, 4, 3, 15, 30, 0, tzinfo=JST),
        "updated_at": datetime(2024, 4, 3, 15, 30, 0, tzinfo=JST),
    },
    {
        "title": "Memo 4",
        "user_id": "a",
        "body": "sample",
        "raw": "sample",
        "is_favorite": False,
        "is_archive": False,
        "simple_embedding": [0.1] * 3,
        "created_at": datetime(2024, 4, 3, 15, 30, 0, tzinfo=JST),
        "updated_at": datetime(2024, 4, 7, 15, 30, 0, tzinfo=JST),
    },
]

EMPTY_MEMOS = []
