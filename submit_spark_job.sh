#!/bin/bash
#
# Arguments:
# 0: Input vertices file path
# 1: Input edges file path
# 2: Output file path
# 3: Selected Algorithm ID
# 4: Src vertex to compute shortest paths
# 5: Number of worker threads -- Set this to the number of *LOGICAL* cores
#
# For extra spark config, see: https://spark.apache.org/docs/latest/configuration.html
# --master local[*] Run spark with as many worker threads as logical cores on the machine.
#
#
spark-submit --conf spark.driver.extraJavaOptions="-D$1,$2,$3,$4,$5" --master local[$6] --jars /opt/spark-1.6.2-bin-hadoop2.6/lib/graphframes-0.1.0-spark1.6.jar --class DGARunner /vagrant/target/scala-2.10/dgarunner_2.10-1.0.jar
