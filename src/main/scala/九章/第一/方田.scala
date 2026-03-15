package jiuzhang

import primitive._
import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 

import AutomatedArrays._

import java.io.PrintWriter

// import AutomatedDMA._

object Fangtian2 extends App{
	
	// //Create Counter based on some indices
	// var idx = List("i", "j", "k")
	// var raw = CounterHighLevel.create(idx,
	// 	desiredName = "Counter"
	// )
	// var meta = DMAHighLevel.parse("out0[] = SIntBasicAdd(out0[],in0[i])")
	// var raw = DMAHighLevel.create(meta,
	// 	desiredName = "DMA")
	
	
	//Assume PE array is controlled by low-level language
	//Memory = | ReadAddr | ReadEn | FromCache | ReadLines | WriteAddr | WriteEn | 
	//MemorySparse = | ZeroMapReadAddr |  | 
	
	
	
}


object Gougu1 extends App {
	
	//In same system
	var meta2 = HighLevel.parseComplex(List(
			"sum[i] = SIntBasicAdd(in0[i,j])",//Step 1
			"out0[i] = SIntBasicAdd(out0_p[i],sum[i])", //Step 2
	))
	
	var raw = HighLevel.createComplexArray(meta2, "AdderTree")
	println("main")
	println(raw("s"))
	
	// println("support")
	// println(raw("support"))
	// var idx = 0
	// for(m <- meta2){
	// 	var raw = HighLevel.createPEArray(m,
	// 		desiredName = "hardware" + idx
	// 	)
	// 	idx = idx + 1
	// 	println( raw("s"))
	// }
	// var chisel1 = raw("s")
	
	// var raw = HighLevel.createPEArray(meta,
	// 	desiredName = hardware1
	// )
	
	
}

object Fangcheng1 extends App{
	
	// var meta2 = HighLevel.parseComplex(List(
	// 	"sum[i] = SIntBasicAdd(in0[i,j])",//Step 1
	// 	"out0[i] = SIntBasicAdd(out0[i],sum[i])", //Step 2
	// ))
	
	var hardware1 = "SIntAdderReduce"
	var meta = HighLevel.parse("sum[i] = SIntAdderN(in0[i,j])")
	
	hardware1 = "SIntAdder"
	meta = HighLevel.parse("out0[i] = SIntBasicAdder(sum[i], out0_p[i])")
	var var2prec =  Map(
		"in0" -> 8,
		"out0" ->8,
		"out0_p" -> 8,
		"in1" -> 8,
		"sum" -> 8
	)
	var iter2tile = Map(
		"i" -> 8,
		"j" -> 8
	)
	var var2systolic = Map(
		"in0" -> 0,
		"sum" -> 0
	)
	var raw = HighLevel.createPEArray(meta,
		desiredName = hardware1
	)
	var chisel1 = raw("s")
	println(chisel1)
	println(raw("b"))
	
	val writer = new PrintWriter("src/main/scala/generated/"+hardware1+".scala") 
	try {writer.write(chisel1)} finally {writer.close()}
	
	var raw2 = HighLevel.GeneratePEArrayVerilog(meta,
		var2prec = var2prec,
		iter2tile = iter2tile,
		var2systolic = var2systolic,
		desiredName = hardware1
	)
	println(raw2("g"))
	
	        var file = "./generated/latest/SIntAdder"
	        new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	                Seq(ChiselGeneratorAnnotation(() =>
	                        new SIntAdderPEArray(
	                                Map(
	                                        "I" -> 8.toString,
	
	                                        "out0prec" -> 8.toString,
	                                        "sumprec" -> 8.toString,
	                                        "out0_pprec" -> 8.toString,
	
	                                        "save_folder" -> file,
	
	                                        "desiredName" -> "SIntAdder",
	                        ))
	                )))
					
	// var file = "./generated/latest/SIntAdderReduce"
	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	// 		Seq(ChiselGeneratorAnnotation(() =>
	// 				new SIntAdderReducePEArray(
	// 						Map(
	// 								"I" -> 8.toString,
	// 								"J" -> 8.toString,

	// 								"out0prec" -> 8.toString,
	// 								"in0prec" -> 8.toString,

	// 								"save_folder" -> file,

	// 								"desiredName" -> "SIntAdderReduce",
	// 				))
	// 		)))		
	}

