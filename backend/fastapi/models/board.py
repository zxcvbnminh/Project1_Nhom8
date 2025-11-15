from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
from bson import ObjectId
from .user import PyObjectId

class BoardMember(BaseModel):
    userId: PyObjectId
    role: Optional[str] = "member"  # member, editor, viewer...

    class Config:
        json_encoders = {ObjectId: str}
        arbitrary_types_allowed = True

class Board(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    title: str
    description: Optional[str] = None
    ownerId: Optional[PyObjectId] = None
    createdAt: datetime = Field(default_factory=datetime.utcnow)
    updatedAt: Optional[datetime] = None
    members: Optional[List[BoardMember]] = []  # [{ userId, role }]

    class Config:
        json_encoders = {ObjectId: str}
        arbitrary_types_allowed = True
        populate_by_name = True
