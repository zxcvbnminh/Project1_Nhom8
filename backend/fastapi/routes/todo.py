# routes/todos.py
from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config.database import todo_collection
from schema.schemas import list_serial, individual_serial
from models.todos import Todo
from config.jwt import decode_access_token
from bson import ObjectId

router = APIRouter(prefix="/todos", tags=["todos"])
bearer_scheme = HTTPBearer()

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    user_id = decode_access_token(token)
    return user_id

@router.get("/", status_code=status.HTTP_200_OK)
async def get_todos(user_id: str = Depends(get_current_user_id)):
    try:
        todos_cursor = todo_collection.find({"owner_id": user_id})
        todos = list(todos_cursor)
        return list_serial(todos)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_todo(todo: Todo, user_id: str = Depends(get_current_user_id)):
    try:
        todo_doc = todo.model_dump(exclude_unset=True)
        todo_doc["owner_id"] = user_id
        result = todo_collection.insert_one(todo_doc)
        created = todo_collection.find_one({"_id": result.inserted_id})
        return individual_serial(created)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.put("/{id}", status_code=status.HTTP_200_OK)
async def update_todo(id: str, todo: Todo, user_id: str = Depends(get_current_user_id)):
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    oid = ObjectId(id)
    # ensure ownership
    existing = todo_collection.find_one({"_id": oid})
    if not existing:
        raise HTTPException(status_code=404, detail="Todo not found")
    if str(existing.get("owner_id")) != user_id:
        raise HTTPException(status_code=403, detail="Not allowed")
    todo_doc = todo.model_dump(exclude_unset=True)
    todo_collection.find_one_and_update({"_id": oid}, {"$set": todo_doc})
    updated = todo_collection.find_one({"_id": oid})
    return individual_serial(updated)

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_todo(id: str, user_id: str = Depends(get_current_user_id)):
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    oid = ObjectId(id)
    existing = todo_collection.find_one({"_id": oid})
    if not existing:
        raise HTTPException(status_code=404, detail="Todo not found")
    if str(existing.get("owner_id")) != user_id:
        raise HTTPException(status_code=403, detail="Not allowed")
    todo_collection.find_one_and_delete({"_id": oid})
    return None
