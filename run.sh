#!/bin/bash

cleanup() {
	podman --root=${ROOT_TMP} rm ${CONTAINER_NAME}
	echo "pipeline container terminated"
	kill -TERM -- -$$
}
trap cleanup INT
source config.sh

#directory where everything shared between container and host is located
BASE_DIR="${PWD}/${SHARED_DIR}"
#select run mode of podman container
RUN_MODE="-ti"
#select software to open pipeline in
RUN_EXEC="bash"
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
	mkdir ${SHARED_DIR}/orca_output; mkdir ${SHARED_DIR}/orca_output/am1; mkdir ${SHARED_DIR}/orca_output/bp86
	mkdir ${SHARED_DIR}/am1; mkdir ${SHARED_DIR}/am1/input; mkdir ${SHARED_DIR}/am1/output
	mkdir ${SHARED_DIR}/bp86; mkdir ${SHARED_DIR}/bp86/input; mkdir ${SHARED_DIR}/bp86/output
	mkdir ${SHARED_DIR}/molekula
	mkdir ${SHARED_DIR}/clustering
	mkdir ${SHARED_DIR}/clustering/outClustersPDB
	mkdir ${SHARED_DIR}/clustering/outClustersXYZ
	mkdir ${SHARED_DIR}/clustering/orcaClusters
else
	echo "working directory \"${SHARED_DIR}\" already created"
fi

./podman_d.sh &
cp {tleapin.txt,pipelineJupyter.ipynb,molekula.txt} ${SHARED_DIR}
cd /tmp


podman --root ${ROOT_TMP} --runtime /usr/bin/crun run --name ${CONTAINER_NAME} --privileged --cgroups disabled -v ${BASE_DIR}:/${SHARED_DIR} -e CPUS=$CPUS -e HOME=/work -p 8888:8888 -ti ${IMAGE_NAME} bash -c "source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --port 8888 --allow-root"

cleanup

#docker run -v /var/run/docker.sock:/var/run/docker.sock \
#           -v $HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR}:/${SHARED_DIR} \
#           -e WORK=$HOME/${SHARED_DIR}/magicforcefield-pipeline/${SHARED_DIR} \
#           --name pipeline \
#           -ti \
#           -p 8888:8888 \
#           pipeline:latest \
#           bash
