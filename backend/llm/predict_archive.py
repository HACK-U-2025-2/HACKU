import datetime
from zoneinfo import ZoneInfo

from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def predict_archive(memo_text: str, created_at_str: str, tag_list: list[str]) -> bool:
    """
    メモの本文・作成日時・タグ情報から、アーカイブ（削除）してよいか判定する。
    STEP1は「経過日数」、STEP2は「経過日数」と「今日の日付」も考慮。
    """

    def to_japanese_date_str(dt: datetime.datetime) -> str:
        weekday_ja = "月火水木金土日"[dt.weekday()]
        return dt.strftime(f"%Y年%m月%d日({weekday_ja})")

    # JSTタイムゾーン指定
    JST = ZoneInfo("Asia/Tokyo")

    # 作成日（naive → aware）
    created_at_dt = datetime.datetime.strptime(
        created_at_str, "%Y-%m-%d %H:%M:%S"
    ).replace(tzinfo=JST)
    # 今日（aware）
    today_dt = datetime.datetime.now(JST)

    created_at_jp = to_japanese_date_str(created_at_dt)
    today_jp = to_japanese_date_str(today_dt)
    elapsed_days = (today_dt - created_at_dt).days
    tags_str = ", ".join(tag_list)

    # --- STEP1: タグで一次判定 ---
    prompt_tag_check = f"""
あなたはメモ整理アシスタントです。

次のタグリスト・メモ作成日・経過日数を踏まえて判定してください。

- タグに「予定」「ToDo」「買い物」「イベント」など**消化型タスク**が含まれていて、かつ**経過日数が一定以上（例：7日以上）経過している場合**は "true"を返してください。
- 逆に、「アイデア」「ヒント」「日記」「人間関係」「旅行」など**参照価値が高いタグ**が含まれている場合は、上記ルールよりも優先して経過日数に関係なく "false"を返してください。
- また、タグがどちらにも該当せず曖昧な場合は "false" を返してください。

# タグリスト
{tags_str}

# メモ作成日
{created_at_jp}

# 経過日数
{elapsed_days}日

# 出力例
{{"result": "true"}}
"""
    tag_check_json = generate_text(
        prompt_tag_check, enable_thinking=False, max_new_tokens=32
    )
    tag_check_result = parse_json(tag_check_json)
    if isinstance(tag_check_result, dict):
        tag_check_result = tag_check_result.get("result", "")
    tag_check_result = str(tag_check_result).strip().lower()

    if tag_check_result == "false":
        return False

    # --- STEP2: 本文＋日付で二次判定 ---
    prompt_archive_check = f"""
あなたはメモ整理アシスタントです。
下記のメモ内容・メモ作成日・経過日数・今日の日付をもとに、過去の予定や期限、ToDoなど「すでに終わった可能性が高いもの」は"true"（消してよい）と判定してください。

- 「予定」「やること」「日付指定のタスク」など、内容がすでに実行済み・消化済みなら"true"
    - 例：経過日数が7日で「明日○○する」などは、実施済みと判断し、"true"
- 作成日からの経過日数が大きく、「もう見返す意味がない」と思える内容も"true"
- 逆に、今後も活用できるヒントや記録、アイデアなら"false"

# メモ本文
{memo_text}

# メモ作成日
{created_at_jp}

# 今日の日付
{today_jp}

# 経過日数
{elapsed_days}日

# 出力例
{{"result": "true"}}
"""
    archive_check_json = generate_text(
        prompt_archive_check, enable_thinking=False, max_new_tokens=32
    )
    archive_check_result = parse_json(archive_check_json)
    if isinstance(archive_check_result, dict):
        archive_check_result = archive_check_result.get("result", "")
    archive_check_result = str(archive_check_result).strip().lower()

    decision = archive_check_result == "true"
    return decision
