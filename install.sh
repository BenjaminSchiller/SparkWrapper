#!/bin/bash

# sudo apt-get update
# sudo apt-get install -y default-jre &&
echo "Downloading spark-1.6.2-bin-hadoop2.6.tgz..."
sudo wget -nc -O /opt/spark-1.6.2-bin-hadoop2.6.tgz https://d3kbcqa49mib13.cloudfront.net/spark-1.6.2-bin-hadoop2.6.tgz
sudo tar -xzvf /opt/spark-1.6.2-bin-hadoop2.6.tgz -C /opt/
sudo wget -nc -O /opt/spark-1.6.2-bin-hadoop2.6/lib/graphframes-0.1.0-spark1.6.jar http://dl.bintray.com/spark-packages/maven/graphframes/graphframes/0.1.0-spark1.6/graphframes-0.1.0-spark1.6.jar
grep -q 'export PATH="/opt/spark-1.6.2-bin-hadoop2.6/bin/:$PATH"' ~/.bashrc || echo 'export PATH="/opt/spark-1.6.2-bin-hadoop2.6/bin/:$PATH"' >> ~/.bashrc

# SBT for scala packaging
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
sudo apt-get update
sudo apt-get install sbt
