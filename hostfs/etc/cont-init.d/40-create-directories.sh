#!/usr/bin/env bash

source /scripts/logger.sh

if [ ! -d /home/service/repositories ]; then
	log_start "Creating repository directory..." "top"

	mkdir -p /home/service/repositories
fi
