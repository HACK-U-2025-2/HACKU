from datetime import datetime
from enum import Enum
from typing import Annotated, List

from pydantic import BaseModel, Field
from schemas.tag import TagResponse

TagName = Annotated[str, Field(min_length=1)]


class MemoPreviewResponse(BaseModel):
    id: int = Field(gt=0, json_schema_extra={"examples": [1]})
    title: str = Field(min_length=1, json_schema_extra={"examples": ["Title"]})
    user_id: str = Field(min_length=1, json_schema_extra={"examples": ["User"]})
    body: str = Field(min_length=1, json_schema_extra={"examples": ["Body"]})
    is_favorite: bool = Field(json_schema_extra={"examples": False})
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class MemoResponse(BaseModel):
    id: int = Field(gt=0, json_schema_extra={"examples": [1]})
    title: str = Field(min_length=1, json_schema_extra={"examples": ["Title"]})
    user_id: str = Field(min_length=1, json_schema_extra={"examples": ["User"]})
    body: str = Field(min_length=1, json_schema_extra={"examples": ["Body"]})
    raw: str = Field(min_length=1, json_schema_extra={"examples": ["Body"]})
    tags: List[TagResponse] = Field(default_factory=list)
    is_favorite: bool = Field(json_schema_extra={"examples": [False]})
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


class MemoCreateRequest(BaseModel):
    raw: str = Field(min_length=1, json_schema_extra={"examples": ["raw text"]})
    tag_names: List[TagName] = Field(
        default_factory=list, json_schema_extra={"examples": [["タグ1", "タグ2"]]}
    )
    need_proofreading: bool = Field(json_schema_extra={"examples": [True]})

    model_config = {"from_attributes": True}


class MemoAllUpdateRequest(BaseModel):
    title: str = Field(min_length=1, json_schema_extra={"examples": ["title"]})
    body: str = Field(min_length=1, json_schema_extra={"examples": ["summary"]})
    tag_names: List[TagName] = Field(
        default_factory=list, json_schema_extra={"examples": [["タグ1", "タグ2"]]}
    )

    model_config = {"from_attributes": True}


class MemoTitleUpdateRequest(BaseModel):
    title: str = Field(min_length=1, json_schema_extra={"examples": ["title"]})

    model_config = {"from_attributes": True}


class MemoBodyUpdateRequest(BaseModel):
    body: str = Field(min_length=1, json_schema_extra={"examples": ["summary"]})

    model_config = {"from_attributes": True}


class MemoTagsUpdateRequest(BaseModel):
    tag_names: List[TagName] = Field(
        default_factory=list, json_schema_extra={"examples": [["タグ1", "タグ2"]]}
    )

    model_config = {"from_attributes": True}


class MemoFavoriteUpdateRequest(BaseModel):
    is_favorite: bool = Field(json_schema_extra={"examples": [False]})

    model_config = {"from_attributes": True}


class MemoSortOrder(str, Enum):
    CREATED_AT_ASC = "created_at_asc"
    CREATED_AT_DESC = "created_at_desc"
    UPDATED_AT_ASC = "updated_at_asc"
    UPDATED_AT_DESC = "updated_at_desc"
