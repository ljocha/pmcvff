#!/bin/bash

unset label
unset parallel_wait 
unset parallel
while getopts ":l:wp" opt; do
  case $opt in
    l)
      label="$OPTARG"
      echo "waiting for job with label $label" >&2
      ;;
    p)
      parallel="yes"
      echo "running in parallel" >&2
      ;;
    w)
      parallel_wait="yes"
      echo "waiting for all parallel running jobs" >&2
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

if [[ -n $parallel_wait ]]; then
  pids=""
  label=$(head -n 1 lock)
  while read -r pid; do pids="$pids $pid"; done < tail -n +2 lock
  if [[ -z $pids ]]; then
    echo "Nothing to wait for" >&2
    exit 1
  fi
  wait "$pids"
  : > lock
else
  kubectl wait --for=condition=complete jobs -l app=$label && exit 0 &
  completion_pid=$!

  kubectl wait --for=condition=failed jobs -l app=$label && exit 1 &
  failure_pid=$!

  # write pid to lock in case of parallel run
  if [[ -n $parallel ]]; then
    echo "$$" >> lock
  fi

  wait -n $completion_pid $failure_pid
  exit_code=$?

  if (( exit_code == 0 )); then
    echo "Job succeeded"
    pkill -P $failure_pid
  else
    echo "Job failed"
    pkill -P $completion_pid
  fi
fi

kubectl logs -l app=$label --tail=-1
