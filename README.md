
## Acme Air Main Service - Java/Liberty

An implementation of the Acme Air Main Service for Java/Liberty. The main service primarily consists of the presentation layer (web pages) that interact with the other services.

This implementation can support running on a variety of runtime platforms including standalone bare metal system, Virtual Machines, docker containers, IBM Bluemix, IBM Bluemix Container Service, IBM Spectrum CFC, and other Kubernetes environments.

## Build Instructions
* Instructions for [setting up and building the codebase](Build_Instructions.md)

## Full Benchmark Installation Instructions on various docker enviornments.
![alt text](https://github.com/blueperf/mainservice-java/blob/master/images/AcmeairMS.png "AcmeairMS Java")

## Prereq \*IMPORTANT\*
All of these examples assume you have the mainservice, authservice, bookingservice, customerservice, and flightservice directories, (and possibly others) on your docker machine in the same directory. It also assume all applications have been built with maven.

* NOTE: DO NOT use acmeair.properties file to configure database unless there is specific needs.  Use Service Bridge for Mongo DB to get good performance results (When using acmeair.properties file, make sure to configure every DB options properly - if only setting up the hostname, port number & credentials, it will give poor performance)

* Instructions for different [run modes](Modes.md)

## Docker Instructions

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd mainservice-node
2. Create docker network
 * docker network create --driver bridge my-net
3. Build/Start Containers. This will build all the node micro-services, mongo db instances, and an nginx proxy.
    * docker-compose build
    * NETWORK=my-net docker-compose up

4. Go to http://docker_machine_ip/main/acmeair

