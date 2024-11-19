podman build --secret id=criu_secrets,src=.env -t semeru_criu -f Dockerfile.semeru.criu --no-cache

exit

cd ../acmeair-authservice-java
./build.semeru.sh

cd ../acmeair-bookingservice-java
./build.semeru.sh

cd ../acmeair-customerservice-java
./build.semeru.sh

cd ../acmeair-flightservice-java
./build.semeru.sh
