#!/bin/bash

source config.sh

#container name
CONTAINER_NAME="pipeline"
#directory shared between host and container
SHARED_DIR="work"
#flag needed to run podman on glados4
ROOT_TMP="--root=/scratch.ssd/${USER}/tmp"

rm -rf ${SHARED_DIR}

podman stop ${ROOT_TMP} ${CONTAINER_NAME}
podman kill ${ROOT_TMP} ${CONTAINER_NAME}
podman rm ${ROOT_TMP} ${CONTAINER_NAME}