object Fangtian1 extends App{
	
	//1. Create PE Array using scala -> Chisel
	
	// meta = HighLevel.parse("out0[] = SIntMaxN(out0[],in0[i])")
	
	var meta = HighLevel.parse("out0[] = SIntBasicAdd(out0[],in0[i])")
	
	
	var hardware1 = "SIntBasicSquareArray"
	meta = HighLevel.parse("out0[i] = SIntBasicSquare(in0[i])")
	
	
	hardware1 = "SIntMaxNArray"
	meta = HighLevel.parse("out0[] = SIntMaxN(in0[i])")
	
	hardware1 = "SIntBasicSquareTransposed"
	meta = HighLevel.parse("out0[j,i] = SIntBasicSquare(in0[i,j])")
	
	hardware1 = "SIntTransposed"
	meta = HighLevel.parse("out0[j,i] = SIntBuffer(in0[i,j])")
	
	hardware1 = "SIntAdder"
	meta = HighLevel.parse("out0[i] = SIntBasicAdder(in1[i],in0[i])")

	// Todos
	// hardware1 = "SIntConcat"
	// meta = HighLevel.parse("out0[i,j+k] = SIntConcat(in0[i,j], in1[i,k])")
	
		
	//2. Create PE 
	var var2prec =  Map(
		"in0" -> 8,
		"in1" -> 8,
		"out0" -> 8
	)
	var iter2tile = Map(
		"i" -> 8,
		"j" -> 8
	)
	var var2systolic = Map(
		"in0" -> 0,
		"out0" -> 0
	)
	
	// HighLevel.setHardwareConfig(
	// 	var2prec = var2prec,
	// 	iter2tile = iter2tile,
	// 	var2systolic = var2systolic
	// )
	var raw = HighLevel.createPEArray(meta, 
		// var2prec = var2prec,
		// iter2tile = iter2tile,
		// var2systolic = var2systolic,
		desiredName = hardware1
	)
	var chisel1 = raw("s")
	println(chisel1)
	println(raw("b"))
	
	val writer = new PrintWriter("src/main/scala/generated/"+hardware1+".scala") 
	try {writer.write(chisel1)} finally {writer.close()}
	
	var raw2 = HighLevel.GeneratePEArrayVerilog(meta,
		var2prec = var2prec,
		iter2tile = iter2tile,
		var2systolic = var2systolic,
		desiredName = hardware1
	)
	println(raw2("g"))
	
 //        var file = "./generated/latest/SIntMaxNArray"
 //        new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 //                Seq(ChiselGeneratorAnnotation(() =>
 //                        new SIntMaxNArrayPEArray(
 //                                Map(
 //                                        "I" -> 8.toString,

 //                                        "out0prec" -> 8.toString,
 //                                        "in0prec" -> 8.toString,

 //                                        "save_folder" -> file,

 //                                        "desiredName" -> "SIntMaxNArray",
 //                        ))
 //                )))
	
	
 //        file = "./generated/latest/SIntBasicSquareArray"
 //        new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 //                Seq(ChiselGeneratorAnnotation(() =>
 //                        new SIntBasicSquareArrayPEArray(
 //                                Map(
 //                                        "I" -> 8.toString,

 //                                        "out0prec" -> 8.toString,
 //                                        "in0prec" -> 8.toString,

 //                                        "save_folder" -> file,

 //                                        "desiredName" -> "SIntBasicSquareArray",
 //                        ))
 //                )))
	//         var file = "./generated/latest/SIntTransposed"
	//         new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	//                 Seq(ChiselGeneratorAnnotation(() =>
	//                         new SIntTransposedPEArray(
	//                                 Map(
	//                                         "J" -> 8.toString,
	//                                         "I" -> 8.toString,
	
	//                                         "out0prec" -> 8.toString,
	//                                         "in0prec" -> 8.toString,
	
	//                                         "save_folder" -> file,
	
	//                                         "desiredName" -> "SIntTransposed",
	//                         ))
	//                 )))
	
	
	
