set -eo pipefail

source venv/bin/activate

{{ range .commands }}
{{- . }}
{{ end }}

exit
