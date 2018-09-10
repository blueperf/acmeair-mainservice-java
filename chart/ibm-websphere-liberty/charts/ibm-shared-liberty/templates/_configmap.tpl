{{- /*
Shared Liberty Templates (SLT)

ConfigMap templates:
  - slt.configmap

Usage of "slt.configmap.*" requires the following line be include at 
the begining of template:
{{- include "slt.config.init" (list . "slt.chart.config.values") -}}
 
********************************************************************
*** This file is shared across multiple charts, and changes must be 
*** made in centralized and controlled process. 
*** Do NOT modify this file with chart specific changes.
*****************************************************************
*/ -}}

{{- define "slt.configmap" -}}
  {{- $params := . -}}
  {{- $root := first $params -}}
---
# SLT: 'slt.configmap' from templates/_configmap.tpl
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "slt.utils.fullname" (list $root) }}
  labels:
    chart: "{{ $root.Chart.Name }}-{{ $root.Chart.Version | replace "+" "_" }}"
    app: {{ include "slt.utils.fullname" (list $root) }}
    release: "{{ $root.Release.Name }}"
    heritage: "{{ $root.Release.Service }}"
data:
###############################################################################
#  Liberty Fabric
###############################################################################
  include-configmap.xml: |-
    <server>
      <include optional="true" location="/etc/wlp/configmap/server.xml"/>
      <include optional="true" location="/etc/wlp/configmap/http-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/https-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/iiop-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/iiop-ssl-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/jms-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/jms-ssl-endpoint.xml"/>
      <include optional="true" location="/etc/wlp/configmap/ssl.xml"/>
      <include optional="true" location="/etc/wlp/configmap/cluster-ssl.xml"/>
      <include optional="true" location="/etc/wlp/configmap/liberty-sessioncache-hazelcast.xml"/>
    </server>

  server.xml: |-
    <server>
      <!-- Customize the running configuration. -->
    </server>

{{ if $root.Values.ssl.enabled }}
  {{- if $root.Values.service.enabled }}
  https-endpoint.xml: |-
    <server>
      <httpEndpoint id="defaultHttpEndpoint" host="*" httpsPort="${env.HTTPENDPOINT_HTTPSPORT}" />
    </server>
  {{- end }}

  {{- if $root.Values.iiopService.enabled }}
  iiop-ssl-endpoint.xml: |-
    <server>
      <iiopEndpoint id="defaultIiopEndpoint" host="${env.POD_IP}" iiopPort="${env.IIOPENDPOINT_IIOPPORT}">
        <iiopsOptions iiopsPort="${env.IIOPENDPOINT_IIOPSPORT}" sslRef="defaultSSLConfig" />
      </iiopEndpoint>
    </server>
  {{- end }}

  {{- if $root.Values.jmsService.enabled }}
  jms-ssl-endpoint.xml: |-
    <server>
      <wasJmsEndpoint id="InboundJmsEndpoint" host="*" wasJmsSSLPort="${env.JMSENDPOINT_JMSSPORT}" />
    </server>
  {{- end }}

  ssl.xml: |-
    <server>
      <featureManager>
        <feature>ssl-1.0</feature>
      </featureManager>
    </server>
{{ else }}
  {{- if $root.Values.service.enabled }}
  http-endpoint.xml: |-
    <server>
      <httpEndpoint id="defaultHttpEndpoint" host="*" httpPort="${env.HTTPENDPOINT_HTTPPORT}" />
    </server>
  {{- end}}

  {{- if $root.Values.iiopService.enabled }}
  iiop-endpoint.xml: |-
    <server>
      <iiopEndpoint id="defaultIiopEndpoint" host="${env.POD_IP}" iiopPort="${env.IIOPENDPOINT_IIOPPORT}" />
    </server>
  {{- end }}

  {{- if $root.Values.jmsService.enabled }}
  jms-endpoint.xml: |-
    <server>
      <wasJmsEndpoint id="InboundJmsEndpoint" host="*" wasJmsPort="${env.JMSENDPOINT_JMSPORT}" />
    </server>
  {{- end }}
{{ end }}

{{ if and $root.Values.ssl.enabled $root.Values.ssl.useClusterSSLConfiguration }}
  cluster-ssl.xml: |-
    <server>
      <featureManager>
        <feature>ssl-1.0</feature>
      </featureManager>
      <ssl id="defaultSSLConfig" keyStoreRef="defaultKeyStore" trustStoreRef="defaultTrustStore"/>
      <keyStore id="defaultKeyStore" location="/etc/wlp/config/keystore/key.jks" password="${env.MB_KEYSTORE_PASSWORD}" />
      <keyStore id="defaultTrustStore" location="/etc/wlp/config/truststore/trust.jks" password="${env.MB_TRUSTSTORE_PASSWORD}" />
    </server>
{{ end }}

{{ if $root.Values.sessioncache.hazelcast.enabled }}
  hazelcast-client.xml: |-
    <hazelcast-client xsi:schemaLocation="http://www.hazelcast.com/schema/client-config hazelcast-client-config-3.9.xsd"
               xmlns="http://www.hazelcast.com/schema/client-config"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <properties>
        <property name="hazelcast.discovery.enabled">true</property>
      </properties>
      <network>
        <redo-operation>true</redo-operation>
        <discovery-strategies>
          <discovery-strategy enabled="true" class="com.hazelcast.kubernetes.HazelcastKubernetesDiscoveryStrategy">
          </discovery-strategy>
        </discovery-strategies>
      </network>
    </hazelcast-client>

  liberty-sessioncache-hazelcast.xml: |-
    <server>
      <featureManager>
        <feature>sessionCache-1.0</feature>
      </featureManager>
      <httpSessionCache libraryRef="HazelcastLib">
        <properties hazelcast.config.location="file:${shared.config.dir}/hazelcast/hazelcast-client.xml"/>
      </httpSessionCache>
      <library id="HazelcastLib">
        <fileset dir="${shared.resource.dir}/hazelcast"/>
      </library>
    </server>
{{ end }}
{{- end -}}

