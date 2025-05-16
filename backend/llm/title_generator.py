from llm.loader import load_model

def generate_title(text: str) -> str:
    """
    与えられた文章 text からタイトルを1文で生成して返す。
    """
    model, tokenizer = load_model()

    # タイトル生成用プロンプト
    prompt = f"""
# 指示
次のメモをタイトルを3-4単語で考えて

# 禁止事項
タイトル以外を出力しないこと

# 文章
{text}
"""
    messages = [{"role": "user", "content": prompt}]
    prepared = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True,
        enable_thinking=False
    )

    # トークナイズしてモデルに渡す
    inputs = tokenizer([prepared], return_tensors="pt", padding=True).to(model.device)
    output_ids = model.generate(
        **inputs,
        max_new_tokens=12, # 最低限
        do_sample=True, # 要検討
        )[0]

    # 入力部分を除いた生成トークンだけをデコード
    input_len = inputs.input_ids.shape[1]
    gen_ids = output_ids.tolist()[input_len:]
    title = tokenizer.decode(gen_ids, skip_special_tokens=True).strip()

    return title