//Version 1 baseline (All dense arrays)
//No sparsity, no systolic, no fusion, no reconfigurable arrays

//1变1元
package PEArrays
import primitive._
import helper._

import suan._
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 

	//1变2元
	// val variable : List[String],
	// val relation : List[Relation],
	// val precision: Map[String,Integer],
	// val inputs : List[String],
	// val outputs: List[String],
	
	// val iters: List[String],
	// val variable_iters: Map[String, List[String]],
	// val iters_tilesize: Map[String, Integer],
	
	// val systolic : Map[String,Boolean] = Map(),
	
class DenseUIntTransposejiPEArray(HardwareConfig: Map[String,String]) extends Module{
	//variable - x
	//relation - (i,j) -> (j,i)
	//precision - x
	val prec1 = HardwareConfig("prec1").toInt
	val prec_out = HardwareConfig("prec_out").toInt
	//inputs - x
	//outputs - y
	
	//iters = i, j
	//variable_iters y[j,i], x[i,j]
	//iters_tilesize = i = 8
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	//Custom unit's config
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, UInt(prec1.W) ) 
		val out0 = Vec(J*I, UInt(prec_out.W) ) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	// 1
	val m = List.fill(I*J)(  Module( 
	
		new PipelineData(prec1)
		
	))
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		m( i+j*I ).io.in.bits := io.in0( i+j*I )
		io.out0(  j+J*i )  := m(  i+j*I ).io.out.bits
	}
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		m(i+j*I).io.out.ready  := io.exit.ready
		m(i+j*I).io.in.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := m(0).io.in.ready //reduce
	io.exit.valid  := m(0).io.out.valid
}



class DenseSIntReduceijPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) 
		val out0 = Vec(I, SInt( prec_out.W)) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val m = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicAdderTree", 
		Map(
			"prec1" -> prec1.toString,
			"prec_out" -> prec_out.toString,			
			"terms" -> J.toString			
		)
	)  )  )
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		m( i ).io.in0(j) := io.in0( j+J*i )
	}
	io.out0(  i )  := m(  i ).io.out
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		m(i).io.exit.ready  := io.exit.ready
		m(i).io.entry.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := m(0).io.entry.ready //reduce
	io.exit.valid  := m(0).io.exit.valid
	
}

