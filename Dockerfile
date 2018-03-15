FROM websphere-liberty:microProfile
RUN installUtility install  --acceptLicense defaultServer
COPY server.xml /config/server.xml
COPY jvm.options /config/jvm.options
COPY target/mainservice-java-2.0.0-SNAPSHOT.war /config/apps/

