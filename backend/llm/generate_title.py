from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def generate_title(text: str) -> str:
    prompt = f"""
# 指示
以下の文章のタイトルを3-4単語で生成してください。

# 文章
{text}
"""
    json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=64)
    return parse_json(json_text)
