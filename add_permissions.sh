#!/bin/bash

#cd into targeted directory and set read/execute permissions to all along it's path
cd $1
problem_dir=""
while [[ $PWD != "/" ]]; do
	permissions=`stat -c %a .`
	o_permissions=${permissions:2:1}
	if [[ o_permissions -lt 5 ]]; then
		chmod o+rx . || problem_dir=$PWD
	fi
	cd ..
done	

if [ -z $problem_dir ]; then
	echo "Permissions successfuly set"
else
	echo "Could not set permissions on directory $problem_dir / consider using Podman"
fi
