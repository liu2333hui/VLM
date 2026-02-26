//i,j,k -> i + w1*(j + w2*k)
//indices -> 流水线层
//p
package suan

import chisel3._
import chisel3.util._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.sys.process._
//counter弄一个real_cnt, compress_cnt
import helper._
class addressio(val idxCnt:Int , val idxPrec:Int, val addrPrec:Int) extends Bundle {
	
	val idx = new Bundle{
		val rellimit = Input(Vec(idxCnt, UInt(idxPrec.W)))
		val relcnt = Input(Vec(idxCnt, UInt(idxPrec.W)))
	}
	val addr = Output( UInt(addrPrec.W) )

	val out = new ExitIO()
	val in = new EntryIO()
	
}

class address1var( val addrPrec:Int, val idxPrec:Int)extends Module{
	
		val io = IO(
			new addressio( idxCnt=1, idxPrec , addrPrec )
		)
		
		io.in.ready := io.out.ready
		io.out.valid := 0.B
		val addr = Reg(UInt(idxPrec.W))
		when(io.out.ready){
			addr := io.idx.relcnt(0)
		}.otherwise{
			addr := addr
		}
		io.addr := addr
		
		// when(io.in.valid && io.in.ready){
			// io.addr := RegNext(io.idx.relcnt(0))
		val valid = RegInit(0.U(1.W))
		valid := io.in.valid
			io.out.valid := valid
		// }
		
}


//For testing purposes
class counter_address1var(val addrPrec:Int, val idxPrec:Int, val idxTile:Int ) extends Module{
	
	val io = IO(new Bundle{
		val idx = new Bundle{
			val limit = Input(Vec(1, UInt(idxPrec.W)))
			val rellimit = Input(Vec(1, UInt(idxPrec.W)))
		}
		
		val addr = Output( UInt(addrPrec.W) )
	
		val in = new EntryIO()
		val out = new ExitIO()
		
		val done = Output(Bool())
	})
	
	//Modules
	val addrMod = Module(new address1var( addrPrec = 8, idxPrec = 8  ) )
	val cntMod = Module(new counter( idxCnt = 1, idxPrec = idxPrec, idxTile = List(idxTile) ))
	
	//Pipeline
	// new PipelineChainValid( Map("prec" -> "1", "depth" -> "3" ))
	// val pipeline = Module(new PipelineChainValidNoData(depth=2) )
	
	//pipeline
	// pipeline.io.validin   := io.in.valid
	// pipeline.io.out_allow := io.out.ready
	// pipeline.io.pipe_ready_go(0) := cntMod.io.in.ready && io.in.valid
	// pipeline.io.pipe_ready_go(1) := addrMod.io.in.ready && cntMod.io.out.valid
	
	//io
	io.in.ready := cntMod.io.in.ready
	io.out.valid := addrMod.io.out.valid
	io.addr := addrMod.io.addr
	io.done := cntMod.io.done
	
	
	//counter
	cntMod.io.idx.limit := io.idx.limit
	cntMod.io.out.ready := addrMod.io.in.ready //RegNext(pipeline.io.pipe_allowin_internal(0))
	cntMod.io.in.valid  := io.in.valid//pipeline.io.validout_internal(0)  
	
	//address
	addrMod.io.idx.rellimit := io.idx.rellimit
	addrMod.io.idx.relcnt   := cntMod.io.idx.relcnt
	addrMod.io.out.ready    := io.out.ready  //RegNext(pipeline.io.pipe_allowin_internal(1))
	addrMod.io.in.valid     := cntMod.io.out.valid
	
	// //counter
	// cntMod.io.idx.limit := (io.idx.limit)
	// cntMod.io.out.ready := (addrMod.io.in.ready)
	// cntMod.io.in.valid  := (io.in.valid)

	// //address
	// addrMod.io.idx.rellimit := io.idx.rellimit
	// addrMod.io.idx.relcnt   := cntMod.io.idx.relcnt
	// addrMod.io.out.ready    := RegNext(io.out.ready)
	// addrMod.io.in.valid     := RegNext(cntMod.io.out.valid)


}

object counter_address1var_test extends App{
		
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "counter_address1var"
	file = file + "/" + mod
	var veri = file + "/" + mod
	
	
	val idxTile = 8
	val idxPrec = 8

	
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new counter_address1var( addrPrec = 8, idxPrec = 8, idxTile=8  )    )))
	
		
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v"),
	svtb = """
		
			
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
		
					task automatic TEST1(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								// @(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 0;io_out_ready = 0;
								repeat (5) @(posedge clock);
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
								repeat (5) @(posedge clock);
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
				io_idx_limit_0 = 32;io_idx_rellimit_0 = 32/"""+idxTile+""";
				testcase = 1;
				for(int i = 1; i <= 3 ; i ++)begin
					RESET();
					TEST1(i);
					testcase += 1;
				end
				
				for(int i = 1; i <= 3 ; i ++)begin
					RESET();
					TEST2(i);
					testcase += 1;
				end					
	
				for(int i = 1; i <= 3 ; i ++)begin
					RESET();
					TEST3(i);
					testcase += 1;
				end	
									
									
				for(int i = 1; i <= 3 ; i ++)begin
					RESET();
					TEST4(i);
					testcase += 1;
				end										
			end
	""")
	
}



class address(   val idxCnt:Int , val addrPrec:Int, val idxPrec:Int =8, 
	val MultThroughput:Int =1, val MultDelay:Int =4, val MultPrec1:Int =8, val MultPrec2:Int =8)  extends Module {
	
	val io = IO(
		new addressio( idxCnt, idxPrec , addrPrec )
	)
	
	val mult = Array.fill( idxCnt) (  Module(new MultiplierShift( MultThroughput ,MultDelay ,  MultPrec1 ,  MultPrec2 )) )
		
	val addr_res = Reg(Vec(idxCnt, UInt(addrPrec.W) ))
	
	addr_res(0) := 0.U
	mult(0).io.math.data1 := RegNext(io.idx.relcnt(idxCnt-1-0)(MultPrec1-1,0)   )
	mult(0).io.math.data2 := RegNext(io.idx.rellimit(idxCnt-1-0)(MultPrec2-1,0) )
	mult(0).io.out.ready := RegNext(io.out.ready )
	mult(0).io.in.valid  := RegNext(io.in.valid  )
	// mult(0).io.in.bits := 1.B
	
	for(i <- 1 until idxCnt){
		addr_res(i) := mult(i).io.math.res + addr_res(i-1) 
		mult(i).io.math.data1 := RegNext(io.idx.relcnt(idxCnt-1-i)(MultPrec1-1,0)   )
		mult(i).io.math.data2 := RegNext(io.idx.rellimit(idxCnt-1-i)(MultPrec2-1,0) ) 
		mult(i).io.out.ready := RegNext(mult(i-1).io.in.ready )
		mult(i).io.in.valid  := RegNext(mult(i-1).io.out.valid)
		// mult(i).io.in.bits := 1.B
	}
	
	io.addr := RegNext(addr_res(idxCnt-1))
	
	io.in.ready  := RegNext(mult(0).io.in.ready        )
 	io.out.valid := RegNext(mult(idxCnt-1).io.out.valid)
	
}


