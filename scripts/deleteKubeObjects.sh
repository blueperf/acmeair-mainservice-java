#!/bin/bash

cd "$(dirname "$0")"
cd ..
kubectl delete -f manifests

sleep 15

cd ../authservice-java
kubectl delete -f manifests

sleep 15

cd ../bookingservice-java
kubectl delete -f manifests

sleep 15

cd ../customerservice-java
kubectl delete -f manifests

sleep 15

cd ../flightservice-java
kubectl delete -f manifests

sleep 15
