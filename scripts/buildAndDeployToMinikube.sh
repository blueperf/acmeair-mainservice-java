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
kubectl apply -f ${MANIFESTS}

cd ../authservice-java
kubectl delete -f ${MANIFESTS}
kubectl apply -f ${MANIFESTS}

cd ../bookingservice-java
kubectl delete -f ${MANIFESTS}
kubectl apply -f ${MANIFESTS}

cd ../customerservice-java
kubectl delete -f ${MANIFESTS}
kubectl apply -f ${MANIFESTS}

cd ../flightservice-java
kubectl delete -f ${MANIFESTS}
kubectl apply -f ${MANIFESTS}


