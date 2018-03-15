docker build -f ./Dockerfile.a8 -t mainservice-java-a8 .
docker build -f ../authservice-java/Dockerfile.a8 -t authservice-java-a8 ../authservice-java
docker build -f ../bookingservice-java/Dockerfile.a8 -t bookingservice-java-a8 ../bookingservice-java
docker build -f ../customerservice-java/Dockerfile.a8 -t customerservice-java-a8 ../customerservice-java
docker build -f ../flightservice-java/Dockerfile.a8 -t flightservice-java-a8 ../flightservice-java

kubectl apply -f k8s-controlplane.yml

echo "sleeping 1 minute... to let controlplane come up"
sleep 60

kubectl delete -f k8s-acmeair-amalgam8.yml
kubectl create -f k8s-acmeair-amalgam8.yml
