FROM continuumio/miniconda3

WORKDIR /app

COPY molekula.txt /app
COPY pipelineJupyter.ipynb /app
COPY render_svg.py /app

#install RDkit
RUN conda install -c rdkit rdkit

#install molvs
RUN conda config --add channels conda-forge
RUN conda install molvs

#install jupyter notebook
RUN conda install -y notebook

RUN apt-get update
#install LibXrender1 needed for RDkit library
RUN apt-get install libxrender1
 
EXPOSE 8888

CMD bash -c "jupyter notebook --allow-root --ip 0.0.0.0 --port 8888"
