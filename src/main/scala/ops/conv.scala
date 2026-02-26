package ops

import chisel3._
import chisel3.util._
import scala.collection.mutable.Queue
import play.api.libs.json._
import scala.io.Source
import chisel3.stage.ChiselGeneratorAnnotation

//General convolution (not optimized for specific types of convolution)
//1. 3x3, 2x2 small filters, 1 stride or 2 strides --> Wino
//2. Patch (32x32, 32 strides) --> Patch
//3. 1x1 MM --> MM
//4. Group convolution --> ?
//5. Depthwise, other types etc.
//Assume incoming data is blocked (not im2col)
class conv(hw:String, rt:String) extends RawModule {
	
	val hwString = Source.fromFile(hw).mkString
	val hwp = Json.parse(hwString)
	
	//print(args(args.length-1))
	
	val jsonString = Source.fromFile(rt).mkString
	// print(jsonString)		
	// 解析 JSON
	val parsed = Json.parse(jsonString)
		
	//Get Conv Parameters
	val kernelX = (parsed \ "main" \ "common" \ "kernelX").as[Int]
	val kernelY = (parsed \ "main" \ "common" \ "strideY").as[Int]
	val strideX = (parsed \ "main" \ "common" \ "strideX").as[Int]
	val strideY = (parsed \ "main" \ "common" \ "strideY").as[Int]
	val inputC  = (parsed \ "main" \ "common" \ "inputC").as[Int]
	val outputC = (parsed \ "main" \ "common" \ "outputC").as[Int]
	
	val weiPrec = (parsed \ "main" \ "quanParameter" \ "aMaxOrBits" ).as[Int]
	val inPrec = 16
	
	println(kernelX)
	println(kernelY)
	println(strideX)
	println(strideY)
	
	//
	
	// print(parsed("main").get("common").get("kernelX").as[Int] )
	// print(parsed("kernelY").as[Int] )
	// print(parsed("strideX").as[Int] )
	// print(parsed("strideY").as[Int] )
	// parsed("inTensors0").as[]
	
	
	
}


object convtest extends App {
	
	
	
	//clock, input precisions?
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/ops/conv"),
		Seq(ChiselGeneratorAnnotation(() => new conv(args(args.length - 2),args(args.length - 1))    )))
	
	
	
}