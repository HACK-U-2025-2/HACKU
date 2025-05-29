from datetime import datetime
from zoneinfo import ZoneInfo

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from crud.tag import delete_invalid_tags
from utils.jst_now import JST

scheduler = AsyncIOScheduler(timezone=JST)


def start_scheduler():
    scheduler.add_job(delete_invalid_tags, CronTrigger(hour=5, minute=0))

    scheduler.start()
