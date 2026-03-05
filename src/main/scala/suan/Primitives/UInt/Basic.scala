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

//UInt units
class UIntBasicSquare(HardwareConfig : Map[String, String]) extends UIntIn1Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 * io.in0
	io.out := p.io.out.bits
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready

}


class UIntBasicMultiplier(HardwareConfig : Map[String, String]) extends UIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 * io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class UIntBasicAdder(HardwareConfig : Map[String, String]) extends UIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 + io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class UIntBasicSubtract(HardwareConfig : Map[String, String]) extends UIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 - io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}

class UIntBasicDivider(HardwareConfig : Map[String, String]) extends UIntIn2Out1(HardwareConfig){
	val p = Module(new PipelineData( prec = prec_out ))
	p.io.in.bits := io.in0 / io.in1
	io.out := p.io.out.bits
	
	p.io.in.valid := io.entry.valid 
	io.entry.ready := p.io.in.ready
	
	io.exit.valid := p.io.out.valid
	p.io.out.ready := io.exit.ready
}



 object UIntBasicMultiplierTest extends App{
 	val file = "./generaced/Primitive/UIntBasicMultiplier"
 	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 		Seq(ChiselGeneratorAnnotation(() => 
			PrimitiveFactory.CreateUIntIn2Out1("UIntBasicMultiplier", Map(  "prec1" -> "8",  
			"prec2" -> "8",
			"prec_out" -> "8"  ))
		)))	
 	//Simulation using vcs or iverilog
 	sim.iverilog(svtbfile = file+"/UIntBasicMultiplier.tb.sv", svfiles = Seq(file+"/UIntBasicMultiplier.v"), svtb = """
 			initial begin
				Reset();
				for(int j = 0; j <= 9; j++)begin
				for(int i = 0; i <= 9; i++)begin
					io_in0 = i; io_in1 = j; 
					io_entry_valid = 1; 
					io_exit_ready = 1;
					@(posedge clock);
					#1;
					assert(io_in0*io_in1 == io_out);
				end
				end
 			end
 	""")
 }
 

 object UIntBasicSquareTest extends App{
 	val file = "./generaced/Primitive/UIntBasicSquare"
 	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 		Seq(ChiselGeneratorAnnotation(() => 
			PrimitiveFactory.CreateUIntIn1Out1("UIntBasicSquare", Map(  "prec1" -> "8",  "prec_out" -> "8"  ))
		)))	
 	//Simulation using vcs or iverilog
 	sim.iverilog(svtbfile = file+"/UIntBasicSquare.tb.sv", svfiles = Seq(file+"/UIntBasicSquare.v"), svtb = """
 			initial begin
				Reset();
				for(int i = 0; i <= 9; i++)begin
					io_in0 = i;
					io_entry_valid = 1; 
					io_exit_ready = 1;
					@(posedge clock);
					#1;
					assert(io_in0*io_in0 == io_out);
				end
 			end
 	""")
 }
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 