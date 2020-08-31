import os


def convert_to_orca_methods(input_path, output_path, torsions, method_desc, nprocs, charge):
    for xyz_cluster in os.listdir(input_path):
        if (not xyz_cluster.endswith(".xyz")) or (xyz_cluster.endswith("trj.xyz")):
            continue
        output_file = open(output_path + xyz_cluster.replace(".xyz", ".inp"), "w")
        output_file.write(method_desc + os.linesep)
        if nprocs != -1:
            output_file.write("%pal" + os.linesep)
            output_file.write("nprocs " + str(nprocs) + os.linesep)
            output_file.write("end" + os.linesep)
        output_file.write("%geom" + os.linesep)
        output_file.write("Constraints" + os.linesep)
        write_torsions(output_file, torsions)
        output_file.write("end" + os.linesep)
        output_file.write("end" + os.linesep)
        output_file.write(os.linesep)

        output_file.write("* xyz {} {}".format(charge[0], charge[1]) + os.linesep)
        copy_xyz_to_orca(input_path + xyz_cluster, output_file)
        output_file.write("*" + os.linesep)

        
def copy_xyz_to_orca(input_file, output_file):
    i = 0
    input_file = open(input_file, "r")
    for line in input_file:
        if i >= 2:
            output_file.write(line)
        i += 1


def write_torsions(output_file, torsionsList):
    for torsions in torsionsList:
        output_file.write("{D ")
        for torsion in torsions:
            output_file.write(str(torsion) + " ")
        output_file.write("C}" + os.linesep)
