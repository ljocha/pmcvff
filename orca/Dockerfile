FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y openmpi-bin && apt-get install xz-utils

ARG ORCA=orca_5_0_1_linux_x86-64_shared_openmpi411
COPY ${ORCA}.tar.xz /tmp
WORKDIR /opt
RUN tar -xvf /tmp/${ORCA}.tar.xz
RUN mv ${ORCA} orca
RUN echo 'export PATH=$PATH:/opt/orca' >> /etc/bash.bashrc
RUN echo '/opt/orca' >> /etc/ld.so.conf.d/orca_p.conf
RUN ldconfig
RUN rm /tmp/${ORCA}.tar.xz

