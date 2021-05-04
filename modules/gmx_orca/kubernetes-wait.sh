#!/bin/bash
#this script is dependant on ttl of watched jobs (wait is completed only after all jobs are deleted)

unset label
while getopts ":l:" opt; do
  case $opt in
    l)
      label="$OPTARG"
      echo "Waiting for job(s) with label $label" >&2
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

sleep 3
while true; do
  succeeded=`kubectl get jobs -l app="$label" -o 'jsonpath={..status.conditions[?(@.type=="Complete")].status}'`
  no_of_succeeded=`echo "$succeeded" | wc -w`

  failed=`kubectl get jobs -l app="$label" -o 'jsonpath={..status.conditions[?(@.type=="Failed")].status}'`
  no_of_failed=`echo "$failed" | wc -w`

  summ=$(( no_of_succeeded + no_of_failed ))
  if [[ summ -eq 0 ]]; then
    break
  fi

  sleep 1
done

kubectl logs -l app=$label --tail=-1
