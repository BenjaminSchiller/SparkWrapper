#!/bin/bash

if [[ "$#" != "7" ]]; then
	echo 'expecting 7 arguments:' >&2
	echo '    flink.sh $datasetCategory $datasetName $states $metric $metricArguments $workers $run' >&2
	exit
fi

function printTime {
	if [[ -d /Users/benni ]]; then
		gdate +%s%N
	else
		date +%s%N
	fi
}

source config.cfg

datasetCategory=$1
datasetName=$2
states=$3
metric=$4
metricArguments=$5
workers=$6
run=$7



# 1: type (cc, dd, sssp, tc)
case $metric in
	"cc")
		metricId=$ccId
		;;
	"dd")
		metricId=$ddId
		;;
	"sssp")
		metricId=$ssspId
		;;
	"tc")
		metricId=$tcId
		;;
	*)
		echo "invalid metric key: $metric" >&2
		exit
		;;
	esac


datasetDir="${mainDatasetDir}/$datasetCategory/$datasetName"
runtimesDir="${mainRuntimesDir}/$datasetCategory/$datasetName/$metric--$states--$workers"
logDir="${mainLogDir}/$datasetCategory/$datasetName/$metric--$states--$workers"
outputDir="${mainOutputDir}/$datasetCategory/$datasetName/$metric--$states--$workers"

if [[ ! -d $runtimesDir ]]; then mkdir -p $runtimesDir; fi
if [[ ! -d $logDir ]]; then mkdir -p $logDir; fi
if [[ ! -d outputDir ]]; then mkdir -p $outputDir; fi

runtimes="${runtimesDir}/${run}${runtimesSuffix}"

if [[ -f $runtimes ]]; then echo "$runtimes exists" >&2; exit; fi

for s in $(seq 1 $states); do
	datasetV="${datasetDir}/${s}${datasetVSuffix}"
	datasetE="${datasetDir}/${s}${datasetESuffix}"

	if [[ ! -f $datasetV ]]; then echo "$datasetV does not exist" >&2; exit; fi
	if [[ ! -f $datasetE ]]; then echo "$datasetE does not exist" >&2; exit; fi

	total_start=$(printTime)
	if [[ $metric == "sssp" ]]; then
		for vertexId in $(echo $metricArguments | tr "," " "); do
			log="${logDir}/${run}-${s}--${vertexId}${logSuffix}"
			err="${logDir}/${run}-${s}--${vertexId}${errSuffix}"
			output="${outputDir}/${run}-${s}--${vertexId}${outputSuffix}"
			echo spark-shell -i exec_job.scala --conf spark.driver.extraJavaOptions="-D${datasetV},${datasetE},${output},${metricId},${vertexId}" --master local[${workers}] --jars $jarPath > >(tee $log) 2> >(tee $err >&2)
		done
	else
		log="${logDir}/${run}-${s}${logSuffix}"
		err="${logDir}/${run}-${s}${errSuffix}"
		output="${outputDir}/${run}-${s}${outputSuffix}"
		echo spark-shell -i exec_job.scala --conf spark.driver.extraJavaOptions="-D${datasetV},${datasetE},${output},${metricId},${metricArguments}" --master local[${workers}] --jars $jarPath > >(tee $log) 2> >(tee $err >&2)
	fi
	total_end=$(printTime)
	duration=$((${total_end} - ${total_start}))
	echo "$s	$duration" >> $runtimes
done
echo "TOTAL	$(awk '{ sum += $2; } END { print sum; }' "$runtimes")" >> $runtimes


