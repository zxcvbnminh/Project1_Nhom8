from pydantic import BaseModel, Field
from typing import List, Optional
from bson import ObjectId
from .user import PyObjectId

class ListModel(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    boardId: Optional[PyObjectId] = None
    title: str
    position: Optional[int] = 0
    cards: Optional[List[PyObjectId]] = []

    class Config:
        json_encoders = {ObjectId: str}
        arbitrary_types_allowed = True
