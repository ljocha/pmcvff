#create directories needed for orca docker to pull from information
rm -rf cluster
mkdir cluster
mkdir cluster/am1; mkdir cluster/am1/input; mkdir cluster/am1/output
mkdir cluster/bp86; mkdir cluster/bp86/input; mkdir cluster/bp86/output

docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -v $HOME/work/magicforcefield-pipeline/cluster:/work \
           -e WORK=$HOME/work/magicforcefield-pipeline/cluster \
           --name pipeline \
           -p 8888:8888 \
           pipeline:latest \
