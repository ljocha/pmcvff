#!/bin/bash

unset count
unset namespace
unset label
while getopts ":l:c:n:" opt; do
  case $opt in
    l)
      label="$OPTARG"
      echo "Waiting for job(s) with label $label" >&2
      ;;
    c)
      count=$OPTARG
      echo "Waiting for $OPTARG jobs to complete" >&2
      ;;
    n)
      namespace="$OPTARG"
      echo "Using namespace $namespace" >&2
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

while true; do
  succeeded=`kubectl get jobs -n $namespace -l app=$label -o 'jsonpath={..status.conditions[?(@.type=="Complete")].status}'`
  no_of_succeeded=`echo "$succeeded" | wc -w`

  failed=`kubectl get jobs -n $namespace -l app=$label -o 'jsonpath={..status.conditions[?(@.type=="Failed")].status}'`
  no_of_failed=`echo "$failed" | wc -w`

  summ=$(( no_of_succeeded + no_of_failed ))
  if [[ summ -eq count ]]; then
    break
  fi

  sleep 1
done

kubectl logs -n $namespace -l app=$label --tail=-1

kubectl delete jobs -n $namespace -l app=$label

