# routes/boards.py
from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config.database import board_collection
from schema.schemas import board_list_serial, board_individual_serial
from models.board import Board
from config.jwt import decode_access_token
from bson import ObjectId
from datetime import datetime

router = APIRouter(prefix="/boards", tags=["boards"])
bearer_scheme = HTTPBearer()

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    user_id = decode_access_token(token)
    return user_id

@router.get("/", status_code=status.HTTP_200_OK)
async def get_boards(user_id: str = Depends(get_current_user_id)):
    """Get all boards owned by or accessible to the current user"""
    try:
        # Get boards where user is owner or member
        boards_cursor = board_collection.find({
            "$or": [
                {"ownerId": ObjectId(user_id)},
                {"members.userId": ObjectId(user_id)}
            ]
        })
        boards = list(boards_cursor)
        return board_list_serial(boards)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# routes/boards.py
@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_board(board: Board, user_id: str = Depends(get_current_user_id)):
    try:
        # Chuyển thành dict, loại bỏ các field không cần
        board_dict = board  = board.model_dump(
            by_alias=True,
            exclude_unset=True,
            exclude={"id", "ownerId", "createdAt", "updatedAt"}  # Không gửi các field này
        )

        # TỰ ĐỘNG THÊM
        board_dict["ownerId"] = ObjectId(user_id)
        board_dict["createdAt"] = datetime.utcnow()

        result = board_collection.insert_one(board_dict)
        created_board = board_collection.find_one({"_id": result.inserted_id})

        return board_individual_serial(created_board)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{id}", status_code=status.HTTP_200_OK)
async def get_board(id: str, user_id: str = Depends(get_current_user_id)):
    """Get a specific board by ID"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    
    oid = ObjectId(id)
    board = board_collection.find_one({"_id": oid})
    
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Check if user has access (owner or member)
    user_oid = ObjectId(user_id)
    is_owner = board.get("ownerId") == user_oid
    is_member = any(m.get("userId") == user_oid for m in board.get("members", []))
    
    if not (is_owner or is_member):
        raise HTTPException(status_code=403, detail="Not allowed")
    
    return board_individual_serial(board)

@router.put("/{id}", status_code=status.HTTP_200_OK)
async def update_board(id: str, board: Board, user_id: str = Depends(get_current_user_id)):
    """Update a board"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    
    oid = ObjectId(id)
    existing = board_collection.find_one({"_id": oid})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Only owner can update board
    if existing.get("ownerId") != ObjectId(user_id):
        raise HTTPException(status_code=403, detail="Only owner can update board")
    
    board_doc = board.model_dump(exclude_unset=True, exclude={"id", "ownerId", "createdAt"})
    board_doc["updatedAt"] = datetime.utcnow()
    
    board_collection.find_one_and_update({"_id": oid}, {"$set": board_doc})
    updated = board_collection.find_one({"_id": oid})
    return board_individual_serial(updated)

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_board(id: str, user_id: str = Depends(get_current_user_id)):
    """Delete a board"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    
    oid = ObjectId(id)
    existing = board_collection.find_one({"_id": oid})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Only owner can delete board
    if existing.get("ownerId") != ObjectId(user_id):
        raise HTTPException(status_code=403, detail="Only owner can delete board")
    
    board_collection.find_one_and_delete({"_id": oid})
    return None

@router.post("/{id}/members", status_code=status.HTTP_200_OK)
async def add_member(id: str, member_data: dict, user_id: str = Depends(get_current_user_id)):
    """Add a member to board"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid board ID")
    
    member_user_id = member_data.get("userId")
    role = member_data.get("role", "member")
    
    if not ObjectId.is_valid(member_user_id):
        raise HTTPException(status_code=400, detail="Invalid member user ID")
    
    oid = ObjectId(id)
    existing = board_collection.find_one({"_id": oid})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Only owner can add members
    if existing.get("ownerId") != ObjectId(user_id):
        raise HTTPException(status_code=403, detail="Only owner can add members")
    
    # Check if member already exists
    members = existing.get("members", [])
    member_oid = ObjectId(member_user_id)
    if any(m.get("userId") == member_oid for m in members):
        raise HTTPException(status_code=400, detail="Member already exists")
    
    # Add member
    board_collection.update_one(
        {"_id": oid},
        {
            "$push": {"members": {"userId": member_oid, "role": role}},
            "$set": {"updatedAt": datetime.utcnow()}
        }
    )
    
    updated = board_collection.find_one({"_id": oid})
    return board_individual_serial(updated)

@router.delete("/{id}/members/{member_id}", status_code=status.HTTP_200_OK)
async def remove_member(id: str, member_id: str, user_id: str = Depends(get_current_user_id)):
    """Remove a member from board"""
    if not ObjectId.is_valid(id) or not ObjectId.is_valid(member_id):
        raise HTTPException(status_code=400, detail="Invalid ID")
    
    oid = ObjectId(id)
    existing = board_collection.find_one({"_id": oid})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Board not found")
    
    # Only owner can remove members
    if existing.get("ownerId") != ObjectId(user_id):
        raise HTTPException(status_code=403, detail="Only owner can remove members")
    
    # Remove member
    board_collection.update_one(
        {"_id": oid},
        {
            "$pull": {"members": {"userId": ObjectId(member_id)}},
            "$set": {"updatedAt": datetime.utcnow()}
        }
    )
    
    updated = board_collection.find_one({"_id": oid})
    return board_individual_serial(updated)