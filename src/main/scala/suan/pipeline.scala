package suan

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



class PipelineData(val  prec :Int ) extends Module{
	
	val io = IO(new Bundle{
		val in = Flipped(DecoupledIO(UInt(prec.W)))
		val out = DecoupledIO(UInt(prec.W))
	})
	
	val bits = RegInit(0.U(prec.W))
	val valid = RegInit(0.U(1.W))
	io.out.valid := valid
	io.in.ready := io.out.ready
	io.out.bits := bits
	
	when(io.in.valid && io.in.ready && io.out.ready){
		valid := io.in.valid
		bits := io.in.bits
	}.otherwise{
		when(io.in.valid && io.in.ready &&  !io.out.valid){
			valid := io.in.valid
			bits := io.in.bits
		}
	}
	
}


class PipelineVecData(val  prec :Int, val term:Int ) extends Module{
	
	val io = IO(new Bundle{
		val in = Flipped(DecoupledIO(Vec(term, UInt(prec.W))))
		val out = DecoupledIO(Vec(term, UInt(prec.W)))
	})
	
	val bits = Reg(Vec(term, UInt(prec.W)))
	val valid = RegInit(0.U(1.W))
	io.out.valid := valid
	io.in.ready := io.out.ready
	io.out.bits := bits
	
	// when(io.in.valid && io.in.ready && io.out.ready){
	// 	valid := io.in.valid
	// 	bits := io.in.bits
	// }.otherwise{
	// 	when(io.in.valid && io.in.ready &&  !io.out.valid){
	// 		valid := io.in.valid
	// 		bits := io.in.bits
	// 	}
	// }
	
	
	when(io.in.valid && io.in.ready){
		valid := io.in.valid
		bits := io.in.bits
	}.otherwise{
		when(io.out.ready && io.out.valid){
			valid := io.in.valid
			bits := io.in.bits
		}
	}
	
}

object PipelineDataTest extends App{
	
	val file = "./generated/suan/PipelineData"
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new PipelineData( 
			8
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/PipelineData.tb.sv", svfiles = Seq(file+"/PipelineData.v"), svtb = """
				
			property p1;
			  @(posedge clock)
			  disable iff(reset)
			  io_in_valid && io_out_ready |=> 
					io_in_bits === io_out_bits;
			endproperty
	
			env_p1 : assert property( p1 ) $display("ok") else $display("error property, valid ready not passing");
			
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				
				//Normal
				io_in_bits = 88;
				io_in_valid = 1; 
				io_out_ready = 1;
				
				@(posedge clock);
				#1;
				assert(io_out_bits == io_in_bits);
				assert(io_out_valid == 1);
				#1;
				io_in_bits = 188;
				
				@(posedge clock);
				#1;
				assert(io_out_bits == io_in_bits);
				assert(io_out_valid == 1);
				io_in_valid = 0;
				
				@(posedge clock);
				#1;
				assert(io_out_valid == 0);
				io_in_valid = 1; io_out_ready = 0; io_in_bits = 8;
				
				@(posedge clock);
				#1;
				assert(io_out_bits == 8); assert(io_out_valid == 1);
				assert(io_in_ready == 0);
				
				
				
			end
	""")
	
	
}


object pipelinetest extends App{
	
	val file = "./generated/suan/Pipeline"
	
	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
	// 	  )    )))
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new PipelineChainValid( 
			Map("prec" -> "8" , "depth" -> "3" )
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/PipelineChainValid.tb.sv", svfiles = Seq(file+"/PipelineChainValid.v"), svtb = """
			initial begin
				reset = 0;
		        io_validin = 1;
		        io_out_allow = 1;
		        io_pipe_ready_go_0 = 1;
		        io_pipe_ready_go_1 = 1;
		        io_pipe_ready_go_2 = 1;
				#10;
				reset = 1;
				#10;
				io_datain = 88;
				reset = 0;
				#10;
				io_datain = 77;
				#10;
				io_datain = 66;
				#10;
				io_datain = 55;
				#10;
				#100;
				$finish;
			end
	""")
	
	
}



object pipelinenodata_test extends App{
	
	val file = "./generated/suan/Pipeline"
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new PipelineChainValidNoData( 
			3
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/PipelineChainValidNoData.tb.sv", svfiles = Seq(file+"/PipelineChainValidNoData.v"), 
	
	svtb = """
			
		task automatic fullpass();
		        begin
				repeat(3) @(posedge clock);
				//Full
				io_validin = 1;io_out_allow = 1;
				io_pipe_ready_go_0 = 1;io_pipe_ready_go_1 = 1;io_pipe_ready_go_2 = 1;	

		        end
		    endtask
	
	
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
					
				fullpass();
				
				fullpass();
				io_validin = 0;
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 1);
				assert(io_validout_internal_2 == 1);
				
