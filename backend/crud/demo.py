import ast
import csv
from datetime import datetime, timedelta
from pathlib import Path

from models.memo import Memos
from models.memoembeddings import MemoEmbeddings
from models.memotag import MemoTags
from models.tag import Tags
from models.tagembeddings import TagEmbeddings
from sqlalchemy import delete, distinct, select, text
from sqlalchemy.orm import Session

CSV_DIR = Path("initial_data")


def demo_get_user(db: Session):
    query = select(distinct(Memos.user_id))
    result = db.execute(query)
    return [row[0] for row in result.fetchall()]


def demo_get_memo(db: Session):
    return db.query(Memos).all()


def demo_get_tag(db: Session):
    return db.query(Tags).all()


def reset_data(db: Session):
    reset_memo(db)
    reset_tag(db)
    reset_memotag(db)
    reset_memoembedding(db)
    reset_tagembedding(db)


def save_data(db: Session):
    save_memo(db)
    save_memoembedding(db)
    save_tag(db)
    save_tagembedding(db)
    save_memotag(db)


def reset_memo(db: Session):
    db.execute(delete(Memos))
    db.commit()

    with (CSV_DIR / "memos.csv").open(newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            memo = Memos(
                id=int(row["id"]),
                title=row["title"],
                user_id=row["user_id"],
                body=row["body"],
                raw=row["raw"],
                simple_embedding=ast.literal_eval(row["simple_embedding"]),
                is_favorite=row["is_favorite"].lower() == "true",
                created_at=datetime.fromisoformat(row["created_at"]),
                updated_at=datetime.fromisoformat(row["updated_at"]),
            )
            db.add(memo)
    db.commit()
    db.execute(
        text(
            "SELECT setval(pg_get_serial_sequence('memos', 'id'), (SELECT MAX(id) FROM memos) + 1, false)"
        )
    )
    db.commit()


def reset_tag(db: Session):
    db.execute(delete(Tags))
    db.commit()

    with (CSV_DIR / "tags.csv").open(newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            tag = Tags(id=int(row["id"]), name=row["name"])
            db.add(tag)
    db.commit()
    db.execute(
        text(
            "SELECT setval(pg_get_serial_sequence('tags', 'id'), (SELECT MAX(id) FROM tags) + 1, false)"
        )
    )
    db.commit()


def reset_memotag(db: Session):
    db.execute(delete(MemoTags))
    db.commit()

    with (CSV_DIR / "memotags.csv").open(newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            memotag = MemoTags(
                memo_tag_id=int(row["memo_tag_id"]),
                memo_id=int(row["memo_id"]),
                tag_id=int(row["tag_id"]),
            )
            db.add(memotag)
    db.commit()
    db.execute(
        text(
            "SELECT setval(pg_get_serial_sequence('memotags', 'memo_tag_id'), (SELECT MAX(memo_tag_id) FROM memotags) + 1, false)"
        )
    )
    db.commit()


def reset_memoembedding(db: Session):
    db.execute(delete(MemoEmbeddings))
    db.commit()

    with (CSV_DIR / "memo_embeddings.csv").open(
        newline="", encoding="utf-8"
    ) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            embedding = MemoEmbeddings(
                id=int(row["id"]),
                embedding=ast.literal_eval(row["embedding"]),
            )
            db.add(embedding)
    db.commit()


def reset_tagembedding(db: Session):
    db.execute(delete(TagEmbeddings))
    db.commit()

    with (CSV_DIR / "tag_embeddings.csv").open(newline="", encoding="utf-8") as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            embedding = TagEmbeddings(
                id=int(row["id"]),
                embedding=ast.literal_eval(row["embedding"]),
            )
            db.add(embedding)
    db.commit()


def save_memo(db: Session):
    memos = db.query(Memos).all()
    with (CSV_DIR / "memos.csv").open("w", newline="", encoding="utf-8") as csvfile:
        fieldnames = [
            "id",
            "title",
            "user_id",
            "body",
            "raw",
            "simple_embedding",
            "is_favorite",
            "created_at",
            "updated_at",
        ]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for memo in memos:
            writer.writerow(
                {
                    "id": memo.id,
                    "title": memo.title,
                    "user_id": memo.user_id,
                    "body": memo.body,
                    "raw": memo.raw,
                    "simple_embedding": list(memo.simple_embedding),
                    "is_favorite": memo.is_favorite,
                    "created_at": memo.created_at.isoformat(),
                    "updated_at": memo.updated_at.isoformat(),
                }
            )


def save_memoembedding(db: Session):
    rows = db.query(MemoEmbeddings).all()
    with (CSV_DIR / "memo_embeddings.csv").open(
        "w", newline="", encoding="utf-8"
    ) as csvfile:
        fieldnames = ["id", "embedding"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    "id": row.id,
                    "embedding": list(row.embedding),
                }
            )


def save_tag(db: Session):
    tags = db.query(Tags).all()
    with (CSV_DIR / "tags.csv").open("w", newline="", encoding="utf-8") as csvfile:
        fieldnames = ["id", "name"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for tag in tags:
            writer.writerow(
                {
                    "id": tag.id,
                    "name": tag.name,
                }
            )


def save_memotag(db: Session):
    links = db.query(MemoTags).all()
    with (CSV_DIR / "memotags.csv").open("w", newline="", encoding="utf-8") as csvfile:
        fieldnames = ["memo_tag_id", "memo_id", "tag_id"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for link in links:
            writer.writerow(
                {
                    "memo_tag_id": link.memo_tag_id,
                    "memo_id": link.memo_id,
                    "tag_id": link.tag_id,
                }
            )


def save_tagembedding(db: Session):
    rows = db.query(TagEmbeddings).all()
    with (CSV_DIR / "tag_embeddings.csv").open(
        "w", newline="", encoding="utf-8"
    ) as csvfile:
        fieldnames = ["id", "embedding"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    "id": row.id,
                    "embedding": list(row.embedding),
                }
            )


def demo_backdate_memos(db: Session, days: int = 10):
    memos = db.query(Memos).all()
    for memo in memos:
        memo.created_at -= timedelta(days=days)
        memo.updated_at -= timedelta(days=days)
    db.commit()
