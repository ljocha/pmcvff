import os
  
def execute_orca(input_path, output_path, method):
    for orca_method in os.listdir(input_path):
        if not orca_method.endswith(".inp"):
            continue
        orca_method_name = orca_method.replace(".inp", "")
        orca_method_number = orca_method_name[len("outCluster"):]
        output_dir_path = output_path + orca_method_name  + "/"
        os.mkdir(output_dir_path)
        command = "cp " + input_path + orca_method + " " + output_dir_path + "; /opt/podman-run.py orca {} {} -w /".format(method, orca_method_number) + output_dir_path + " -- " + orca_method
        os.system(command)
