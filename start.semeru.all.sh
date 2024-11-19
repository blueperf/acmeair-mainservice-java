podman run --rm --name acmeair-customerservice-java --privileged -d --net=my-net --memory=1024m --cpuset-cpus 2 quarkus-semeru-customerservice 
sleep 1
podman run --rm --name acmeair-flightservice-java --privileged -d --net=my-net --memory=1024m --cpuset-cpus 3 quarkus-semeru-flightservice
sleep 1
podman run --rm --name acmeair-bookingservice-java --privileged -d --net=my-net --memory=1024m --cpuset-cpus 4 quarkus-semeru-bookingservice
sleep 1
podman run --rm --name acmeair-authservice-java --privileged -d --net=my-net --memory=1024m --cpuset-cpus 5 quarkus-semeru-authservice
sleep 1
podman run --rm --name acmeair-nginx1 --privileged -d --net=my-net --memory=1024m --cpuset-cpus 6-12 -p 80:80 acmeair-nginx
sleep 1
