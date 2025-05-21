from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def clean_transcript(text: str) -> str:
    prompt = f"""
# 指示
以下の文章を、次の要件に従って修正してください。

# 要件
- 誤字・脱字の修正
- 適切な句読点の追加
- カタカナ語を適切な英語表記に変換
- 文法の整合性を保ち、自然で読みやすい日本語にする

変更後の文章のみを出力してください。

# 文章
{text}
"""
    json_text = generate_text(prompt, enable_thinking=True, max_new_tokens=8192)
    return parse_json(json_text)
