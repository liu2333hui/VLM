// // //Polynomial based (pipelined)
// // //1. Cycle, 1 mult + 1 add, re-use
// // //Pipelined, multiple mult + multiple add, similar to address generator

// // //i,j,k -> i + w1*(j + w2*k)
// // //indices -> 流水线层
// // //p
// // Cosine + Sine (for RotEmbed)
// // Use similar to exponent methods
// package suan

// import chisel3._
// import chisel3.util._

// import chisel3._
// import chisel3.stage.ChiselGeneratorAnnotation
// import chisel3.experimental._
// import chisel3.util._
	
// import java.io.PrintWriter
// import scala.sys.process._

// import suan._
// import helper._


// class FP(val preci:Int, val precf:Int) extends Bundle {
// 	val i = Input(UInt(preci.W) )
// 	val f = Input(UInt(precf.W) )
// }

// class SingleOpIO(val preci:Int, val precf:Int) extends Bundle{
// 	val data = new FP(preci, precf)
// 	val res = Flipped( new FP(preci, precf) )
// 	val out = Decoupled(Bool())
// 	val in = Flipped(Decoupled(Bool()))
// }


// class BasicExp(val preci:Int = 8, val precf:Int = 8, val MultThroughput:Int = 4, val MultDelay:Int = 4 ) extends Module {
	
// 	val io = IO(new SingleOpIO(preci, precf))
	
// 	// val w0 = 1.260e-5
// 	// val w1 = 0.9996
// 	// val w2 = 0.002307
// 	// val w3 = -0.1723
// 	// val w4 = 0.006044
// 	// val w5 = 0.005752
	
// 	val w0 = 1.0 - 0.005
// 	val w1 = 1.0/1.0 - 0.005
// 	val w2 = 1.0/2.0
// 	val w3 = 1.0/6.0
// 	val w4 = 1.0/24
// 	val w5 = 1.0/120
    
// 	//all less than 1
// 	val w0f = (w0 * (1<<precf)).toInt.U
// 	val w1f = (w1 * (1<<precf)).toInt.U
// 	val w2f = (w2 * (1<<precf)).toInt.U
// 	val w3f = (w3 * (1<<precf)).toInt.U
// 	val w4f = (w4 * (1<<precf)).toInt.U
// 	// val w0i = (w0).toInt.U
// 	// val w1i = (w1).toInt.U
// 	// val w2i = (w2).toInt.U
// 	// val w3i = (w3).toInt.U
// 	// val w4i = (w4).toInt.U
	
	
// 	val mult1 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = precf,  Prec2 = preci+precf))
// 	io.out.bits := 1.B
// 	io.in.ready := mult1.io.in.ready
// 	mult1.io.in.bits := 1.B
// 	mult1.io.in.valid := io.in.valid
// 	mult1.io.out.ready := 1.U
// 	io.out.valid := mult1.io.out.valid
	
// 	mult1.io.math.data1 :=  w1f
// 	mult1.io.math.data2 := Cat(io.data.i, io.data.f)
	
// 	val res = Wire(UInt((preci+precf+precf).W))
// 	res := mult1.io.math.res + (w0f << precf)
// 	io.res.i := res(preci+precf+precf-1, precf+precf)
// 	io.res.f := res(precf+precf-1, precf)
	
// }

// //2 Stage Exponent Pipeline
// class BasicExp2(val preci:Int = 8, val precf:Int = 8, val MultThroughput:Int = 4, val MultDelay:Int = 4 ) extends Module {
	
// 	val io = IO(new SingleOpIO(preci, precf))
	
// 	// val w0 = 1.260e-5
// 	// val w1 = 0.9996
// 	// val w2 = 0.002307
// 	// val w3 = -0.1723
// 	// val w4 = 0.006044
// 	// val w5 = 0.005752
	
// 	val w0 = 1.0 - 0.005
// 	val w1 = 1.0/1.0 - 0.005
// 	val w2 = 1.0/2.0
// 	val w3 = 1.0/6.0
// 	val w4 = 1.0/24
// 	val w5 = 1.0/120
    
// 	//all less than 1
// 	val w0f = (w0 * (1<<precf)).toInt.U
// 	val w1f = (w1 * (1<<precf)).toInt.U
// 	val w2f = (w2 * (1<<precf)).toInt.U
// 	val w3f = (w3 * (1<<precf)).toInt.U
// 	val w4f = (w4 * (1<<precf)).toInt.U
// 	// val w0i = (w0).toInt.U
// 	// val w1i = (w1).toInt.U
// 	// val w2i = (w2).toInt.U
// 	// val w3i = (w3).toInt.U
// 	// val w4i = (w4).toInt.U
	
	
// 	//Multiplier
// 	val mult2 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
// 	val mult1 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))

