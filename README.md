
## Acme Air Main Service - Java/Liberty

An implementation of the Acme Air Main Service for Java/Liberty. The main service primarily consists of the presentation layer (web pages) that interact with the other services.

This implementation can support running on a variety of runtime platforms including standalone bare metal system, Virtual Machines, docker containers, IBM Bluemix, IBM Bluemix Container Service, IBM Spectrum CFC, and other Kubernetes environments.

## Build Instructions
* Instructions for [setting up and building the codebase](Build_Instructions.md)

## Full Benchmark Installation Instructions on various docker enviornments.
![alt text](https://github.ibm.com/BluemixPerf/mainservice-java/blob/master/images/AcmeairMS.png "AcmeairMS Java")

## Prereq \*IMPORTANT\*
All of these examples assume you have the mainservice, authservice, bookingservice, customerservice, and flightservice directories, (and possibly others) on your docker machine in the same directory. It also assume all applications have been built with maven.

* NOTE: DO NOT use acmeair.properties file to configure database unless there is specific needs.  Use Service Bridge for Mongo DB to get good performance results (When using acmeair.properties file, make sure to configure every DB options properly - if only setting up the hostname, port number & credentials, it will give poor performance)

* Instructions for different [run modes](Modes.md)

## Docker Instructions

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd mainservice-java
2. Create docker network
 * docker network create --driver bridge my-net
3. Build/Start Containers. This will build all the node micro-services, mongo db instances, and an nginx proxy.
    * docker-compose build
    * NETWORK=my-net docker-compose up

4. Go to http://docker_machine_ip/main/acmeair
5. Go to the Configuration Page and Load the Database

## Minikube Instructions

* Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)
* Prereq: [Install and configure Minikube, and install kubectl](https://github.com/kubernetes/minikube/)

1. minikube docker-env
2. eval $(minikube docker-env)
3. minikube addons enable ingress
4. cd mainservice-java/scripts
5. Build and Deploy Services
	./buildAndDeployToMinikube.sh
6. Wait a couple minutes and go to http://kubernetes_ip/acmeair
7. Go to the Configuration Page and Load the Database

## IBM Cloud Private Instructions - w/ Ingress
This doc assumes that
* ICP is installed and configured
* The docker env is logged into the CFC docker repo
	* docker login mycluster.icp:8500

* kubectl is attached the ICP cluster

* You are running ICP as admin

* maven is installed and set up to build with a full SDK.

1. Build and push the apps

	`cd mainservice-java/scripts`

	`./buildAndPushtoICP.sh`
2. For each service, in manifests-no-msb/deploy.*, update the image name and add any imagePullSecrets required
Example: `mainservice-java:latest -> mycluster.icp:8500/admin/mainservice-java:latest`

	`imagePullSecrets:`

	`  - name: admin.registrykey`

3. Deploy to ICP. 

	`./deployToICP.sh`

4. Wait a couple minutes and go to http://proxy_ip/acmeair
5. Go to the Configuration Page and Load the Database

## IBM Cloud Public Instructions (TODO)



