# models/user.py
from pydantic import BaseModel, Field, GetCoreSchemaHandler
from pydantic_core import core_schema
from typing import List, Optional, Any
from datetime import datetime
from bson import ObjectId

# =================== PYOBJECTID CHO PYDANTIC V2 ===================
class PyObjectId(ObjectId):
    @classmethod
    def __get_pydantic_core_schema__(
        cls, source_type: Any, handler: GetCoreSchemaHandler
    ) -> core_schema.CoreSchema:
        return core_schema.union_schema(
            [
                # Chấp nhận chuỗi → validate → ObjectId
                core_schema.chain_schema(
                    [
                        core_schema.str_schema(),
                        core_schema.no_info_plain_validator_function(cls.validate),
                    ]
                ),
                # Chấp nhận ObjectId trực tiếp
                core_schema.is_instance_schema(ObjectId),
            ],
            serialization=core_schema.to_string_ser_schema(),
        )

    @classmethod
    def validate(cls, v):
        if isinstance(v, ObjectId):
            return v
        if not ObjectId.is_valid(str(v)):
            raise ValueError("Invalid ObjectId")
        return ObjectId(v)

    @classmethod
    def __get_pydantic_json_schema__(cls, core_schema, handler):
        return handler(core_schema)

# =================== USER MODELS ===================
class User(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    userName: str
    password: str
    boards: Optional[List[PyObjectId]] = Field(default_factory=list)
    role: Optional[str] = "member"
    createdAt: datetime = Field(default_factory=datetime.utcnow)
    lastLogin: Optional[datetime] = None

    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True
        json_encoders = {ObjectId: str}


class UserCreate(BaseModel):
    userName: str
    password: str

    class Config:
        populate_by_name = True