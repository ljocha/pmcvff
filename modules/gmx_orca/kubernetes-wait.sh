#!/bin/bash
# First parameter is pod name (base without hash)
# Second parameter is wait time between every pulse

name="$1"
wait_time="$2"

# Get whole name of pod (with Rancher hash)
pod_name="$(kubectl get pods -n mff-user-ns -o json | jq ".items[] | select(.metadata.name|test(\"$name\"))| .metadata.name" | tr -d \")"

if [[ -z $pod_name ]]; then
    echo "error finding pod" && exit 1
fi

# Wait until pod is alive or succeeded
while true; do
    status="$(kubectl get pods $pod_name -n mff-user-ns -o 'jsonpath={..status.conditions[?(@.type=="Ready")].reason}')"
    if [[ $? != 0 || "$status" == "PodCompleted" ]]; then
        break
    fi
    
    echo "waiting for pod .."
    sleep $wait_time
done
