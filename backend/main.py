from contextlib import asynccontextmanager

from fastapi import FastAPI
from llm.utils.loader import load_model
from routers import auth, memo, memo_websocket, tag


@asynccontextmanager
async def lifespan(app: FastAPI):
    # サーバ起動時に一度だけモデルをロード
    load_model()
    yield


# FastAPI インスタンスに lifespan を渡す
app = FastAPI(
    title="mindly",
    description="アイデアを即時に記録・管理するためのAPI",
    version="1.0.0",
    lifespan=lifespan,
)

app.include_router(auth.router)
app.include_router(tag.router)
app.include_router(memo.router)
app.include_router(memo_websocket.router)