from llm.utils.generator import generate_text
from llm.utils.parser import parse_json

def classify_memo_llm(created_at: str, body: str) -> dict:
    """
    LLMを使って「アイデア」「日記」「ヒント」か「タスク（ToDo）」か分類し、
    タスクの場合のみ推定実行日（Timestamp）が含まれる場合はその日付もテキストで返す。
    例: "アイデア" / "日記" / "タスク 2025-06-15 15:00:00" / "タスク" など
    """
    prompt = f"""
次の「作成日時」と「本文」をもとに、このメモが
- アイデア、日記、ヒントなど参照価値があるものか
- それともタスク、ToDo、予定など実行型のメモか
を判定してください。

「アイデア」「日記」「ヒント」などの場合は、その種類名だけ出力してください（例: アイデア）。
タスク・ToDo・予定などの場合は「タスク」と出力し、もし本文から実行日が読み取れる場合は「タスク YYYY-MM-DD HH:MM:SS」の形式で実行日も付与してください（例: タスク 2025-06-15 15:00:00）。

# 作成日時
{created_at}
# 本文
{body}
"""
    # LLMは必ず{"result": "<テキスト>"}形式のJSONを返す
    raw_result = generate_text(prompt, enable_thinking=False, max_new_tokens=64)
    result = parse_json(raw_result)
    return result  # 例: "アイデア" / "タスク 2025-06-15 15:00:00"