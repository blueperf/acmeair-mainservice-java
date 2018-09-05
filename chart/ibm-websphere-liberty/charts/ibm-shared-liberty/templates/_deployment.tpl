{{- /*
Shared Liberty Templates (SLT)

Deployment templates:
  - slt.deployment

Usage of "slt.deployment.*" requires the following line be include at 
the begining of template:
{{- include "slt.config.init" (list . "slt.chart.config.values") -}}
 
********************************************************************
*** This file is shared across multiple charts, and changes must be 
*** made in centralized and controlled process. 
*** Do NOT modify this file with chart specific changes.
*****************************************************************
*/ -}}

{{- define "slt.deployment" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
---
# SLT: 'slt.deployment' from templates/_deployment.tpl
{{- $stateful := or $root.Values.logs.persistTransactionLogs $root.Values.logs.persistLogs -}}
{{ if $stateful }}
apiVersion: apps/v1beta1
kind: StatefulSet
{{ else }}
apiVersion: extensions/v1beta1
kind: Deployment
{{ end }}
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
spec:
  {{ if $stateful }}
  serviceName: {{ include "slt.utils.fullname" (list $root) }}
  {{ end }}
  {{ if not $root.Values.autoscaling.enabled -}}
  replicas: {{ $root.Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      app: {{ include "slt.utils.fullname" (list $root) }}
  template:
    metadata:
      labels:
        chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
        app: {{ include "slt.utils.fullname" (list $root) }}
        release: "{{ $root.Release.Name }}"
        heritage: "{{ $root.Release.Service }}"
    spec:
      volumes:
      - name: liberty-overrides
        configMap:
          name: {{ include "slt.utils.fullname" (list $root) }}
          items:
          - key: include-configmap.xml
            path: include-configmap.xml
      - name: liberty-config
        configMap:
          name: {{ include "slt.utils.fullname" (list $root) }}
      {{ if $root.Values.image.license }}
      {{ if (or (eq $root.Values.image.license "core") (eq $root.Values.image.license "base") (eq $root.Values.image.license "nd")) }} 
      - name: wlp-license
        secret:
          secretName: "wlp-{{ $root.Values.image.license }}-license"
      {{ end }}
      {{ end }}
      {{ if $root.Values.sessioncache.hazelcast.enabled }}
      - name: hazelcast-config
        configMap: 
          name: {{ include "slt.utils.fullname" (list $root) }}
          items:
          - key: hazelcast-client.xml
            path: hazelcast-client.xml
      - name: hazelcast-libs
        emptyDir: {}
      {{ end }}
      {{ if and $root.Values.ssl.enabled $root.Values.ssl.useClusterSSLConfiguration }}
      - name: keystores
        secret:
          secretName: mb-keystore
      - name: truststores
        secret:
          secretName: mb-truststore
      {{ end }}
      {{ if $root.Values.sessioncache.hazelcast.enabled }}
      initContainers:
      - name: init-hazelcast
        image: "{{ $root.Values.sessioncache.hazelcast.image.repository }}:{{ $root.Values.sessioncache.hazelcast.image.tag }}"
        imagePullPolicy: {{ $root.Values.sessioncache.hazelcast.image.pullPolicy }}
        command: ['sh', '-c', 'cp /opt/hazelcast/*.jar /hazelcast-libs']
        volumeMounts:
        - name: hazelcast-libs
          mountPath: /hazelcast-libs
      {{ end }}
      affinity:
      {{- include "slt.affinity.nodeaffinity" (list $root) | indent 6 }}
      {{/* Prefer horizontal scaling */}}
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - {{ include "slt.utils.fullname" (list $root) }}
                - key: release
                  operator: In
                  values:
                  - {{ $root.Release.Name | quote }}
              topologyKey: kubernetes.io/hostname
      containers:
      - name: {{ $root.Chart.Name }}
        {{- if $root.Values.service.enabled }}
        readinessProbe:
          httpGet:
          {{ if $root.Values.microprofile.health.enabled }}
            path: /health
          {{ else }}
            path: /
          {{ end }}
            port: {{ $root.Values.service.targetPort }}
            {{ if $root.Values.ssl.enabled }}
            scheme: HTTPS
            {{ end }}
        {{- end }}
        image: "{{ $root.Values.image.repository }}:{{ $root.Values.image.tag }}"
        imagePullPolicy: {{ $root.Values.image.pullPolicy }}
        env:
        {{ if $root.Values.image.license }}
        - name: LICENSE
          value: {{ $root.Values.image.license }}
        {{ end }}
        - name: JVM_ARGS
          value: {{ $root.Values.env.jvmArgs }}
        - name: WLP_LOGGING_CONSOLE_FORMAT
          value: {{ $root.Values.logs.consoleFormat }}
        - name: WLP_LOGGING_CONSOLE_LOGLEVEL
          value: {{ $root.Values.logs.consoleLogLevel }}
        - name: WLP_LOGGING_CONSOLE_SOURCE
          value: {{ $root.Values.logs.consoleSource }}
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        {{- if $root.Values.service.enabled }}
        {{- if $root.Values.ssl.enabled }}
        - name: HTTPENDPOINT_HTTPSPORT
          value: "{{ $root.Values.service.targetPort }}"
        {{- else }}
        - name: HTTPENDPOINT_HTTPPORT
          value: "{{ $root.Values.service.targetPort }}"
        {{- end }}
        {{- end }}
        {{- if $root.Values.iiopService.enabled }}
        - name: IIOPENDPOINT_IIOPPORT
          value: "{{ $root.Values.iiopService.nonSecureTargetPort }}"
        {{- if $root.Values.ssl.enabled }}
        - name: IIOPENDPOINT_IIOPSPORT
          value: "{{ $root.Values.iiopService.secureTargetPort }}"
        {{- end }}
        {{- end }}
        {{- if $root.Values.jmsService.enabled }}
        {{- if $root.Values.ssl.enabled }}
        - name: JMSENDPOINT_JMSSPORT
          value: "{{ $root.Values.jmsService.targetPort }}"
        {{- else }}
        - name: JMSENDPOINT_JMSPORT
          value: "{{ $root.Values.jmsService.targetPort }}"
        {{- end }}
        {{- end }}
        {{ if $root.Values.sessioncache.hazelcast.enabled }}
        - name: HAZELCAST_KUBERNETES_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        {{ end }}
        - name : KEYSTORE_REQUIRED
          {{ if and $root.Values.ssl.enabled (not $root.Values.ssl.useClusterSSLConfiguration) }}
          value: "true"
          {{ else }}
          value: "false"
          {{ end }}
        {{ if and $root.Values.ssl.enabled $root.Values.ssl.useClusterSSLConfiguration -}}
        - name: MB_KEYSTORE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mb-keystore-password
              key: password
        - name: MB_TRUSTSTORE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mb-truststore-password
              key: password
        {{- end }}
        volumeMounts:
        - name: liberty-overrides
          mountPath: /config/configDropins/overrides/include-configmap.xml
          subPath: include-configmap.xml
          readOnly: true
        - name: liberty-config
          mountPath: /etc/wlp/configmap
          readOnly: true
        {{ if $root.Values.image.license }}
        {{ if (or (eq $root.Values.image.license "core") (eq $root.Values.image.license "base") (eq $root.Values.image.license "nd")) }} 
        - name: wlp-license
          mountPath: /etc/wlp/license
          readOnly: true
        {{ end }}
        {{ end }}
        {{ if $root.Values.sessioncache.hazelcast.enabled }}
        - name: hazelcast-config
          mountPath: {{ $root.slt.paths.wlpInstallDir }}/usr/shared/config/hazelcast
          readOnly: true
        - name: hazelcast-libs
          mountPath: {{ $root.slt.paths.wlpInstallDir }}/usr/shared/resources/hazelcast
          readOnly: true
        {{ end }}
        {{ if or $stateful (and $root.Values.ssl.enabled $root.Values.ssl.useClusterSSLConfiguration) }}
        {{ if and $root.Values.ssl.enabled $root.Values.ssl.useClusterSSLConfiguration -}}
        - name: keystores
          mountPath: /etc/wlp/config/keystore
          readOnly: true
        - name: truststores
          mountPath: /etc/wlp/config/truststore
          readOnly: true
        {{ end }}
        {{ if $root.Values.logs.persistTransactionLogs }}
        - mountPath: /output/tranlog
          name: {{ $root.Values.persistence.name | trunc 63 | lower | trimSuffix "-" | quote }}
          subPath: tranlog
        {{ end }}
        {{ if $root.Values.logs.persistLogs }}
        - mountPath: /logs
          name: {{ $root.Values.persistence.name | trunc 63 | lower | trimSuffix "-" | quote }}
          subPath: logs
        {{ end }}
        {{ end }}
        resources:
          {{- if $root.Values.resources.constraints.enabled }}
          limits:
{{ toYaml $root.Values.resources.limits | indent 12 }}
          requests:
{{ toYaml $root.Values.resources.requests | indent 12 }}
          {{- end }}
        securityContext:
          privileged:  false
      restartPolicy: "Always"
      terminationGracePeriodSeconds: 30
      dnsPolicy: "ClusterFirst"
  {{ if $stateful -}}
  volumeClaimTemplates:
  - metadata:
      name: {{ $root.Values.persistence.name | trunc 63 | lower | trimSuffix "-"  | quote }}
      labels:
        chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version }}"
        app: {{ include "slt.utils.fullname" (list $root) }}
        release: "{{ $root.Release.Name }}"
        heritage: "{{ $root.Release.Service }}"
    spec:
      {{- if $root.Values.persistence.useDynamicProvisioning }}
      # if present, use the storageClassName from the values.yaml, else use the
      # default storageClass setup by kube Administrator
      # setting storageClassName to nil means use the default storage class
      storageClassName: {{ default nil $root.Values.persistence.storageClassName | quote }}
      {{- else }}
      # bind to an existing pv.
      # setting storageClassName to "" disables dynamic provisioning
      storageClassName: {{ default "" $root.Values.persistence.storageClassName | quote }}
      {{- if $root.Values.persistence.selector.label }}
      # use selectors in the binding process
      selector:
        matchExpressions:
          - {key: {{ $root.Values.persistence.selector.label }}, operator: In, values: [{{ $root.Values.persistence.selector.value }}]}
      {{- end }}
      {{- end }}
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: {{ $root.Values.persistence.size | quote }}
  {{- end }}
{{- end -}}

