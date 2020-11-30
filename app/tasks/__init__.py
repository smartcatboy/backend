import sentry_sdk
from sentry_sdk.integrations.celery import CeleryIntegration
from celery import Celery
from celery.schedules import crontab
from app.core import config

if config.ENABLE_SENTRY:
    sentry_sdk.init(
        dsn="https://ad50b72443114ca783a4f2aa3d06fba6@o176406.ingest.sentry.io/5520928",
        integrations=[CeleryIntegration()],
    )


celery_app = Celery("worker", broker="redis://redis:6379/0")

celery_app.conf.task_routes = {"app.tasks.*": "main-queue"}

celery_app.autodiscover_tasks(
    [
        "app.tasks.ansible",
        "app.tasks.connect",
        "app.tasks.clean",
        "app.tasks.traffic",
        "app.tasks.example",
        "app.tasks.iptables",
        "app.tasks.gost",
        "app.tasks.tc",
    ]
)

celery_app.conf.beat_schedule = {
    "run-every-minute": {
        "task": "app.tasks.traffic.traffic_runner",
        "schedule": crontab(minute="*/10"),
    }
}