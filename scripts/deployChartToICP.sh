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

set -exo pipefail

NAMESPACE="default"

if [[ "${1}" == "--open-liberty" ]]
then
  DOCKERFILE=Dockerfile-ol-base
  CLUSTER=${2:-mycluster.icp}
  CHART="ibm-open-liberty"
  SUFFIX="-ol"
else
  CLUSTER=${1:-mycluster.icp}
  CHART="ibm-websphere-liberty"
  SUFFIX=""
fi



cd "$(dirname "$0")"
pwd

helm install \
  --tls \
  --namespace="${NAMESPACE}" \
  --name="acmeair-mainservice-java" \
  --set ${CHART}.image.repository="${CLUSTER}:8500/${NAMESPACE}/acmeair-mainservice-java" \
  ../chart${SUFFIX}/acmeair-mainservice-java

  
helm install \
  --tls \
  --namespace="${NAMESPACE}" \
  --name="acmeair-authservice-java" \
  --set ${CHART}.image.repository="${CLUSTER}:8500/${NAMESPACE}/acmeair-authservice-java" \
  ../../acmeair-authservice-java/chart${SUFFIX}/acmeair-authservice-java
  
  
  
helm install \
  --tls \
  --namespace="${NAMESPACE}" \
  --name="acmeair-bookingservice-java" \
  --set ${CHART}.image.repository="${CLUSTER}:8500/${NAMESPACE}/acmeair-bookingservice-java" \
  ../../acmeair-bookingservice-java/chart${SUFFIX}/acmeair-bookingservice-java

  
helm install \
  --tls \
  --namespace="${NAMESPACE}" \
  --name="acmeair-customerservice-java" \
  --set ${CHART}.image.repository="${CLUSTER}:8500/${NAMESPACE}/acmeair-customerservice-java" \
  ../../acmeair-customerservice-java/chart${SUFFIX}/acmeair-customerservice-java
  
  
helm install \
  --tls \
  --namespace="${NAMESPACE}" \
  --name="acmeair-flightservice-java" \
  --set ${CHART}.image.repository="${CLUSTER}:8500/${NAMESPACE}/acmeair-flightservice-java" \
  ../../acmeair-flightservice-java/chart${SUFFIX}/acmeair-flightservice-java

