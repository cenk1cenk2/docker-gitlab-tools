{{- $required := list "GITLAB_APP_ID" "GITLAB_APP_SECRET" "GITLAB_URL" "SERVER_NAME" "SECRET_KEY" "SQLALCHEMY_DATABASE_URI" "CELERY_BROKER_URL" "CELERY_TASK_LOCK_BACKEND" }}
{{- $optional := list "GITLAB_SSH" }}
{{- $all := concat $required $optional }}
{{- range $required }}
  {{- $key := printf "GT_%s" . | upper }}
  {{- if eq (env $key) "" }}
    {{- fail (printf "Required environment variable is missing: %s" $key) }}
  {{- end }}
{{- end -}}
---
{{- range $key, $value := $ }}
{{ $key | upper }}: {{ $value | quote }}
{{- end }}
{{- range $all }}
{{- $key := printf "GT_%s" . | upper }}
{{ . }}: {{ (env $key) | quote }}
{{- end }}
