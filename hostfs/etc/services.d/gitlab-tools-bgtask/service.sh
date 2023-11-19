#!/usr/bin/env bash

set -eo pipefail

source venv/bin/activate

python manage.py celerybeat --config_prod --schedule=/home/service/celery_beat.db --pid=/tmp/celerybeat.pid
