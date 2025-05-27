import logging
from contextlib import asynccontextmanager

from embedding.loader import load_embedding_model
from fastapi import FastAPI
from llm.utils.loader import load_llm_model
from routers import auth, memo, memo_websocket, tag

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # ── ① モデル類をロード ─────────────────────────────
    model, tokenizer = load_llm_model()
    load_embedding_model()

    # ── ② ウォームアップ ────────────────────────────────
    #    1 トークンだけ生成して KV キャッシュ確保 & カーネル JIT を済ませる
    try:
        # モックならウォームアップ不要
        if model != "mock_llm":
            dummy = tokenizer("<warmup>", return_tensors="pt").to(model.device)
            model.generate(**dummy, max_new_tokens=1)
            logger.warning("LLM warm-up completed")
        else:
            logger.warning("LLM warm-up skipped (mock mode)")
    except Exception as e:
        logger.warning("LLM warm-up skipped: %s", e)

    # ── ③ アプリ起動へ ────────────────────────────────
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
