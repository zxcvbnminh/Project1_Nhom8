from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
from bson import ObjectId
from .user import PyObjectId

class Card(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    listId: PyObjectId
    title: str
    description: Optional[str] = None
    assignee: Optional[PyObjectId] = None
    labels: Optional[List[PyObjectId]] = Field(default_factory=list)
    deadline: Optional[datetime] = None
    attachments: Optional[List[Dict[str, str]]] = Field(default_factory=list)
    comments: Optional[List[Dict[str, Any]]] = Field(default_factory=list)
    position: Optional[int] = 0
    priority: Optional[int] = None
    createdAt: datetime = Field(default_factory=datetime.utcnow)

    class Config:
        json_encoders = {ObjectId: str}
        arbitrary_types_allowed = True
        populate_by_name = True