// 	//Datapath
// 	mult2.io.math.data1 := Cat(io.data.i, io.data.f)
// 	mult2.io.math.data2 := w2f//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
// 	val res2 = Wire(UInt((preci+preci+precf+precf).W))
// 	val res2i = Wire(UInt((preci).W))
// 	val res2f = Wire(UInt((precf).W))
	
// 	res2 := mult2.io.math.res + (w1f << precf)
// 	res2i := res2(preci+precf+precf-1, precf+precf)
// 	res2f := res2(precf+precf-1, precf)
	
// 	//Data
// 	mult1.io.math.data1 :=  RegNext(Cat(io.data.i, io.data.f))
// 	mult1.io.math.data2 := RegNext(Cat(res2i, res2f))//Cat(io.data.i, io.data.f)
// 	val res1 = Wire(UInt((preci+preci+precf+precf).W))
// 	res1 := mult1.io.math.res + (w0f << precf)
// 	val res1i = Wire(UInt((preci).W))
// 	val res1f = Wire(UInt((precf).W))
// 	res1i := res1(preci+precf+precf-1, precf+precf)
// 	res1f := res1(precf+precf-1, precf)
// 	io.res.i := res1i
// 	io.res.f := res1f
	
// 	//Pipeline
// 	io.in.ready := mult2.io.in.ready
// 	mult2.io.in.valid := io.in.valid
// 	mult2.io.out.ready := mult1.io.in.ready
	
// 	mult1.io.in.valid := mult2.io.out.valid
// 	mult1.io.out.ready := io.out.ready
// 	io.out.valid := mult1.io.out.valid
	


// 	//Extra
// 	io.out.bits := 1.B
// 	mult1.io.in.bits := 1.B
// 	mult2.io.in.bits := 1.B	
// }

																	
// //2 Stage Exponent Pipeline
// class BasicExp3(val preci:Int = 8, val precf:Int = 8, val MultThroughput:Int = 4, val MultDelay:Int = 4 ) extends Module {
	
// 	val io = IO(new SingleOpIO(preci, precf))
	
// 	// val w0 = 1.260e-5
// 	// val w1 = 0.9996
// 	// val w2 = 0.002307
// 	// val w3 = -0.1723
// 	// val w4 = 0.006044
// 	// val w5 = 0.005752
	
// 	val w0 = 1.0
// 	val w1 = 1.0/1.0 
// 	val w2 = 1.0/2.0
// 	val w3 = 1.0/6.0
// 	val w4 = 1.0/24
// 	val w5 = 1.0/120
    
// 	//all less than 1
// 	val w0f = (w0 * (1<<precf)).toInt.U
// 	val w1f = (w1 * (1<<precf)).toInt.U
// 	val w2f = (w2 * (1<<precf)).toInt.U
// 	val w3f = (w3 * (1<<precf)).toInt.U
// 	val w4f = (w4 * (1<<precf)).toInt.U
// 	// val w0i = (w0).toInt.U
// 	// val w1i = (w1).toInt.U
// 	// val w2i = (w2).toInt.U
// 	// val w3i = (w3).toInt.U
// 	// val w4i = (w4).toInt.U
	
// 	//Multiplier
// 	val mult3 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
// 	val mult2 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))
// 	val mult1 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = preci+precf,  Prec2 = preci+precf))

// 	//Pipelined Variables
// 	val x = Module(new PipelineChainValid(
// 		Map("prec" -> (preci+precf).toString , "depth" -> (3*MultDelay).toString )
// 	  ) )
// 	x.io.validin := io.in.valid
// 	x.io.out_allow := io.out.ready
	
// 	for(d <- 1 until MultDelay){
// 		x.io.pipe_ready_go(d) := 1.U//mult3.io.out.valid
// 		x.io.pipe_ready_go(d+MultDelay) := 1.U//mult3.io.out.valid
// 		x.io.pipe_ready_go(d+MultDelay+MultDelay) := 1.U//mult3.io.out.valid
// 	}
// 	x.io.pipe_ready_go(0) := io.in.valid
// 	x.io.pipe_ready_go(MultDelay) := mult3.io.out.valid
// 	x.io.pipe_ready_go(2*MultDelay) := mult2.io.out.valid
// 	x.io.datain := Cat(io.data.i, io.data.f)
	
	
// 	//Datapath
// 	mult3.io.math.data1 := Cat(io.data.i, io.data.f)//x.io.all_dataout(0)//Cat(io.data.i, io.data.f)
// 	mult3.io.math.data2 := w3f//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
// 	val res3 = Wire(UInt((preci+preci+precf+precf).W))
// 	val res3i = Wire(UInt((preci).W))
// 	val res3f = Wire(UInt((precf).W))
	
