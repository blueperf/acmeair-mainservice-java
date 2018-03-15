#!/bin/bash

if [[ "${1}" == "--with-msb" ]]
then 
  MANIFESTS=manifests
else
  MANIFESTS=manifests-no-msb
fi

cd "$(dirname "$0")"
cd ..
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t acmeair-mainservice-java .
kubectl apply -f ${MANIFESTS}

cd ../acmeair-authservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t acmeair-authservice-java .
kubectl apply -f ${MANIFESTS}

cd ../acmeair-bookingservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t acmeair-bookingservice-java .
kubectl apply -f ${MANIFESTS}

cd ../acmeair-customerservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t acmeair-customerservice-java .
kubectl apply -f ${MANIFESTS}

cd ../acmeair-flightservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t acmeair-flightservice-java .
kubectl apply -f ${MANIFESTS}


