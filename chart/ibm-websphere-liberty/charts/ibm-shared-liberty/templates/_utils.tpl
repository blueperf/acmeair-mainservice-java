{{- /*
Shared Liberty Templates (SLT)

Utility functions:
  - slt.utils.getItem
  - slt.utils.name
  - slt.utils.fullname

Usage of "slt.utils.*" requires the following line be include at 
the begining of template:
{{- include "slt.config.init" (list . "slt.chart.config.values") -}}
 
********************************************************************
*** This file is shared across multiple charts, and changes must be 
*** made in centralized and controlled process. 
*** Do NOT modify this file with chart specific changes.
*****************************************************************
*/ -}}

{{/*
"slt.utils.getItem" is a helper to get an item based on the index in the 
list and default value if the item does not exist. If the item exists, its text is 
generated, if the index is out of range of the list, then the default text is generated.

Config Values Used: NA
  
Uses: NA
    
Parameters input as an array of one values:
  - a list of items (required)
  - the index of the list (required)
  - the default text (required)

Usage:
  {{- $param1 := (include "slt.utils.getItem" (list $params 1 "defaultValue")) -}}
 
*/}}
{{- define "slt.utils.getItem" -}}
  {{- $params := . -}}
  {{- $list := first $params -}}
  {{- $index := (index $params 1) -}}
  {{- $default := (index $params 2) -}}
  {{- if (gt (add $index 1) (len $list) ) -}}
    {{- $default -}}
  {{- else -}}
    {{- index $list $index -}}
  {{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "slt.utils.name" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- default $root.Chart.Name $root.Values.nameOverride | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "slt.utils.fullname" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- $name := default $root.Chart.Name $root.Values.nameOverride -}}
{{- printf "%s-%s" $root.Release.Name $name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Creates a boolean value names "isICP" that determines if Helm chart is deployed to IBM Cloud Private (ICP).
*/}}
{{- define "slt.utils.isICP" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
{{- if contains "icp" $root.Capabilities.KubeVersion.GitVersion -}}
{{- $_ := set $root.Values "isICP" true -}}
{{- end -}}
{{- end -}}