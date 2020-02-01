#create directories needed for orca docker to pull from information
mkdir work
mkdir work/am1; mkdir work/am1/input; mkdir work/am1/output
mkdir work/bp86; mkdir work/bp86/input; mkdir work/bp86/output
mkdir work/molekula
mkdir work/clustering
mkdir work/clustering/outClustersPDB
mkdir work/clustering/outClustersXYZ
mkdir work/clustering/orcaClusters
cp {tleapin.txt,pipelineJupyter.ipynb} work

docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -v $HOME/work/magicforcefield-pipeline/work:/work \
           -e WORK=$HOME/work/magicforcefield-pipeline/work \
           --name pipeline \
           -p 8888:8888 \
           pipeline:latest \
