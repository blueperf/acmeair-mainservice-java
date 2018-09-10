{{- /*
Shared Liberty Templates (SLT)

Service templates:
  - slt.service
  - slt.service.headless

Usage of "slt.service.*" requires the following line be include at 
the begining of template:
{{- include "slt.config.init" (list . "slt.chart.config.values") -}}
 
********************************************************************
*** This file is shared across multiple charts, and changes must be 
*** made in centralized and controlled process. 
*** Do NOT modify this file with chart specific changes.
*****************************************************************
*/ -}}

{{- define "slt.service" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs }}
{{- if $root.Values.service.enabled }}
---
# SLT: 'slt.service' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
{{- if $stateful }}
  name: {{ include "slt.utils.fullname" (list $root) }}-np
{{- else }}
  name: {{ $root.Values.service.name | trunc 63 | lower | trimSuffix "-" | quote }}
{{- end }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
{{- if or (not $root.Values.ingress.enabled) $root.Values.ssl.enabled }}  
  type: {{ $root.Values.service.type }}
{{- end }}
  ports:
  - port: {{ $root.Values.service.port }}
    targetPort: {{ $root.Values.service.targetPort }}
    protocol: TCP
  {{- if $root.Values.ssl.enabled }}
    name: "{{ $root.Values.service.name  | trunc 57 | lower | trimSuffix "-" }}-https"
  {{- else }}
    name: {{ $root.Values.service.name | trunc 63 | lower | trimSuffix "-" | quote }}
  {{- end }}
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{- end }}
{{- end -}}


{{- define "slt.service.headless" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs -}}
{{ if $stateful }}
---
# SLT: 'slt.service.headless' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
  ports:
  - port: {{ $root.Values.service.port }}
  clusterIP: None
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{ end }}
{{- end -}}


{{- define "slt.service.iiop" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs }}
{{- if $root.Values.iiopService.enabled }}
---
# SLT: 'slt.service.iiop' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
{{- if $stateful }}
  name: {{ include "slt.utils.fullname" (list $root) }}-iiop-np
{{- else }}
  name: {{ include "slt.utils.fullname" (list $root) }}-iiop
{{- end }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
{{- if or (not $root.Values.ingress.enabled) $root.Values.ssl.enabled }}  
  type: {{ $root.Values.iiopService.type }}
{{- end }}
  ports:
  - port: {{ $root.Values.iiopService.nonSecurePort }}
    targetPort: {{ $root.Values.iiopService.nonSecureTargetPort }}
    protocol: TCP
    name: "{{ $root.Values.iiopService.name | trunc 58 | lower | trimSuffix "-" }}-iiop"
  {{- if $root.Values.ssl.enabled }}
  - port: {{ $root.Values.iiopService.securePort }}
    targetPort: {{ $root.Values.iiopService.secureTargetPort }}
    protocol: TCP
    name: "{{ $root.Values.iiopService.name  | trunc 54 | lower | trimSuffix "-" }}-iiop-ssl"
  {{- end }}
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{- end }}
{{- end -}}


{{- define "slt.service.iiop.headless" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs }}
{{- if and $root.Values.iiopService.enabled $stateful }}
---
# SLT: 'slt.service.iiop.headless' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}-iiop
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
  ports:
  - port: {{ $root.Values.iiopService.nonSecurePort }}
    name: "{{ $root.Values.iiopService.name | trunc 58 | lower | trimSuffix "-" }}-iiop"
  {{- if $root.Values.ssl.enabled }}
  - port: {{ $root.Values.iiopService.securePort }}
    name: "{{ $root.Values.iiopService.name  | trunc 54 | lower | trimSuffix "-" }}-iiop-ssl"
  {{- end }}
  clusterIP: None
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{- end }}
{{- end -}}


{{- define "slt.service.jms" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs }}
{{- if $root.Values.jmsService.enabled}}
---
# SLT: 'slt.service.jms' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
{{- if $stateful }}
  name: {{ include "slt.utils.fullname" (list $root) }}-jms-np
{{- else }}
  name: {{ include "slt.utils.fullname" (list $root) }}-jms
{{- end }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
{{- if or (not $root.Values.ingress.enabled) $root.Values.ssl.enabled }}  
  type: {{ $root.Values.jmsService.type }}
{{- end }}
  ports:
  - port: {{ $root.Values.jmsService.port }}
    targetPort: {{ $root.Values.jmsService.targetPort }}
    protocol: TCP
  {{- if $root.Values.ssl.enabled }}
    name: "{{ $root.Values.jmsService.name  | trunc 55 | lower | trimSuffix "-" }}-jms-ssl"
  {{- else }}
    name: "{{ $root.Values.jmsService.name | trunc 59 | lower | trimSuffix "-" }}-jms"
  {{- end }}
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{- end }}
{{- end -}}


{{- define "slt.service.jms.headless" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs }}
{{- if and $root.Values.jmsService.enabled $stateful }}
---
# SLT: 'slt.service.jms.headless' from templates/_service.tpl
apiVersion: v1
kind: Service
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}-jms
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
  ports:
  - port: {{ $root.Values.jmsService.port }}
  clusterIP: None
  selector:
    app: {{ include "slt.utils.fullname" (list $root) }}
{{- end }}
{{- end -}}

