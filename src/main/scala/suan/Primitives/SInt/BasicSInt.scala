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

import suan.PipelineData


class SIntBasicSquare(HardwareConfig : Map[String, String]) extends SIntIn1Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 * io.in0
	io.out := p.io.out.bits
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready

}


class SIntBasicMultiplier(HardwareConfig : Map[String, String]) extends SIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 * io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class SIntBasicAdder(HardwareConfig : Map[String, String]) extends SIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 + io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class SIntBasicSubtract(HardwareConfig : Map[String, String]) extends SIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 - io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class SIntBasicDivider(HardwareConfig : Map[String, String]) extends SIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 / io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}


class SIntBasicAdderTree(HardwareConfig: Map[String, String]) extends SIntInNOut1(HardwareConfig){

	val p = Module(new PipelineData( prec = prec_out ))
	
	val ins = List.fill(terms)( Wire( SInt(prec1.W) ) )
	for(t <- 0 until terms){
		ins(t) := io.in0(t)
	}
	p.io.in.bits := ins.reduce(_ + _)
	// p.io.in.bits := io.in0 / io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
	
}