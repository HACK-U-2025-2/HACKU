from datetime import datetime
from typing import List

from pydantic import BaseModel, Field
from schemas.tag import TagResponse


class MemoPreviewResponse(BaseModel):
    id: int = Field(gt=0, examples=[1])
    title: str = Field(min_length=1, examples=["Title"])
    user_id: str = Field(min_length=1, examples=["User"])
    body: str = Field(min_length=1, examples=["Body"])
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class MemoResponse(BaseModel):
    id: int = Field(gt=0, examples=[1])
    title: str = Field(min_length=1, examples=["Title"])
    user_id: str = Field(min_length=1, examples=["User"])
    body: str = Field(min_length=1, examples=["Body"])
    raw: str = Field(min_length=1, examples=["Body"])
    tags: List[TagResponse] = Field(default_factory=list)
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}
