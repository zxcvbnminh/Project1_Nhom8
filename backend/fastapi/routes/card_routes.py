# routes/cards.py
from fastapi import APIRouter, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from config.database import card_collection, list_collection, board_collection
from schema.schemas import card_list_serial, card_individual_serial
from models.card import Card
from config.jwt import decode_access_token
from bson import ObjectId
from datetime import datetime

router = APIRouter(prefix="/cards", tags=["cards"])
bearer_scheme = HTTPBearer()

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    user_id = decode_access_token(token)
    return user_id

def check_list_access(list_id: str, user_id: str):
    """Kiểm tra user có quyền truy cập list (thông qua board) không"""
    if not ObjectId.is_valid(list_id):
        raise HTTPException(status_code=400, detail="Invalid list ID")
    
    list_doc = list_collection.find_one({"_id": ObjectId(list_id)})
    if not list_doc:
        raise HTTPException(status_code=404, detail="List not found")
    
    # Kiểm tra quyền truy cập board
    board_id = list_doc.get("boardId")
    board = board_collection.find_one({"_id": board_id})
    if not board:
        raise HTTPException(status_code=404, detail="Board not found")
    
    user_oid = ObjectId(user_id)
    is_owner = board.get("ownerId") == user_oid
    is_member = any(m.get("userId") == user_oid for m in board.get("members", []))
    
    if not (is_owner or is_member):
        raise HTTPException(status_code=403, detail="Not allowed to access this list")
    
    return list_doc

@router.get("/list/{list_id}", status_code=status.HTTP_200_OK)
async def get_cards_by_list(list_id: str, user_id: str = Depends(get_current_user_id)):
    """Get all cards in a list"""
    try:
        # Kiểm tra quyền truy cập list
        check_list_access(list_id, user_id)
        
        # Lấy tất cả cards của list, sắp xếp theo position
        cards_cursor = card_collection.find({"listId": ObjectId(list_id)}).sort("position", 1)
        cards = list(cards_cursor)
        return card_list_serial(cards)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/", status_code=status.HTTP_201_CREATED)
async def create_card(card_data: Card, user_id: str = Depends(get_current_user_id)):
    try:
        # listId đã là ObjectId → dùng trực tiếp
        list_id_obj = card_data.listId
        list_id_str = str(list_id_obj)

        # Kiểm tra quyền
        check_list_access(list_id_str, user_id)

        # Chuyển dict
        card_dict = card_data.model_dump(
            by_alias=True,
            exclude_unset=True,
            exclude={"id"}
        )

        # listId đã đúng kiểu
        card_dict["listId"] = list_id_obj

        # Xử lý assignee
        if card_dict.get("assignee"):
            card_dict["assignee"] = ObjectId(card_dict["assignee"])

        # Xử lý labels
        if card_dict.get("labels"):
            card_dict["labels"] = [
                ObjectId(label) if isinstance(label, str) and ObjectId.is_valid(label)
                else label for label in card_dict["labels"]
            ]

        # Tự động position
        if "position" not in card_dict or card_dict["position"] in (0, None):
            max_pos = card_collection.find_one(
                {"listId": list_id_obj},
                sort=[("position", -1)]
            )
            card_dict["position"] = (max_pos["position"] + 1) if max_pos else 0

        # Đảm bảo mặc định
        card_dict.setdefault("attachments", [])
        card_dict.setdefault("comments", [])
        card_dict["createdAt"] = datetime.utcnow()

        # Insert
        result = card_collection.insert_one(card_dict)
        created_card = card_collection.find_one({"_id": result.inserted_id})

        # Cập nhật list
        list_collection.update_one(
            {"_id": list_id_obj},
            {"$push": {"cards": result.inserted_id}}
        )

        return card_individual_serial(created_card)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/{id}", status_code=status.HTTP_200_OK)
async def get_card(id: str, user_id: str = Depends(get_current_user_id)):
    """Get a specific card by ID"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    card_doc = card_collection.find_one({"_id": ObjectId(id)})
    
    if not card_doc:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list
    list_id = str(card_doc.get("listId"))
    check_list_access(list_id, user_id)
    
    return card_individual_serial(card_doc)

@router.put("/{id}", status_code=status.HTTP_200_OK)
async def update_card(id: str, card_data: Card, user_id: str = Depends(get_current_user_id)):
    """Update a card"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    existing = card_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list
    list_id = str(existing.get("listId"))
    check_list_access(list_id, user_id)
    
    # Chuẩn bị data update
    card_dict = card_data.model_dump(
        exclude_unset=True,
        exclude={"id", "listId", "createdAt"}  # Không cho phép đổi listId
    )
    
    # Xử lý assignee
    if "assignee" in card_dict and card_dict["assignee"]:
        card_dict["assignee"] = ObjectId(card_dict["assignee"])
    
    # Xử lý labels
    if "labels" in card_dict and card_dict["labels"]:
        card_dict["labels"] = [ObjectId(label) if ObjectId.is_valid(label) else label for label in card_dict["labels"]]
    
    card_collection.find_one_and_update(
        {"_id": ObjectId(id)},
        {"$set": card_dict}
    )
    
    updated = card_collection.find_one({"_id": ObjectId(id)})
    return card_individual_serial(updated)

