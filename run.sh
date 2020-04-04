#!/bin/bash

source config.sh

eval set -- $(getopt -o +jh -- "$@")

#directory where everything shared between container and host is located
BASE_DIR="${HOME}/magicforcefield-pipeline/${SHARED_DIR}"
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
PODMAND_PID=$!
#export PODMAND_PID

trap ctrlc_func INT

ctrlc_func() {
	kill $PODMAND_PID
	echo "\npodmand terminated\n"
	exit 2
}


cp {tleapin.txt,pipelineJupyter.ipynb} ${SHARED_DIR}

cd /tmp
podman --root ${ROOT_TMP} --runtime /usr/bin/crun run --name ${CONTAINER_NAME} --privileged --cgroups disabled -v ${BASE_DIR}:/${SHARED_DIR} -e HOME=/work -p 8888:8888 -ti ${IMAGE_NAME} bash -c "source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root"

#podman run --name ${CONTAINER_NAME} --root=${ROOT_TMP} -p 8888:8888 -v ${BASE_DIR}:/${SHARED_DIR} ${RUN_MODE} ${IMAGE_NAME} ${RUN_EXEC}


#docker run -v /var/run/docker.sock:/var/run/docker.sock \
#           -v $HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR}:/${SHARED_DIR} \
#           -e WORK=$HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR} \
#           --name pipeline \
#           -ti \
#           -p 8888:8888 \
#           pipeline:latest \
#           bash
