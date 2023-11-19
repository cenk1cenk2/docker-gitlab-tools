{{- $required := list "GT_GITLAB_APP_ID" "GT_GITLAB_APP_SECRET" "GT_GITLAB_URL" "GT_SERVER_NAME" "GT_DATABASE_URI" "GT_SECRET_KEY" "GT_CELERY_BROKER_URL" "GT_CELERY_TASK_LOCK_BACKEND" }}
{{- range $required }}
  {{- if eq (env .) "" }}
  {{- fail (printf "Required environment variable is missing: %s" .) }}
  {{- end }}
{{- end }}
---
HOST: 0.0.0.0
PORT: '80'
USER: 'service'
GITLAB_SSH: {{ env "GT_GITLAB_SSH" }}
GITLAB_APP_ID: {{ env "GT_GITLAB_APP_ID" }}
GITLAB_APP_SECRET: {{ env "GT_GITLAB_APP_SECRET" }}
GITLAB_URL: {{ env "GT_GITLAB_URL" }}
SERVER_NAME: {{ env "GT_SERVER_NAME" }}
SECRET_KEY: {{ env "GT_SECRET_KEY" }}
SQLALCHEMY_DATABASE_URI: {{ env "GT_DATABASE_URI" }}
CELERY_BROKER_URL: {{ env "GT_CELERY_BROKER_URL" }}
CELERY_TASK_LOCK_BACKEND: {{ env "GT_CELERY_TASK_LOCK_BACKEND" }}
