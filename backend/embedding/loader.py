import os

import torch
from transformers import AutoModel, AutoTokenizer

# モデルとトークナイザーを一度だけロードして再利用する
_embedding_model = None
_embedding_tokenizer = None
_embedding_model_name = "BAAI/bge-m3"


def load_embedding_model():
    """
    BAAI/bge-m3 モデルとトークナイザーをキャッシュして返す。
    GPU があれば float16、なければ float32 でロードし、適切なデバイスに配置。
    """
    global _embedding_model, _embedding_tokenizer  # ←★追加！

    if _embedding_model is None or _embedding_tokenizer is None:
        use_mock = os.getenv("USE_MOCK_MODEL", "false").lower() == "true"

        if use_mock:
            _embedding_model = "mock_model"
            _embedding_tokenizer = "mock_tokenizer"
        else:
            # 利用可能なら GPU、なければ CPU
            device = "cuda" if torch.cuda.is_available() else "cpu"
            # トークナイザー読み込み
            _embedding_tokenizer = AutoTokenizer.from_pretrained(
                _embedding_model_name, force_download=False
            )
            # モデル読み込み (GPU 時は半精度で)
            dtype = torch.float16 if device == "cuda" else torch.float32
            _embedding_model = AutoModel.from_pretrained(
                _embedding_model_name, torch_dtype=dtype, force_download=False
            ).to(device)
    return _embedding_model, _embedding_tokenizer
