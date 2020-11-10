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
cd ..
#mvn clean pre-integration-test liberty:start liberty:deploy integration-test liberty:stop failsafe:verify

cd ../acmeair-authservice-java
mvn clean pre-integration-test liberty:start liberty:deploy integration-test liberty:stop failsafe:verify

cd ../acmeair-bookingservice-java
mvn clean pre-integration-test liberty:start liberty:deploy integration-test liberty:stop failsafe:verify

cd ../acmeair-customerservice-java
mvn clean pre-integration-test liberty:start liberty:deploy integration-test liberty:stop failsafe:verify

cd ../acmeair-flightservice-java
mvn clean pre-integration-test liberty:start liberty:deploy integration-test liberty:stop failsafe:verify

