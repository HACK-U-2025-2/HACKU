from datetime import datetime

from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    user_id: str = Field(min_length=1, json_schema_extra={"examples": ["a"]})

    model_config = {"from_attributes": True}


class Token(BaseModel):
    access_token: str
    token_type: str
    expired_at: datetime

    model_config = {"from_attributes": True}


class DecodedToken(BaseModel):
    user_id: str

    model_config = {"from_attributes": True}
