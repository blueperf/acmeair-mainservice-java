#!/bin/bash

cd "$(dirname "$0")"
cd ..
mvn clean package

cd ../acmeair-authservice-java
mvn clean package

cd ../acmeair-bookingservice-java
mvn clean package

cd ../acmeair-customerservice-java
mvn clean package

cd ../acmeair-flightservice-java
mvn clean package


