import logging

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from database import SessionLocal
from scheduler.delete_invald_tags import delete_invalid_tags
from scheduler.delete_unnecessary_memos import delete_unnecessary_memos
from utils.jst_now import JST

scheduler = AsyncIOScheduler(timezone=JST)

logger = logging.getLogger(__name__)


def tag_wrapper():
    logger.warning(f"tag auto delete")
    db = SessionLocal()
    try:
        delete_invalid_tags(db)
    except Exception as e:
        logger.error("Error tag auto delete: %s", e)
    finally:
        db.close()


def memo_wrapper():
    logger.warning(f"memo auto delete")
    db = SessionLocal()
    try:
        delete_unnecessary_memos(db, is_demo=False)
    finally:
        db.close()


def start_scheduler():
    scheduler.add_job(tag_wrapper, CronTrigger(hour=5, minute=0))
    scheduler.add_job(memo_wrapper, CronTrigger(day_of_week="mon", hour=5, minute=0))
    scheduler.start()
