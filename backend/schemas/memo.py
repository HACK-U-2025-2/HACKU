from datetime import datetime
from enum import Enum
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


class MemoCreateRequest(BaseModel):
    raw: str
    tag_names: List[str]
    need_proofreading: bool

    model_config = {"from_attributes": True}


class MemoTitleUpdateRequest(BaseModel):
    title: str

    model_config = {"from_attributes": True}


class MemoBodyUpdateRequest(BaseModel):
    body: str

    model_config = {"from_attributes": True}


class MemoTagsUpdateRequest(BaseModel):
    tag_names: List[str]

    model_config = {"from_attributes": True}


class MemoSortOrder(str, Enum):
    CREATED_AT_ASC = "created_at_asc"
    CREATED_AT_DESC = "created_at_desc"
    UPDATED_AT_ASC = "updated_at_asc"
    UPDATED_AT_DESC = "updated_at_desc"
