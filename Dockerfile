FROM open-liberty:kernel

COPY src/main/liberty/config/server.xml /config/server.xml
COPY src/main/liberty/config/server.env /config/server.env
COPY src/main/liberty/config/jvm.options /config/jvm.options
COPY target/acmeair-mainservice-java-3.3.war /config/apps/

USER 0
RUN chown 1001:0 /config/server.xml
RUN chown 1001:0 /config/server.env
RUN chown 1001:0 /config/jvm.options
RUN chown 1001:0 /config/apps/acmeair-mainservice-java-3.3.war
USER 1001

RUN configure.sh || if [ $? -ne 22 ]; then exit $?; fi
