//Version 1 baseline (All dense arrays)
//No sparsity, no systolic, no fusion, no reconfigurable arrays

//1变1元
package PEArrays
import primitive._
import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 

	//1变1元
	// val variable : List[String],
	// val relation : List[Relation],
	// val precision: Map[String,Integer],
	// val inputs : List[String],
	// val outputs: List[String],
	
	// val iters: List[String],
	// val variable_iters: Map[String, List[String]],
	// val iters_tilesize: Map[String, Integer],
	
	// val systolic : Map[String,Boolean] = Map(),
	
class DenseSinPEArray(HardwareConfig: Map[String,String]) extends Module{
	
	//variable - x
	//relation - sin
	//precision - x
	val prec1i = HardwareConfig("prec1i").toInt
	val prec1f = HardwareConfig("prec1f").toInt
	val prec_outi = HardwareConfig("prec_outi").toInt
	val prec_outf = HardwareConfig("prec_outf").toInt
	//inputs - x
	//outputs - y
	
	//iters = i
	//variable_iters y[i], x[i]
	//iters_tilesize = i = 8
	
	val i_tilesize = HardwareConfig("i").toInt
	
	//Custom unit's config
	val MultThroughput = HardwareConfig("MultThroughput")
	val MultDelay = HardwareConfig("MultDelay")
	val stages = HardwareConfig("stages")
	
	val io = IO(new Bundle{ 
		val in0 =  Vec(i_tilesize, new FP(prec1i, prec1f) ) 
		val out0 = Vec(i_tilesize, new FP(prec_outi, prec_outf) ) 
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	// 1
	val m = List.fill(i_tilesize)(  Module( PrimitiveFactory.CreateFixedPointIn1Out1(
		"FixedPointTrigSin", 
	
		Map(
			"prec1i" -> prec1i.toString,
			"prec1f" -> prec1f.toString,
			"MultThroughput" -> MultThroughput.toString,
			"MultDelay" -> MultDelay.toString,
			"stages" -> stages.toString			
		)
		
	)  ))
	
	// 2
	for(i <- 0 until i_tilesize){
		m(i).io.in0 := io.in0(i)
		io.out0(i)  := m(i).io.out
	}
	
	// 3 
	for(i <- 0 until i_tilesize){
		m(i).io.exit.ready  := io.exit.ready
		m(i).io.entry.valid := io.entry.valid
	}
	
	// 4
	io.entry.ready := m(0).io.entry.ready //reduce
	io.exit.valid  := m(0).io.exit.valid

}



class DenseCosPEArray(HardwareConfig: Map[String,String]) extends Module{
	val prec1i = HardwareConfig("prec1i").toInt
	val prec1f = HardwareConfig("prec1f").toInt
	val prec_outi = HardwareConfig("prec_outi").toInt
	val prec_outf = HardwareConfig("prec_outf").toInt
	val i_tilesize = HardwareConfig("i").toInt
	val MultThroughput = HardwareConfig("MultThroughput")
	val MultDelay = HardwareConfig("MultDelay")
	val stages = HardwareConfig("stages")
	val io = IO(new Bundle{ 
		val in0 =  Vec(i_tilesize, new FP(prec1i, prec1f) ) 
		val out0 = Vec(i_tilesize, new FP(prec_outi, prec_outf) ) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val m = List.fill(i_tilesize)(  Module( PrimitiveFactory.CreateFixedPointIn1Out1(
		"FixedPointTrigCos", 
		Map(
			"prec1i" -> prec1i.toString,
			"prec1f" -> prec1f.toString,
			"MultThroughput" -> MultThroughput.toString,
			"MultDelay" -> MultDelay.toString,
			"stages" -> stages.toString			
		)
	)  ))
	for(i <- 0 until i_tilesize){
		m(i).io.in0 := io.in0(i)
		io.out0(i)  := m(i).io.out
	}
	for(i <- 0 until i_tilesize){
		m(i).io.exit.ready  := io.exit.ready
		m(i).io.entry.valid := io.entry.valid
	}
	io.entry.ready := m(0).io.entry.ready //reduce
	io.exit.valid  := m(0).io.exit.valid
}




class DenseSIntReduceiPEArray(HardwareConfig:Map[String,String]) extends Module{
	val prec1 = HardwareConfig("prec1").toInt
	val prec_out = HardwareConfig("prec_out").toInt
	val i_tilesize = HardwareConfig("i").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(i_tilesize, SInt(prec1.W) ) 
		val out0 = SInt( prec_out.W) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val m = Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicAdderTree", 
		Map(
			"prec1" -> prec1.toString,
			"prec_out" -> prec_out.toString,			
			"terms" -> i_tilesize.toString			
		)
	)  )
	
	for(i <- 0 until i_tilesize){
		m.io.in0(i) := io.in0(i)
	}
	io.out0 := m.io.out
	
	m.io.exit.ready  := io.exit.ready
	m.io.entry.valid := io.entry.valid
	
	io.entry.ready := m.io.entry.ready //reduce
	io.exit.valid  := m.io.exit.valid
}

