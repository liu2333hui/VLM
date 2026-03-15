package primitive

import chisel3._
import chisel3.util._
import scala.collection.mutable.Queue
// import networks.{Mux2}

import chisel3._
import chisel3.util._
import blocks.FixedBlock


import chisel3._
import chisel3.util._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.sys.process._

import suan._
import helper._

//Max2
// class SIntBasicAdder( HardwareConfig:Map[String, String]) extends SIntIn2Out1(HardwareConfig) {
// 	override def desiredName = HardwareConfig.getOrElse("desiredName", "") + "_SIntMax2"

// 	val p = Module(new PipelineSInt( Map("prec" -> prec_out.toString, 
// 		"desiredName" -> desiredName ) ))
// 	p.io.in.bits := Mux(io.in0 > io.in1, io.in0, io.in1)
// 	io.out := p.io.out.bits
// 	p.io.in.valid := io.entry.valid 
// 	io.entry.ready := p.io.in.ready
	
// 	io.exit.valid := p.io.out.valid
// 	p.io.out.ready := io.exit.ready
	
// }

//MaxTreeN
//(todos generic tree structure for any arithmetic unit)
class SIntAdderN(HardwareConfig:Map[String, String]) extends SIntInNOut1(HardwareConfig) {
  
  if(HardwareConfig("terms") == "2"){
	  val root = Module(new SIntBasicAdder(HardwareConfig + ("prec2" -> HardwareConfig("prec1")) ))
	  io.out := root.io.out
	  io.exit <> root.io.exit
	  io.entry <> root.io.entry
	  root.io.in0 := io.in0(0)
	  root.io.in1 := io.in0(1)
  }else{
  
  // tree
  val root = Module(new SIntBasicAdder(HardwareConfig + ("prec2" -> HardwareConfig("prec1")) ))
  io.out := root.io.out
  
  
  root.io.exit  <> io.exit
  root.io.entry <> io.entry
  
  
  val cur_layer = Queue[SIntBasicAdder](root)
  for(i <- 1 until log2Ceil(terms)){
	  val cur_layer_len = cur_layer.length
		  for (j <- 0 until cur_layer_len){
			val element = cur_layer.dequeue()
			val childA : SIntBasicAdder = Module(new SIntBasicAdder(HardwareConfig + ("prec2" -> HardwareConfig("prec1"))))
			val childB : SIntBasicAdder = Module(new SIntBasicAdder(HardwareConfig + ("prec2" -> HardwareConfig("prec1"))))
			element.io.in0 := childA.io.out 
			element.io.in1 := childB.io.out 
			
			childA.io.exit  <> io.exit
			childA.io.entry <> io.entry
			
			childB.io.exit  <> io.exit
			childB.io.entry <> io.entry
			
			
			cur_layer.enqueue(childA)
			cur_layer.enqueue(childB)
		  }
   }
	
	var idx = 0
	val cur_layer_len = cur_layer.length
	for (j <- 0 until cur_layer_len){
	val element = cur_layer.dequeue()
	element.io.in0 := io.in0(idx) 
	element.io.in1 := io.in0(idx+1)
	idx = idx+ 2
	}	

	}
}


