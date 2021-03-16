#!/bin/bash

unset filename
unset label
while getopts ":f:l:" opt; do
  case $opt in
    f)
      filename="$OPTARG"
      echo "waiting for $filename" >&2
      ;;
    l)
      label="$OPTARG"
      echo "waiting for jobs with label $label" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


# get pod base
name="$(cat $filename | grep name | head -1 | awk '{print $2}')"

# get pod name with rancher hash
pod_name="$(kubectl get pods -n mff-prod-ns -o json | jq ".items[] | select(.metadata.name|test(\"$name\"))| .metadata.name" | tr -d \")"
if [[ -z $pod_name ]]; then
    echo "error finding pod" && exit 1
fi

FILENAME_FLAG=""
if [[ -n $filename ]]; then
    FILENAME_FLAG="-f $filename"
fi
LABEL_FLAG=""
if [[ -n $label ]]; then
    LABEL_FLAG="-l app=$label"
fi

kubectl wait --for=condition=complete "$FILENAME_FLAG $LABEL_FLAG" --timeout 14400s && exit 0 &
completion_pid=$!

kubectl wait --for=condition=failed "$FILENAME_FLAG $LABEL_FLAG" --timeout 14400s && exit 1 &
failure_pid=$!

wait -n $completion_pid $failure_pid
exit_code=$?

if (( exit_code == 0 )); then
  echo "Job succeeded"
  pkill -P $failure_pid
else
  echo "Job failed"
  pkill -P $completion_pid
fi

kubectl logs "$LABEL_FLAG $pod_name"
