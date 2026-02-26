package suan

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

class counterIO(val idxCnt:Int,val idxPrec:Int = 16 ) extends Bundle {
	val idx = new Bundle{
		val limit = Input(Vec(idxCnt, UInt(idxPrec.W)))
		val cnt  = Output(Vec(idxCnt, UInt( idxPrec.W )))
		
		
		val relcnt  = Output(Vec(idxCnt, UInt( idxPrec.W )))
	}
	val out = new ExitIO()
	val in = new EntryIO()

	val done = Output(Bool())
}

//Hard counter
//(todos) soft counter, reconfigurable tiling
//Counter -> DMA
class counter(val idxCnt:Int,val idxPrec:Int,val idxTile:List[Int] ) extends Module {
	
	val io = IO(new counterIO(idxCnt, idxPrec))
	// io.out.bits := io.in.bits


	// val cnt = Reg(Vec(idxCnt, UInt(idxPrec.W)))
	
	val cnt = RegInit(VecInit(Seq.fill(idxCnt)(0.U(idxPrec.W))))
	val relcnt = RegInit(VecInit(Seq.fill(idxCnt)(0.U(idxPrec.W))))
				
	for(idx <- 0 until idxCnt){
		io.idx.cnt(idx) := cnt(idx)
		io.idx.relcnt(idx) := relcnt(idx)
	}
	
	val done = RegInit(0.U(1.W))
	
	val valid = RegInit(0.U(1.W))
	io.done := done.asBool
	
	
	//1cycle module, always ready
	val ready = Wire(UInt(1.W))
	io.in.ready := ready
	ready := io.out.ready
	
	when(io.in.valid && io.in.ready &&  !done){
		io.out.valid := io.in.valid && io.in.ready  && !done
		valid := (io.in.valid && io.in.ready && !done)
	}.otherwise{
		io.out.valid := valid
	}
	
	
	when(io.in.valid && io.in.ready  && !done){
		when(  cnt(0) + idxTile(0).U >=  io.idx.limit(0)    ){
				// cnt(0) := 0.U 
				// relcnt(0) := 0.U
				done := 1.U
		}.otherwise{
				cnt(0) := cnt(0) + idxTile(0).U
				relcnt(0) := relcnt(0) + 1.U
		}
	}.otherwise{
		cnt(0) := cnt(0)
		io.idx.relcnt(0) := relcnt(0)
	}
	

	for(idx <- 1 until idxCnt){
		when( cnt(idx-1) >= io.idx.limit(idx)  ){
			when(  cnt(idx) + idxTile(idx).U >=  io.idx.limit(idx)){
					cnt(idx) := 0.U
					relcnt(idx) := 0.U
			}.otherwise{
					cnt(idx) := cnt(idx) + idxTile(idx).U
					
					relcnt(idx) :=relcnt(idx) + 1.U
			}
		}.otherwise{
			cnt(idx) := cnt(idx)
			relcnt(idx) := relcnt(idx)
		}		
	}
	
	if(idxCnt == 1){
		when(io.in.valid && io.in.ready && !done){
		when(  cnt(0)+ idxTile(0).U >=  io.idx.limit(0)){
				done := 1.U
			}}
		
	}else{
			
		when(cnt(idxCnt-1) >= io.idx.limit(idxCnt-1)){
			when( cnt(idxCnt-1) + idxTile(idxCnt-1).U>= io.idx.limit(idxCnt-1)){
				done := 1.U
			}
		}
	
	}
	
	
	
}


object countertest extends App{
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/suan/counter"),
		Seq(ChiselGeneratorAnnotation(() => new counter( 3, 8, List(2,2,2)  )    )))
	
}

object counter1var_test extends App{
		
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "counter"
	file = file + "/" + mod
	var veri = file + "/" + mod
	
	
	val idxTile = 8
	val idxPrec = 8
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new counter( idxCnt = 1, idxPrec = idxPrec, 
			idxTile = List(idxTile)  )    )))
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v"),
	svtb = """
		
			task automatic FULL();
			begin
				Reset();
				io_in_valid = 1;io_out_ready = 1;
				repeat(15) @(posedge clock);
				assert(io_idx_relcnt_0+1 == io_idx_limit_0/"""+idxTile+""");
			end 
			endtask

			task automatic NOREADY();
			begin
				Reset();
				io_in_valid = 1;io_out_ready = 0;
				repeat(15) @(posedge clock);
				assert(io_idx_relcnt_0 == 0);
			end 
			endtask
			
			
			task automatic READY_STOP_READY();
			begin
				Reset();
				io_in_valid = 1;io_out_ready = 0;
				@(posedge clock); io_out_ready = 1;
				@(posedge clock); io_out_ready = 0;
				repeat(15) @(posedge clock);
				assert(io_idx_relcnt_0 == 1);
			end 
			endtask
			
			task automatic NOVALID();
			begin
				Reset();
				io_in_valid = 1;io_out_ready = 1;
				@(posedge clock); io_in_valid = 0;
				repeat(15) @(posedge clock);
				assert(io_idx_relcnt_0 == 1);
			end 
			endtask
			
			task automatic VALID_STOP_VALID();
			begin
				Reset();
				io_in_valid = 1;io_out_ready = 1;
				@(posedge clock); io_in_valid = 0;
				@(posedge clock); io_in_valid = 1;
				@(posedge clock); io_in_valid = 0;
				repeat(15) @(posedge clock);
				assert(io_idx_relcnt_0 == 2);
			end 
			endtask	
			
			initial begin
				// reset = 0;
				// #10;
				// reset = 1;
				// #10;
				// reset = 0;
				
				// io_idx_limit_0 = 32;io_in_valid = 1;io_out_ready = 1;
				// for(int i = 0; i < io_idx_limit_0 ; i+="""+idxTile+""") begin
				// 	@(posedge clock);
				// 	assert(io_idx_cnt_0 == i);
				// 	assert(io_idx_relcnt_0 == i/"""+idxTile+""");
				// end
				
				io_idx_limit_0 = 32;io_in_valid = 1;io_out_ready = 1;
				
				//1. Normal
				FULL();
				
				//2. No rdu
				NOREADY();
				
				//3. No valid
				NOVALID();
				
				//4. No ready
				NOREADY();
				
				//5. Stop valid stop
				VALID_STOP_VALID();
				
				//6. 
				READY_STOP_READY();
				
			end
	""")
	
}

