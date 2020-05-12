#!/bin/bash
# Copyright (c) 2018 IBM Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MANIFESTS=manifests-openshift

if [[ ${2} == "" ]]
then
  echo "Usage: buildAndDeployToOpenshift.sh <IMAGE_PREFIX> <ROUTE_PATH>"
  exit
fi

IMAGE_PREFIX_EXTERNAL=${1}
IMAGE_PREFIX=${2}
ROUTE_HOST=${3}

echo "Image Prefix External=${IMAGE_PREFIX_EXTERNAL}"
echo "Image Prefix Internal=${IMAGE_PREFIX}"
echo "Route Host=${ROUTE_HOST}"

cd "$(dirname "$0")"
cd ..
kubectl delete -f ${MANIFESTS}
mvn clean package
podman build --pull -t ${IMAGE_PREFIX_EXTERNAL}/acmeair-mainservice-java:latest .
podman push ${IMAGE_PREFIX_EXTERNAL}/acmeair-mainservice-java:latest --tls-verify=false

if [[ `grep -c ${IMAGE_PREFIX} ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml` == 0 ]]
then
  echo "Adding ${IMAGE_PREFIX}/"
  sed -i.bak "s@acmeair-mainservice-java:latest@${IMAGE_PREFIX}/acmeair-mainservice-java:latest@" ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml
fi

if [[ `grep -c ${ROUTE_HOST} ${MANIFESTS}/acmeair-mainservice-route.yaml` == 0 ]]
then
  echo "Patching Route Host: ${ROUTE_HOST}"
  sed -i.bak "s@_HOST_@${ROUTE_HOST}@" ${MANIFESTS}/acmeair-mainservice-route.yaml
fi

kubectl apply -f ${MANIFESTS}

echo "Removing ${IMAGE_PREFIX}"
sed -i.bak "s@${IMAGE_PREFIX}/acmeair-mainservice-java:latest@acmeair-mainservice-java:latest@" ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml

echo "Removing ${ROUTE_HOST}"
sed -i.bak "s@${ROUTE_HOST}@_HOST_@" ${MANIFESTS}/acmeair-mainservice-route.yaml

rm ${MANIFESTS}/acmeair-mainservice-route.yaml.bak
rm ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml.bak

cd ../acmeair-authservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
podman build --pull -t ${IMAGE_PREFIX_EXTERNAL}/acmeair-authservice-java .
podman push ${IMAGE_PREFIX_EXTERNAL}/acmeair-authservice-java:latest --tls-verify=false

if [[ `grep -c ${IMAGE_PREFIX} ${MANIFESTS}/deploy-acmeair-authservice-java.yaml` == 0 ]]
then
  echo "Adding ${IMAGE_PREFIX}/"
  sed -i.bak "s@acmeair-authservice-java:latest@${IMAGE_PREFIX}/acmeair-authservice-java:latest@" ${MANIFESTS}/deploy-acmeair-authservice-java.yaml
fi

if [[ `grep -c ${ROUTE_HOST} ${MANIFESTS}/acmeair-authservice-route.yaml` == 0 ]]
then
  echo "Patching Route Host: ${ROUTE_HOST}"
  sed -i.bak "s@_HOST_@${ROUTE_HOST}@" ${MANIFESTS}/acmeair-authservice-route.yaml
fi

kubectl apply -f ${MANIFESTS}

echo "Removing ${IMAGE_PREFIX}"
sed -i.bak "s@${IMAGE_PREFIX}/acmeair-authservice-java:latest@acmeair-authservice-java:latest@" ${MANIFESTS}/deploy-acmeair-authservice-java.yaml

echo "Removing ${ROUTE_HOST}"
sed -i.bak "s@${ROUTE_HOST}@_HOST_@" ${MANIFESTS}/acmeair-authservice-route.yaml

rm ${MANIFESTS}/acmeair-authservice-route.yaml.bak
rm ${MANIFESTS}/deploy-acmeair-authservice-java.yaml.bak

cd ../acmeair-bookingservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
podman build --pull -t ${IMAGE_PREFIX_EXTERNAL}/acmeair-bookingservice-java .
podman push ${IMAGE_PREFIX_EXTERNAL}/acmeair-bookingservice-java:latest --tls-verify=false

