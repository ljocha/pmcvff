#!/bin/bash

source config.sh

podman --root=${ROOT_TMP} build  -t ${IMAGE_NAME} .
