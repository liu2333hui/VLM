//Data preprocessors
//1. get data -> infixed_pretiles
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


//Data preprocessors
//1. get data -> into specific tiles
// bw*malen -> dataPrec*idxTile
class fixed_pre_1var(val idxTile:Int,
	val bw :Int, val maxlen:Int, val dataPrec:Int ) extends Module{
	
	
	val io = IO(new Bundle{
		val in = new Bundle{
			val valid = Input(Bool())
			val ready = Output(Bool())
			val data = Input(UInt((bw*maxlen).W))
		}
			
		val out = new Bundle{
			val valid = Output(Bool())
			val ready = Input(Bool())
			val data = Output(Vec(idxTile, UInt(dataPrec.W)))
		}
	})
	
	//简单!
	val bits = Reg(Vec(idxTile, UInt(dataPrec.W)))
	val valid = RegInit(0.U(1.W))
	io.out.valid := valid
	io.in.ready := io.out.ready
	io.out.data := bits
	
	when(io.out.ready){
		valid := io.in.valid
		// bits := io.in.bits
		
		for(i <- 0 until idxTile){
			bits(i) := io.in.data((i+1)*dataPrec - 1, i*dataPrec)
		}
		
	}.otherwise{
		when(!io.out.valid){
			valid := io.in.valid
			// bits := io.in.bits
			
		for(i <- 0 until idxTile){
			bits(i) := io.in.data((i+1)*dataPrec - 1, i*dataPrec)
		}
			
		}
	}
	
	
}















//For testing purposes
class counter_address_dma_pp1var(val addrPrec:Int, val idxPrec:Int, val idxTile:Int,
	val bw :Int, val maxlen:Int, val dataPrec:Int ) extends Module{
	
	val io = IO(new Bundle{
		//Counter
		val idx = new Bundle{
			val limit = Input(Vec(1, UInt(idxPrec.W)))
			val rellimit = Input(Vec(1, UInt(idxPrec.W)))
		}	
		val addr = Output( UInt(addrPrec.W) )
	
		//IO
		val in = new EntryIO()
		// val out = new ExitIO()
		
		val done = Output(Bool())
		
		//DMA
		val L2 = Flipped(new dramIO(bw = bw, addrPrec = addrPrec))
		val out = new Bundle{
			val valid = Output(Bool())
			val ready = Input(Bool())
			val data = Output(UInt((bw*maxlen).W))
			val ppdata = Output(Vec(idxTile, UInt(dataPrec.W)))
			
		}
	})
	
	//Modules
	val cntMod = Module(new counter( idxCnt = 1, idxPrec = idxPrec, idxTile = List(idxTile) ))	
	val addrMod = Module(new address1var( addrPrec = addrPrec, idxPrec = idxPrec  ) )
	val dmaMod =  Module(new  mmu1var(bw = bw, addrPrec = addrPrec, maxlen = maxlen))
	val ppMod = Module (new fixed_pre_1var(idxTile, bw, maxlen, dataPrec ) )
	
	//counter
	cntMod.io.idx.limit := io.idx.limit
	cntMod.io.out.ready := addrMod.io.in.ready //RegNext(pipeline.io.pipe_allowin_internal(0))
	cntMod.io.in.valid  := io.in.valid//pipeline.io.validout_internal(0)  
	
	//address
	addrMod.io.idx.rellimit := io.idx.rellimit
	addrMod.io.idx.relcnt   := cntMod.io.idx.relcnt
	addrMod.io.out.ready    := dmaMod.io.AGU.ready //RegNext(pipeline.io.pipe_allowin_internal(1))
	addrMod.io.in.valid     := cntMod.io.out.valid

	//dma read var 1
	dmaMod.io.L2 <> io.L2
	dmaMod.io.AGU.valid := addrMod.io.out.valid
	dmaMod.io.AGU.addr  := (addrMod.io.addr * ((idxTile * dataPrec)/bw).U )
	dmaMod.io.AGU.arlen := ((idxTile * dataPrec)/bw).U 
	dmaMod.io.OUT.ready := ppMod.io.in.ready
	
	//PP
	ppMod.io.in.data   := dmaMod.io.OUT.data
	ppMod.io.in.valid  := dmaMod.io.OUT.valid
	ppMod.io.out.ready := io.out.ready
	
	//io
	io.in.ready := cntMod.io.in.ready
	io.out.valid := ppMod.io.out.valid//dmaMod.io.OUT.valid
	io.addr := addrMod.io.addr
	io.done := cntMod.io.done
	io.out.data := dmaMod.io.OUT.data
	io.out.ppdata := ppMod.io.out.data
	
	
}









object counter_address_dma_pp1var_test extends App{
		
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "counter_address_dma_pp1var"
	file = file + "/" + mod
	var veri = file + "/" + mod
	var dram = file + "/" + "DRAMModel"
	
	
	val idxTile = 8
	val idxPrec = 8
	val dataPrec = 8
	val maxlen = 8
	val bw = 32
	val addrPrec = 8

	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new counter_address_dma_pp1var( 
			addrPrec = addrPrec, idxPrec = idxPrec, idxTile=idxTile ,
				bw = bw, maxlen = maxlen, dataPrec = dataPrec,
			 )    )))
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  DRAMModel(
			bw = bw, addrPrec = addrPrec, depth = 16000,
				readDelay = 2, writeDelay = 2
		)  )) )
	
	
		
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v", dram+".v"),
		extra_top_instance = Seq(1), 
	svtb = """			
			initial begin
				for(int i = 0; i < 1000; i++) begin
					DRAMModel1.lut[i] = $urandom;	
				end
			end
			
			
			task automatic RESET();
			        begin
							io_in_valid = 0;io_out_ready = 0;
							io_in_valid = 0;
							reset = 0;
							#10;
							reset = 1;
							#10;
							reset = 0;
							
			        end
			    endtask
					
					task automatic TEST0();
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge io_done);
								// assert(io_addr == i);
								#55;
					        end
					    endtask
					
					
					task automatic TEST1(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								// @(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 0;io_out_ready = 0;
								repeat (15) @(posedge clock);
								assert(io_addr == i);
								#5;
					        end
					    endtask

					task automatic TEST2(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								repeat (15) @(posedge clock);
								if(i+1 >= 3)begin
									assert(io_addr == 3);
								end else begin
								assert(io_addr == i+1);
								end
								#5;
					        end
					    endtask

					task automatic TEST3(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								// @(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 1;
								@(posedge io_done);
								assert(io_addr == 3);
								// @(posedge clock);
								#5;
							end
					    endtask
	
					task automatic TEST4(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								//@(posedge io_done);
								if(i+1>=3) assert(io_addr == 3);
								else assert(io_addr == i+1);
								#5;
								// @(posedge clock);
							end
					    endtask
														
														
			integer testcase;										
			initial begin
				io_idx_limit_0 = 128;io_idx_rellimit_0 = io_idx_limit_0/"""+idxTile+""";
				testcase = 1;
				RESET();
				//Normal
				TEST0();
				
				//Delayed by downstream
				RESET();
				TEST2(0);
				
				// for(int i = 1; i <= 3 ; i ++)begin
				// 	RESET();
				// 	TEST1(i);
				// 	testcase += 1;
				// end
				
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST2(i);
	// 				testcase += 1;
	// 			end					
	
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST3(i);
	// 				testcase += 1;
	// 			end	
									
									
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST4(i);
	// 				testcase += 1;
	// 			end										
			end
	""")
	
}


