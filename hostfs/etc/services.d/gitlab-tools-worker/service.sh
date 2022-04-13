#!/usr/bin/env bash

cd /opt/gitlab-tools
source venv/bin/activate

python manage.py celeryworker --config_prod
