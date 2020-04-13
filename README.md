Run instructions:

1. Clone the pipeline repository
2. Clone Gromacs repository (https://gitlab.ics.muni.cz/3086/gromacs-plumed-docker) inside magicforcefield-pipeline repository 
3. Temporary solution: copy gmx-docker from magicforcefield-pipeline directory to gromacs-plumed-docker/gromacs directory
    1. Original solution: Run “make gromacs/gmx-docker” in gromacs-plumed-docker directory

---

1. ssh into zuphux
2. run screen
3. run interactive job ->> qsub -I -l select=[]:ncpus=[]:mem=[]gb:scratch_local=[]gb (tested successfuly on qsub -I -l select=1:ncpus=15:mem=2gb:scratch_local=20gb:cluster=zenon)
4. When the job is ready, due to some server error, you have to log in to logged computer from different terminal window (e.g your job started running on zenon56; open new terminal window and ssh into zenon56, that’s all) otherwise you will get “Error: could not get runtime: mkdir /run/user/6943: permission denied” error
5. start pipeline script run.sh

Bonus info:
- you can check output of gromacs in podman_d.log file continually (tail -f podman_d.log)
- you can check output of each orca method in work/orca_output directory

---
---
---

Build instructions:

Before executing build scripts, you need to get all necessary software
which has to be downloaded/set manually:

* Podman: https://podman.io/
* IntelPython: https://software.intel.com/en-us/distribution-for-python/choose-download
    * note1: if there has been released new version, which is not set in Dockerfile, contact me or just set new version in Dockerfile manually
    * note2: download it to pipeline directory (where Dockerfile is)
* Git clone: https://gitlab.ics.muni.cz/3086/gromacs-plumed-docker
    * note: clone it inside pipeline directory

1. Execute script build.sh which will build the podman image for pipeline


