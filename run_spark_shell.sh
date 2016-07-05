#!/bin/bash
#
# Arguments:
# 0: Input vertices file path
# 1: Input edges file path
# 2: Output file path
# 3: Selected Algorithm ID

spark-shell -i exec_job.scala --conf spark.driver.extraJavaOptions="-D$1,$2,$3,$4" --master local[4] --jars /opt/spark-1.6.2-bin-hadoop2.6/lib/graphframes-0.1.0-spark1.6.jar
