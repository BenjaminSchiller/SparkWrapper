Installation
============
(The OS used was Uubntu, trusty x64)

Copy and paste the bash script below to install Spark 1.6.2 and The graph frames library version 0.1.0:
```bash
sudo apt-get update &&
sudo apt-get install -y default-jre &&
echo "Downloading spark-1.6.2-bin-hadoop2.6.tgz..."
sudo wget -nc -O /opt/spark-1.6.2-bin-hadoop2.6.tgz https://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz &&
sudo tar -xzvf /opt/spark-1.6.2-bin-hadoop2.6.tgz &&
sudo wget -nc -O /opt/spark-1.6.2-bin-hadoop2.6/lib/graphframes-0.1.0-spark1.6.jar http://dl.bintray.com/spark-packages/maven/graphframes/graphframes/0.1.0-spark1.6/graphframes-0.1.0-spark1.6.jar &&
grep -q 'export PATH="/opt/spark-1.6.2-bin-hadoop2.6/bin/:$PATH"' /home/vagrant/.bashrc || echo 'export PATH="/opt/spark-1.6.2-bin-hadoop2.6/bin/:$PATH"' >> /home/vagrant/.bashrc
```
Please note that the script above is not yet idempotent. Do not run it twice. If it failed in the middle, please clean up the files manually, before re-running it.

Directory structure
===================
* `input-edges` A sample file for the input edges format. A TSV of node identifiers (type: Long)
* `input-vertices` A sample file for the input nodes format. A list of node identifiers (type: Long)
* `exec_job.scala` The source code used to run the graph algorithms
* `run_spark_shell.sh` A simple bash script to run and execute `exec_job.scala` in spark.

How to run
==========
```bash
./run_spark_shell.sh <input_vertices_filepath> <input_edges_filepath> <output_filepath> <algorithm_id> <src_vertex_id_shortest_paths> <num_worker_threads>
```
