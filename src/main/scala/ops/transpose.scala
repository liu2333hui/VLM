

// package ops

// import chisel3._
// import chisel3.util._
// import scala.collection.mutable.Queue
// import play.api.libs.json._
// import scala.io.Source
// import chisel3.stage.ChiselGeneratorAnnotation

// class transposeio extends Bundle {
	
// }

// class transpose(hw:String) extends RawModule {
	
// 	val io = new IO(
// 		new transposeio()
// 	)
	
// }


// object transposetest extends App {
	
	
// 	val hw = args(args.length - 2)
// 	val rt = args(args.length - 1)
	
// 	//clock, input precisions?
// 	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/ops/transpose"),
// 		Seq(ChiselGeneratorAnnotation(() => new  transpose(  hw   )  )) )
	
// 	val rtString = Source.fromFile(rt).mkString
// 	val parsed = Json.parse(rtString)
	
// 	val dims = (parsed \ "main" \ "dims" ).as[ List[Int ] ]
	
// 	println(dims)
	
// }