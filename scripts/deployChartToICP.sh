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


cd "$(dirname "$0")"
pwd

helm install \
  --tls \
  --name="acmeair-mainservice-java" \
  --set image.repository="mycluster.icp:8500/default/acmeair-mainservice-java" \
  --set image.pullPolicy="Always" \
  --set service.type="ClusterIP" \
  --set service.port="9080" \
  --set service.targetPort="9080" \
  --set service.name="acmeair-main-service" \
  --set ssl.enabled="false" \
  --set ingress.enabled="true" \
  --set ingress.path="/acmeair" \
  --set ingress.rewriteTarget="/acmeair" \
  ../chart/ibm-websphere-liberty 

  
helm install \
  --tls \
  --name="acmeair-authservice-java" \
  --set image.repository="mycluster.icp:8500/default/acmeair-authservice-java" \
  --set image.pullPolicy="Always" \
  --set service.type="ClusterIP" \
  --set service.port="9080" \
  --set service.targetPort="9080" \
  --set service.name="acmeair-auth-service" \
  --set ssl.enabled="false" \
  --set ingress.enabled="true" \
  --set ingress.path="/auth" \
  --set ingress.rewriteTarget="/" \
  --set env.jvmArgs="-Dcom.acmeair.client.CustomerClient/mp-rest/url=http://acmeair-customer-service:9080" \
  ../../acmeair-authservice-java/chart/ibm-websphere-liberty
  
  
  
helm install \
  --tls \
  --name="acmeair-bookingservice-java" \
  --set image.repository="mycluster.icp:8500/default/acmeair-bookingservice-java" \
  --set image.pullPolicy="Always" \
  --set service.type="ClusterIP" \
  --set ssl.enabled="false" \
  --set service.port="9080" \
  --set service.targetPort="9080" \
  --set service.name="acmeair-booking-service" \
  --set ingress.enabled="true" \
  --set ingress.path="/booking" \
  --set ingress.rewriteTarget="/" \
  --set env.jvmArgs="-Dcom.acmeair.client.CustomerClient/mp-rest/url=http://acmeair-customer-service:9080 -Dcom.acmeair.client.FlightClient/mp-rest/url=http://acmeair-flight-service:9080 -DMONGO_HOST=acmeair-booking-db" \
  ../../acmeair-bookingservice-java/chart/ibm-websphere-liberty

  
helm install \
  --tls \
  --name="acmeair-customerservice-java" \
  --set image.repository="mycluster.icp:8500/default/acmeair-customerservice-java" \
  --set image.pullPolicy="Always" \
  --set service.type="ClusterIP" \
  --set ssl.enabled="false" \
  --set service.port="9080" \
  --set service.targetPort="9080" \
  --set service.name="acmeair-customer-service" \
  --set ingress.enabled="true" \
  --set ingress.path="/customer" \
  --set ingress.rewriteTarget="/" \
  --set env.jvmArgs="-DMONGO_HOST=acmeair-customer-db" \
  ../../acmeair-customerservice-java/chart/ibm-websphere-liberty
  
  
helm install \
  --tls \
  --name="acmeair-flightservice-java" \
  --set image.repository="mycluster.icp:8500/default/acmeair-flightservice-java" \
  --set image.pullPolicy="Always" \
  --set service.type="ClusterIP" \
  --set ssl.enabled="false" \
  --set service.port="9080" \
  --set service.targetPort="9080" \
  --set service.name="acmeair-flight-service" \
  --set ingress.enabled="true" \
  --set ingress.path="/flight" \
  --set ingress.rewriteTarget="/" \
  --set env.jvmArgs="-DMONGO_HOST=acmeair-flight-db" \
  ../../acmeair-flightservice-java/chart/ibm-websphere-liberty 

