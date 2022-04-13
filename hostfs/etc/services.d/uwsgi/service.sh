#!/usr/bin/env bash

cd /opt/gitlab-tools
source venv/bin/activate

uwsgi -i "/etc/uwsgi/gitlab-tools.ini" --thunder-lock
