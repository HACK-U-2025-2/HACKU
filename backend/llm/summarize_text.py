from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def summarize_text(text: str) -> str:
    prompt = f"""
# 指示
以下の文章を簡潔に要約し、段落つきの箇条書き等を使用し、スライドで発表しやすい形になるようMarkdown形式で出力してください。

# 文章
{text}
"""
    json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=512)
    print(json_text)
    return parse_json(json_text)
