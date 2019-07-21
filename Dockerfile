FROM ljocha/gromacs:2019.4.30-1

USER root

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Prague

ARG INTELPYTHON=l_pythoni3_p_2019.4.088.tar.gz
COPY ${INTELPYTHON} /tmp

RUN cd /opt && tar xzf /tmp/${INTELPYTHON} && cd intelpython3 && ./setup_intel_python.sh && echo source /opt/intelpython3/bin/activate  >>/etc/bash.bashrc && rm /tmp/${INTELPYTHON}
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y notebook pandas"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c openbabel openbabel"
RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y --freeze-installed -c conda-forge pypdb pydoe mdtraj nglview"
#RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y -c intel tensorflow keras"
#RUN bash -c "source /opt/intelpython3/bin/activate && conda install -y --freeze-installed -c spiwokv anncolvar"

FROM continuumio/miniconda3

#install antechamber tools
RUN conda install ambertools=19 -c ambermd
#install molvs
RUN conda config --add channels conda-forge
RUN conda install molvs
#install jupyter notebook
RUN conda install -y notebook
RUN apt-get update
#install LibXrender1 needed for RDkit library
RUN apt-get install libxrender1
#install py3Dmol and rdkit visualisation tools
RUN pip install py3Dmol
RUN conda install -c rdkit rdkit

WORKDIR app/

ADD modules app/
COPY molekula.txt pipelineJupyter.ipynb *.py modules/*.py app/
 
EXPOSE 8888

CMD bash -c "jupyter notebook --allow-root --ip 0.0.0.0 --port 8888"

