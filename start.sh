./down.sh
podman stop -a; podman rm -a;


if [[ "${1}" == *old* || "${1}" == *61* ]]
then
  sed -i "s@<feature>microProfile-7.0</feature>@<feature>microProfile-6.1</feature>@" ../acmeair-authservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-7.0</feature>@<feature>microProfile-6.1</feature>@" ../acmeair-bookingservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-7.0</feature>@<feature>microProfile-6.1</feature>@" ../acmeair-customerservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-7.0</feature>@<feature>microProfile-6.1</feature>@" ../acmeair-flightservice-java/src/main/liberty/config/server.xml
fi


./up-${1}.sh
sleep 20
curl localhost/booking/loader/load
curl localhost/flight/loader/load
curl localhost/customer/loader/load?numCustomers=10000

if [[ "${1}" == *old* || "${1}" == *61* ]]
then
  sed -i "s@<feature>microProfile-6.1</feature>@<feature>microProfile-7.0</feature>@" ../acmeair-authservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-6.1</feature>@<feature>microProfile-7.0</feature>@" ../acmeair-bookingservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-6.1</feature>@<feature>microProfile-7.0</feature>@" ../acmeair-customerservice-java/src/main/liberty/config/server.xml
  sed -i "s@<feature>microProfile-6.1</feature>@<feature>microProfile-7.0</feature>@" ../acmeair-flightservice-java/src/main/liberty/config/server.xml
fi
