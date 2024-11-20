#!/bin/bash
#set -o xtrace

if [[ $# -ne 1 ]]
then
  echo "Usage: loop.sh [application]"
  exit
fi

APPLICATION=${1}

PORT=9090
ENDPOINT=auth/status

while [[ $(curl -s -o /dev/null -w ''%{http_code}'' 127.0.0.1:9080/${ENDPOINT}) != 200 ]] 
do
  sleep 0.001
done
date +"%Y-%m-%d %H:%M:%S.%N" > output2
