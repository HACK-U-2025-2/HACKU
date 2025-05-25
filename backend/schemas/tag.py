from pydantic import BaseModel, Field


class TagResponse(BaseModel):
    id: int = Field(gt=0, json_schema_extra={"examples": [1]})
    name: str = Field(min_length=1, json_schema_extra={"examples": ["Name"]})

    model_config = {"from_attributes": True}
