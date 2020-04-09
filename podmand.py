#!/usr/bin/env python3

import os
import socket
import sys

socket_path = "work/podmand.sock"
orca = os.environ['HOME'] + "/magicforcefield-pipeline/orca-docker"
gromacs = os.environ['HOME'] + "/magicforcefield-pipeline/gromacs-plumed-docker/gromacs/gmx-docker"

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
try:
	os.remove(socket_path)
except FileNotFoundError:
	pass

server.bind(socket_path)
server.listen()

while True:
    conn,_addr = server.accept()
    cmd = conn.recv(1024).decode('utf-8')
    if not cmd:
            break
    else:
        if "gromacs" in cmd:
            os.system("cd /tmp; " + gromacs + cmd[len("gromacs"):])
        elif "orca" in cmd:
            os.system("cd /tmp; " + orca + " " + cmd[len("orca"):] + " > " + os.environ['WORK'] + "/orca_output.log ")
        else:
            conn.send("error choosing between containers".encode('utf-8'))
        conn.send("done".encode('utf-8'))
		

server.close()
os.remove(socket_path)

