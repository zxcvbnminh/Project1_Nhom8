# routes/route.py
from fastapi import APIRouter
from .auth import router as auth_router
# from .todo import router as todos_router
from .board_routes import router as board_router
from .list_routes import router as list_router
from .card_routes import router as card_router

router = APIRouter()
router.include_router(auth_router)
# router.include_router(todos_router)
router.include_router(board_router)
router.include_router(list_router)
router.include_router(card_router)