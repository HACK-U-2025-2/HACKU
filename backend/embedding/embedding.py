import torch

from .loader import load_embedding_model


def get_embedding(text: str) -> list:
    """
    テキストをモデルで埋め込みベクトル化し、リストで返します。
    """
    model, tokenizer = load_embedding_model()
    device = next(model.parameters()).device

    with torch.no_grad():
        # トークナイズしてデバイスへ転送
        inputs = tokenizer([text], return_tensors="pt", padding=True, truncation=True)
        inputs = {k: v.to(device) for k, v in inputs.items()}
        # モデル推論とベクトル算出
        outputs = model(**inputs)
        vec = outputs.last_hidden_state.mean(dim=1)

    # CPU上に移動し、NumPy配列をリスト形式で返す
    return vec[0].cpu().numpy().tolist()