if [[ `grep -c ${IMAGE_PREFIX} ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml` == 0 ]]
then
  echo "Adding ${IMAGE_PREFIX}/"
  sed -i.bak "s@acmeair-bookingservice-java:latest@${IMAGE_PREFIX}/acmeair-bookingservice-java:latest@" ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml
fi

if [[ `grep -c ${ROUTE_HOST} ${MANIFESTS}/acmeair-bookingservice-route.yaml` == 0 ]]
then
  echo "Patching Route Host: ${ROUTE_HOST}"
  sed -i.bak "s@_HOST_@${ROUTE_HOST}@" ${MANIFESTS}/acmeair-bookingservice-route.yaml
fi

kubectl apply -f ${MANIFESTS}

echo "Removing ${IMAGE_PREFIX}"
sed -i.bak "s@${IMAGE_PREFIX}/acmeair-bookingservice-java:latest@acmeair-bookingservice-java:latest@" ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml

echo "Removing ${ROUTE_HOST}"
sed -i.bak "s@${ROUTE_HOST}@_HOST_@" ${MANIFESTS}/acmeair-bookingservice-route.yaml

rm ${MANIFESTS}/acmeair-bookingservice-route.yaml.bak
rm ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml.bak



cd ../acmeair-customerservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
podman build --pull -t ${IMAGE_PREFIX_EXTERNAL}/acmeair-customerservice-java .
podman push ${IMAGE_PREFIX_EXTERNAL}/acmeair-customerservice-java:latest --tls-verify=false

if [[ `grep -c ${IMAGE_PREFIX} ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml` == 0 ]]
then
  echo "Adding ${IMAGE_PREFIX}/"
  sed -i.bak "s@acmeair-customerservice-java:latest@${IMAGE_PREFIX}/acmeair-customerservice-java:latest@" ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml
fi

if [[ `grep -c ${ROUTE_HOST} ${MANIFESTS}/acmeair-customerservice-route.yaml` == 0 ]]
then
  echo "Patching Route Host: ${ROUTE_HOST}"
  sed -i.bak "s@_HOST_@${ROUTE_HOST}@" ${MANIFESTS}/acmeair-customerservice-route.yaml
fi

kubectl apply -f ${MANIFESTS}

echo "Removing ${IMAGE_PREFIX}"
sed -i.bak "s@${IMAGE_PREFIX}/acmeair-customerservice-java:latest@acmeair-customerservice-java:latest@" ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml

echo "Removing ${ROUTE_HOST}"
sed -i.bak "s@${ROUTE_HOST}@_HOST_@" ${MANIFESTS}/acmeair-customerservice-route.yaml

rm ${MANIFESTS}/acmeair-customerservice-route.yaml.bak
rm ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml.bak

cd ../acmeair-flightservice-java
kubectl delete -f ${MANIFESTS}
mvn clean package
podman build --pull -t ${IMAGE_PREFIX_EXTERNAL}/acmeair-flightservice-java .
podman push ${IMAGE_PREFIX_EXTERNAL}/acmeair-flightservice-java:latest --tls-verify=false

if [[ `grep -c ${IMAGE_PREFIX} ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml` == 0 ]]
then
  echo "Adding ${IMAGE_PREFIX}/"
  sed -i.bak "s@acmeair-flightservice-java:latest@${IMAGE_PREFIX}/acmeair-flightservice-java:latest@" ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml
fi

if [[ `grep -c ${ROUTE_HOST} ${MANIFESTS}/acmeair-flightservice-route.yaml` == 0 ]]
then
  echo "Patching Route Host: ${ROUTE_HOST}"
  sed -i.bak "s@_HOST_@${ROUTE_HOST}@" ${MANIFESTS}/acmeair-flightservice-route.yaml
fi

kubectl apply -f ${MANIFESTS}

echo "Removing ${IMAGE_PREFIX}"
sed -i.bak "s@${IMAGE_PREFIX}/acmeair-flightservice-java:latest@acmeair-flightservice-java:latest@" ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml

echo "Removing ${ROUTE_HOST}"
sed -i.bak "s@${ROUTE_HOST}@_HOST_@" ${MANIFESTS}/acmeair-flightservice-route.yaml

rm ${MANIFESTS}/acmeair-flightservice-route.yaml.bak
rm ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml.bak



