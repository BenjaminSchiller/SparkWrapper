name := "DGARunner"

version := "1.0"

scalaVersion := "2.10.5"

resolvers += "bintray-spark-packages" at "https://dl.bintray.com/spark-packages/maven/"

libraryDependencies += "org.apache.spark" %% "spark-core" % "1.6.2"

libraryDependencies += "org.apache.spark" %% "spark-sql" % "1.6.2"

libraryDependencies += "org.apache.spark" %% "spark-graphx" % "1.6.2"

libraryDependencies += "graphframes" % "graphframes" % "0.1.0-spark1.6"

