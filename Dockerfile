FROM continuumio/miniconda3

COPY molekula.txt /
COPY pipelineJupyter.ipynb /

#install RDkit
RUN conda install -c rdkit rdkit

#install molvs
RUN conda config --add channels conda-forge
RUN conda install molvs

#install jupyter notebook
RUN conda install -y notebook

RUN apt-get update
#install LibXrender1
RUN apt-get install libxrender1
 
EXPOSE 8888

CMD bash -c "jupyter notebook --allow-root --ip 0.0.0.0 --port 8888"
