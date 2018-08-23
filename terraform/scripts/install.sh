#! /usr/bin/env bash

apt-get update
apt-get install -f
echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt-get install -y -t jessie-backports openjdk-8-jre unzip
