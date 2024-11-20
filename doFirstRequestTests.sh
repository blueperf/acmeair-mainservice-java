#!/bin/bash
#set -eux

declare -r IMAGE=${1}

echo "Testing ${IMAGE}"

if [[ ${2} == 1 ]] 
then
  CPUS="2"
else
  LAST_CPU=$((2 + ${2} -1 ))
  CPUS="2-${LAST_CPU}"	
fi

echo "CPUS=${CPUS}"

for i in 1 2 3 4 5 6 7 8 9 10
do
  sleep 2

  ./loop.sh pingperf &

  CID=$(podman run --privileged -d --net=host --memory=1g --cpuset-cpus ${CPUS} ${IMAGE})
  sleep 5
  podman logs ${CID}

  # Grab First Response
  FR_TIME="$(head -1 output2)" # from loop.sh
  let stopMillis=$(date "+%s%N" -d "${FR_TIME}")/1000000

  #use docker inspect to get start time
  time2=$(podman inspect ${CID} | grep StartedAt | awk '{print $2}'| awk '{gsub("\"", " "); print $1}'| awk '{gsub("T"," "); print}'|awk '{print substr($0, 1, length($0)-6)}')
  time2="$time2 $( date "+%z")"
  #echo "start time"
  echo $time2
  echo $FR_TIME
  let startMillis=$(date "+%s%N" -d "$time2")/1000000
  let sutime=${stopMillis}-${startMillis}
  echo "First Response Time in ms: $sutime"

  #wait to get FP
  sleep 5
  PID=$(ps -ef | grep java | grep -v grep | awk '{print $2}' | tail -1)
  FP=$(ps -o rss= ${PID} | numfmt --from-unit=1024 --to=iec | awk '{gsub("M"," "); print $1}')
  FP2=$(cat /proc/${PID}/smaps | grep 'Rss' | awk '{total+=$2;} END{print total;}' | numfmt --from-unit=1024 --to=iec | awk '{gsub("M"," "); print $1}')
  #echo "Footprint in MB:        : $FP"
  echo "Footprint in MB:        : $FP2"

  podman kill $CID
  podman rm $CID
done

