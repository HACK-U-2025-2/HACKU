from datetime import datetime

from pydantic import BaseModel, Field


class Token(BaseModel):
    access_token: str
    token_type: str


class DecodedToken(BaseModel):
    user_id: str
