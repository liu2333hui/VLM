package primitive

import suan._

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

import networks._

import helper.EntryIO
import helper.ExitIO


class FixedPointTrigExp(HardwareConfig : Map[String, String]) extends FixedPointIn1Out1(HardwareConfig){
	//val io = IO(new FixedPointUnaryIO(preci, precf))
	//val preci:Int = 8, val precf:Int = 8,
	// val MultThroughput:Int = 4, val MultDelay:Int = 4, val stages:Int = 1
	// val preci = HardwareConfig("prec1i").toInt
	// val precf = HardwareConfig("prec1f").toInt
	val MultThroughput = HardwareConfig("MultThroughput").toInt
	val MultDelay = HardwareConfig("MultDelay").toInt
	val stages = HardwareConfig("stages").toInt
	
	val w0 = 1.0
	val w1 = 1.0/1.0 
	val w2 = 1.0/2.0
	val w3 = 1.0/6.0
	val w4 = 1.0/24
	val w5 = 1.0/120
	val main = Module(new approx_op(preci, precf, 
		MultThroughput, MultDelay, stages, 
			w0,w1,w2,w3,w4,w5, top = desiredName
		))
	// main.io <> io
	main.io.out <> io.exit
	main.io.in <> io.entry
	main.io.data <> io.in0
	main.io.res <> io.out
	
}


	
class FixedPointTrigSin(HardwareConfig : Map[String, String]) extends FixedPointIn1Out1(HardwareConfig){
	// val preci = HardwareConfig("prec1i").toInt
	// val precf = HardwareConfig("prec1f").toInt
	val MultThroughput = HardwareConfig("MultThroughput").toInt
	val MultDelay = HardwareConfig("MultDelay").toInt
	val stages = HardwareConfig("stages").toInt
	val w0 = 0.0
	val w1 = 1.0
	val w2 = 0.0
	val w3 = -1.0/(3*2)
	val w4 = 0.0
	val w5 = 1.0/(5*4*3*2)
	val main = Module(new approx_op(preci, precf, 
		MultThroughput, MultDelay, stages, 
			w0,w1,w2,w3,w4,w5,
		))
	main.io.out <> io.exit
	main.io.in <> io.entry
	main.io.data <> io.in0
	main.io.res <> io.out
}

class FixedPointTrigCos(HardwareConfig : Map[String, String]) extends FixedPointIn1Out1(HardwareConfig){
	val MultThroughput = HardwareConfig("MultThroughput").toInt
	val MultDelay = HardwareConfig("MultDelay").toInt
	val stages = HardwareConfig("stages").toInt
	val w0 = 1.0
	val w1 = 0.0
	val w2 = -1.0/2
	val w3 = 0.0
	val w4 = 1.0/(4*3*2)
	val w5 = 0.0
	val main = Module(new approx_op(preci, precf, 
		MultThroughput, MultDelay, stages, 
			w0,w1,w2,w3,w4,w5,
		))
	main.io.out <> io.exit
	main.io.in <> io.entry
	main.io.data <> io.in0
	main.io.res <> io.out
}

class tanh_op(){
	
}