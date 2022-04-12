#!/usr/bin/env bash

source /scripts/logger.sh

log_start "Checking for required variables..."
REQUIRED_VARIABLES_NAME=("GT_GITLAB_APP_ID" "GT_GITLAB_APP_SECRET" "GT_GITLAB_URL" "GT_HOST" "GT_PORT" "GT_SERVER_NAME" "GT_DATABASE_URI" "GT_SECRET_KEY")

source /scripts/variable-initiate.sh

log_start "Generating configuration file..."
REQUIRED_VARIABLES_NAME=("GT_GITLAB_APP_ID" "GT_GITLAB_APP_SECRET" "GT_GITLAB_URL" "GT_HOST" "GT_PORT" "GT_SERVER_NAME" "GT_DATABASE_URI" "GT_SECRET_KEY")

SED_STRING="sed"
for VAR in ${REQUIRED_VARIABLES_NAME[@]}; do
	VALUE=$(eval "echo \$${VAR}")
	SED=$(eval "echo 's|\${${VAR}}|${VALUE}|g'")

	log_debug "Current variable/value/sed string: ${VAR} + ${VALUE} -> ${SED}"

	SED_STRING="${SED_STRING} -e '${SED}'"
done
SED_STRING="${SED_STRING} /etc/gitlab-tools/config.template.yml > /etc/gitlab-tools/config.yml"

log_debug "sed command: ${SED_STRING}"

eval "${SED_STRING}"

log_debug "Current configuration file: $(cat /etc/gitlab-tools/config.yml)"
