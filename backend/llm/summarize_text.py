from llm.loader import load_model


def summarize_text(text: str) -> str:
    """
    与えられた文章 text を要約してMarkdown形式で返す。
    """
    # モデルとトークナイザの読み込み
    model, tokenizer = load_model()

    # 要約用プロンプトの作成
    prompt = f"""
# 指示
次の文章を箇条書きで簡潔に要約して、Markdown形式で出力

# 文章
{text}
"""
    messages = [{"role": "user", "content": prompt}]
    prepared = tokenizer.apply_chat_template(
        messages, tokenize=False, add_generation_prompt=True, enable_thinking=False
    )

    # トークナイズしてモデルに渡す
    inputs = tokenizer([prepared], return_tensors="pt", padding=True).to(model.device)
    output_ids = model.generate(
        **inputs,
        max_new_tokens=256,  # 要調整
        do_sample=True,  # 要検討
    )[0]

    # 入力部分を除いた生成トークンだけをデコード
    input_len = inputs.input_ids.shape[1]
    gen_ids = output_ids.tolist()[input_len:]
    summary = tokenizer.decode(gen_ids, skip_special_tokens=True).strip()

    return summary
