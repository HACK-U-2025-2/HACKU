from datetime import datetime
from zoneinfo import ZoneInfo

JST = ZoneInfo("Asia/Tokyo")


def jst_now():
    return datetime.now(ZoneInfo("Asia/Tokyo"))
