FROM open-liberty:kernel
COPY --chown=1001:0 server.xml /config/server.xml
COPY --chown=1001:0 jvm.options /config/jvm.options
COPY --chown=1001:0 target/acmeair-mainservice-java-2.0.0-SNAPSHOT.war /config/apps/

RUN configure.sh

