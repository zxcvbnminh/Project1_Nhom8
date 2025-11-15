# schema/schemas.py
from bson import ObjectId

def individual_serial(todo) -> dict:
    return {
        "id": str(todo.get("_id")),
        "owner_id": str(todo.get("owner_id")) if todo.get("owner_id") else None,
        "title": todo.get("title"),
        "completed": todo.get("completed", False)
    }

def list_serial(todos) -> list:
    return [individual_serial(todo) for todo in todos]


def board_individual_serial(board) -> dict:
    return {
        "id": str(board.get("_id")),
        "title": board.get("title"),
        "description": board.get("description"),
        "ownerId": str(board.get("ownerId")),
        "createdAt": board.get("createdAt").isoformat() if board.get("createdAt") else None,
        "updatedAt": board.get("updatedAt").isoformat() if board.get("updatedAt") else None,
        "members": [
            {
                "userId": str(m.get("userId")),
                "role": m.get("role")
            }
            for m in board.get("members", [])
        ]
    }

def board_list_serial(boards) -> list:
    return [board_individual_serial(board) for board in boards]

def list_individual_serial(list_doc) -> dict:
    return {
        "id": str(list_doc.get("_id")),
        "boardId": str(list_doc.get("boardId")),
        "title": list_doc.get("title"),
        "cards": [str(card_id) for card_id in list_doc.get("cards", [])]
    }

def list_list_serial(lists) -> list:
    return [list_individual_serial(list_doc) for list_doc in lists]

def card_individual_serial(card_doc) -> dict:
    return {
        "id": str(card_doc.get("_id")),
        "listId": str(card_doc.get("listId")),
        "title": card_doc.get("title"),
        "description": card_doc.get("description"),
        "assignee": str(card_doc.get("assignee")) if card_doc.get("assignee") else None,
        "labels": [str(label) for label in card_doc.get("labels", [])],
        "deadline": card_doc.get("deadline").isoformat() if card_doc.get("deadline") else None,
        "attachments": card_doc.get("attachments", []),
        "comments": [
            {
                "userId": str(comment.get("userId")),
                "content": comment.get("content"),
                "createdAt": comment.get("createdAt").isoformat() if comment.get("createdAt") else None
            }
            for comment in card_doc.get("comments", [])
        ],
        "position": card_doc.get("position", 0),
        "priority": card_doc.get("priority", 0),
        "createdAt": card_doc.get("createdAt").isoformat() if card_doc.get("createdAt") else None
    }

def card_list_serial(cards) -> list:
    return [card_individual_serial(card_doc) for card_doc in cards]