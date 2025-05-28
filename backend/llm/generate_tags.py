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
        # parse_jsonの返り値はカンマ区切りの文字列前提
        tag_str = parse_json(json_text)
        if isinstance(tag_str, str):
            tags = [t.strip() for t in tag_str.split(",") if t.strip()]
        elif isinstance(tag_str, list):  # 念のためリスト形式にも対応
            tags = [t.strip() for t in tag_str if t.strip()]
        else:
            tags = []
        return tags

    # カスタムタグ抽出
    def extract_custom_tags(text: str) -> list[str]:
        prompt = f"""
# 指示
あなたはメモ分類アシスタントです。
以下のメモ本文から、「カスタムタグ」として本文中に現れる固有名詞や個人に紐づく表現（人名、地名、商品名、施設名、個別ワードなど）を全て抽出してください。

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

    # 実装が間に合えばここに、関連メモを取得 -> プロンプトで参照 -> 新たなタグ候補を取得するプロセスを追加

    # タグ取得
    major_tags = extract_major_tags(text)
    custom_tags = extract_custom_tags(text)
    # 重複排除
    all_tags = list(dict.fromkeys(major_tags + custom_tags))
    return all_tags
