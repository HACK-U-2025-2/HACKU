from fastapi import FastAPI
from routers import memo

app = FastAPI()

app.include_router(memo.router)
