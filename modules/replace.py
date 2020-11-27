def replace_text_for_embedding(input_file=None, stride=None, file_name=None, weight=None):    
    #change file
    with open(input_file, "r") as ifile:
        data = ifile.read()
        if stride != None:
                data = data.replace("STRIDE=" + str(stride[0]), "STRIDE=" + str(stride[1]))
        if file_name != None:
                data = data.replace("FILE=" + file_name[0], "FILE=" + file_name[1])
        if weight != None:
                data = data.replace(str(weight[0]), str(weight[1]))
        if data == "":
            raise SystemExit("Operation not supported")
        
    #write final output
    with open(input_file, "w") as ofile:
        ofile.writelines(data)
