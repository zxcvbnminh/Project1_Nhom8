from pymongo import MongoClient

MONGO_URI = "mongodb+srv://nguyenhuutam114_db_user:test1234@cluster0.h5eo7w9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = MongoClient(MONGO_URI)
db = client.todo_db
# Collections
users_collection = db["users"]
# todo_collection = db["todo_collection"]
board_collection = db["boards_collection"]
list_collection = db["lists_collection"]   # ← Thêm dòng này
card_collection = db["cards_collection"]