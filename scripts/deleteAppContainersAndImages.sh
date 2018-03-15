#!/bin/bash

echo "Delete Docker Exited Docker Containers"

docker rm -v -f $(docker ps -a -q -f "status=exited")
docker rmi -f $(docker images -f "dangling=true" -q)
docker rmi -f mainservicejava_acmeair-authservice-java mainservicejava_nginx1 mainservicejava_acmeair-customerservice-java mainservicejava_acmeair-flightservice-java mainservicejava_acmeair-bookingservice-java mainservicejava_acmeair-mainservice-java
#docker rmi websphere-liberty:beta websphere-liberty:latest websphere-liberty:microProfile
