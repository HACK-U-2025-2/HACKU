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

    model_config = {"from_attributes": True}


class TagRead(BaseModel):
    id: int
    name: str

    model_config = {"from_attributes": True}
