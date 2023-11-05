#!/usr/bin/env bash

set -eo pipefail

source venv/bin/activate

uwsgi -i "/etc/uwsgi/gitlab-tools.ini" --thunder-lock
