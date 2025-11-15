from pydantic import BaseModel
from typing import Optional

class Todo(BaseModel):
    owner_id: Optional[str] = None
    title: str
    completed: bool = False