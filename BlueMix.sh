## Replace these with the your env.
MONGO_BRIDGE=MongoBridge3
BLUEMIX_REGISTRY_NAMESPACE=wasperf
BLUEMIX_REGISTRY_HOST=registry.ng.bluemix.net
ROUTES_DOMAIN=mybluemix.net

## Replace these with the your route names.
CONTROLLER_HOSTNAME=acmeair-controller
REGISTRY_HOSTNAME=acmeair-registry
GATEWAY_HOSTNAME=acmeair-home


GATEWAY_IMAGE=a8-sidecar:latest
CONTROLLER_IMAGE=a8-controller:latest
REGISTRY_IMAGE=a8-registry:latest

###NOTE: Use HTTP and not HTTPS for the controller and registry URLs.
CONTROLLER_URL=http://${CONTROLLER_HOSTNAME}.${ROUTES_DOMAIN}
REGISTRY_URL=http://${REGISTRY_HOSTNAME}.${ROUTES_DOMAIN}

DOCKERHUB_NAMESPACE=amalgam8

CONTROLPLANE_IMAGES=(
    ${CONTROLLER_IMAGE}
    ${REGISTRY_IMAGE}
    ${GATEWAY_IMAGE}
)

if [[ $1 != "--skipBuildAndPush" ]]
then 
#################################################################################
# Build Services
#################################################################################

docker build -f ./Dockerfile.a8 -t ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/mainservice-java-a8 .
docker build -f ../authservice-java/Dockerfile.a8 -t ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/authservice-java-a8 ../authservice-java
docker build -f ../bookingservice-java/Dockerfile.a8 -t ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/bookingservice-java-a8 ../bookingservice-java
docker build -f ../customerservice-java/Dockerfile.a8 -t ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/customerservice-java-a8 ../customerservice-java
docker build -f ../flightservice-java/Dockerfile.a8 -t ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/flightservice-java-a8 ../flightservice-java

docker pull amalgam8/a8-sidecar:latest
docker pull amalgam8/a8-controller:latest
docker pull amalgam8/a8-registry:latest

docker tag amalgam8/a8-sidecar:latest ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-sidecar:latest
docker tag amalgam8/a8-registry:latest ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-registry:latest
docker tag amalgam8/a8-controller:latest ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-controller:latest


#################################################################################
# Push Services
#################################################################################

docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/mainservice-java-a8
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/authservice-java-a8
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/bookingservice-java-a8
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/customerservice-java-a8
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/flightservice-java-a8

docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-sidecar:latest
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-registry:latest
docker push ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/a8-controller:latest

#for image in ${CONTROLPLANE_IMAGES[@]}; do
#  echo "$BLUEMIX_IMAGES" | grep "$image" > /dev/null
#  if [ $? -ne 0 ]; then
#    echo "Copying ${DOCKERHUB_NAMESPACE}/$image from Dockerhub into ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/$image"
#    bluemix ic cpi ${DOCKERHUB_NAMESPACE}/$image ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/$image
#  fi
#done
#
fi

#################################################################################
# Start controller and registry
#################################################################################
echo "Starting controller"
bluemix ic group-create --name amalgam8_controller \
    --publish 8080 --memory 128 --auto \
    --min 1 --max 2 --desired 1 \
    --hostname $CONTROLLER_HOSTNAME \
    --domain $ROUTES_DOMAIN \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${CONTROLLER_IMAGE}

echo "Starting registry"
bluemix ic group-create --name amalgam8_registry \
    --publish 8080 --memory 128 --auto \
    --min 1 --max 2 --desired 1 \
    --hostname $REGISTRY_HOSTNAME \
    --domain $ROUTES_DOMAIN \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${REGISTRY_IMAGE}

        # Wait for controller route to set up
        echo "Waiting for controller route to set up"
        attempt=0
        while true; do
            code=$(curl -w "%{http_code}" --max-time 10 "${CONTROLLER_URL}/health" -o /dev/null)
            if [ "$code" = "200" ]; then
                echo "Controller route is set to '$CONTROLLER_URL'"
                break
            fi

            attempt=$((attempt + 1))
            if [ "$attempt" -gt 15 ]; then
                echo "Timeout waiting for controller route: /health returned HTTP ${code}"
                echo "Deploying the controlplane has failed"
                exit 1
            fi
            sleep 10s
        done 

