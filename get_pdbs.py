import os

output_dir = "pdb_opt/"
#input_dir = "/work/bp86/output/"
input_dir = "output/"

os.system("mkdir " + output_dir)

#ifile = open("/work/clustering/outClustersPDB/outCluster0.pdb", "r")
ifile = open("cluster_1.pdb", "r")
atoms = []
for line in ifile.readlines():
	if "ATOM" in line:
		atoms.append(line[:26])

for i in range(0, clusters_count):
	hetatms = []
	os.system("babel -ixyz {}outCluster{}.xyz -opdb {}temp_cluster_{}.pdb".format(input_dir, str(i), output_dir, str(i)))
	ifile1 = open("{}temp_cluster_{}.pdb".format(output_dir, str(i))
	for line in ifile1.readlines():
		if "HETATM" in line:
			hetatms.append(line[27:66])
	output_cluster = open("pdb_opt/cluster{}.pdb".format(str(i)), "w")
	for i in range(atoms.length()):
		output_cluster.write(atoms[i])
		output_cluster.write(heatatms[i] + "\n")

os.system("rm temp_*")

