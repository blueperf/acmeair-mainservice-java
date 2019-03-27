
## Acme Air Main Service - Java/Liberty

An implementation of the Acme Air Main Service for Java/Liberty. The main service primarily consists of the presentation layer (web pages) that interact with the other services.

This implementation can support running on a variety of runtime platforms including standalone bare metal system, Virtual Machines, docker containers, IBM Cloud, IBM Cloud Private, and other Kubernetes environments.

## Build Instructions
* Instructions for [setting up and building the codebase](Build_Instructions.md)

## Full Benchmark Installation Instructions on various docker enviornments.
![alt text](https://github.com/blueperf/acmeair-mainservice-java/blob/master/images/AcmeairMS.png "AcmeairMS Java")

## Prereq \*IMPORTANT\*
All of these examples assume you have the acmeair-mainservice-java, acmeair-authservice-java, acmeair-bookingservice-java, acmeair-customerservice-java, and acmeair-flightservice-java directories, (and possibly others) on your docker machine in the same directory. It also assumes all applications have been built with maven.


* Instructions for different [run modes](Modes.md)

## Docker Instructions

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd acmeair-mainservice-java
2. Create docker network
 * docker network create --driver bridge my-net
3. Build/Start Containers. This will build all the micro-services, mongo db instances, and an nginx proxy.
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
4. cd acmeair-mainservice-java/scripts
5. Build and Deploy Services
  ./buildAndDeployToMinikube.sh
6. Wait a couple minutes and go to http://kubernetes_ip/acmeair
7. Go to the Configuration Page and Load the Database

## IBM Cloud Private Instructions - w/ Ingress
This doc assumes that
* ICP is installed and configured
* The docker env is logged into the CFC docker repo
  * docker login mycluster.icp:8500

* kubectl and helm are attached the ICP cluster

* You are running ICP as admin

* maven is installed and set up to build with a full SDK.

1. Build and push the apps
   * `cd acmeair-mainservice-java/scripts`
   * `./buildAndPushtoICP.sh`
2. Deploy to ICP using one of the following options: 
   * Using ibm-websphere-liberty helm chart
      * `./deployChartToICP.sh`
   * Using loose deployment manifests
     * `./deployToICP.sh`
   * Using [Microclimate](https://microclimate-dev2ops.github.io/)
     * The AcmeAir java projects are structured to be imported and deployed using Microclimate.
3. Wait a couple minutes and go to http://proxy_ip/acmeair
4. Go to the Configuration Page and Load the Database
5. Cleanup
   * Helm chart
      * `./deleteChartRelease.sh`
   * Loose deployment manifests
      * `./deleteKubeObjects.sh`
   * Using [Microclimate](https://microclimate-dev2ops.github.io/)
     * Delete the deployment pipeline

## Microclimate Instructions

Prerequisites
* [Install Microclimate.](https://microclimate-dev2ops.github.io/installlocally)
* [Install IBM Cloud Private.](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.0/installing/installing.html)
* [Install Microclimate on IBM Cloud Private.](https://github.com/IBM/charts/blob/master/stable/ibm-microclimate/README.md)
* Microclimate and AcmeAir microservices integration supported from three branches. (master, microprofile-1.4, microclimate-mp-1.3)     

1. Import the following microservices into Microclimate with [Importing projects](https://microclimate-dev2ops.github.io/importingaproject):
	* [acmeair-mainservice-java](https://github.com/blueperf/acmeair-mainservice-java)
	* [acmeair-bookingservice-java](https://github.com/blueperf/acmeair-bookingservice-java)
	* [acmeair-authservice-java](https://github.com/blueperf/acmeair-authservice-java)
	* [acmeair-customerservice-java](https://github.com/blueperf/acmeair-customerservice-java)
	* [acmeair-flightservice-java](https://github.com/blueperf/acmeair-flightservice-java)

	
2. After you import all the microservices into Microclimate, you can deploy projects into IBM Cloud Private: 
	* A.) Connect the remote Microclimate instance from your Microclimate dashboard with [Connecting the local and IBM Cloud Private installations](https://microclimate-dev2ops.github.io/connectlocalandcloud).
	* B.) Create a pipeline for each microservice with [Creating a build pipeline](https://microclimate-dev2ops.github.io/usingapipeline#creating-a-build-pipeline).
	* C.) After a pipeline is created successfully, you can add deployments.
	* D.) Deploy all the microservices with [Deploying applications](https://microclimate-dev2ops.github.io/usingapipeline#deploying-applications).
	* E.) After successful deployments, you can reach the application from the `http://proxy_ip/acmeair` URL.
	* F.) Go to the **Configuration** page and click the **Load the Database** link.

## Istio Instructions

When using Acmeair with the Istio ingress-gateway, the root context for the services need to be redefined as it does not support rewrites. Use the Dockerfile-istio file to build the images for the flight, booking, customer and auth services as it takes care of the required changes.
