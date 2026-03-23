{{/*
Expand the name of the chart.
*/}}
{{- define "opencut.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "opencut.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opencut.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: opencut
{{- end }}

{{/*
Selector labels for a component
*/}}
{{- define "opencut.selectorLabels" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .release }}
{{- end }}

{{/*
Build the DATABASE_URL from values.
When postgres.enabled is true, connect to the internal StatefulSet.
When false, use externalPostgres config.
*/}}
{{- define "opencut.databaseUrl" -}}
{{- if .Values.postgres.enabled -}}
postgresql://{{ .Values.postgres.auth.username }}:{{ .Values.postgres.auth.password }}@{{ include "opencut.fullname" . }}-postgres:5432/{{ .Values.postgres.auth.database }}
{{- else if .Values.externalPostgres.databaseUrl -}}
{{ .Values.externalPostgres.databaseUrl }}
{{- else -}}
postgresql://{{ .Values.externalPostgres.username }}:{{ .Values.externalPostgres.password }}@{{ .Values.externalPostgres.host }}:{{ .Values.externalPostgres.port }}/{{ .Values.externalPostgres.database }}
{{- end -}}
{{- end }}
