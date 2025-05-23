import asyncio

from models.memo import Memos
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos


# 指定されたメモが正常に変更されるか(websocket)
def test_normal_update_websocket(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    body = "成功"

    with client.websocket_connect(
        f"/memos/{memo_id}/body", headers=headers
    ) as websocket:
        websocket.send_json({"body": body})

        response = websocket.receive_json()
        assert response["status"] == "success"
        assert response["memo_id"] == memo_id

        asyncio.run(asyncio.sleep(1.2))

        updated_memo = (
            test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
        )
        assert updated_memo is not None
        assert updated_memo.body == body


# 存在しないメモを指定した場合に正常に通信が行われるかwebsocket)
def test_empty_memo_websocket(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    body = "失敗"

    with client.websocket_connect(
        f"/memos/{memo_id}/body", headers=headers
    ) as websocket:
        websocket.send_json({"body": body})

        response = websocket.receive_json()
        assert response["status"] == "error"


# 異なるユーザのメモを指定した場合に正常に通信が行われるか(websocket)
def test_failure_id_websocket(test_db, client):
    user_id = "b"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, EMPTY_MEMOS)

    memo_id = 1
    body = "失敗"

    with client.websocket_connect(
        f"/memos/{memo_id}/body", headers=headers
    ) as websocket:
        websocket.send_json({"body": body})

        response = websocket.receive_json()
        assert response["status"] == "error"


# 複数回更新したときに最後の更新が反映されるか(websocket)
def test_multiple_updates_websocket(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    bodies = ["更新1", "更新２", "成功"]

    with client.websocket_connect(
        f"/memos/{memo_id}/body", headers=headers
    ) as websocket:
        websocket.send_json({"body": bodies[0]})
        response1 = websocket.receive_json()
        assert response1["status"] == "success"

        websocket.send_json({"body": bodies[1]})
        response2 = websocket.receive_json()
        assert response2["status"] == "success"

        websocket.send_json({"body": bodies[2]})
        response3 = websocket.receive_json()
        assert response3["status"] == "success"

    asyncio.run(asyncio.sleep(1.2))

    updated_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )

    assert updated_memo.body == bodies[2]


# WebSocketの途中で接続が切れた場合に問題なく処理される
def test_websocket_disconnect_midway(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    memo_id = 1
    body = "成功"

    with client.websocket_connect(
        f"/memos/{memo_id}/body", headers=headers
    ) as websocket:
        websocket.send_json({"body": body})
        response = websocket.receive_json()
        assert response["status"] == "success"

        websocket.close()

    asyncio.run(asyncio.sleep(1.2))

    updated_memo = (
        test_db.query(Memos).filter_by(id=memo_id, user_id=user_id).one_or_none()
    )

    assert updated_memo.body == body
