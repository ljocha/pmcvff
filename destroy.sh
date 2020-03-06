#!/bin/bash

source config.sh

rm -rf ${SHARED_DIR}

podman stop ${ROOT_TMP} ${CONTAINER_NAME}
podman kill ${ROOT_TMP} ${CONTAINER_NAME}
podman rm ${ROOT_TMP} ${CONTAINER_NAME}

