
## Acme Air Main Service - Java/Liberty

An implementation of the Acme Air Main Service for Java/Liberty. The main service primarily consists of the presentation layer (web pages) that interact with the other services.

This implementation can support running on a variety of runtime platforms including standalone bare metal system, Virtual Machines, docker containers, IBM Cloud, IBM Cloud Private, and other Kubernetes environments.

## Build Instructions
* Instructions for [setting up and building the codebase](Build_Instructions.md)

## JMeter Instructions
* Instructions for [driving load to the app after it has been deployed](https://github.com/blueperf/acmeair-mainservice-java/tree/master/jmeter-files)

## Full Benchmark Installation Instructions on various docker enviornments.
![alt text](https://github.com/blueperf/acmeair-mainservice-java/blob/master/images/AcmeairMS.png "AcmeairMS Java")

## Prerequisites
All of these examples assume you have the acmeair-mainservice-java, acmeair-authservice-java, acmeair-bookingservice-java, acmeair-customerservice-java, and acmeair-flightservice-java directories, (and possibly others) on your docker machine in the same directory. It also assumes all applications have been built with maven.


## Docker Instructions

Prereq: [Install Docker, docker-compose, and start Docker daemon on your local machine](https://docs.docker.com/installation/)

1. cd acmeair-mainservice-java
2. Create docker network
 * docker network create --driver bridge my-net
3. Build/Start Containers. This will build all the micro-services, mongo db instances, and an nginx proxy.
    * docker-compose --pull build
    * NETWORK=my-net docker-compose up

4. Go to http://docker_machine_ip/main/acmeair
5. Go to the Configuration Page and Load the Database

## Openshift Instructions
This doc assumes that
* Openshift is installed and configured
* The docker env is logged into the openshift image repository
  * Example: docker login -u developer -p $(oc whoami -t) 172.30.1.1:5000
* oc and kubectl are attached the Openshift cluster

1. Create new procject: oc new-project acmeair
2. Determine host for the route. 
   * Example: acmeair.192.168.99.101.nip.io (The part after acmeair. should match other routes for you cluster) 
3. Run ./buildAndDeployToOpenshift.sh docker-repo/project_name host_name
   * Example: ./buildAndDeployToOpenshift.sh 172.30.1.1:5000/acmeair acmeair.192.168.99.101.nip.io

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

## IBM Cloud Private Instructions
This doc assumes that
* ICP is installed and configured
* The docker env is logged into the ICP docker repo
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
3. Wait a couple minutes and go to http://proxy_ip/acmeair
4. Go to the Configuration Page and Load the Database
5. Cleanup
   * Helm chart
      * `./deleteChartRelease.sh`
   * Loose deployment manifests
      * `./deleteKubeObjects.sh`

## Istio Instructions

There is also a sample [manifest file](./manifests-istio/deploy-acmeair-istio.yaml) for deployment of the Acmeair application in a Istio service mesh, with all services and deployments required to run the application, including the gateway and virtual services definition. The required Mongo databases are also deployed as pods/services. You need to define the docker images to be used and inject the sidecars, either automatically or manually (with kubectl kube-inject command).  
