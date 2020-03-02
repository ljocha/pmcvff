#!/bin/bash

#image name
IMAGE_NAME="pipeline:latest"
#flag needed to run podman on glados4
ROOT_TMP="--root=/scratch.ssd/${USER}/tmp"

podman build ${ROOT_TMP} -t ${IMAGE_NAME} .
