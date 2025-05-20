from pydantic import BaseModel, Field


class TagResponse(BaseModel):
    id: int = Field(gt=0, examples=[1])
    name: str = Field(min_length=1, examples=["Name"])
