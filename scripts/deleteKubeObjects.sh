#!/bin/bash

cd "$(dirname "$0")"
cd ..
kubectl delete -f manifests

sleep 15

cd ../acmeair-authservice-java
kubectl delete -f manifests

sleep 15

cd ../acmeair-bookingservice-java
kubectl delete -f manifests

sleep 15

cd ../acmeair-customerservice-java
kubectl delete -f manifests

sleep 15

cd ../acmeair-flightservice-java
kubectl delete -f manifests

sleep 15
