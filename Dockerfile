FROM ubuntu:18.04

USER root

#set variables
ARG INTELPYTHON
ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague
ENV BASE=/home/base
ENV SHARED_DIR=/work

#install IntelPython from manually downloaded package specified in build script
COPY ${INTELPYTHON} /tmp
RUN cd /opt && \
    tar xzf /tmp/${INTELPYTHON} && \
    cd intelpython3 && \
    ./setup_intel_python.sh && \
    echo source /opt/intelpython3/bin/activate  >>/etc/bash.bashrc && rm /tmp/${INTELPYTHON}

#install jupyter, python tools and widgets used for visualisation
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y ruamel_yaml"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge jupyter"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -n base -c conda-forge widgetsnbextension"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge ipywidgets"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y --freeze-installed -c conda-forge pypdb pydoe mdtraj nglview"
RUN bash -c "source /opt/intelpython3/bin/activate && jupyter-nbextension enable nglview --py --sys-prefix"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y pandas"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c rmg py3dmol"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge tqdm"

#install openbabel, amber, molvs
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c openbabel openbabel"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y ambertools=19 -c ambermd"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge molvs"

#install LibXrender1 needed for RDkit library
RUN apt-get update && apt-get install -y libxrender1 libgfortran3
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c rdkit rdkit"

#install acpype and its needed packages xorg-libxext and pillow
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge acpype"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge xorg-libxext"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge pillow"

#install other tools
RUN bash -c "apt-get install xz-utils"
RUN apt-get update && apt install -y docker.io

#copy all necessary files to run force field correction evaluation
COPY modules ${BASE}/modules/
COPY ./gromacs-plumed-docker/gromacs/gmx-docker orca-docker podman-run.py /opt/
COPY molekula.txt tleapin.txt pipelineJupyter.ipynb ${BASE}/

WORKDIR ${SHARED_DIR}
EXPOSE 8888

#run Jupyter Notebook when container is executed
CMD bash -c "sleep 2 && source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --allow-root --port 8888"
