import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.SparkContext._;
import org.apache.spark.sql.types.{StructType,StructField,StringType};
import org.apache.spark.sql.Row;
import org.apache.spark.sql._
import org.apache.spark.sql.functions._

import org.graphframes._
import org.apache.spark.graphx._

object DGARunner {

def main(args: Array[String]) {

// Paramater parsing via --conf spark.driver.extraJavaOptions="-Darg1,arg2,arg3"
val sconf = new SparkConf()
val sc = new SparkContext(sconf)
val paramsString = sconf.get("spark.driver.extraJavaOptions")
val paramsSlice = paramsString.slice(2,paramsString.length)
val paramsArray = paramsSlice.split(",")
val inputVerticesFilepath = paramsArray(0)
val inputEdgesFilepath = paramsArray(1)
val outputFilepath = paramsArray(2)
val selectedAlgorithm = paramsArray(3)
val srcVertextShortestPaths = paramsArray(4)


// Helper method to time certain blocks of the code
def time[R](block: => R): R = {
    val t0 = System.nanoTime()
    val result = block    // call-by-name
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) + "ns")
    result
}

val sqlContext = new org.apache.spark.sql.SQLContext(sc)
import sqlContext.implicits._

// Reading and loading edges into Dataframes
println("*************************************************")
println("Reading and converting graph into graphframes....")
println("*************************************************")

var graphFrame:GraphFrame = null;

time {
	// Reading vertices...
	val vertices = sc.textFile(inputVerticesFilepath)
	val verticesDataFrame = vertices.toDF("id")
	
	// Reading edges....
	val edges = sc.textFile(inputEdgesFilepath)
	val schemaString = "src dst"

	val schema =
	  StructType(
	    schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))


	val rowRDD = edges.map(_.split("\\t")).map(p => Row(p(0), p(1).trim))
	val edgesDataFrame = sqlContext.createDataFrame(rowRDD, schema)
	
	graphFrame = GraphFrame(verticesDataFrame, edgesDataFrame)
}

// Select and run user-selected algorithm
// graphFrame.shortestPaths.landmarks(Array("1","2")).run.show
// println(graphFrame.toGraphX.subgraph(vpred = (id, attr) => id == 1).vertices.collect.mkString("\n"))

var result:DataFrame=null

if (selectedAlgorithm == "1") {
	println("Running connected components...");
	time { result=graphFrame.connectedComponents.run }; 

} else if (selectedAlgorithm == "2") {
	println("Running vertex degrees...");
	time { result=graphFrame.degrees };
 
} else if (selectedAlgorithm == "4") {
	println("Running shortest paths...");
	time { graphFrame.shortestPaths.landmarks(Array(srcVertextShortestPaths)).run }; 

} else if (selectedAlgorithm == "5") {
	println("Running triangle count...");
	time { result=graphFrame.triangleCount.run }; 

} else {
	println("Algorithm not supported!");
}



// Write result to output file
result.repartition(1).rdd.saveAsTextFile(outputFilepath) 

}

}

// Exit to clean local state and memory.
//exit