	//         var file = "./generated/latest/SIntAdder"
	//         new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	//                 Seq(ChiselGeneratorAnnotation(() =>
	//                         new SIntAdderPEArray(
	//                                 Map(
	//                                         "I" -> 8.toString,
	
	//                                         "out0prec" -> 8.toString,
	//                                         "in1prec" -> 8.toString,
	//                                         "in0prec" -> 8.toString,
	
	//                                         "save_folder" -> file,
	
	//                                         "desiredName" -> "SIntAdder",
	//                         ))
	//                 )))
	
	
	
	
	// HighLevel.createValueSparse(meta,
		
	// )
	// HighLevel.CreateSharedCore()
	// HighLevel.CreateCore(
	// 	[PEArray,PEArray2]
	// 	ValueSparsity,
	// 	InMemorySparsity,
	// 	OutMemorySparsity,
	// 	WriteDMAUnit,
	// 	DMAUnit,
	// 	Counter
	// )
	
	//3. Synthesize Chisel
	
	
	// val file = "./generated/Primitive/Fangtian1"

	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	// 	Seq(ChiselGeneratorAnnotation(() => 
		
	// 		// PrimitiveFactory.CreateUIntIn1Out1("UIntBasicSquare", Map(  "prec1" -> "8",  "prec_out" -> "8"  ))
		
	// 		new Automated11SIntArray(
	// 			Map(
	// 				// "expr" -> "out0[i] = SInt(in0[i])"
	// 				"expr" -> "out0[] = out0[] + in0[i]"
	// 		))
		
	// 	)))	
	//Simulation using vcs or iverilog
	// sim.iverilog(svtbfile = file+"/UIntBasicSquare.tb.sv", svfiles = Seq(file+"/UIntBasicSquare.v"), svtb = """
	// 		initial begin
	// 			Reset();
	// 			// for(int i = 0; i <= 9; i++)begin
	// 			// 	io_in0 = i;
	// 			// 	io_entry_valid = 1; 
	// 			// 	io_exit_ready = 1;
	// 			// 	@(posedge clock);
	// 			// 	#1;
	// 			// 	assert(io_in0*io_in0 == io_out);
	// 			// end
	// 		end
	// """)
}
 
 
 
 
 
object fangtian extends App {

		def fang(cong:Int, guang:Int) = {
			
			(cong*guang, cong*guang/240)
		}
		println(fang(15,16))
		println(fang(12,14))
		
		def li(cong:Int, guang:Int) = {
			(cong*guang, cong*guang*375)
		}
		println(li(1,1))
		println(li(2,3))
		
		def yue(mu:Int, zi:Int) = {
			var yue:Int = 0
			var yue2:Int = 0
			if(mu > zi){
				yue = mu
				yue2 = zi
			}else{
				yue = zi
				yue2 = mu
			}
			while(yue != yue2){
				if(yue > yue2){
					yue=yue-yue2
				}else{
					yue2=yue2-yue
				}
			}
			(yue, mu/yue, zi/yue)
		}
		println(yue(18,12))
		println(yue(91,49))
	
		
		def 分( 母:Int, 子:Int) = new fen(母,子)
		class fen(val 母:Int, val 子:Int)
		
		def 合分( 分数 : List[fen]) = {
		   val 子 =	分数.map(_.子)
		   val 母 = 分数.map(_.母)
		   
		   
		   var 法 = 母.reduce(_ * _)
		   var 实 :Int = 0
		   for(数 <- 分数){
			   实 = 实 +  数.子 * 法 / 数.母 
			}
		   // val 母子 = 子.map(_ * 法)
		   // 法子 zip 母
		   // val 法子 = 子.map(_ * 法)
		   
		   val 数 :Int= 实/法
		   val 达姆 :Int= 法 
		   val 达子 :Int= 实 % 法 
		   
		   // ((数,达姆, 达子),yue( 达姆, 达子))
		   val 约 = yue( 达姆, 达子)
		   (数, 约._2, 约._3 )
		  
		}
		println(合分(List(  分(3,1), 分(5,2)  )))
		println(合分(List(  分(3,2), 分(7,4), 分(9,5)  )))
		println(合分(List(  分(2,1), 分(3,2), 分(4,3),分(5,4)  )))
		
		
		
		
		
		
		
}



