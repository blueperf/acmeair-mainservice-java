#!/bin/bash
# Copyright (c) 2020 IBM Corp.
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

GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
DEFAULT='\033[0;10m'
GRAFANA_DASHBOARD="https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/master/deploy/dashboards/metrics/RHOCP4.2-GrafanaOperator2.0.0-Grafana5.2/open-liberty-grafana-mpMetrics2.x.yml"
APPLICATION_NAMESPACE=$1
NAMESPACE=$2
MANIFESTS=manifests-openshift-metrics

if [[ ${2} == "" ]]
then
  echo "Usage: setupOpenshiftMetrics.sh project_name metrics_project_name"
  exit
fi

echo -e "${GREEN}===> Applying labels to acmeair secure (9443) services...${DEFAULT}"
for service in `oc get svc -o name -n $APPLICATION_NAMESPACE | grep "acmeair-secure-.*-service"`;
do 
  oc label "$service" team=backend -n $APPLICATION_NAMESPACE 
done
cd ../${MANIFESTS}
echo -e "${GREEN}===> Starting operator installation for: $NAMESPACE${DEFAULT}"
echo -e "${YELLOW}Switching to $NAMESPACE...${DEFAULT}" 
oc project $NAMESPACE
echo -e "${YELLOW}Adding cluster-admin role to kube:admin...${DEFAULT}"
oc adm policy add-role-to-user cluster-admin kube:admin
echo -e "${YELLOW}Installing grafana.yaml...${DEFAULT}"   
sed -i "s/__NAMESPACE__/$NAMESPACE/g" grafana.yaml
# Install grafana, grafana datasource
oc apply -f grafana.yaml
echo -e "${YELLOW}Installing Grafana Dashboard from ${PURPLE}${GRAFANA_DASHBOARD}${DEFAULT}"
oc apply -f ${GRAFANA_DASHBOARD}

echo -e "${YELLOW}Installing prometheus.yaml...${DEFAULT}"
sed -i "s/__NAMESPACE__/$NAMESPACE/g" prometheus.yaml
echo -e "${YELLOW}Binding view role to system:serviceaccount:$NAMESPACE:prometheus-k8s...${DEFAULT}"
oc adm policy add-cluster-role-to-user view system:serviceaccount:$NAMESPACE:prometheus-k8s
oc apply -f prometheus.yaml
echo -e "${YELLOW}Exposing service prometheus-operated...${DEFAULT}"
oc expose svc/prometheus-operated

sed -i "s/$NAMESPACE/__NAMESPACE__/g" grafana.yaml
sed -i "s/$NAMESPACE/__NAMESPACE__/g" prometheus.yaml
echo -e "${GREEN}===> Finished operator installation!${DEFAULT}"
