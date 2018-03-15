#!/bin/bash

cd "$(dirname "$0")"
cd ..
mvn clean package
docker build -t mycluster.icp:8500/admin/acmeair-mainservice-java .
docker push mycluster.icp:8500/admin/acmeair-mainservice-java

cd ../acmeair-authservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/acmeair-authservice-java .
docker push mycluster.icp:8500/admin/acmeair-authservice-java

cd ../acmeair-bookingservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/acmeair-bookingservice-java .
docker push mycluster.icp:8500/admin/acmeair-bookingservice-java

cd ../acmeair-customerservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/acmeair-customerservice-java .
docker push mycluster.icp:8500/admin/acmeair-customerservice-java

cd ../acmeair-flightservice-java
mvn clean package
docker build -t mycluster.icp:8500/admin/acmeair-flightservice-java .
docker push mycluster.icp:8500/admin/acmeair-flightservice-java
