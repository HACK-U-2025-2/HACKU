from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class ExaResponse(BaseModel):  # ただの例、修正予定
    name: str = Field(min_length=2, max_length=20, examples=["example"])
    viewed_at: datetime
    model_config = ConfigDict(from_attributes=True)
