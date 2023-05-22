# Property map collective variable force field correction
Molecular dynamics simulations rely on so-called forcefields, which contain specific parameters that determine the properties of molecules. These parameters are well tuned for biopolymers such as proteins, but struggle to faithfully reproduce the behavior of smaller organic molecules due to their high chemical diversity. Therefore, the force fields need to be reparameterized for each such molecule. We provide a pipeline that automatizes this process. It generates landmark structures, and it calculates the correction  between  accurate  quantum  mechanics  and  the less accurate force field. The deployment is available publicly. The whole workflow is divided into few big steps. Each step is divided into its own set of logically grouped Jupyter notebook cells. Most of these steps can be customized by the user - parameters of calculations can be changed accordingly. Visualizations are provided for the results after multiple steps, and the user can decide whether to change the parameters and repeat the step or continue the computation. The table also  illustrates the needed software. The majority of steps need Gromacs, which uses the same Docker container image as the Protein folding space exploration use case. Another software  we need is Orca, which is containerized in Docker as well (3.4 GB). Last software which is better containerised (due to Python 2 version) is parmtSNEcv. The rest is installed directly and no other container is needed.

## News
22.5.2023
### v3.2
- updated jupyterhub to 2.0.0

## Run instructions

1. Go to https://pmcvff-correction.cerit-sc.cz/
2. Log in via **Elixir**
3. Start your own pipeline
4. Use the pipeline

---

**Bonus info:**
- you can check the output of each method via (Linux) terminal on Jupyterhub
- you can watch progress of computation in detail (via terminal) in log files
