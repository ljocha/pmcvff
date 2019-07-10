FROM continuumio/miniconda3

WORKDIR /

ADD modules /
COPY molekula.txt pipelineJupyter.ipynb *.py modules/*.py /

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
 
EXPOSE 8888

CMD bash -c "jupyter notebook --allow-root --ip 0.0.0.0 --port 8888"
