#!/bin/bash

function sparkJob {
	# $1: dataset
	# $2: states
	# $3: metric
	# $4: metricArguments
	# $5: workers
	# $6: run
	./jobs.sh create "./sparkTask.sh $1 $2 $3 $4 $5 $6"
}

dataset="Undirected__-/Random__100_500/RandomEdgeExchange__10_99999999/0__99"
states="100"

workerss=(1 2 4 8 16 32)
runs=(1 2 3)

workerss=(4 8)
runs=(1 2)

for run in ${runs[@]}; do
	for workers in ${workerss[@]}; do
		sparkJob $dataset $states dd 0 $workers $runs
	done
done