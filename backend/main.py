from contextlib import asynccontextmanager

from fastapi import FastAPI
from llm.loader import load_model
from routers import memo


async def lifespan(app: FastAPI):
    # サーバ起動時に一度だけモデルをロード
    load_model()
    yield


# FastAPI インスタンスに lifespan を渡す
app = FastAPI(lifespan=lifespan)

app.include_router(memo.router)
