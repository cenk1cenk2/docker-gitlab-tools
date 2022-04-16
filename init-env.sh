#!/bin/bash

SCRIPT_NAME="init-env.sh"
SCRIPT_VERSION="20211110"
LOG_LEVEL="INFO"

source <(curl -s "https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/logger.sh")

OVERWRITE_CONSENT=0
log_this "${SCRIPT_VERSION}" "${MAGENTA}${SCRIPT_NAME}${RESET}" "LIFETIME" "bottom"

## Variables
# Write down the data required in .env file here for initiation.
ENV_FILE=.env
ENV_FILE_CONTENTS=$(
	cat <<EOF
LOG_LEVEL=lifetime
GT_GITLAB_APP_ID=
GT_GITLAB_APP_SECRET=
GT_GITLAB_URL=
GT_SERVER_NAME=
GT_SECRET_KEY=
GT_DATABASE_URI=postgres://gitlab-tools:something@gitlab-tools-db/gitlab-tools
EOF
)

## Script
log_start "Initiating ${ENV_FILE} file."

if [ ! -f ${ENV_FILE} ] || [ "${OVERWRITE_CONSENT}" -eq "1" ] || (log_warn ".env file already initiated. You want to override? [ y/N ]: " && read -r OVERRIDE && echo ${OVERRIDE::1} | grep -iqF "y"); then
	log_info "Will rewrite the .env file with the default one."
	echo -e "${ENV_FILE_CONTENTS} " >${ENV_FILE}
	log_finish "All done."
else
	log_error "File already exists with no overwrite permission given."
	log_finish "Not doing anything."
	exit 127
fi
