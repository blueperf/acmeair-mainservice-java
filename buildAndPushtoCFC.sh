#!/bin/bash

cd "$(dirname "$0")"
mvn clean package
docker build -t master.cfc:8500/admin/mainservice-java .
docker push master.cfc:8500/admin/mainservice-java

cd ../authservice-java
mvn clean package
docker build -t master.cfc:8500/admin/authservice-java .
docker push master.cfc:8500/admin/authservice-java

cd ../bookingservice-java
mvn clean package
docker build -t master.cfc:8500/admin/bookingservice-java .
docker push master.cfc:8500/admin/bookingservice-java


cd ../customerservice-java
mvn clean package
docker build -t master.cfc:8500/admin/customerservice-java .
docker push master.cfc:8500/admin/customerservice-java

cd ../flightservice-java
mvn clean package
docker build -t master.cfc:8500/admin/flightservice-java .
docker push master.cfc:8500/admin/flightservice-java
