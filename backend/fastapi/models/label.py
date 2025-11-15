from pydantic import BaseModel, Field
from typing import Optional
from bson import ObjectId
from .user import PyObjectId

class Label(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    boardId: PyObjectId
    name: str
    color: str

    class Config:
        json_encoders = {ObjectId: str}
        arbitrary_types_allowed = True
