from models.memo import Memos
from sqlalchemy.orm import Session


def fetch_memos(db: Session, user_id: str):
    query = db.query(Memos)
    query = query.filter(Memos.user_id == user_id)
    return query.all()
