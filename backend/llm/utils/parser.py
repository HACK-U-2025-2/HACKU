import json


def parse_json(json_text: str) -> str:
    try:
        data = json.loads(json_text)
        return data["result"].strip()
    except (json.JSONDecodeError, KeyError) as e:
        raise ValueError(f"JSON形式のパースに失敗 {e}")