// 	res3 := mult3.io.math.res + (w2f << precf)
// 	res3i := res3(preci+precf+precf-1, precf+precf)
// 	res3f := res3(precf+precf-1, precf)
	
// 	//Datapath
// 	mult2.io.math.data1 := x.io.all_dataout(MultDelay-1)//RegNext(Cat(io.data.i, io.data.f))//x.io.data_update(0)//
// 	mult2.io.math.data2 := (Cat(res3i, res3f))//Cat(res2i, res2f)//Cat(io.data.i, io.data.f)
// 	val res2 = Wire(UInt((preci+preci+precf+precf).W))
// 	val res2i = Wire(UInt((preci).W))
// 	val res2f = Wire(UInt((precf).W))
// 	res2 := mult2.io.math.res + (w1f << precf)
// 	res2i := res2(preci+precf+precf-1, precf+precf)
// 	res2f := res2(precf+precf-1, precf)
	
// 	//Datapath
// 	mult1.io.math.data1 := x.io.all_dataout(2*MultDelay-1)//RegNext(RegNext(Cat(io.data.i, io.data.f)))//x.io.data_update(1)//
// 	mult1.io.math.data2 := (Cat(res2i, res2f))//Cat(io.data.i, io.data.f)
// 	val res1 = Wire(UInt((preci+preci+precf+precf).W))
// 	res1 := mult1.io.math.res + (w0f << precf)
// 	val res1i = Wire(UInt((preci).W))
// 	val res1f = Wire(UInt((precf).W))
// 	res1i := res1(preci+precf+precf-1, precf+precf)
// 	res1f := res1(precf+precf-1, precf)
// 	io.res.i := res1i
// 	io.res.f := res1f
	
// 	//Pipeline
// 	io.in.ready := mult3.io.in.ready
// 	mult3.io.in.valid := io.in.valid
// 	mult3.io.out.ready := mult2.io.in.ready
	
// 	mult2.io.in.valid := mult3.io.out.valid
// 	mult2.io.out.ready := mult1.io.in.ready
	
// 	mult1.io.in.valid := mult2.io.out.valid
// 	mult1.io.out.ready := io.out.ready
// 	io.out.valid := mult1.io.out.valid
	


// 	//Extra
// 	io.out.bits := 1.B
// 	mult1.io.in.bits := 1.B
// 	mult2.io.in.bits := 1.B	
// 	mult3.io.in.bits := 1.B	
// }


// ///For thorughput = 1
// object BasicExpTest extends App{
	
// 	val file = "./generated/suan/BasicExp"
	
// 	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
// 	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
// 	// 	  )    )))
// 	val PRECI = 8
// 	val PRECF = 8
// 	val simtime = 300
	
// 	val res = new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 		Seq(ChiselGeneratorAnnotation(() => new BasicExp3( 
// 			MultThroughput = 4 ,MultDelay = 4 ,  preci = PRECI,  precf =PRECF
// 	  )    )))
		  
// 	// println(res(0))
	
// 	//Simulation using vcs or iverilog
// 	sim.iverilog(simtime = simtime, svtbfile = file+"/BasicExp.tb.sv", svfiles = Seq(file+"/BasicExp3.v"), svtb = """
	
// 			parameter PRECI = """+PRECI+"""; // 整数位宽
// 			parameter PRECF = """+PRECF+"""; // 小数位宽
// 			parameter SCALE = 2 ** PRECF; // 缩放因子 32
// 			real r_val = 0.20;
// 			int signed fixed_val; // 定点数结果
// 			real res;
			
// 			real testvectors[3];
// 			initial begin
// 			testvectors[0] = 0.2;
// 			testvectors[1] = 0.7;
// 			testvectors[2] = 0.9;//{0.2, 0.7, 0.9};
			
// 			end
			
// 			initial begin
// 				reset = 0;
// 				io_in_valid = 0;
// 				io_out_ready = 1;
// 				#10;
// 				reset = 1;
// 				#10;
// 				reset = 0;
				
