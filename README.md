
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

## Docker

There are 2 ways to run with Docker
1. Simple - In this version, there is no Service Discovery/Registry. If you add a service, you will also need to manually update the nginx configuration file (nginx/conf/nginx.conf)
2. amalgam8 - This uses amalgam8 as the Service Registry and Proxy. If you add a service to the docker-compose yaml, it will automatically get updated.


## Docker Instructions - Simple

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd mainservice-node
2. Create docker network
 * docker network create --driver bridge my-net
3. Build/Start Containers. This will build all the node micro-services, mongo db instances, and an nginx proxy.
    * docker-compose build
    * NETWORK=my-net docker-compose up

4. Go to http://docker_machine_ip/main/acmeair


## Docker Instructions - amalgam8

This example assumes you have the mainservice, authservice, bookingservice, customerservice, and flightservice directories, (and possibly others) on your docker machine in the same directory.

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd mainservice-java
2. Start amalgam8 control-plane
    * docker-compose -f docker-controlplane-amalgam8.yml up -d
3. Start service Containers
    * docker-compose -f docker-acmeair-amalgam8.yml up -d

4. Wait a minute and go to http://docker_machine_ip:32000/main/acmeair

## Minikube/Kubernetes Instructions - w/ amalgam8

* Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)
* Prereq: Install and configure Minikube, and install kubectl.

1. cd mainservice-java
2. Build and Deploy Services
	./k8s.sh
3. Wait a couple minutes and go to http://kubernetes_ip:32000/main/acmeair

## Full IBM Spectrum CFC Kubernetes Instructions - w/ Ingress
This doc assumes that
* CFC is installed and configured
* The docker env is logged into the CFC docker repo
	* docker login master.cfc:8500

* kubectl is attached the CFC cluster

* You are running CFC as admin

* maven is installed and set up to build with a full SDK.

1. Clone the repository

	`git clone https://github.ibm.com/BluemixPerf/mainservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/authervice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/bookingservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/customerservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/flightservice-java.git`

2. Build and push the apps

	`cd mainservice-java`

	`./buildAndPushtoCFC.sh`

3. Deploy to cfc.

	* `kubectl apply -f k8s-cfc.yml`
	* If the Microservice Builder fabric is installed: `kubectl apply -f k8s-cfc-with-mb-fabric.yml `

## Full IBM Spectrum CFC Kubernetes Instructions - w/ istio (In progress)
This doc assumes that
* CFC is installed and configured
* The docker env is logged into the CFC docker repo
	* docker login master.cfc:8500

* kubectl is attached the CFC cluster

* You are running CFC as admin

* maven is installed and set up to build with a full SDK.

* istio is installed on the CFC cluster

1. Clone the repository

	`git clone https://github.ibm.com/BluemixPerf/mainservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/authervice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/bookingservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/customerservice-java.git`

	`git clone https://github.ibm.com/BluemixPerf/flightservice-java.git`

2. In the server.xmls for the authservice-java, bookingservice-java, customerservice-java, and flightservice-java directories, change the context root from / to /<SERVICE_NAME>

	`Example: contextRoot="/auth" />`

3. Build and push the apps

	`cd mainservice-java`

	`./buildAndPushtoCFC.sh`

3. Deploy to cfc.

	* `kubectl apply -f <(istopctl kube-inject -f k8s-cfc-istio.yml)`


## Bluemix Armada Kubrnetes Instructions (TODO)


## IBM Containers Instructions

Prereq:

* [Install Docker and stared Docker daemon on your local machine](https://docs.docker.com/installation/) 
* [Install Cloud Foundry](http://docs.cloudfoundry.org/cf-cli/)  
* [IBM Containers Plugin](https://console.ng.bluemix.net/docs/containers/container_cli_cfic.html) 
* [Setup Compose Mongo DB & create acmeair database](https://www.compose.io/mongodb/)

### Connect MongoDB to Bluemix Environment
Retrieve & save these information from Compose Mongo DB

	  hostname,"port", "db", "username", "password”

 Create a string:
	
        "url": "mongodb://username:password@hostname:port/db"
	    e.g. mongodb://acmeuser:password@myServer.dblayer.com:27017/acmeair

 On cf cli, run following commands to create Compose Mongo DB service on Bluemix:

	cf cups mongoCompose -p "url"
	
	At the URL prompt, enter above URL that was created:
	url>mongodb://acmeuser:password@myServer.dblayer.com:27017/acmeair

Mongo DB CF Bridge App:

	On Bluemix UI, go to dashboard
	
	Under “Cloud Foundry App”, click CREATE APP > WEB > SDK for Node.js > Continue > Enter “MongoBridge1” as an app name > FINISH
	
	Click “Overview” from left navigator for “MongoBridge” app > Click “Bind a Service” > Select “mongoCompose” that you have created > ADD
	

### Create Routes
Three routes need to be created
* CONTROLLER_HOSTNAME
* REGISTRY_HOSTNAME
* GATEWAY_HOSTNAME

	bluemix cf create-route <bluemix_registry_namespace> mybluemix.net -n <route>

Examples:
On cf cli,
	
	bluemix cf create-route wasperf mybluemix.net -n acmeair-a8-controller
	bluemix cf create-route wasperf mybluemix.net -n acmeair-a8-registry
	bluemix cf create-route wasperf mybluemix.net -n acmeair-gatwway


### Create Container Groups in IBM Container service
In Bluemix.sh, update the following variables.
Example:


	## Replace these with the your env.
	MONGO_BRIDGE=
	BLUEMIX_REGISTRY_NAMESPACE=
	BLUEMIX_REGISTRY_HOST=registry.ng.bluemix.net
	ROUTES_DOMAIN=mybluemix.net

	## Replace these with your route names.
	CONTROLLER_HOSTNAME=
	REGISTRY_HOSTNAME=
	GATEWAY_HOSTNAME=

	
On local docker server, Go to the root directory of mainservice-java.	

Invoke:
    
    ./Bluemix.sh

By default, this will build the docker images for all the services, push them to Bluemix, create container groups for each service.

Wait for couple minutes AFTER all services are running  initialization including networking.

	http://GATEWAY_HOSTNAME/main/acmeair/config.html
	http://GATEWAY_HOSTNAME/main/acmeair

