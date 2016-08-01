#!/bin/bash

if [[ "$#" != "6" ]]; then
	echo 'expecting 6 arguments:' >&2
	echo '    sparkTask.sh $dataset $states $metric $metricArguments $workers $run' >&2
	exit
fi

source config.cfg

dataset=$1
states=$2
metric=$3
metricArguments=$4
workers=$5
run=$6


endCpu=$(($startCpu+$auxCpus+$workers-1))
echo "binding spark to cpus: $startCpu-$endCpu"
taskset -c "${startCpu}-${endCpu}" ./spark.sh $dataset $states $metric $metricArguments $workers $run
echo "DONE"

