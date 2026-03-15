package primitive


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

import chisel3._

import helper._
import chisel3.util._

import suan.PipelineSIntData


class SIntBoothMultiplier(HardwareConfig : Map[String, String]) extends SIntIn2Out1(HardwareConfig){
	override def desiredName = HardwareConfig.getOrElse("desiredName", "") + "_SIntBoothMultiplier"
	
	// val p = Module(new PipelineSInt( Map(
	// 		"prec" -> prec_out,
	// 		"desiredName" -> desiredName,		
	// 	)
	// ))
	
	val p = Module(new BoothMultiplier(
		top = desiredName,
		 Delay = HardwareConfig("MultDelay").toInt,  Prec1 = prec1,  Prec2 = prec2))
		 
	p.io.math.data1 := io.in0
	p.io.math.data2 := io.in1
	io.out := p.io.math.res
		 
	// p.io.in.bits := io.in0 * io.in1
	// io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready

}