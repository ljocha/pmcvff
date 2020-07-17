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


cp {tleapin.txt,pipelineJupyter.ipynb,molekula.txt} ${SHARED_DIR}
ENV_SETUP="-v ${WORK}:/${SHARED_DIR} \
	   -e CPUS=$CPUS \
	   -e HOME=/${SHARED_DIR} \
	   -e WORK=$WORK \
	   --name ${CONTAINER_NAME} \
	   -p 8888:8888"


if [ -z "$PODMAN" ]; then
	gid=$(stat -c %g /var/run/docker.sock)
	docker run -u $(id -u):$gid -v /var/run/docker.sock:/var/run/docker.sock $ENV_SETUP -ti ${IMAGE_NAME} bash -c "source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root" 
else
	./podman_persist.sh &
	cd /tmp
	podman run --privileged $ENV_SETUP -ti ${IMAGE_NAME} bash -c "source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root"
fi

cleanup

