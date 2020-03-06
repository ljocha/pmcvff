#!/bin/bash

source config.sh

eval set -- $(getopt -o +jh -- "$@")

#image name
IMAGE_NAME="pipeline:latest"
#container name
CONTAINER_NAME="pipeline"
#directory shared between host and container
SHARED_DIR="work"
#flag needed to run podman on glados4
ROOT_TMP="--root=/scratch.ssd/${USER}/tmp"
#directory where everything shared between container and host is located
BASE_DIR="/storage/brno3-cerit/home/${USER}/magicforcefield-pipeline/${SHARED_DIR}" 
#select run mode of podman container
RUN_MODE="-ti"
#select software to open pipeline in
RUN_EXEC="bash"

while [ $1 != '--' ]; do case $1 in
	-j) RUN_MODE=""; RUN_EXEC=""; shift ;;
        -h) cat >&2 <<EOF
usage: $0 options [--] pipeline_args ...

options are:
	-j jupyter-notebook  run pipeline and get link for jupyter notebook
EOF
        exit 1;;
        --) shift; break ;;
esac; done


#create directories for pipeline temporary results 
mkdir ${SHARED_DIR}
mkdir ${SHARED_DIR}/am1; mkdir ${SHARED_DIR}/am1/input; mkdir ${SHARED_DIR}/am1/output
mkdir ${SHARED_DIR}/bp86; mkdir ${SHARED_DIR}/bp86/input; mkdir ${SHARED_DIR}/bp86/output
mkdir ${SHARED_DIR}/molekula
mkdir ${SHARED_DIR}/clustering
mkdir ${SHARED_DIR}/clustering/outClustersPDB
mkdir ${SHARED_DIR}/clustering/outClustersXYZ
mkdir ${SHARED_DIR}/clustering/orcaClusters

#run daemon to watch socket in SHARED_DIR and execute external container when needed
./podmand.py &
_podmand_pid=$!

cp {tleapin.txt,pipelineJupyter.ipynb} ${SHARED_DIR}

podman run --name ${CONTAINER_NAME} ${ROOT_TMP} -p 8888:8888 -v ${BASE_DIR}:/${SHARED_DIR} ${RUN_MODE} ${IMAGE_NAME} ${RUN_EXEC}

kill ${_podmand_pid}
echo "container \"${CONTAINER_NAME}\" and podman daemon \"${_podmand_pid}\" terminated; to remove all files and containers, run destroy.sh"

#docker run -v /var/run/docker.sock:/var/run/docker.sock \
#           -v $HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR}:/${SHARED_DIR} \
#           -e WORK=$HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR} \
#           --name pipeline \
#           -ti \
#           -p 8888:8888 \
#           pipeline:latest \
#           bash
