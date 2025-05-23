import logging

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

logger = logging.getLogger(__name__)

_model = None
_tokenizer = None

_model_name = "Qwen/Qwen3-4B"
_small_model_name = "Qwen/Qwen3-0.6B"


def load_model():
    """
    モデルとトークナイザーを一度だけロードしてキャッシュし、返す
    GPU が使えない環境では _small_model_name を使用
    """
    global _model, _tokenizer
    if _model is None or _tokenizer is None:
        # GPU 利用可否をチェック
        use_gpu = torch.cuda.is_available()
        # 使用するモデル名とデバイスマップを選択
        model_name = _model_name if use_gpu else _small_model_name

        logger.warning(f"Loading model: {model_name}")

        # トークナイザーとモデルをロード
        _tokenizer = AutoTokenizer.from_pretrained(model_name)
        _model = AutoModelForCausalLM.from_pretrained(
            model_name, torch_dtype="auto", device_map="auto"
        )
    return _model, _tokenizer
