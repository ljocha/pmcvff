#!/bin/bash

source config.sh
INTELPYTHON=l_pythoni3_p_2019.4.088.tar.gz

if [ ! -f "$INTELPYTHON" ]; then
	echo "You don't possess IntelPython package... Download at https://software.intel.com/content/www/us/en/develop/tools/distribution-for-python/choose-download.html"
	echo "If the version is different than \"$INTELPYTHON\", change variable name in build script"
	exit 1
fi


if [ "$1" == "-p" ]; then
	podman --root=${ROOT_TMP} build --build-arg INTELPYTHON=${INTELPYTHON} -t ${IMAGE_NAME} .
else
	docker build -t ${IMAGE_NAME} .
fi
