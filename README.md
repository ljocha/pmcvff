Run instructions:

Before executing build scripts, you need to get all necessary software
which has to be downloaded/set manually:

* Podman: https://podman.io/
* IntelPython: https://software.intel.com/en-us/distribution-for-python/choose-download
    * note1: if there has been released new version, which is not set in Dockerfile, contact me or just set new version in Dockerfile manually
    * note2: download it to pipeline directory (where Dockerfile is)
* Git clone: https://gitlab.ics.muni.cz/3086/gromacs-plumed-docker
    * note: clone it to pipeline directory


1. Execute script build.sh which will build the podman image for pipeline
2. For interactive run and open in jupyter notebook, execute script run.sh