#################################################################################
# Start Main Service
#################################################################################
echo "Starting main"
bluemix ic group-create --name acmeair-mainservice-java-a8 \
    --publish 9080 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_SERVICE=main \
    --env A8_ENDPOINT_PORT=9080 \
    --env A8_ENDPOINT_TYPE=http \
    --env A8_REGISTER=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/mainservice-java-a8
#################################################################################
# Start Booking Service
#################################################################################
echo "Starting booking"
bluemix ic group-create --name acmeair-bookingservice-java-a8 \
    --publish 9080 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_SERVICE=booking \
    --env A8_ENDPOINT_PORT=9080 \
    --env A8_ENDPOINT_TYPE=http \
    --env A8_REGISTER=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
    -e CCS_BIND_APP=${MONGO_BRIDGE} \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/bookingservice-java-a8
      
#################################################################################
# Start Customer Service
#################################################################################
echo "Starting customer"
bluemix ic group-create --name acmeair-customerservice-java-a8 \
    --publish 9080 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_SERVICE=customer \
    --env A8_ENDPOINT_PORT=9080 \
    --env A8_ENDPOINT_TYPE=http \
    --env A8_REGISTER=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
    -e CCS_BIND_APP=${MONGO_BRIDGE} \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/customerservice-java-a8
     
#################################################################################
# Start Flight Service
#################################################################################
echo "Starting flight"
bluemix ic group-create --name acmeair-flightservice-java-a8 \
    --publish 9080 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_SERVICE=flight \
    --env A8_ENDPOINT_PORT=9080 \
    --env A8_ENDPOINT_TYPE=http \
    --env A8_REGISTER=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
    -e CCS_BIND_APP=${MONGO_BRIDGE} \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/flightservice-java-a8
 
#################################################################################
# Start Auth Service
#################################################################################

echo "Starting auth"
bluemix ic group-create --name acmeair-authservice-java-a8 \
    --publish 9080 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_SERVICE=auth \
    --env A8_ENDPOINT_PORT=9080 \
    --env A8_ENDPOINT_TYPE=http \
    --env A8_REGISTER=true \
    --env A8_REGISTRY_POLL=15s \
    --env A8_CONTROLLER_URL=$CONTROLLER_URL \
    --env A8_CONTROLLER_POLL=15s \
    --env A8_PROXY=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/authservice-java-a8

#################################################################################
# Start the gateway
#################################################################################
echo "Starting  gateway"
bluemix ic group-create --name acmeair_gateway \
    --publish 6379 --memory 128 --auto --anti \
    --min 1 --max 2 --desired 1 \
    --hostname $GATEWAY_HOSTNAME \
    --domain $ROUTES_DOMAIN \
    --env A8_REGISTRY_URL=$REGISTRY_URL \
    --env A8_REGISTRY_POLL=5s \
    --env A8_CONTROLLER_URL=$CONTROLLER_URL \
    --env A8_CONTROLLER_POLL=5s \
    --env A8_SERVICE=gateway:none: \
    --env A8_PROXY=true \
    --env A8_LOG_LEVEL=error \
    --env GODEBUG=netdns=go \
    --env HTTP_MONITOR_RC_LIST=200,201,202,204,300,301,302,401,403,404,426 \
      ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${GATEWAY_IMAGE}

#echo "Starting  gateway"
#bluemix ic create --name acmeair_gateway \
#    --publish 6379 --memory 128 \
#    --env A8_REGISTRY_URL=$REGISTRY_URL \
#    --env A8_REGISTRY_POLL=5s \
#    --env A8_CONTROLLER_URL=$CONTROLLER_URL \
#    --env A8_CONTROLLER_POLL=5s \
#    --env A8_SERVICE=gateway:none: \
#    --env A8_PROXY=true \
#    --env A8_LOG_LEVEL=error \
#    --env GODEBUG=netdns=go \
#    --env HTTP_MONITOR_RC_LIST=200,201,202,204,300,301,302,401,403,404,426 \
#     ${BLUEMIX_REGISTRY_HOST}/${BLUEMIX_REGISTRY_NAMESPACE}/${GATEWAY_IMAGE}

