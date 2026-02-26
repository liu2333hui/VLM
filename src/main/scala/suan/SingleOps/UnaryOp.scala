//1变，1元

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

import networks._

import helper.EntryIO
import helper.ExitIO

class FixedPointUnaryIO(val preci:Int, val precf:Int) extends Bundle{
	val data = new FP(preci, precf)
	val res = Flipped( new FP(preci, precf) )
	val out =new  ExitIO()
	val in = new EntryIO()
	
	val debug = new Bundle{
		val data = Output(UInt((preci+precf).W)) //new FP(preci, precf)
	}
}

class UIntUnaryIO(val preci:Int) extends Bundle{
	val data = Input(UInt(preci.W))
	val res = Output(UInt(preci.W))
	val out = new ExitIO()
	val in = new EntryIO()
}

//Operators
class neg_op(val idxTile:Int, val dataPrec:Int ){
	
}

class square_op(){
	
}

class approx_op(val preci:Int = 8, val precf:Int = 8, 
	val MultThroughput:Int = 4, val MultDelay:Int = 4, val stages:Int = 1, 
			val w0 :Double= 1.0,
			val w1 :Double= 1.0/1.0, 
			val w2 :Double= 1.0/2.0,
			val w3 :Double= 1.0/6.0,
			val w4 :Double= 1.0/24 ,
			val w5 :Double= 1.0/120
		) extends Module{
			
			val io = IO(new FixedPointUnaryIO(preci, precf))
			//all less than 1
			val w0f = (w0 * (1<<precf)).toInt.S
			val w1f = (w1 * (1<<precf)).toInt.S
			val w2f = (w2 * (1<<precf)).toInt.S
			val w3f = (w3 * (1<<precf)).toInt.S
			val w4f = (w4 * (1<<precf)).toInt.S
			
			if(stages == 1){
				//X pipeline
				val first_stage = Module(new PipelineData( preci + precf))
			
				//Multiplier
				// val first_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				val first_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
								 
				//First Pipe
				first_stage.io.in.bits := Cat(io.data.i, io.data.f)
				first_stage.io.out.ready := first_mul.io.out.ready
				first_stage.io.in.valid := first_mul.io.in.valid
				
				//First Mul
				first_mul.io.math.data1 := Cat(io.data.i, io.data.f)//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				first_mul.io.math.data2 := w1f//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				first_mul.io.out.ready := io.out.ready
				first_mul.io.in.valid := io.in.valid
				val res3 = Wire(UInt((preci+preci+precf+precf).W))
				val res3i = Wire(UInt((preci).W))
				val res3f = Wire(UInt((precf).W))
				res3 := first_mul.io.math.res + (w0f << precf)
				res3i := res3(preci+precf+precf-1, precf+precf)
				res3f := res3(precf+precf-1, precf)
				
				//top io
				io.in.ready :=  first_mul.io.in.ready
				io.out.valid := first_mul.io.out.valid
				io.res.i := res3i
				io.res.f := res3f
				io.debug.data := first_stage.io.out.bits
				
			} else if(stages == 2){
			
				//X pipeline
				val first_stage = Module(new PipelineData( preci + precf))
				// val second_stage = Module(new PipelineData( preci + precf))
				
				//Multiplier
				// val first_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				// val second_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				// val third_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				
				val first_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				val second_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
									 
				//Pipeline
				first_stage.io.in.bits := Cat(io.data.i, io.data.f)
				first_stage.io.out.ready := first_mul.io.out.ready
				first_stage.io.in.valid := first_mul.io.in.valid
			
				//First Mul
				first_mul.io.math.data1 := Cat(io.data.i, io.data.f)//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				first_mul.io.math.data2 := w2f//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				first_mul.io.out.ready := second_mul.io.in.ready
				first_mul.io.in.valid := io.in.valid
				val res3 = Wire(UInt((preci+preci+precf+precf).W))
				val res3i = Wire(UInt((preci).W))
				val res3f = Wire(UInt((precf).W))
				res3 := first_mul.io.math.res + (w1f << precf)
				res3i := res3(preci+precf+precf-1, precf+precf)
				res3f := res3(precf+precf-1, precf)
				
				//Second Mul
				second_mul.io.math.data1 := Cat(res3i, res3f)//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				second_mul.io.math.data2 := first_stage.io.out.bits//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				second_mul.io.out.ready := io.out.ready
				second_mul.io.in.valid := first_mul.io.out.valid
				val res2 = Wire(UInt((preci+preci+precf+precf).W))
				val res2i = Wire(UInt((preci).W))
				val res2f = Wire(UInt((precf).W))
				res2 := second_mul.io.math.res + (w0f << precf)
				res2i := res2(preci+precf+precf-1, precf+precf)
				res2f := res2(precf+precf-1, precf)
			
				//top io
				io.in.ready := first_mul.io.in.ready
				io.out.valid := second_mul.io.out.valid
				io.res.i := res2i
				io.res.f := res2f
				io.debug.data := first_stage.io.out.bits
			} else if(stages == 3){
			
				//X pipeline
				val first_stage = Module(new PipelineData( preci + precf))
				val second_stage = Module(new PipelineData( preci + precf))
				
				//Multiplier
				// val first_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				// val second_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				// val third_mul = Module(new MultiplierShift(
				// 	Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				
				val first_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				val second_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				val third_mul = Module(new BoothMultiplier(
					 Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
				
				//Pipeline for x variable
				first_stage.io.in.bits := Cat(io.data.i, io.data.f)
				first_stage.io.out.ready := first_mul.io.out.ready
				first_stage.io.in.valid := first_mul.io.in.valid && first_mul.io.in.ready
			
				second_stage.io.in.bits := first_stage.io.out.bits
				second_stage.io.out.ready := second_mul.io.out.ready
				second_stage.io.in.valid := second_mul.io.in.valid && second_mul.io.in.ready
			
				//First Mul
				first_mul.io.math.data1 := Cat(io.data.i, io.data.f).asSInt//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				first_mul.io.math.data2 := w3f//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				first_mul.io.out.ready := second_mul.io.in.ready
				first_mul.io.in.valid := io.in.valid
				val res3 = Wire(SInt((preci+preci+precf+precf).W))
				val res3i = Wire(UInt((preci).W))
				val res3f = Wire(UInt((precf).W))
				res3 := first_mul.io.math.res + (w2f << precf)
				res3i := res3(preci+precf+precf-1, precf+precf)
				res3f := res3(precf+precf-1, precf)
				
				//Second Mul
				second_mul.io.math.data1 := Cat(res3i, res3f).asSInt//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				second_mul.io.math.data2 := first_stage.io.out.bits.asSInt//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				second_mul.io.out.ready := third_mul.io.in.ready
				second_mul.io.in.valid := first_mul.io.out.valid
				val res2 = Wire(SInt((preci+preci+precf+precf).W))
				val res2i = Wire(UInt((preci).W))
				val res2f = Wire(UInt((precf).W))
				res2 := second_mul.io.math.res + (w1f << precf)
				res2i := res2(preci+precf+precf-1, precf+precf)
				res2f := res2(precf+precf-1, precf)
			
				//Third Mul
				third_mul.io.math.data1 := Cat(res2i, res2f).asSInt//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
				third_mul.io.math.data2 := second_stage.io.out.bits.asSInt//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
				third_mul.io.out.ready := io.out.ready
				third_mul.io.in.valid := second_mul.io.out.valid
				val res1 = Wire(SInt((preci+preci+precf+precf).W))
				val res1i = Wire(UInt((preci).W))
				val res1f = Wire(UInt((precf).W))
				res1 := third_mul.io.math.res + (w0f << precf)
				res1i := res1(preci+precf+precf-1, precf+precf)
				res1f := res1(precf+precf-1, precf)
			
			
				//top io
				io.in.ready := first_mul.io.in.ready
				io.out.valid := third_mul.io.out.valid
				io.res.i := res1i
				io.res.f := res1f
				io.debug.data := first_stage.io.out.bits
	}
}

class exp_op(val preci:Int = 8, val precf:Int = 8, 
	val MultThroughput:Int = 4, val MultDelay:Int = 4, val stages:Int = 1) extends Module{
	val io = IO(new FixedPointUnaryIO(preci, precf))
	val w0 = 1.0
	val w1 = 1.0/1.0 
	val w2 = 1.0/2.0
	val w3 = 1.0/6.0
	val w4 = 1.0/24
	val w5 = 1.0/120
	val main = Module(new approx_op(preci, precf, 
		MultThroughput, MultDelay, stages, 
			w0,w1,w2,w3,w4,w5,
		))
	main.io <> io
}

class sin_op(val preci:Int = 8, val precf:Int = 8, 
	val MultThroughput:Int = 4, val MultDelay:Int = 4, val stages:Int = 1) extends Module{
	val io = IO(new FixedPointUnaryIO(preci, precf))
	val w0 = 1.260e-5
	val w1 = 0.9996
	val w2 = 0.002307
	val w3 = -0.1723
	val w4 = 0.006044
	val w5 = 0.005752
	val main = Module(new approx_op(preci, precf, 
		MultThroughput, MultDelay, stages, 
			w0,w1,w2,w3,w4,w5,
		))
	main.io <> io
}
class cos_op(){
	
}

class tanh_op(){
	
}



///For thorughput = 1
object exp_op_test extends App{
	
	val file = "./generated/suan/exp_op"
	
	val PRECI = 8
	val PRECF = 8
	val simtime = 300
	val stages = 3
	
	
	val res = new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new exp_op( 
			MultThroughput = 4 ,MultDelay = 4 ,  preci = PRECI,  precf =PRECF, stages = stages
	  )    )))
	
	//Simulation using vcs or iverilog
	sim.iverilog(simtime = simtime, svtbfile = file+"/exp_op.tb.sv", svfiles = Seq(file+"/exp_op.v"), svtb = """
	
			parameter PRECI = """+PRECI+"""; // 整数位宽
			parameter PRECF = """+PRECF+"""; // 小数位宽
			parameter SCALE = 2 ** PRECF; // 缩放因子 32
			real r_val = 0.20;
			int signed fixed_val; // 定点数结果
			real res;
			
			real testvectors[3];
			initial begin
			testvectors[0] = 0.2;
			testvectors[1] = 0.7;
			testvectors[2] = 0.9;//{0.2, 0.7, 0.9};
			
			end
			
			initial begin
				reset = 0;
				io_in_valid = 0;
				io_out_ready = 1;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				//Case1
				r_val = 0.2;
				fixed_val = $rtoi(r_val * SCALE);
				io_data_i = fixed_val >>> PRECF;
				io_data_f = (fixed_val & ((1 << PRECF) - 1));
				io_in_valid = 1;
				
				
			end
			
			integer test = 0;
			initial begin
			forever begin
				@(negedge clock);          // 1. 等待时钟上升沿
				if (io_out_valid) begin  // 2. 在该时钟周期内检查信
					res = io_res_i +  io_res_f / (real'(SCALE));;
					$display("[%0t] data est valid: result: %f",$realtime, res);
				end
				
				if(io_in_ready == 1 && io_in_valid == 1) begin
					
					r_val = testvectors[test];
					fixed_val = $rtoi(r_val * SCALE);
					io_data_i = fixed_val >>> PRECF;
					io_data_f = (fixed_val & ((1 << PRECF) - 1));
					
					$display($time, " ", io_in_ready, io_in_valid, " ", test);
					$display("%f -> %f", r_val, 2.71**r_val);
					
					test++;
				end
			end
			end

	""")
	
	
}




