#!/bin/bash

unset PODMAN
if [ "$1" == "-p" ]; then
	PODMAN="y"
fi

cleanup() {
	if [ -z "$PODMAN" ]; then
		docker rm ${CONTAINER_NAME}
	else
		podman rm ${CONTAINER_NAME}
	fi
	echo "pipeline container terminated"
	kill -TERM -- -$$
}
trap cleanup INT
source config.sh

#detect number of available CPU's in job
if [ -z "$PBS_NODEFILE" ]; then
	CPUS=1
else
	CPUS=$(wc -l $PBS_NODEFILE | awk '{print $1}')
fi
echo "running with ${CPUS} cpu's"

#create directories for pipeline temporary results 
if [ ! -d "$SHARED_DIR" ]; then
	mkdir ${SHARED_DIR}
else
	echo "working directory \"${SHARED_DIR}\" already created"
fi


cp {tleapin.txt,pipelineJupyter.ipynb} ${SHARED_DIR}
env_setup="-v ${WORK}:/${SHARED_DIR} \
	   -e CPUS=$CPUS \
	   -e HOME=/${SHARED_DIR} \
	   -e WORK=$WORK \
	   --name ${CONTAINER_NAME} \
	   -p 8888:8888"

if [ -z "$PODMAN" ]; then
	./add_permissions.sh $PWD/$SHARED_DIR
	gid=$(stat -c %g /var/run/docker.sock)
	docker run -u $(id -u):$gid -v /var/run/docker.sock:/var/run/docker.sock $env_setup -ti $IMAGE_NAME 
else
	./podman_persist.sh &
	cd /tmp
	podman run --privileged $env_setup -ti $IMAGE_NAME
fi

cleanup
