# routes/auth.py
from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.security import OAuth2PasswordRequestForm, HTTPBearer, HTTPAuthorizationCredentials
from models.user import UserCreate
from config.database import users_collection
from config.jwt import decode_access_token , create_access_token
from passlib.context import CryptContext
from datetime import datetime
from bson import ObjectId

router = APIRouter(prefix="/auth", tags=["auth"])

pwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")
bearer_scheme = HTTPBearer()

# ======== Utility functions ========
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

def get_current_user_id(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    user_id = decode_access_token(token)
    return user_id



# ======== Register API ========
@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate):
    # check username exists
    if users_collection.find_one({"userName": user.userName}):
        raise HTTPException(status_code=400, detail="Username đã tồn tại")
    # Tạo document mới
    user_doc = {
        "userName": user.userName,
        "password": hash_password(user.password),
        "boards": [],
        "role": "member",
        "createdAt": datetime.utcnow(),
        "lastLogin": None
    }
    result = users_collection.insert_one(user_doc)
    return {
        "id": str(result.inserted_id),
        "userName": user.userName,
        "role": "member"
    }

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = users_collection.find_one({"userName": form_data.username})

    if not user or not verify_password(form_data.password, user["password"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sai username hoặc password")
    
    # Cập nhật thời gian đăng nhập
    users_collection.update_one(
        {"_id": ObjectId(user["_id"])},
        {"$set": {"lastLogin": datetime.utcnow()}}
    )

    # Tạo access token
    user_id_str = str(user["_id"])
    token = create_access_token(subject=user_id_str)

    return {
        "access_token": token,
        "token_type": "bearer",
        "user_id": user_id_str,
        "userName": user["userName"],
        "role": user.get("role", "member")
    }

@router.get("/getId")
async def get_user_id(user_id: str = Depends(get_current_user_id)):
    """
    Lấy thông tin user_id và userName từ token
    """
    # Tìm user trong database
    user = users_collection.find_one({"_id": ObjectId(user_id)})
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User không tồn tại"
        )
    
    return {
        "user_id": user_id,
        "userName": user["userName"],
        "role": user.get("role", "member")
    }

# ======== Get Current User Info API (Optional - thông tin đầy đủ hơn) ========


@router.get("/me")
async def get_current_user(user_id: str = Depends(get_current_user_id)):
    """
    Lấy thông tin đầy đủ của user hiện tại
    """
    user = users_collection.find_one({"_id": ObjectId(user_id)})
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User không tồn tại"
        )
    
    return {
        "id": str(user["_id"]),
        "userName": user["userName"],
        "role": user.get("role", "member"),
        "boards": user.get("boards", []),
        "createdAt": user.get("createdAt"),
        "lastLogin": user.get("lastLogin")
    }