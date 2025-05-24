class BodyState:
    def __init__(self, body: str):
        self.body = body
        self.hash = hash(body)

    def update(self, new_body: str):
        self.body = new_body
        self.hash = hash(new_body)
