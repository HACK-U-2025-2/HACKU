from database import Base
from pgvector.sqlalchemy import Vector
from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.orm import relationship


class MemoEmbeddings(Base):
    __tablename__ = "memo_embeddings"

    id = Column(Integer, ForeignKey("memos.id"), primary_key=True)
    embedding = Column(Vector(1024), nullable=False)

    memo = relationship("Memos", back_populates="embedding", uselist=False)
