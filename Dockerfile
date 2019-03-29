FROM websphere-liberty:microProfile1
RUN installUtility install  --acceptLicense defaultServer
COPY server.xml /config/server.xml
COPY jvm.options /config/jvm.options
COPY target/acmeair-mainservice-java-2.0.0-SNAPSHOT.war /config/apps/

