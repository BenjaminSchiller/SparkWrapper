import org.apache.spark.SparkConf;
import org.apache.spark.sql.types.{StructType,StructField,StringType};
import org.apache.spark.sql.Row;
import org.apache.spark.sql._
import org.apache.spark.sql.functions._

import org.graphframes._

// Paramater parsing via --conf spark.driver.extraJavaOptions="-Darg1,arg2,arg3"
val sconf = new SparkConf()
val paramsString = sconf.get("spark.driver.extraJavaOptions")
val paramsSlice = paramsString.slice(2,paramsString.length)
val paramsArray = paramsSlice.split(",")
val inputVerticesFilepath = paramsArray(0)
val inputEdgesFilepath = paramsArray(1)
val outputFilepath = paramsArray(2)


// Helper method to time certain blocks of the code
def time[R](block: => R): R = {
    val t0 = System.nanoTime()
    val result = block    // call-by-name
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) + "ns")
    result
}

val sqlContext = new org.apache.spark.sql.SQLContext(sc)

// Reading and loading edges into Dataframes
println("*************************************************")
println("Reading and converting graph into graphframes....")
println("*************************************************")


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
	
	val graphFrame = GraphFrame(verticesDataFrame, edgesDataFrame)
	graphFrame.inDegrees.show
}


