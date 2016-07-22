Installation
============
(The OS used was Uubntu, trusty x64)

Use the `install.sh` script to install Spark 1.6.2 and The graph frames library version 0.1.0.

Please note that the script above is not yet idempotent. Do not run it twice. If it failed in the middle, please clean up the files manually, before re-running it.

Directory structure
===================
* `input-edges` A sample file for the input edges format. A TSV of node identifiers (type: Long)
* `input-vertices` A sample file for the input nodes format. A list of node identifiers (type: Long)
* `exec_job.scala` The source code used to run the graph algorithms
* `run_spark_shell.sh` [DEVELOPMENT ONLY] A simple bash script to run and execute `exec_job.scala` in spark.
* `submit_spark_job.sh` [USEME] A simple bash script to submit a spark job to the master server

How to run
==========
1. First, make sure the spark master is running in the background. You only need to start the master once and then submit as many jobs to it as you want.
```bash
# Make sure JAVA_HOME is set first.
sudo /opt/spark-1.6.2-bin-hadoop2.6/sbin/start-master.sh
```
2. Build and package your scala app into a JAR file
```bash
sbt package
```
Your output JAR should now be in: `target/scala-2.10/dgarunner_2.10-1.0.jar` 

3. Submit your job to the spark master. This step assumes your JAR file resides in the location above in step 2.
```bash
./submit_spark_job.sh <input_vertices_filepath> <input_edges_filepath> <output_filepath> <algorithm_id> <src_vertex_id_shortest_paths> <num_worker_threads>
```

Algorithm Ids
=============
* [1] Connected components
* [2] Vertext degrees
* [4] Single source shortest paths
* [5] Triangle count

