#!/usr/bin/env bash

source /scripts/logger.sh

log_start "Migrating the database..."

cd /opt/gitlab-tools
source venv/bin/activate

log_start "Creating database tables..."
python manage.py create_all --config_prod
log_start "Migrating the database..."
python manage.py db upgrade || log_info "Migrations are failed or already applied."
log_start "Stamping the database..."
python manage.py db stamp
