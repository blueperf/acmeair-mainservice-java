#! /usr/bin/env bash

pkill java
unzip acmeairmainservicejava.zip
wlp/bin/server start
