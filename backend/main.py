from contextlib import asynccontextmanager

from fastapi import FastAPI
from llm.loader import load_model
from routers import auth, memo, tag


@asynccontextmanager
async def lifespan(app: FastAPI):
    # サーバ起動時に一度だけモデルをロード
    load_model()
    yield


# FastAPI インスタンスに lifespan を渡す
app = FastAPI(lifespan=lifespan)


app.include_router(auth.router)
app.include_router(memo.router)
app.include_router(tag.router)
