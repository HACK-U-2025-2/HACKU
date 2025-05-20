from datetime import datetime

from pydantic import BaseModel, Field


class MemoPreviewResponse(BaseModel):
    id: int = Field(gt=0, examples=[1])
    title: str = Field(min_length=1, examples=["Title"])
    user_id: str = Field(min_length=1, examples=["User"])
    body: str = Field(min_length=1, examples=["Body"])
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}
