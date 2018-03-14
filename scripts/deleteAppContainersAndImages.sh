#!/bin/bash

echo "Delete Docker Exited Docker Containers"

docker rm -v -f $(docker ps -a -q -f "status=exited")
docker rmi -f $(docker images -f "dangling=true" -q)
docker rmi -f mainservicejava_authservice-java mainservicejava_nginx1 mainservicejava_customerservice-java mainservicejava_flightservice-java mainservicejava_bookingservice-java mainservicejava_mainservice-java
#docker rmi websphere-liberty:beta websphere-liberty:latest websphere-liberty:microProfile
