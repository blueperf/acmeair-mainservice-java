{{- /*
Shared Liberty Templates (SLT)

RoleBinding templates:
  - slt.role.binding

Usage of "slt.role.binding.*" requires the following line be include at 
the begining of template:
{{- include "slt.config.init" (list . "slt.chart.config.values") -}}
 
********************************************************************
*** This file is shared across multiple charts, and changes must be 
*** made in centralized and controlled process. 
*** Do NOT modify this file with chart specific changes.
*****************************************************************
*/ -}}

{{- define "slt.role.binding" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{ if $root.Values.rbac.install }}
{{ if or $root.Values.sessioncache.hazelcast.enabled $root.Values.ssl.createClusterSSLConfiguration }}
---
# SLT: 'slt.role.binding' from templates/_role-binding.tpl
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
subjects:
- kind: ServiceAccount
  name: default
  namespace: {{ $root.Release.Namespace }}
roleRef:
  kind: ClusterRole
  name: {{ if $root.Values.ssl.createClusterSSLConfiguration }}edit{{ else }}view{{ end }}
  apiGroup: rbac.authorization.k8s.io
{{ end }}
{{ end }}
{{- end -}}