				fullpass();
				assert(io_validout_internal_0 == 0);
				assert(io_validout_internal_1 == 0);
				assert(io_validout_internal_2 == 0);
				
				
				fullpass();
				io_out_allow = 0;
				
				fullpass();
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 1);
				assert(io_validout_internal_2 == 1);
				
				fullpass();
				io_pipe_ready_go_0 = 0;io_pipe_ready_go_1 = 1;io_pipe_ready_go_2 = 1;
				
				
				fullpass();
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 0);
				assert(io_validout_internal_2 == 0);
				
				fullpass();
				io_pipe_ready_go_0 = 1;io_pipe_ready_go_1 = 0;io_pipe_ready_go_2 = 1;
				
				
				
				fullpass();
				
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 1);
				assert(io_validout_internal_2 == 0);
				
				fullpass();
				io_pipe_ready_go_0 = 1;io_pipe_ready_go_1 = 1;io_pipe_ready_go_2 = 0;
				
				
				fullpass();
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 1);
				assert(io_validout_internal_2 == 1);
				
				
				fullpass();
				io_pipe_ready_go_0 = 0;io_pipe_ready_go_1 = 1;io_pipe_ready_go_2 = 1;
				
				
				fullpass();
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 0);
				assert(io_validout_internal_2 == 0);
				io_pipe_ready_go_0 = 1;io_pipe_ready_go_1 = 1;io_pipe_ready_go_2 = 1;
				repeat(3) @(posedge clock);
				assert(io_validout_internal_0 == 1);
				assert(io_validout_internal_1 == 1);
				assert(io_validout_internal_2 == 1);
				
				
				
				$finish;
			end
	""")
	
	
}

class PipelineChainValidNoData(val  depth :Int ) extends Module{
	
	val io = IO(new Bundle{
		val validin = Input( Bool() )
		val out_allow = Input(  Bool()  )
		val pipe_ready_go = Input(Vec(depth, Bool() ))
		
		val validout = Output( Bool() )
		val data_update = Output(Vec(depth, Bool()))
		val validout_internal = Output( Vec(depth,Bool() ))
		val validin_internal = Output( Vec(depth,Bool() ))
		val pipe_allowin_internal = Output(Vec(depth, Bool()))
		val pipe_allowin = Output(Bool())
	})
	
	
	
	val pipeline = Module(new PipelineChainValid(
		Map("prec" -> "1" , "depth" -> depth.toString )
	  ))

	
	pipeline.io.validin   := io.validin
	pipeline.io.datain    := 1.U
	pipeline.io.out_allow := io.out_allow
	pipeline.io.pipe_ready_go := io.pipe_ready_go
	
	io.validout :=          pipeline.io.validout 
	io.data_update :=       pipeline.io.data_update 
	io.validout_internal := pipeline.io.validout_internal
	io.pipe_allowin :=      pipeline.io.pipe_allowin 
	io.pipe_allowin_internal := pipeline.io.pipe_allowin_internal
	io.validin_internal := pipeline.io.validin_internal
}


class PipelineChainValid( HardwareConfig:Map[String, String] ) extends Module{
	
	val depth:Int = HardwareConfig("depth").toInt
	val prec:Int  = HardwareConfig("prec").toInt //Ratio, terms:1
	
	val io = IO(new Bundle{
		// val validin = Input( Bool() )
		// val out_allow = Input(  Bool()  )
		
		// val validout = Output( Bool() )
		
		val validin = Input( Bool() )
		val datain  = Input( UInt(prec.W))
		val out_allow = Input(  Bool()  )
		
		val validout = Output( Bool() )
		val dataout = Output( UInt(prec.W) )
		
		
		val all_dataout = Output(Vec(depth, UInt(prec.W) ))
		
		val data_update = Output(Vec(depth, Bool()))
		
		val validout_internal = Output( Vec(depth,Bool() ))
		val validin_internal = Output( Vec(depth,Bool() ))
		
		val pipe_allowin_internal = Output(Vec(depth, Bool()))
		val pipe_ready_go = Input(Vec(depth, Bool() ))
		val pipe_allowin = Output(Bool())
		
		
	})
	
	
	val m = Module(new PipelineChain(
		HardwareConfig + ("prec" -> prec.toString)
	))
	
	io.all_dataout := m.io.all_dataout
	m.io.validin := io.validin
	m.io.datain := io.datain
	io.dataout := m.io.dataout
	m.io.out_allow := io.out_allow
	
	io.validout := m.io.validout
	
	m.io.pipe_ready_go := io.pipe_ready_go
	io.pipe_allowin := m.io.pipe_allowin
	
	for(d <- 0 until depth){
		io.data_update(d) :=	m.io.validin_internal(d) & m.io.pipe_allowin_internal(d)
	}
	
	io.validout_internal := m.io.validout_internal
	io.pipe_allowin_internal := m.io.pipe_allowin_internal
	io.validin_internal := m.io.validin_internal
}

class PipelineChain( HardwareConfig:Map[String, String]) extends Module{

	val depth:Int = HardwareConfig("depth").toInt
	val prec:Int  = HardwareConfig("prec").toInt //Ratio, terms:1
	

	val io = IO(new Bundle{
		val validin = Input( Bool() )
		val datain  = Input( UInt(prec.W))
		val out_allow = Input(  Bool()  )
		
		val validout = Output( Bool() )
		val dataout = Output( UInt(prec.W) )
		
		
		val all_dataout = Output(Vec(depth, UInt(prec.W) ))
		
		val validin_internal = Output(Vec(depth, Bool() ))
		val pipe_allowin_internal = Output(Vec(depth, Bool()))
		val validout_internal = Output(Vec(depth, Bool()))
		
		val pipe_ready_go = Input(Vec(depth, Bool() ))
		val pipe_allowin = Output(Bool())
		
		
	})
	
	
    val cur_pea =  Array.fill(depth)( Module(new PipelineUnit(HardwareConfig) )	)  
	
	for(d <- 0 until depth){
		val p = cur_pea(d)
		p.io.pipe1_ready_go := io.pipe_ready_go(d)
	}
	
	val f = cur_pea(0)
	f.io.validin := io.validin
	f.io.datain  := io.datain
	
	io.validin_internal(0) := io.validin
	io.pipe_allowin_internal(0) := io.pipe_allowin
	
	io.pipe_allowin := f.io.pipe_allowin
	
	val w = cur_pea(depth-1)
	w.io.out_allow := io.out_allow
	io.validout := w.io.validout
	io.dataout := w.io.dataout
	
	io.validout_internal(0) := f.io.pipe_valid_reg
	
	for (d <- 0 until depth){
			io.all_dataout(d) := cur_pea(d).io.dataout
	}
	
	for (d <- 1 until depth){
		val p = cur_pea(d-1)
		val pp = cur_pea(d)
		
		io.validout_internal(d) := pp.io.pipe_valid_reg
		
		io.validin_internal(d) := pp.io.validin
		
		io.pipe_allowin_internal(d) := pp.io.pipe_allowin
		
		pp.io.validin := p.io.validout
		pp.io.datain := p.io.dataout

		p.io.out_allow := pp.io.pipe_allowin		
	}
	
	
}


class PipelineUnit( HardwareConfig:Map[String, String]) 
	extends Module{

   val prec:Int  = HardwareConfig("prec").toInt //Ratio, terms:1

	val io = IO(new Bundle{

		val validin = Input(Bool())
		val datain = Input( UInt(prec.W)  )
		val out_allow = Input(    Bool()  )
		
		val validout  = Output(   Bool()  )
		val dataout = Output( UInt(prec.W) )
	
		val pipe1_ready_go = Input(Bool())
		val pipe_allowin = Output(Bool())
	
		val pipe_valid_reg = Output(Bool())
	})
	
	//One pipeline stage
	val pipe_valid = RegInit(false.B)
	val pipe_data = Reg(UInt(prec.W))

	io.pipe_valid_reg := pipe_valid
	
	when(io.pipe_allowin){
		pipe_valid := io.validin
	}
	
	when(io.validin && io.pipe_allowin){
		pipe_data := io.datain
	}
	//pipelining logic
	io.pipe_allowin := !pipe_valid || io.pipe1_ready_go && io.out_allow
	
	//Output
	io.validout := pipe_valid && io.pipe1_ready_go
	io.dataout  := pipe_data
	
	

}