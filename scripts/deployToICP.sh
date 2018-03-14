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
docker build -t mainservice-java .
kubectl apply -f ${MANIFESTS}

cd ../authservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t authservice-java .
kubectl apply -f ${MANIFESTS}

cd ../bookingservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t bookingservice-java .
kubectl apply -f ${MANIFESTS}

cd ../customerservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t customerservice-java .
kubectl apply -f ${MANIFESTS}

cd ../flightservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
docker build -t flightservice-java .
kubectl apply -f ${MANIFESTS}


