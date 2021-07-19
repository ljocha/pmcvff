# Gromacs and Orca Kubernetes wrapper
Every minor software package needed is contained in the main pipeline image. [Gromacs](https://www.gromacs.org/) and [Orca](https://sites.google.com/site/orcainputlibrary/home) are considered too large to be contained in the main container. Therefore these packages are divided into another two independent images.

This implies there is a need of connecting the main pipeline container with Gromacs and Orca containers. A wrapper has been written exactly for this purpose.  The wrapper is written in *Python* and converts the Gromacs/Orca command along with its arguments to a .yaml (Kubernetes job) configuration file. Based on this file the Kubernetes job is spawned where all computations happen. 

## Gromacs
***Mandatory:***

    string gmx_command       -       gromacs command to be evaluated

***Optional:***

    int mpi_run              -       request number of cpus for mpi_run software
    str groups               -       specify interactive groups for gromacs*
    str make_ndx             -       specify interactive make_ndx input for gromacs make_ndx
    str image                -       specify used image
    str workdir              -       specify directory where should the calculation take place
    str arch                 -       specify architecture
    bool double              -       double precision for mdrun
    bool rdtscp              -       enable rndscp
    bool parallel            -       run jobs as parallel

    * https://manual.gromacs.org/documentation/2019-rc1/reference-manual/analysis/using-groups.html

***Example usages:***
 
<sub>gmx_run('mdrun -deffnm em1 -ntomp 2')</sub>\
<sub>gmx_run('mdrun -deffnm mtd1 -replex 500 -plumed plumed.dat', mpi_run=6')</sub>\
<sub>gmx_run('mdrun -deffnm em1', image='user/gromacs:123')</sub>\
<sub>gmx_run('mdrun -deffnm em1 -ntomp 2', arch='AVX256')</sub>

## Orca
