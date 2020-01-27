FROM ljocha/gromacs:2019.10.1-1

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague
ENV BASE=/home/gromacs/base

ARG INTELPYTHON=l_pythoni3_p_2019.5.098.tar.gz
COPY ${INTELPYTHON} /tmp
RUN cd /opt && \
    tar xzf /tmp/${INTELPYTHON} && \
    cd intelpython3 && \
    ./setup_intel_python.sh && \
    echo source /opt/intelpython3/bin/activate  >>/etc/bash.bashrc && rm /tmp/${INTELPYTHON}

#install jupyter and widgets used for visualisation
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c conda-forge jupyter"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -n base -c conda-forge widgetsnbextension"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c conda-forge ipywidgets"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y --freeze-installed -c conda-forge pypdb pydoe mdtraj nglview"
RUN bash -c "source /opt/intelpython3/bin/activate && jupyter-nbextension enable nglview --py --sys-prefix"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c openbabel openbabel"

RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y pandas"

#install LibXrender1 needed for RDkit library
RUN apt-get update && apt-get install -y libxrender1 libgfortran3

#install antechamber tools
RUN bash -c "source /opt/intelpython3/bin/activate && conda install ambertools=19 -c ambermd"
#install molvs
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c conda-forge molvs"
RUN bash -c "source /opt/intelpython3/bin/activate && conda config --add channels conda-forge"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c rmg py3dmol"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c rdkit rdkit"
#install acpype and its needed packages xorg-libxext and pillow
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c conda-forge acpype"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c conda-forge xorg-libxext"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -c conda-forge pillow"
RUN bash -c "apt-get install xz-utils"

ADD modules base/modules
ADD gromacs-plumed-docker /opt/gromacs
COPY molekula.txt tleapin.txt pipelineJupyter.ipynb base/

WORKDIR /work
 
EXPOSE 8888

RUN apt-get update && apt install -y docker.io

CMD bash -c "sleep 2 && source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --allow-root --port 8888"
