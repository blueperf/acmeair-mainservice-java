FROM websphere-liberty:microProfile2

# Install opentracing usr feature
RUN wget -t 10 -x -nd -P /opt/ibm/wlp/usr https://github.com/WASdev/sample.opentracing.zipkintracer/releases/download/1.3/liberty-opentracing-zipkintracer-1.3-sample.zip && cd /opt/ibm/wlp/usr && unzip liberty-opentracing-zipkintracer-1.3-sample.zip && rm liberty-opentracing-zipkintracer-1.3-sample.zip


#COPY with chown to support liberty non-root default user account. This option supported only docker version >= 17.09
#Liberty docker image doc (https://hub.docker.com/_/websphere-liberty/)
COPY --chown=1001:0 /target/liberty/wlp/usr/servers/defaultServer /config/
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml
COPY --chown=1001:0 /src/main/liberty/config/jvmbx.options /config/jvm.options
COPY --chown=1001:0 target/acmeair-mainservice-java-2.0.0-SNAPSHOT.war /config/apps/

# Don't fail on rc 22 feature already installed
RUN installUtility install --acceptLicense apmDataCollector-7.4 && installUtility install --acceptLicense defaultServer || if [ $? -ne 22 ]; then exit $?; fi
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/opt/ibm/wlp/usr/extension/liberty_dc/toolkit/lib/lx8266 \
    JVM_ARGS="$JVM_ARGS -agentlib:am_ibm_16=defaultServer -Xbootclasspath/p:/opt/ibm/wlp/usr/extension/liberty_dc/toolkit/lib/bcm-bootstrap.jar -Xverbosegclog:/logs/gc.log,1,10000 -verbosegc -Djava.security.policy=/opt/ibm/wlp/usr/extension/liberty_dc/itcamdc/etc/datacollector.policy -Dliberty.home=/opt/ibm/wlp"

# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \ 
  if [ $LICENSE_JAR_URL ]; then \
    wget $LICENSE_JAR_URL -O /tmp/license.jar \
    && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
    && rm /tmp/license.jar; \
  fi