// 				//Case1
// 				r_val = 0.2;
// 				fixed_val = $rtoi(r_val * SCALE);
// 				io_data_i = fixed_val >>> PRECF;
// 				io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 				io_in_valid = 1;
				
				
// 				// @(posedge clock) if(io_in_ready == 1)
// 				// #1;				
// 				// r_val = 0.7;
// 				// fixed_val = $rtoi(r_val * SCALE);
// 				// io_data_i = fixed_val >>> PRECF;
// 				// io_data_f = (fixed_val & ((1 << PRECF) - 1));	
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready == 1)
// 				// #1;				
// 				// r_val = 0.9;
// 				// fixed_val = $rtoi(r_val * SCALE);
// 				// io_data_i = fixed_val >>> PRECF;
// 				// io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready)
// 				// #1;
// 				// io_in_valid = 1;
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready)
// 				// #1;
// 				// io_in_valid = 0;
// 				// $display($time);
// 				// //#300;			
// 				// //$finish;
// 			end
			
// 			integer test = 0;
// 			initial begin
// 			forever begin
// 				@(negedge clock);          // 1. 等待时钟上升沿
// 				if (io_out_valid) begin  // 2. 在该时钟周期内检查信号是否有效
// 					// 3. 如果有效，执行操作（例如读取数据）
// 					res = io_res_i +  io_res_f / (real'(SCALE));;
// 					// #9;
// 					// $display("result: %f", res);
// 					$display("[%0t] data est valid: result: %f",$realtime, res);
// 				end
				
// 				if(io_in_ready == 1 && io_in_valid == 1) begin
// 					$display($time, " ", io_in_ready, " ", test);
// 					r_val = testvectors[test];
// 					fixed_val = $rtoi(r_val * SCALE);
// 					io_data_i = fixed_val >>> PRECF;
// 					io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 					test++;
// 				end
// 			end
// 			end

// 			// //Maximum limit
// 			// initial begin
// 			// 	#100000;
// 			// 	res = io_res_i +  io_res_f / (real'(SCALE));;
// 			// 	$display("result: %f", res);
// 			// 	$finish;
// 			// end
// 	""")
	
	
// }



// ///For Throughput > 1
// object BasicExpTest2 extends App{
	
// 	val file = "./generated/suan/BasicExp"
	
// 	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
// 	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
// 	// 	  )    )))
// 	val PRECI = 8
// 	val PRECF = 8
// 	val simtime = 300
	
// 	val res = new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 		Seq(ChiselGeneratorAnnotation(() => new BasicExp3( 
// 			MultThroughput = 4 ,MultDelay = 4 ,  preci = PRECI,  precf =PRECF
// 	  )    )))
		  
// 	// println(res(0))
	
// 	//Simulation using vcs or iverilog
// 	sim.iverilog(simtime = simtime, svtbfile = file+"/BasicExp.tb.sv", svfiles = Seq(file+"/BasicExp3.v"), svtb = """
	
// 			parameter PRECI = """+PRECI+"""; // 整数位宽
// 			parameter PRECF = """+PRECF+"""; // 小数位宽
// 			parameter SCALE = 2 ** PRECF; // 缩放因子 32
// 			real r_val = 0.20;
// 			int signed fixed_val; // 定点数结果
// 			real res;
			
// 			real testvectors[3];
// 			initial begin
// 			testvectors[0] = 0.2;
// 			testvectors[1] = 0.7;
// 			testvectors[2] = 0.9;//{0.2, 0.7, 0.9};
			
// 			end
			
// 			initial begin
// 				reset = 0;
// 				io_in_valid = 0;
// 				io_out_ready = 1;
// 				#10;
// 				reset = 1;
// 				#10;
// 				reset = 0;
				
// 				//Case1
// 				r_val = 0.2;
// 				fixed_val = $rtoi(r_val * SCALE);
// 				io_data_i = fixed_val >>> PRECF;
// 				io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 				io_in_valid = 1;
				
				
// 				// @(posedge clock) if(io_in_ready == 1)
// 				// #1;				
// 				// r_val = 0.7;
// 				// fixed_val = $rtoi(r_val * SCALE);
// 				// io_data_i = fixed_val >>> PRECF;
// 				// io_data_f = (fixed_val & ((1 << PRECF) - 1));	
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready == 1)
// 				// #1;				
// 				// r_val = 0.9;
// 				// fixed_val = $rtoi(r_val * SCALE);
// 				// io_data_i = fixed_val >>> PRECF;
// 				// io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready)
// 				// #1;
// 				// io_in_valid = 1;
// 				// $display($time);
// 				// @(posedge clock) if(io_in_ready)
// 				// #1;
// 				// io_in_valid = 0;
// 				// $display($time);
// 				// //#300;			
// 				// //$finish;
// 			end
			
