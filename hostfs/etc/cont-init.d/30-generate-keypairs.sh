#!/usr/bin/env bash

source /scripts/logger.sh

if [ ! -f /home/service/.ssh/id_rsa_1 ]; then
	log_start "Generating SSH keypairs..." "top"

	mkdir -p /home/service/.ssh

	ssh-keygen -t rsa -b 4096 -C "$HOSTNAME" -f /home/service/.ssh/id_rsa_1

	log_warn "This is a one time operation. Please mount a persistent volume to /conf to keep this configuration!"
fi

chown service:service -R /home/service/.ssh/
