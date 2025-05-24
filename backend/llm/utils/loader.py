import logging

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

logger = logging.getLogger(__name__)

_model = None
_tokenizer = None

# 使用モデル
_model_name = "Qwen/Qwen3-4B"


def load_model():
    """
    モデルとトークナイザーを一度だけロードして返す。
    ・GPU が利用可能な場合：モデルを FP16/BF16 でロード（device_map="auto"）
    ・GPU が使えない場合：モデルをロードしない (Noneのまま)
    """
    global _model, _tokenizer

    if _model is None or _tokenizer is None:
        # GPU の利用可否を判定
        use_gpu = torch.cuda.is_available()

        if use_gpu:
            # GPU 向け：自動で dtype と device_map を設定
            _tokenizer = AutoTokenizer.from_pretrained(_model_name)
            _model = AutoModelForCausalLM.from_pretrained(
                _model_name, torch_dtype="auto", device_map="auto"
            )
        else:
            logger.warning(f"GPU使用可否: use_gpu={use_gpu} -> モックLLMを使用します")
            _model = "mock_llm"
            _tokenizer = "mock_tokenizer"

    return _model, _tokenizer
