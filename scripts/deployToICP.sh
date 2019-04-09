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

#!/bin/bash

if [[ "${1}" == "--with-microclimate" ]]
then 
  MANIFESTS=manifests
else
  MANIFESTS=manifests-no-mc
fi

cd "$(dirname "$0")"
cd ..
kubectl delete -f ${MANIFESTS}
if [[ `grep -c mycluster.icp ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml` == 0 ]]
then
  echo "Adding mycluster.icp:8500/default/"
  sed -i "s@acmeair-mainservice-java:latest@mycluster.icp:8500/default/acmeair-mainservice-java:latest@" ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml
fi
kubectl apply -f ${MANIFESTS}
echo "Removing mycluster.icp:8500/default/"
sed -i "s@mycluster.icp:8500/default/acmeair-mainservice-java:latest@acmeair-mainservice-java:latest@" ${MANIFESTS}/deploy-acmeair-mainservice-java.yaml


cd ../acmeair-authservice-java
kubectl delete -f ${MANIFESTS}
if [[ `grep -c mycluster.icp ${MANIFESTS}/deploy-acmeair-authservice-java.yaml` == 0 ]]
then
  echo "Adding mycluster.icp:8500/default/"
  sed -i "s@acmeair-authservice-java:latest@mycluster.icp:8500/default/acmeair-authservice-java:latest@" ${MANIFESTS}/deploy-acmeair-authservice-java.yaml
fi
kubectl apply -f ${MANIFESTS}
echo "Removing mycluster.icp:8500/default/"
sed -i "s@mycluster.icp:8500/default/acmeair-authservice-java:latest@acmeair-authservice-java:latest@" ${MANIFESTS}/deploy-acmeair-authservice-java.yaml


cd ../acmeair-bookingservice-java
kubectl delete -f ${MANIFESTS}
if [[ `grep -c mycluster.icp ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml` == 0 ]]
then
  echo "Adding mycluster.icp:8500/default/"
  sed -i "s@acmeair-bookingservice-java:latest@mycluster.icp:8500/default/acmeair-bookingservice-java:latest@" ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml
fi
kubectl apply -f ${MANIFESTS}
echo "Removing mycluster.icp:8500/default/"
sed -i "s@mycluster.icp:8500/default/acmeair-bookingservice-java:latest@acmeair-bookingservice-java:latest@" ${MANIFESTS}/deploy-acmeair-bookingservice-java.yaml


cd ../acmeair-customerservice-java
kubectl delete -f ${MANIFESTS}
if [[ `grep -c mycluster.icp ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml` == 0 ]]
then
  echo "Adding mycluster.icp:8500/default/"
  sed -i "s@acmeair-customerservice-java:latest@mycluster.icp:8500/default/acmeair-customerservice-java:latest@" ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml
fi
kubectl apply -f ${MANIFESTS}
echo "Removing mycluster.icp:8500/default/"
sed -i "s@mycluster.icp:8500/default/acmeair-customerservice-java:latest@acmeair-customerservice-java:latest@" ${MANIFESTS}/deploy-acmeair-customerservice-java.yaml


cd ../acmeair-flightservice-java
kubectl delete -f ${MANIFESTS}
if [[ `grep -c mycluster.icp ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml` == 0 ]]
then
  echo "Adding mycluster.icp:8500/default/"
  sed -i "s@acmeair-flightservice-java:latest@mycluster.icp:8500/default/acmeair-flightservice-java:latest@" ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml
fi
kubectl apply -f ${MANIFESTS}
echo "Removing mycluster.icp:8500/default/"
sed -i "s@mycluster.icp:8500/default/acmeair-flightservice-java:latest@acmeair-flightservice-java:latest@" ${MANIFESTS}/deploy-acmeair-flightservice-java.yaml
