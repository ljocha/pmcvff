#!/bin/bash

git clone git@gitlab.ics.muni.cz:3086/gromacs-plumed-docker.git 
#cd gromacs-plumed-docker && make gromacs/gmx_docker

docker build -t pipeline:latest .
