import json

from llm.utils.loader import load_llm_model


def generate_text(prompt: str, enable_thinking: bool, max_new_tokens: int) -> str:
    model, tokenizer = load_llm_model()

    if model == "mock_model":
        clean_prompt = prompt.replace("\n", "")
        mock_result = f"モック応答（プロンプト: {clean_prompt[:25]}...）"
        return json.dumps({"result": mock_result})

    # JSON形式の出力を強制するプロンプト設計
    json_prompt = f"""
# 指示
次の指示を実行し、結果を必ずJSON形式で返してください。
結果は必ず{{"result": "<生成した内容>"}}の形式で出力してください。
JSON以外のテキストを絶対に出力してはいけません。

{prompt}

# 出力
"""

    messages = [{"role": "user", "content": json_prompt}]
    prepared = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=True,
        enable_thinking=enable_thinking,
    )

    inputs = tokenizer([prepared], return_tensors="pt", padding=True).to(model.device)

    output_ids = model.generate(
        **inputs,
        max_new_tokens=max_new_tokens,
        do_sample=True,
    )[0]

    input_len = inputs.input_ids.shape[1]
    gen_ids = output_ids.tolist()[input_len:]

    if enable_thinking:
        THINK_END_ID = 151668
        try:
            cut_index = len(gen_ids) - gen_ids[::-1].index(THINK_END_ID)
        except ValueError:
            cut_index = 0
        content_ids = gen_ids[cut_index:]
    else:
        content_ids = gen_ids

    generated_json = tokenizer.decode(content_ids, skip_special_tokens=True).strip()

    return generated_json
