from llm.utils.generator import generate_text


def summarize_text(text: str) -> str:
    prompt = f"""
# 指示
以下の文章を分かりやすく要約してください。

# 要件
- 段落つきの箇条書き等を活用し、情報を整理してください
- Markdown形式で出力してください
- 見出し行（タイトル行）は不要です
- 重要語句は**太字**にしてください

# 出力例
- **背景**：本プロジェクトは2024年に開始された。
- **目的**：目的は業務効率化である。

# 文章
{text}
"""
    result_text = generate_text(
        prompt, enable_thinking=False, max_new_tokens=1024, json_output=False
    )
    return result_text
