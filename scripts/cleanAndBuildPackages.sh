#!/bin/bash

cd "$(dirname "$0")"
cd ..
mvn clean package

cd ../authservice-java
mvn clean package

cd ../bookingservice-java
mvn clean package

cd ../customerservice-java
mvn clean package

cd ../flightservice-java
mvn clean package


