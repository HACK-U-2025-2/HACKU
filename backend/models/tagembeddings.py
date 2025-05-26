from database import Base
from pgvector.sqlalchemy import Vector
from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.orm import relationship


class TagEmbeddings(Base):
    __tablename__ = "tag_embeddings"

    id = Column(Integer, ForeignKey("tags.id", ondelete="CASCADE"), primary_key=True)
    embedding = Column(Vector(1024), nullable=False)

    tag = relationship("Tags", back_populates="embedding", uselist=False)
