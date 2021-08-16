FROM continuumio/miniconda3 as build

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague

WORKDIR /tmp
COPY environment.yml .
RUN conda env create -f environment.yml 


FROM ubuntu:20.04

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Prague

RUN apt-get update && apt-get install -y \
    python3-distutils \
    python3-rdkit \
    librdkit1 \
    rdkit-data \
    curl

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN bash -c 'echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list'
RUN apt update
RUN apt install -y kubectl

COPY --from=build /opt/conda/envs/pyenv /opt/conda/envs/pyenv
ENV PATH="$PATH:/opt/conda/envs/pyenv/bin"
#COPY --from=build /opt/conda /opt/conda

#copy all necessary files to run PMCV force field correction pipeline
COPY modules /home/base/modules/
COPY tleapin.txt /work/
COPY init.sh /opt/
RUN chown -R 1001:1001 /work

ENV PYTHONPATH=/home/base
ENV HOME=/work

WORKDIR /work
EXPOSE 8888


# CMD bash -c "/opt/init.sh && \
#    sleep 2 && \
#    curl -LO https://gitlab.ics.muni.cz/467814/magicforcefield-pipeline/-/raw/kubernetes/pipelineJupyter.ipynb && \
#    source /opt/intelpython3/bin/activate && \
#    jupyter notebook --ip 0.0.0.0 --allow-root --port 8888"
