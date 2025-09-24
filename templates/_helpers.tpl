{{/* Define standard labels */}}
{{- define "myapp.labels" -}}
app.kubernetes.io/name: myapp
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{- define "myapp.containerResources" -}}
resources:
  requests:
    cpu: {{ .Values.resources.requests.cpu }}
    memory: {{ .Values.resources.requests.memory }}
  limits:
    cpu: {{ .Values.resources.limits.cpu }}
    memory: {{ .Values.resources.limits.memory }}
{{- end -}}