// 			integer test = 0;
// 			initial begin
// 			forever begin
// 				@(posedge clock);          // 1. 等待时钟上升沿
// 				if (io_out_valid) begin  // 2. 在该时钟周期内检查信号是否有效
// 					// 3. 如果有效，执行操作（例如读取数据）
// 					res = io_res_i +  io_res_f / (real'(SCALE));;
// 					// #9;
// 					// $display("result: %f", res);
// 					$display("[%0t] data est valid: result: %f",$realtime, res);
// 				end
				
// 			end
// 			end
			
// 			initial begin
// 			forever begin
// 				@(posedge io_in_ready)          // 1. 等待时钟上升沿				
		
// 					$display($time, " ", io_in_ready, " ", test);
// 					r_val = testvectors[test];
// 					fixed_val = $rtoi(r_val * SCALE);
// 					io_data_i = fixed_val >>> PRECF;
// 					io_data_f = (fixed_val & ((1 << PRECF) - 1));
// 					test++;
		
// 			end
// 			end
						

// 			// //Maximum limit
// 			// initial begin
// 			// 	#100000;
// 			// 	res = io_res_i +  io_res_f / (real'(SCALE));;
// 			// 	$display("result: %f", res);
// 			// 	$finish;
// 			// end
// 	""")
	
	
// }



// // object BasicExpTest extends App{
	
// // 	val file = "./generated/suan/BasicExp"
	
// // 	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// // 	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
// // 	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
// // 	// 	  )    )))
// // 	val PRECI = 8
// // 	val PRECF = 8
	
// // 	val res = new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// // 		Seq(ChiselGeneratorAnnotation(() => new BasicExp3( 
// // 			MultThroughput = 1 ,MultDelay = 8 ,  preci = PRECI,  precf =PRECF
// // 	  )    )))
		  
// // 	// println(res(0))
	
// // 	//Simulation using vcs or iverilog
// // 	sim.iverilog(svtbfile = file+"/BasicExp.tb.sv", svfiles = Seq(file+"/BasicExp3.v"), svtb = """
	
// // 			parameter PRECI = """+PRECI+"""; // 整数位宽
// // 			parameter PRECF = """+PRECF+"""; // 小数位宽
// // 			parameter SCALE = 2 ** PRECF; // 缩放因子 32
// // 			real r_val = 0.20;
// // 			int signed fixed_val; // 定点数结果
// // 			real res;
			
// // 			initial begin
// // 				reset = 0;
// // 				io_in_valid = 0;
// // 				io_out_ready = 1;
// // 				#10;
// // 				reset = 1;
// // 				#10;
// // 				reset = 0;
				
				
// // 				r_val = 0.2;
// // 				fixed_val = $rtoi(r_val * SCALE);
// // 				io_data_i = fixed_val >>> PRECF;
// // 				io_data_f = (fixed_val & ((1 << PRECF) - 1));
// // 				io_in_valid = 1;
// // 				@(posedge clock) if(io_in_ready)
// // 				#1;				
				
// // 				r_val = 0.7;
// // 				fixed_val = $rtoi(r_val * SCALE);
// // 				io_data_i = fixed_val >>> PRECF;
// // 				io_data_f = (fixed_val & ((1 << PRECF) - 1));
// // 				//@( posedge io_out_valid)
				
// // 				//#1;
// // 				// res = io_res_i +  io_res_f / (real'(SCALE));; 
// // 				// $display("result: %f", res);
// // 				// //@( posedge io_in_ready)
// // 				// #9;
								
// // 				// #1;
// // 				// res = io_res_i +  io_res_f / (real'(SCALE));; 
// // 				// #9;
// // 				// $display("result: %f", res);
				
// // 				// //@( posedge io_in_ready)
								
// // 				#300;
// // 				// res = io_res_i +  io_res_f / (real'(SCALE));; 
// // 				// $display("result: %f", res);
													
// // 				$finish;
// // 			end
			
// // 			initial begin
// // 			forever begin
// // 				@(posedge clock);          // 1. 等待时钟上升沿
// // 				if (io_out_valid) begin  // 2. 在该时钟周期内检查信号是否有效
// // 					// 3. 如果有效，执行操作（例如读取数据）
// // 					res = io_res_i +  io_res_f / (real'(SCALE));;
// // 					// #9;
// // 					// $display("result: %f", res);
// // 					$display("[%0t] data est valid: result: %f",$realtime, res);
// // 				end
// // 			end
// // 			end

// // 			//Maximum limit
// // 			initial begin
// // 				#100000;
// // 				res = io_res_i +  io_res_f / (real'(SCALE));;
// // 				$display("result: %f", res);
// // 				$finish;
// // 			end
// // 	""")
	
	
// // }

