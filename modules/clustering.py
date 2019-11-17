def divide_clusters(input_cluster, output_cluster_path):
    with open(input_cluster) as openfileobject:
        i = 0
        outFile = open(output_cluster_path + "outCluster" + str(i) + ".pdb", "w")

        for line in openfileobject:
            if line != "ENDMDL\n":
                outFile.write(line)
                continue
            outFile.write("ENDMDL\n")
            i += 1
            outFile = open(output_cluster_path + "outCluster" + str(i) + ".pdb", "w")
            
import os             
            
def convert_to_xyz(input_dir, output_dir):
    for filename in os.listdir(input_dir):
        command = "babel -ipdb " + input_dir + filename + " -oxyz " + output_dir + filename.replace("pdb", "xyz")
        os.system(command)

def convert_to_orca_am1opt(input_path, output_path, torsions):
    i = 0
    for xyz_cluster in os.listdir(input_path):
        output_file = open(output_path + "outClusterOrca" + str(i), "w")
        output_file.write("!AM1 Opt\n")
        output_file.write("%geom\n")
        output_file.write("Constraints\n")
        print_torsions(output_file, torsions)
        output_file.write("end\n")
        output_file.write("end\n")
        output_file.write("\n")

        output_file.write("* xyz 1 1\n")
        copy_xyz_to_orca(input_path + xyz_cluster, output_file)
        output_file.write("*\n")

        i += 1


def copy_xyz_to_orca(input_file, output_file):
    i = 0
    input_file = open(input_file, "r")
    for line in input_file:
        if i >= 2:
            output_file.write(line)
        i += 1


def print_torsions(output_file, torsions):
    for torsion in torsions:
        output_file.write("{D ")
        for item in torsion:
            output_file.write("%s " % item)
        output_file.write("C}\n")

