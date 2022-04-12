#!/usr/bin/env bash

source /scripts/logger.sh

log_start "Starting Nginx server..." "top"
service nginx start

log_start "Starting RabbitMQ server..." "top"
service rabbitmq-server start

log_start "Starting Redis server..." "top"
service redis-server start
