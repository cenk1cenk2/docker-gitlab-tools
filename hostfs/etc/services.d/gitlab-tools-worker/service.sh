#!/usr/bin/env bash

set -eo pipefail

source venv/bin/activate

python manage.py celeryworker --config_prod
