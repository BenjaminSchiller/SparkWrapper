#!/bin/bash

echo "$(date) - stopping spark master"
ps aux | grep "org.apache.spark.deploy.master.Master" | grep -v grep | sudo kill $(awk {'print $2'})
echo "$(date) - stopped spark master"
