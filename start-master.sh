#!/bin/bash

echo "$(date) - starting spark master"
sudo /opt/spark-1.6.2-bin-hadoop2.6/sbin/start-master.sh
echo "$(date) - started spark master"
