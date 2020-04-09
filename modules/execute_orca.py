import os
  
def execute_orca(input_path, output_path):
    for orca_method in os.listdir(input_path):
        if not orca_method.endswith(".inp"):
            continue
        output_dir_path = output_path + orca_method.replace(".inp", "") + "/"
        os.mkdir(output_dir_path)
        command = "cp " + input_path + orca_method + " " + output_dir_path + "; /opt/podman-run.py orca -w /" + output_dir_path + " -- " + orca_method
        os.system(command)
