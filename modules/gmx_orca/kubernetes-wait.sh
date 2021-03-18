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

filename_flag=""
if [[ -n $filename ]]; then
    filename_flag="-f $filename"
fi
label_flag=""
if [[ -n $label ]]; then
    label_flag="jobs -l app=$label"
fi

kubectl wait --for=condition=complete $filename_flag $label_flag --timeout 14400s && exit 0 &
completion_pid=$!

kubectl wait --for=condition=failed $filename_flag $label_flag --timeout 14400s && exit 1 &
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

kubectl logs "$label_flag" --tail=-1
