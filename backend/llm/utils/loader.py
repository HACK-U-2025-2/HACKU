import logging
import os

from transformers import AutoModelForCausalLM, AutoTokenizer

logger = logging.getLogger(__name__)

_model = None
_tokenizer = None
_model_name = "Qwen/Qwen3-4B"


def load_model():
    """
    モデルとトークナイザーを一度だけロードして返す。
    環境変数 `USE_MOCK_LLM=true` の場合はモックを返し、falseの場合はモデルをロードする。
    """
    global _model, _tokenizer

    if _model is None or _tokenizer is None:
        use_mock = os.getenv("USE_MOCK_LLM", "false").lower() == "true"
        logger.warning("INFO:     USE_MOCK_LLM = %s", use_mock)

        if use_mock:
            _model = "mock_llm"
            _tokenizer = "mock_tokenizer"
        else:
            _tokenizer = AutoTokenizer.from_pretrained(_model_name)
            _model = AutoModelForCausalLM.from_pretrained(
                _model_name,
                torch_dtype="auto",
                device_map="auto"
            )

    return _model, _tokenizer