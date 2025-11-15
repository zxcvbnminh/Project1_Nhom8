# # from fastapi import FastAPI
# # from routes.route import router  
# # app = FastAPI()

# # app.include_router(router)

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes.route import router  # Import router của bạn

app = FastAPI()

# ========================================
# CORS MIDDLEWARE - QUAN TRỌNG CHO FLUTTER WEB
# ========================================
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:*",
        "http://127.0.0.1:*",
        "http://localhost:53841",  # Flutter web default port
        "http://localhost:8080",
        "*"  # Cho phép tất cả (development only)
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],  # Tất cả methods
    allow_headers=["*"],  # Tất cả headers
    expose_headers=["*"],
)

# Include router
app.include_router(router)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        app, 
        host="0.0.0.0",  # Cho phép access từ mọi nơi
        port=8000, 
        reload=True,
        log_level="info"
    )
