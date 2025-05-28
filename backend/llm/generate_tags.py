from llm.utils.generator import generate_text
from llm.utils.parser import parse_json


def generate_tags(text: str) -> list[str]:
    # メジャータグ抽出
    def extract_major_tags(text: str) -> list[str]:
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
以下のメモ本文から、該当する「メジャータグ」を**必要なだけ全て**選んでください。
- メジャータグ：「アイデア、ヒント、日記、ToDo、旅行、食事、人間関係、イベント、買い物、予定」

# 出力形式 該当がなければ空リスト
{{"result": "タグ1, タグ2, タグ3"}}

# メモ本文
{text}
"""
        json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=128)
        tag_str = parse_json(json_text)
        if isinstance(tag_str, str):
            tags = [t.strip() for t in tag_str.split(",") if t.strip()]
        elif isinstance(tag_str, list):
            tags = [t.strip() for t in tag_str if t.strip()]
        else:
            tags = []
        return tags

    # カスタムタグ抽出
    def extract_custom_tags(text: str) -> list[str]:
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
以下のメモ本文から、人名以外の固有名詞（例：地名、商品名、施設名、イベント名、キーワードなど）を「カスタムタグ」としてすべて抽出してください。

# 出力形式 該当がなければ空リスト
{{"result": "タグ1, タグ2, タグ3"}}

# メモ本文
{text}
"""
        json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=128)
        tag_str = parse_json(json_text)
        if isinstance(tag_str, str):
            tags = [t.strip() for t in tag_str.split(",") if t.strip()]
        elif isinstance(tag_str, list):
            tags = [t.strip() for t in tag_str if t.strip()]
        else:
            tags = []
        return tags

    # アイデア種別の分類
    def classify_idea_type(text: str) -> str:
        prompt = f"""
# 指示
次のメモがどの分野やカテゴリの「アイデア」か、1つの短い単語で答えてください。
例：「アプリ」「サービス」「イベント」「商品」「仕事」「週間」「企画」「研究」「デザイン」「ストーリー」など
該当するものがない場合は"None"を返してください。

# メモ本文
{text}

# 出力形式
例1: {{"result": "健康"}}
例2: {{"result": "None"}}
"""
        json_text = generate_text(prompt, enable_thinking=False, max_new_tokens=64)
        category = parse_json(json_text)
        if isinstance(category, str):
            category = category.strip()
            # None, "None", 空文字列は除外
            if category and category.lower() != "none":
                return category
        return ""

    # タグ取得
    major_tags = extract_major_tags(text)

    # アイデアタグがあれば種別分類
    idea_category = None
    if "アイデア" in major_tags:
        idea_category = classify_idea_type(text)

    custom_tags = extract_custom_tags(text)

    # アイデア分類結果をメジャータグの次に追加
    all_tags = major_tags.copy()
    if idea_category and idea_category not in all_tags:
        all_tags.append(idea_category)
    all_tags += [tag for tag in custom_tags if tag not in all_tags]

    # 重複排除
    all_tags = list(dict.fromkeys(all_tags))
    return all_tags