@router.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_card(id: str, user_id: str = Depends(get_current_user_id)):
    """Delete a card"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    existing = card_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list
    list_id = str(existing.get("listId"))
    check_list_access(list_id, user_id)
    
    # Xóa card khỏi list
    list_collection.update_one(
        {"_id": ObjectId(list_id)},
        {"$pull": {"cards": ObjectId(id)}}
    )
    
    # Xóa card
    card_collection.find_one_and_delete({"_id": ObjectId(id)})
    return None

@router.put("/{id}/move", status_code=status.HTTP_200_OK)
async def move_card(id: str, move_data: dict, user_id: str = Depends(get_current_user_id)):
    """Move card to another list or change position"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    existing = card_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list cũ
    old_list_id = str(existing.get("listId"))
    check_list_access(old_list_id, user_id)
    
    new_list_id = move_data.get("listId")
    new_position = move_data.get("position")
    
    # Nếu di chuyển sang list khác
    if new_list_id and new_list_id != old_list_id:
        if not ObjectId.is_valid(new_list_id):
            raise HTTPException(status_code=400, detail="Invalid new list ID")
        
        # Kiểm tra quyền truy cập list mới
        check_list_access(new_list_id, user_id)
        
        # Xóa card khỏi list cũ
        list_collection.update_one(
            {"_id": ObjectId(old_list_id)},
            {"$pull": {"cards": ObjectId(id)}}
        )
        
        # Thêm card vào list mới
        list_collection.update_one(
            {"_id": ObjectId(new_list_id)},
            {"$push": {"cards": ObjectId(id)}}
        )
        
        # Cập nhật listId và position của card
        update_data = {"listId": ObjectId(new_list_id)}
        if new_position is not None:
            update_data["position"] = new_position
        
        card_collection.update_one(
            {"_id": ObjectId(id)},
            {"$set": update_data}
        )
    elif new_position is not None:
        # Chỉ thay đổi position trong cùng list
        card_collection.update_one(
            {"_id": ObjectId(id)},
            {"$set": {"position": new_position}}
        )
    
    updated = card_collection.find_one({"_id": ObjectId(id)})
    return card_individual_serial(updated)

@router.post("/{id}/comments", status_code=status.HTTP_201_CREATED)
async def add_comment(id: str, comment_data: dict, user_id: str = Depends(get_current_user_id)):
    """Add a comment to a card"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    existing = card_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list
    list_id = str(existing.get("listId"))
    check_list_access(list_id, user_id)
    
    content = comment_data.get("content")
    if not content:
        raise HTTPException(status_code=400, detail="Comment content is required")
    
    comment = {
        "userId": ObjectId(user_id),
        "content": content,
        "createdAt": datetime.utcnow()
    }
    
    card_collection.update_one(
        {"_id": ObjectId(id)},
        {"$push": {"comments": comment}}
    )
    
    updated = card_collection.find_one({"_id": ObjectId(id)})
    return card_individual_serial(updated)

@router.post("/{id}/attachments", status_code=status.HTTP_201_CREATED)
async def add_attachment(id: str, attachment_data: dict, user_id: str = Depends(get_current_user_id)):
    """Add an attachment to a card"""
    if not ObjectId.is_valid(id):
        raise HTTPException(status_code=400, detail="Invalid card ID")
    
    existing = card_collection.find_one({"_id": ObjectId(id)})
    
    if not existing:
        raise HTTPException(status_code=404, detail="Card not found")
    
    # Kiểm tra quyền truy cập list
    list_id = str(existing.get("listId"))
    check_list_access(list_id, user_id)
    
    name = attachment_data.get("name")
    url = attachment_data.get("url")
    
    if not name or not url:
        raise HTTPException(status_code=400, detail="Attachment name and url are required")
    
    attachment = {
        "name": name,
        "url": url
    }
    
    card_collection.update_one(
        {"_id": ObjectId(id)},
        {"$push": {"attachments": attachment}}
    )
    
    updated = card_collection.find_one({"_id": ObjectId(id)})
    return card_individual_serial(updated)