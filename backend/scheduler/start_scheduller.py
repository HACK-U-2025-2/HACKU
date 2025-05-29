from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from crud.tag import delete_invalid_tags
from database import SessionLocal
from utils.jst_now import JST

scheduler = AsyncIOScheduler(timezone=JST)


def job_wrapper():
    db = SessionLocal()
    try:
        delete_invalid_tags(db)
    finally:
        db.close()


def start_scheduler():
    scheduler.add_job(job_wrapper, CronTrigger(hour=5, minute=0))
    scheduler.start()
