import os

class Config:

    # set images to be used in calculations
    GMX_IMAGE = "ljocha/gromacs:2021-1"
    ORCA_IMAGE = "spectraes/pipeline_orca:5.0.1"
    PARMTSNECV_IMAGE = "spectraes/parmtsnecv:28-08-2021"

    # set filepaths relative to this config file
    KUBERNETES_WAIT_PATH = PICKLE_PATH = os.path.dirname(os.path.realpath(__file__))
