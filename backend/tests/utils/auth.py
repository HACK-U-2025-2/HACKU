def get_headers(user_id, client):
    token_response = client.post("/auth", json={"user_id": user_id})

    token = token_response.json()["access_token"]

    return {"Authorization": f"Bearer {token}"}
