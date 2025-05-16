from datetime import datetime

from pydantic import BaseModel, Field


class MemoResponse(BaseModel):
    id: int = Field(gt=0, examples=[1])
    title: str = Field(min_length=1, examples=["MemoTitle"])
    memo_id: str = Field(min_length=1, examples=["User"])
    body: str = Field(min_length=1, examples=["Body"])
    created_at: datetime
    updated_at: datetime
