from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def generate_tags(
    new_text: str,
    initial_tags: list[str] = None,
    related_text: str = None,  # ここをstr型に
    related_tags: list[str] = None,  # ここをlist[str]型に
) -> list[str]:
    """
    メモ追加時のタグ生成アシスタント関数。
    """
    initial_tags = initial_tags or []
    related_text = related_text or ""
    related_tags = related_tags or []
    already_tags = set(initial_tags)

    # tags（除外したいタグ）が空でなければ、それらを除外するようLLMへの指示文を設計する
    def format_exclude_tags_instruction(tags: set[str]) -> str:
        if tags:
            return f"- 既に含まれるタグ（{', '.join(tags)}）は除外してください。"
        return ""

    # メジャータグ抽出
    def extract_major_tags(text: str, exclude_tags: set[str]) -> list[str]:
        exclude_instruction = format_exclude_tags_instruction(exclude_tags)
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
以下のメモ本文から、該当する「メジャータグ」を**必要なだけ全て**選んでください。
- メジャータグ：「アイデア、日記、ToDo、イベント」
{exclude_instruction}

# 出力形式 該当がなければ空リスト
{{"result": "タグ1, タグ2, タグ3"}}

# メモ本文
{text}
"""
        tag_str = parse_json(
            generate_text(prompt, enable_thinking=False, max_new_tokens=128)
        )
        if isinstance(tag_str, str):
            return [t.strip() for t in tag_str.split(",") if t.strip()]
        if isinstance(tag_str, list):
            return [t.strip() for t in tag_str if t.strip()]
        return []

    # カスタムタグ抽出
    def extract_custom_tags(text: str, exclude_tags: set[str]) -> list[str]:
        exclude_instruction = format_exclude_tags_instruction(exclude_tags)
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
以下のメモ本文から、人名以外の固有名詞（例：地名、商品名、施設名、イベント名、キーワードなど）をすべて抽出してください。
{exclude_instruction}

# 出力形式 該当がなければ空リスト
{{"result": "タグ1, タグ2, タグ3"}}

# メモ本文
{text}
"""
        tag_str = parse_json(
            generate_text(prompt, enable_thinking=False, max_new_tokens=128)
        )
        if isinstance(tag_str, str):
            return [t.strip() for t in tag_str.split(",") if t.strip()]
        if isinstance(tag_str, list):
            return [t.strip() for t in tag_str if t.strip()]
        return []

    # アイデア種別分類
    def classify_idea_type(text: str) -> str:
        prompt = f"""
# 指示
次のメモがどの分野やカテゴリの「アイデア」か、1つの短い単語で答えてください。
例：「アプリ」「サービス」「イベント」「商品」「仕事」「企画」「研究」「デザイン」「ストーリー」など
該当するものがない場合は"None"を返してください。

# メモ本文
{text}

# 出力形式
例1: {{"result": "健康"}}
例2: {{"result": "None"}}
"""
        category = parse_json(
            generate_text(prompt, enable_thinking=False, max_new_tokens=64)
        )
        if isinstance(category, str):
            cat = category.strip()
            if cat and cat.lower() != "none":
                return cat
        return ""

    # 関連メモ由来タグの提案（ここを単一に変更）
    def suggest_related_tags(
        text: str, rel_text: str, rel_tags: list[str], exclude_tags: set[str]
    ) -> list[str]:
        if not rel_text or not rel_tags:
            return []
        exclude_instruction = format_exclude_tags_instruction(exclude_tags)
        formatted = f"- 本文: {rel_text}\n  タグ: {', '.join(rel_tags)}"
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
追加されるメモ本文と関連メモの情報を参考に、
**追加すべきタグ**を必要なだけ提案してください。
{exclude_instruction}

# 追加されるメモ本文
{text}

# 関連メモ
{formatted}

# 出力形式
{{"result": "タグ1, タグ2, タグ3"}}
"""
        tag_str = parse_json(
            generate_text(prompt, enable_thinking=False, max_new_tokens=128)
        )
        if isinstance(tag_str, str):
            return [t.strip() for t in tag_str.split(",") if t.strip()]
        if isinstance(tag_str, list):
            return [t.strip() for t in tag_str if t.strip()]
        return []

    # メインのタグ生成処理
    tags_result: list[str] = list(initial_tags)

    # メジャータグ
    major_tags = extract_major_tags(new_text, already_tags)
    tags_result += [t for t in major_tags if t not in already_tags]
    already_tags.update(major_tags)

    # アイデア区分追加
    # initial_tagsに「アイデア」が含まれる場合は「アイデア」を残して区分を追加、major_tagsに含まれる場合は置換
    idea_in_initial = "アイデア" in (initial_tags or [])
    idea_in_major = "アイデア" in major_tags

    if idea_in_initial or idea_in_major:
        idea_category = classify_idea_type(new_text)
        if idea_category and idea_category not in already_tags:
            tags_result.append(idea_category)
            already_tags.add(idea_category)
        # 置換はmajor_tagsに「アイデア」があってinitial_tagsにない場合のみ
        if idea_in_major and not idea_in_initial:
            tags_result = [t for t in tags_result if t != "アイデア"]

    # カスタムタグ
    custom_tags = extract_custom_tags(new_text, already_tags)
    tags_result += [t for t in custom_tags if t not in already_tags]
    already_tags.update(custom_tags)

    # 関連メモタグ
    related_suggestions = suggest_related_tags(
        new_text, related_text, related_tags, already_tags
    )
    tags_result += [t for t in related_suggestions if t not in already_tags]

    return tags_result
