#!/bin/bash

eval set -- $(getopt -o +c:i:o: --)

while [ $1 != '--' ]; do case $1 in
        -c) CLUSTERS=$2; shift; shift ;;
        -i) INPUT_DIR="$2"; shift; shift ;;
	-o) OUTPUT_DIR="$2"; shift; shift ;;
esac; done

mkdir ${OUTPUT_DIR}

grep ATOM /work/clustering/outClustersPDB/outCluster0.pdb | cut -c 1-26  > ${OUTPUT_DIR}/temp_atom_names

for (( i=0; i<${CLUSTERS}; i++))
do
  babel -ixyz ${INPUT_DIR}outCluster$i.xyz -opdb ${OUTPUT_DIR}/temp_cluster_$i.pdb
  grep HETATM ${OUTPUT_DIR}/temp_cluster_$i.pdb | cut -c 27-66 > ${OUTPUT_DIR}/temp_coord_$i
  paste -d "" ${OUTPUT_DIR}/temp_atom_names ${OUTPUT_DIR}/temp_coord_$i > ${OUTPUT_DIR}/cluster_$i.pdb
done

rm ${OUTPUT_DIR}/temp_*
