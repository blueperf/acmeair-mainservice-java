
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

4. Go to http://docker_machine_ip/acmeair
5. Go to the Configuration Page and Load the Database or do the following:
    ```
    curl http://docker_machine_ip/booking/loader/load
    curl http://docker_machine_ip/flight/loader/load
    curl http://docker_machine_ip/customer/loader/load?numCustomers=10000
    ```

## Openshift Instructions
This doc assumes Openshift is installed and configured, and internal image registry is available and its default-route is exposed.

1. Log in with oc 

   Example
   ```
   oc login https://api.your.clusterhost.com:6443 -u ocpadmin -p password
   ```

2. Create new project
   ```
   oc new-project acmeair
   ```
3. Run the deploy script. This will build the code, build the conatainers, push the containers, and setup the deployments for all 5 services.
   ```
   cd acmeair-mainservice-java/scripts
   ./buildAndDeployToOpenshift.sh
   ```
   Add podman as the last argument if using podman.
   ```
   ./buildAndDeployToOpenshift.sh podman
   ```
4. Go to http://acmeair.apps.your.clusterhost.com/acmeair
5. Go to the Configuration Page and Load the Database or do the following:
    ```
    curl http://acmeair.apps.your.clusterhost.com/booking/loader/load
    curl http://acmeair.apps.your.clusterhost.com/flight/loader/load
    curl http://acmeair.apps.your.clusterhost.com/customer/loader/load?numCustomers=10000
    ```

### Addon: Openshift Application Metrics (Optional)
1. Create new project: oc new-project app-metrics
2. On the Openshift console under "Operators", click "Operator Hub" and install the following operators to your individual project.
    * Install "Grafana Operator"
    * Install "Prometheus Operator"
3. Run ./setupOpenshiftMetrics.sh project_name app_metrics_project_name
    * Example: ./setupOpenshiftMetrics.sh acmeair app-metrics
4. Visit the Grafana URL in the "Networking" > "Routes" section and click to open the pre-loaded dashboard.

### Addon: Openshift Application Tracing (Optional)
1. On the Openshift console, navigate to your acmeair project
2. The following environment variables are already setup in each acmeair deployment for your ease of use.
    * JAEGER_AGENT_HOST - jaeger-all-in-one-inmemory-agent
    * JAEGER_AGENT_PORT - 6832
    * JAEGER_ENDPOINT - http://jaeger-all-in-one-inmemory-collector:14268/api/traces
3. Under "Operators", click "Operator Hub" and install the "Community Jaeger Operator" to your individual project.
4. Click "Installed Operators" and for the newly installed operator create a new Jaeger instance.
5. Visit the Jaeger URL in the "Networking" > "Routes" section and load test the application to see some traces.

## Logging/Tracing Options: 

To get more data, you can optionally enable access logs and tracing or switch the logging format to json for each service by updating the following env variables.
```
    - name: LOGGING_FORMAT
      value: 'json'
    - name: ACCESS_LOGGING_ENABLED
      value: 'true'
    - name: TRACE_SPEC
      value: 'com.acmeair*=all'
```

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

## Istio Instructions

There is also a sample [manifest file](./manifests-istio/deploy-acmeair-istio.yaml) for deployment of the Acmeair application in a Istio service mesh, with all services and deployments required to run the application, including the gateway and virtual services definition. The required Mongo databases are also deployed as pods/services. You need to define the docker images to be used and inject the sidecars, either automatically or manually (with kubectl kube-inject command).  
