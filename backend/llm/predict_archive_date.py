from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def predict_archive_date(created_at: str, body: str) -> str:
    """
    メモの作成日時（PostgreSQLのタイムスタンプ）と本文をもとに、
    アーカイブ予定日を推定し、PostgreSQLのタイムスタンプ形式で返す。
    """
    prompt = f"""
# 指示
以下の「作成日時」と「本文」をもとに、このメモがアーカイブされるべき日付を予測してください。
出力は必ず「YYYY-MM-DD HH:MI:SS」形式のタイムスタンプで返してください。

# 作成日時
{created_at}

# 本文
{body}
"""
    json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=32)
    return parse_json(json_text)