///For thorughput = 1
object sin_op_test extends App{
	
	val file = "./generated/suan/sin_op"
	
	val PRECI = 8
	val PRECF = 8
	val simtime = 300
	val stages = 3
	
	val res = new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new sin_op( 
			MultThroughput = 4 ,MultDelay = 4 ,  preci = PRECI,  precf =PRECF, stages = stages
	  )    )))
	
	//Simulation using vcs or iverilog
	sim.iverilog(simtime = simtime, svtbfile = file+"/sin_op.tb.sv", svfiles = Seq(file+"/sin_op.v"), svtb = """
	
			parameter PRECI = """+PRECI+"""; // 整数位宽
			parameter PRECF = """+PRECF+"""; // 小数位宽sss
			parameter SCALE = 2 ** PRECF; // 缩放因子 32
			real r_val = 0.20;
			int signed fixed_val; // 定点数结果
			real res;
			
			real testvectors[3];
			initial begin
			testvectors[0] = 0.2;
			testvectors[1] = 3.14/4;
			testvectors[2] = ;//{0.2, 0.7, 0.9};
			
			end
			
			initial begin
				reset = 0;
				io_in_valid = 0;
				io_out_ready = 1;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				//Case1
				r_val = 0.2;
				fixed_val = $rtoi(r_val * SCALE);
				io_data_i = fixed_val >>> PRECF;
				io_data_f = (fixed_val & ((1 << PRECF) - 1));
				io_in_valid = 1;
				
				
			end
			
			integer test = 0;
			initial begin
			forever begin
				@(negedge clock);          // 1. 等待时钟上升沿
				if (io_out_valid) begin  // 2. 在该时钟周期内检查信
					res = io_res_i +  io_res_f / (real'(SCALE));;
					$display("[%0t] data est valid: result: %f",$realtime, res);
				end
				
				if(io_in_ready == 1 && io_in_valid == 1) begin
					
					r_val = testvectors[test];
					fixed_val = $rtoi(r_val * SCALE);
					io_data_i = fixed_val >>> PRECF;
					io_data_f = (fixed_val & ((1 << PRECF) - 1));
					
					$display($time, " ", io_in_ready, io_in_valid, " ", test);
					$display("%f -> %f", r_val, 2.71**r_val);
					
					test++;
				end
			end
			end

	""")
	
	
}





///////////////////////////////////////////////////////////////////////////////



//For testing purposes


//For testing purposes
class counter_address_dma_pp_neg(val addrPrec:Int, val idxPrec:Int, val idxTile:Int,
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
	// val negMod = Module(new neg_op( idxTile,  ))
	
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









object counter_address_dma_pp_neg_test extends App{
		
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
		Seq(ChiselGeneratorAnnotation(() => new counter_address_dma_pp_neg( 
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

