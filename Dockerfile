FROM continuumio/miniconda3 as build

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague

WORKDIR /tmp
COPY environment.yml .
RUN conda env create -f environment.yml 


FROM jupyterhub/k8s-singleuser-sample:1.1.3

USER root

# install k8s
RUN apt update && apt install -y curl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN bash -c 'echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list'
RUN apt update
RUN apt install -y kubectl

# resolve throttling
RUN mkdir -p /home/jovyan/.kube && ln -s /mnt/secret/config/config.yaml /home/jovyan/.kube/config.yaml

COPY --from=build /opt/conda/envs /opt/conda/envs
COPY modules /home/base/modules/
COPY pipelineJupyter.ipynb tleapin.txt /tmp/base

ENV PATH="/opt/conda/envs/pyenv/bin:/opt/conda/bin:$PATH"
ENV PYTHONPATH="/home/base"
ENV KUBECONFIG="/home/jovyan/.kube/config.yaml"

RUN bash -c "python -m ipykernel install --user"

