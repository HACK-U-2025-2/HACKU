from database import Base
from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.orm import relationship


class MemoTags(Base):
    __tablename__ = "memotags"
    memo_tag_id = Column(Integer, primary_key=True, autoincrement=True)
    memo_id = Column(Integer, ForeignKey("memos.id", ondelete="CASCADE"))
    tag_id = Column(Integer, ForeignKey("tags.id", ondelete="CASCADE"))

    memo = relationship("Memos", back_populates="tags")
    tag = relationship("Tags", back_populates="memos")
