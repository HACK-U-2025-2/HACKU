from fastapi import FastAPI
from contextlib import asynccontextmanager
from routers import memo
from app.llm.loader import load_model

async def lifespan(app: FastAPI):
    # サーバ起動時に一度だけモデルをロード
    load_model()
    yield

# FastAPI インスタンスに lifespan を渡す
app = FastAPI(lifespan=lifespan)

app.include_router(memo.router)