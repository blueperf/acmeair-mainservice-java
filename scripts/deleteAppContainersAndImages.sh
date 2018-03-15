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

echo "Delete Docker Exited Docker Containers"

docker rm -v -f $(docker ps -a -q -f "status=exited")
docker rmi -f $(docker images -f "dangling=true" -q)
docker rmi -f mainservicejava_acmeair-authservice-java mainservicejava_nginx1 mainservicejava_acmeair-customerservice-java mainservicejava_acmeair-flightservice-java mainservicejava_acmeair-bookingservice-java mainservicejava_acmeair-mainservice-java
#docker rmi websphere-liberty:beta websphere-liberty:latest websphere-liberty:microProfile
