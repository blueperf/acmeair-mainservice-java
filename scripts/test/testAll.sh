#!/bin/bash
cd $(dirname "$0")

CWD=$(pwd)

cd ../../
docker-compose -f docker-compose-v3.yml down > /dev/null 2>&1
sleep 4
docker-compose -f docker-compose-v3.yml up --build -d > /dev/null 2>&1
sleep 30

cd ${CWD}
./loadDB.sh
./runTestLoad.sh

cd ../../
docker-compose -f docker-compose-v3.yml down > /dev/null 2>&1
sleep 4
docker-compose -f docker-compose-wf-v3.yml up --build -d > /dev/null 2>&1
sleep 30

cd ${CWD}
./loadDB.sh
./runTestLoad.sh

cd ../../
docker-compose -f docker-compose-wf-v3.yml down > /dev/null 2>&1
sleep 4
docker-compose -f docker-compose-pm-v3.yml up --build -d > /dev/null 2>&1
sleep 30

cd ${CWD}
./loadDB.sh
./runTestLoad.sh

cd ../../
docker-compose -f docker-compose-pm-v3.yml down > /dev/null 2>&1
sleep 4
docker-compose -f docker-compose-qu-v3.yml up --build -d > /dev/null 2>&1
sleep 30

cd ${CWD}
./loadDB.sh
./runTestLoad.sh

cd ../../
docker-compose -f docker-compose-qu-v3.yml down > /dev/null 2>&1
sleep 4 
docker-compose -f docker-compose-qn-v3.yml up --build -d > /dev/null 2>&1
sleep 30

cd ${CWD}
./loadDB.sh
./runTestLoad.sh

cd ../../
docker-compose -f docker-compose-qn-v3.yml down > /dev/null 2>&1

