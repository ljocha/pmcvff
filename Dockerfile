FROM ljocha/gromacs:2019.4.30-1

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague

ARG INTELPYTHON=l_pythoni3_p_2019.4.088.tar.gz
COPY ${INTELPYTHON} /tmp
RUN cd /opt && \
    tar xzf /tmp/${INTELPYTHON} && \
    cd intelpython3 && \
    ./setup_intel_python.sh && \
    echo source /opt/intelpython3/bin/activate  >>/etc/bash.bashrc && rm /tmp/${INTELPYTHON}

RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y notebook pandas"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c openbabel openbabel"

RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y --freeze-installed -c conda-forge pypdb pydoe mdtraj nglview"

ARG MINICONDA=Miniconda3-latest-Linux-x86_64.sh
ARG CONDA=/opt/miniconda3
COPY ${MINICONDA} /tmp

RUN bash /tmp/${MINICONDA} -b -p ${CONDA}

#RUN bash -c "source ${CONDA}/bin/activate && conda config --add channels intel"
RUN bash -c "source ${CONDA}/bin/activate && conda install -c rdkit rdkit"
#install antechamber tools
RUN bash -c "source ${CONDA}/bin/activate && conda install ambertools=19 -c ambermd"
#install molvs
RUN bash -c "source ${CONDA}/bin/activate && conda install -c conda-forge molvs"
#need to add channel conda-forge before installing py3dmol
RUN bash -c "source ${CONDA}/bin/activate && conda config --add channels conda-forge"
RUN bash -c "source ${CONDA}/bin/activate && conda install -c rmg py3dmol"


#install LibXrender1 needed for RDkit library
RUN apt-get update && apt-get install -y libxrender1

ADD modules app/
COPY molekula.txt pipelineJupyter.ipynb *.py modules/*.py app/

WORKDIR app/
 
EXPOSE 8888

CMD bash -c "sleep 2 && source /opt/intelpython3/bin/activate && jupyter notebook --ip 0.0.0.0 --allow-root --port 8888"
