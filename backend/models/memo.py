from database import Base
from pgvector.sqlalchemy import Vector
from sqlalchemy import Boolean, Column, Date, DateTime, Integer, String
from sqlalchemy.orm import relationship
from utils.jst_now import jst_now


class Memos(Base):
    __tablename__ = "memos"
    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String, nullable=False)
    user_id = Column(String, nullable=False)
    body = Column(String, nullable=False)
    raw = Column(String, nullable=False)
    simple_embedding = Column(Vector(3), nullable=False)
    is_favorite = Column(Boolean, nullable=False)
    created_at = Column(DateTime, default=jst_now)
    updated_at = Column(DateTime, default=jst_now, onupdate=jst_now)

    tags = relationship(
        "MemoTags",
        back_populates="memo",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )
    embedding = relationship(
        "MemoEmbeddings",
        back_populates="memo",
        uselist=False,
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    model_config = {"from_attributes": True}
