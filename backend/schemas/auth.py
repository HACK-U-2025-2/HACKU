from datetime import datetime

from pydantic import BaseModel, Field


class Token(BaseModel):
    access_token: str
    token_type: str

    model_config = {"from_attributes": True}


class DecodedToken(BaseModel):
    user_id: str

    model_config = {"from_attributes": True}
