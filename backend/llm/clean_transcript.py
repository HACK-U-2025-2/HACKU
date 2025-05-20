from llm.loader import load_model


def clean_transcript(text: str) -> str:
    """
    与えられた文章の誤字脱字を修正して返す
    （内部で thinking-mode のタグを除去）
    """
    model, tokenizer = load_model()

    prompt = f"""
# 指示
以下の文章を、以下の要件に従って修正してください。

- 誤字・脱字の修正
- 適切な句読点の追加
- カタカナ語を適切な英語表記に変換
- 文法の整合性を保ち、自然で読みやすい日本語にする

変更後の文章のみを出力してください。

# 文章
{text}
"""
    messages = [{"role": "user", "content": prompt}]
    prepared = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True,
        enable_thinking=True,  # thinking-mode を有効化
    )

    # トークナイズしてモデルに渡す
    inputs = tokenizer([prepared], return_tensors="pt", padding=True).to(model.device)
    output_ids = model.generate(
        **inputs,
        max_new_tokens=8192,  # 必要に応じて調整
        do_sample=True,
    )[0]

    # 生成トークン列から入力部分を除去
    input_len = inputs.input_ids.shape[1]
    gen_ids = output_ids.tolist()[input_len:]

    # </think> のトークンID
    THINK_END_ID = 151668

    # </think> の位置を後ろから探す
    try:
        cut_index = len(gen_ids) - gen_ids[::-1].index(THINK_END_ID)
    except ValueError:
        cut_index = 0

    # 思考部分を除いたあとのコンテンツだけをデコード
    content_ids = gen_ids[cut_index:]
    cleaned_text = tokenizer.decode(content_ids, skip_special_tokens=True).strip()

    return cleaned_text
