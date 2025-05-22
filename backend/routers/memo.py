import asyncio
from typing import Annotated, List, Optional

from crud.auth import get_current_user
from crud.memo import (
    delete_memo_by_id,
    fetch_memo_by_id,
    fetch_memos,
    update_memo_by_id,
)
from database import get_db
from fastapi import (
    APIRouter,
    Depends,
    Header,
    HTTPException,
    Query,
    WebSocket,
    WebSocketDisconnect,
    status,
)
from schemas.auth import DecodedToken
from schemas.memo import (
    MemoBodyUpdateRequest,
    MemoPreviewResponse,
    MemoResponse,
    MemoTagsUpdateRequest,
    MemoTitleUpdateRequest,
)
from schemas.tag import TagResponse
from sqlalchemy.orm import Session
from starlette import status

DbDependency = Annotated[Session, Depends(get_db)]

UserDependency = Annotated[DecodedToken, Depends(get_current_user)]

router = APIRouter(prefix="/memos", tags=["Memos"])


@router.get(
    "/", response_model=List[MemoPreviewResponse], status_code=status.HTTP_200_OK
)
async def read_memos(
    db: DbDependency,
    user: UserDependency,
    keyword: Optional[str] = Query(None, description="検索キーワード"),
    tags: Optional[List[str]] = Query(None, description="タグでの絞り込み"),
    sort: Optional[str] = Query(None, description="ソート順(別issue)"),
):
    memos = fetch_memos(db=db, user_id=user.user_id, search_word=keyword, tags=tags)
    return [MemoPreviewResponse.model_validate(m) for m in memos]


@router.get("/{memo_id}", response_model=MemoResponse, status_code=status.HTTP_200_OK)
async def read_memo(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = fetch_memo_by_id(db=db, user_id=user.user_id, memo_id=memo_id)
    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    tag_response = [TagResponse.model_validate(memo_tag.tag) for memo_tag in memo.tags]
    memo_response = MemoResponse.model_validate({**memo.__dict__, "tags": tag_response})

    return memo_response


@router.put("/{memo_id}/title", status_code=status.HTTP_200_OK)
async def write_title(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTitleUpdateRequest,
):

    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, title=request.title
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return


@router.put("/{memo_id}/body", status_code=status.HTTP_200_OK)
async def write_body(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoBodyUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, body=request.body
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return


@router.put("/{memo_id}/tags", status_code=status.HTTP_200_OK)
async def write_tags(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
    request: MemoTagsUpdateRequest,
):
    memo = update_memo_by_id(
        db=db, user_id=user.user_id, memo_id=memo_id, tag_names=request.tag_names
    )

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")

    return


@router.delete("/{memo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_memo(
    db: DbDependency,
    user: UserDependency,
    memo_id: int,
):
    memo = delete_memo_by_id(db=db, user_id=user.user_id, memo_id=memo_id)

    if memo is None:
        raise HTTPException(status_code=404, detail="Memo not found")
    return


@router.websocket("/{memo_id}/body")
async def websocket_memo_body(
    websocket: WebSocket, db: DbDependency, user: UserDependency, memo_id: int
):
    await websocket.accept()

    memo = get_memo_by_id(db, user.user_id, memo_id)

    if memo is None:
        await websocket.send_json({"status": "error", "detail": "Memo not found"})
        await websocket.close()
        return

    latest_body_ref = {"body": memo.body}
    db_body_hash_ref = {"hash": hash(memo.body)}

    lock = asyncio.Lock()

    async def batch_update_loop():  # 1秒ごとにbodyの変更をDBに反映
        while True:
            await asyncio.sleep(1)
            await update_if_changed(
                db=db,
                user_id=user.user_id,
                memo_id=memo_id,
                latest_body_ref=latest_body_ref,
                db_body_hash_ref=db_body_hash_ref,
                lock=lock,
            )

    batch_task = asyncio.create_task(batch_update_loop())

    try:
        while True:
            new_body = receive_valid_body(websocket=websocket)
            if new_body is None:
                continue

            async with lock:
                if hash(new_body) == db_body_hash_ref["hash"]:
                    continue
                latest_body_ref["body"] = new_body

            await websocket.send_json({"status": "success", "memo_id": memo_id})

    except WebSocketDisconnect:  # 通信終了時に最終状態をDBに反映
        batch_task.cancel()
        try:
            await batch_task
        except asyncio.CancelledError:
            pass

        await update_if_changed(
            db, user.user_id, memo_id, latest_body_ref, db_body_hash_ref, lock
        )
        await websocket.close()


async def update_if_changed(  # 最新のbodyとDBのハッシュを比較し、変更があればDBを更新
    db: DbDependency,
    user_id: int,
    memo_id: int,
    latest_body_ref: dict,
    db_body_hash_ref: dict,
    lock: asyncio.Lock,
):
    async with lock:
        latest_body_hash = hash(latest_body_ref["body"])
        if latest_body_hash != db_body_hash_ref["hash"]:
            await asyncio.to_thread(
                update_memo_by_id,
                db=db,
                user_id=user_id,
                memo_id=memo_id,
                body=latest_body_ref["body"],
            )
            db_body_hash_ref["hash"] = latest_body_hash


async def receive_valid_body(  # WebSocketから受け取ったbodyの形式を検証
    websocket: WebSocket,
):
    try:
        data = await websocket.receive_json()
    except ValueError:
        await websocket.send_json({"error": "Invalid JSON format"})
        return None

    new_body = data.get("body")

    if not isinstance(new_body, str):
        await websocket.send_json({"error": "Invalid payload"})
        return None

    return new_body
