#!/usr/bin/env bash

DOCKER_CMD="$(which podman)"
${DOCKER_CMD} stop $(${DOCKER_CMD} ps -a -q); ${DOCKER_CMD} rm $(${DOCKER_CMD} ps -a -q)  
#${DOCKER_CMD} rm "$(${DOCKER_CMD} stop ol-trade7)"
