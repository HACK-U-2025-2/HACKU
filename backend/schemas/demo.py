from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class MemoRead(BaseModel):
    id: int
    title: str
    user_id: str
    body: str
    raw: str
    simple_embedding: list[float]
    is_favorite: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        orm_mode = True


class TagRead(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True
