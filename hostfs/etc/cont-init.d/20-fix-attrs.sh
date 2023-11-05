#!/usr/bin/env bash

set -eo pipefail

mkdir -p /home/service
chown -R service:service /home/service
chmod -R 640 /home/service
chmod 2700 /home/service

mkdir -p /home/service/.ssh
chown -R service:service /home/service
chmod -R 600 /home/service/.ssh
chmod 2700 /home/service/.ssh
