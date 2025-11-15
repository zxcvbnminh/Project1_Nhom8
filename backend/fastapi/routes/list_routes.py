# routes/lists.py
from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config.database import list_collection, board_collection
from schema.schemas import list_list_serial, list_individual_serial
from models.list import ListModel
from config.jwt import decode_access_token
from bson import ObjectId

router = APIRouter(prefix="/lists", tags=["lists"])
bearer_scheme = HTTPBearer()

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    user_id = decode_access_token(token)
    return user_id

def check_board_access(board_id: str, user_id: str):
    """Kiểm tra user có quyền truy cập board không"""
    if not ObjectId.is_valid(board_id):
        raise HTTPException(status_code=400, detail="Invalid board ID")
    
    board = board_collection.find_one({"_id": ObjectId(board_id)})
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    user_oid = ObjectId(user_id)
    is_owner = board.get("ownerId") == user_oid
    is_member = any(m.get("userId") == user_oid for m in board.get("members", []))
    
    if not (is_owner or is_member):
        raise HTTPException(status_code=403, detail="Not allowed to access this board")
    
    return board

@router.get("/board/{board_id}", status_code=status.HTTP_200_OK)
async def get_lists_by_board(board_id: str, user_id: str = Depends(get_current_user_id)):
    """Get all lists in a board"""
    try:
        # Kiểm tra quyền truy cập board
        check_board_access(board_id, user_id)
        
        # Lấy tất cả lists của board, sắp xếp theo position
        lists_cursor = list_collection.find({"boardId": ObjectId(board_id)}).sort("position", 1)
        lists = list(lists_cursor)
        return list_list_serial(lists)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_list(list_data: ListModel, user_id: str = Depends(get_current_user_id)):
    """Create a new list in a board"""
    try:
        # Kiểm tra quyền truy cập board
        board_id = str(list_data.boardId)
        check_board_access(board_id, user_id)
        
        # Chuyển thành dict
        list_dict = list_data.model_dump(
            by_alias=True,
            exclude_unset=True,
            exclude={"id"}
        )
        
        # Đảm bảo boardId là ObjectId
        list_dict["boardId"] = ObjectId(board_id)
        
        # Nếu không có position, tự động gán position cuối cùng
        if "position" not in list_dict or list_dict["position"] == 0:
            max_position = list_collection.find_one(
                {"boardId": ObjectId(board_id)},
                sort=[("position", -1)]
            )
            list_dict["position"] = (max_position.get("position", 0) + 1) if max_position else 0
        
        # Khởi tạo cards rỗng nếu chưa có
        if "cards" not in list_dict:
            list_dict["cards"] = []
        
        result = list_collection.insert_one(list_dict)
        created_list = list_collection.find_one({"_id": result.inserted_id})
        
        return list_individual_serial(created_list)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{id}", status_code=status.HTTP_200_OK)
async def get_list(id: str, user_id: str = Depends(get_current_user_id)):
    """Get a specific list by ID"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid list ID")
    
    list_doc = list_collection.find_one({"_id": ObjectId(id)})
    
    if not list_doc:
        raise HTTPException(status_code=404, detail="List not found")
    
    # Kiểm tra quyền truy cập board
    board_id = str(list_doc.get("boardId"))
    check_board_access(board_id, user_id)
    
    return list_individual_serial(list_doc)

@router.put("/{id}", status_code=status.HTTP_200_OK)
async def update_list(id: str, list_data: ListModel, user_id: str = Depends(get_current_user_id)):
    """Update a list"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid list ID")
    
    existing = list_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="List not found")
    
    # Kiểm tra quyền truy cập board
    board_id = str(existing.get("boardId"))
    check_board_access(board_id, user_id)
    
    # Chuẩn bị data update
    list_dict = list_data.model_dump(
        exclude_unset=True,
        exclude={"id", "boardId"}  # Không cho phép đổi boardId
    )
    
    list_collection.find_one_and_update(
        {"_id": ObjectId(id)},
        {"$set": list_dict}
    )
    
    updated = list_collection.find_one({"_id": ObjectId(id)})
    return list_individual_serial(updated)

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_list(id: str, user_id: str = Depends(get_current_user_id)):
    """Delete a list"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid list ID")
    
    existing = list_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="List not found")
    
    # Kiểm tra quyền truy cập board
    board_id = str(existing.get("boardId"))
    check_board_access(board_id, user_id)
    
    list_collection.find_one_and_delete({"_id": ObjectId(id)})
    return None

@router.put("/{id}/position", status_code=status.HTTP_200_OK)
async def update_list_position(id: str, new_position: dict, user_id: str = Depends(get_current_user_id)):
    """Update list position (for drag & drop)"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid list ID")
    
    existing = list_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="List not found")
    
    # Kiểm tra quyền truy cập board
    board_id = str(existing.get("boardId"))
    check_board_access(board_id, user_id)
    
    position = new_position.get("position")
    if position is None:
        raise HTTPException(status_code=400, detail="Position is required")
    
    list_collection.update_one(
        {"_id": ObjectId(id)},
        {"$set": {"position": position}}
    )
    
    updated = list_collection.find_one({"_id": ObjectId(id)})
    return list_individual_serial(updated)