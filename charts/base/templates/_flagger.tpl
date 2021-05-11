{{- define "base.flagger" -}}
{{- if .Values.flagger }}
---
apiVersion: {{ .Values.flagger.apiVersion | default "flagger.app/v1beta1" }}
kind: Canary
metadata:
  {{- if .Values.flagger.name }}
  name: {{ .Values.flagger.name }}
  {{- else }}
  name: {{ include "base.fullname" . }}
  {{- end }}
spec:
  {{- with .Values.flagger.ingressRef }}
  ingressRef:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  targetRef:
    apiVersion: {{ .Values.apiVersion | default "apps/v1" }}
    kind: Deployment
    name: {{ include "base.fullname" . }}
  autoscalerRef:
    apiVersion: autoscaling/v2beta1
    kind: HorizontalPodAutoscaler
    name: {{ include "base.fullname" . }}
  service:
  {{- if .Values.flagger.service }}
    port: {{ .Values.flagger.service.name }}
  {{- else }}
    port: {{ include "base.servicePortDefaultNum" . }}
  {{- end }}
  {{- with .Values.flagger.analysis }}
  analysis:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}