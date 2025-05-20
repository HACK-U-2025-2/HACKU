import pytest
from tests.mock_data.memo import EMPTY_MEMOS, SHORT_MEMOS
from tests.utils.auth import get_headers
from tests.utils.post import create_test_memos


def test_demo(test_db, client):
    user_id = "a"
    headers = get_headers(user_id, client)
    create_test_memos(test_db, SHORT_MEMOS)

    response = client.get("/", headers=headers)
    assert response.status_code == 200

    data = response.json()

    assert len(data) == 3
