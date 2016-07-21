#!/bin/bash

source jobs.cfg

rsync -auvzl \
	../install.sh \
	../exec_job.scala \
	spark.sh config.cfg \
	datasets \
	clean.sh \
	$server_name:$server_dir/