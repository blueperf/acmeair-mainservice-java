#!/bin/bash

cd "$(dirname "$0")"
cd ..
mvn clean package
docker build -t mycluster.icp:8500/admin/mainservice-java .
docker push mycluster.icp:8500/admin/mainservice-java

cd ../authservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/authservice-java .
docker push mycluster.icp:8500/admin/authservice-java

cd ../bookingservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/bookingservice-java .
docker push mycluster.icp:8500/admin/bookingservice-java

cd ../customerservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/customerservice-java .
docker push mycluster.icp:8500/admin/customerservice-java

cd ../flightservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/flightservice-java .
docker push mycluster.icp:8500/admin/flightservice-java
