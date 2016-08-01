#!/bin/bash

source jobs.cfg

rsync -auvzl \
	../install.sh \
	../submit_spark_job.sh \
	../start-master.sh ../stop-master.sh \
	spark.sh sparkTask.sh config.cfg \
	_jobsRunner.sh \
	../package.sbt ../src \
	clean.sh \
	$server_name:$server_dir/