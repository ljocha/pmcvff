FROM ubuntu:18.04

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague

COPY --from=spectraes/pmcv-pipeline-python:2021-04-19 /opt/intelpython3 /opt/intelpython3
COPY --from=lachlanevenson/k8s-kubectl:v1.20.2 /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN bash -c "source /opt/intelpython3/bin/activate && jupyter-nbextension enable nglview --py --sys-prefix"
RUN bash -c "apt-get update && apt-get install -y libxrender1 libgfortran3 git sudo jq apt-transport-https gnupg2 curl xz-utils"

#install parmtSNE
RUN bash -c "cd /opt && git clone https://github.com/spiwokv/parmtSNEcv.git" 
RUN source /opt/intelpython3/bin/activate && \
    pip install 'ruamel.yaml<=0.15.94' && \ 
    cd /opt/parmtSNEcv && \
    pip install . && \
    pip install --ignore-installed six tensorflow

#install other tools
ARG DISTRIBUTION=ubuntu18.04
ARG NVIDIA_DOCKER_LIST="https://nvidia.github.io/nvidia-docker/${DISTRIBUTION}/nvidia-docker.list"

RUN bash -c "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
RUN bash -c "echo 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable' >>/etc/apt/sources.list"
RUN bash -c "curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -"
RUN bash -c "curl -s -L -o /etc/apt/sources.list.d/nvidia-docker.list ${NVIDIA_DOCKER_LIST}" 
RUN bash -c "apt update && apt install -y docker-ce-cli nvidia-container-toolkit"

#copy all necessary files to run PMCV force field correction pipeline
COPY modules /home/base/modules/
COPY tleapin.txt /work/
COPY init.sh /opt/

WORKDIR /work
EXPOSE 8888


CMD /opt/init.sh && \
    sleep 2 && \
    curl -LO https://gitlab.ics.muni.cz/467814/magicforcefield-pipeline/-/raw/kubernetes/pipelineJupyter.ipynb && \
    source /opt/intelpython3/bin/activate && \
    jupyter notebook --ip 0.0.0.0 --allow-root --port 8888
