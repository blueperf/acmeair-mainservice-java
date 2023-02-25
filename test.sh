HOST=localhost
PORT=8080
JMX=/opt/apache-jmeter-5.4.3/bin/jmx/AcmeAir-microservices-jwt5-header2.jmx

docker-compose --compatibility -f podman-compose-${1}.yml up -d --build
sleep 20

echo 
echo

curl ${HOST}:${PORT}/booking/loader/load
echo
curl ${HOST}:${PORT}/flight/loader/load
echo
curl ${HOST}:${PORT}/customer/loader/load?numCustomers=10000

echo 
echo

echo "Bookings Before: "
curl ${HOST}:${PORT}/booking/config/countBookings
echo

/opt/apache-jmeter-5.4.3/bin/jmeter.sh -DusePureIDs=true -n -t ${JMX} -JHOST=${HOST} -JPORT=${PORT} -JTHREAD=1 -JUSER=999 -JDURATION=30 -JRAMP=0

echo "Bookings After: "
curl ${HOST}:${PORT}/booking/config/countBookings
echo


echo "Flight Successes: "
curl ${HOST}:${PORT}/booking/rewards/flightsuccesses
echo

echo "Flight Failures: "
curl ${HOST}:${PORT}/booking/rewards/flightfailures
echo

echo "Customer Successes: "
curl ${HOST}:${PORT}/booking/rewards/customersuccesses
echo

echo "Customer Failures: "
curl ${HOST}:${PORT}/booking/rewards/customerfailures
echo

docker-compose --compatibility -f podman-compose-${1}.yml down
