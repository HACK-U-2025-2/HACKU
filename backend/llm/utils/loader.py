from transformers import AutoModelForCausalLM, AutoTokenizer

_model = None
_tokenizer = None
_model_name = "Qwen/Qwen3-4B"


def load_model():
    """
    モデルとトークナイザーを一度だけロードしてキャッシュし、返す。
    """
    global _model, _tokenizer
    if _model is None or _tokenizer is None:
        _tokenizer = AutoTokenizer.from_pretrained(_model_name)
        _model = AutoModelForCausalLM.from_pretrained(
            _model_name, torch_dtype="auto", device_map="auto"
        )
    return _model, _tokenizer
