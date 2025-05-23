from datetime import datetime

from pydantic import BaseModel


class LoginRequest(BaseModel):
    user_id: str

    model_config = {"from_attributes": True}


class Token(BaseModel):
    access_token: str
    token_type: str
    expired_at: datetime

    model_config = {"from_attributes": True}


class DecodedToken(BaseModel):
    user_id: str

    model_config = {"from_attributes": True}
