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

// class TrigIO(val preci:Int, val precf:Int) extends Bundle{
// 	val data = new Bundle{
// 		val i = Input(UInt(preci.W))
// 		val f = Input(UInt(precf.W)) 
// 	}
// 	val res = new Bundle{
// 		val i = Output(UInt(preci.W))
// 		val f = Output(UInt(precf.W))
// 	}
// 	val out = Decoupled(Bool())
// 	val in = Flipped(Decoupled(Bool()))
// }

// class Sine(val preci:Int = 8, val precf:Int = 8, val MultThroughput:Int = 4, val MultDelay:Int = 4 ) extends Module {
	
// 	val io = IO(new TrigIO(preci, precf))
	
// 	val w0 = 1.260e-5
// 	val w1 = 0.9996
// 	val w2 = 0.002307
// 	val w3 = -0.1723
// 	val w4 = 0.006044
// 	val w5 = 0.005752
    
// 	// val w0 = 1.0
// 	// val w1 = 0.99
// 	// val w2 = 1.0/2.0
// 	// val w3 = 1.0/6.0
// 	// val w4 = 1.0/24
// 	// val w5 = 1.0/120
	
// 	//all less than 1
// 	val w0f = (w0 * (1<<precf)).toInt.U
// 	val w1f = (w1 * (1<<precf)).toInt.U
// 	val w2f = (w2 * (1<<precf)).toInt.U
// 	// val w3f = (w3 * (1<<precf)).toInt.U
// 	// val w4f = (w4 * (1<<precf)).toInt.U
	
// 	val mult1 = Module(new MultiplierShift(
// 		Throughput = MultThroughput, Delay = MultDelay,  Prec1 = precf,  Prec2 = preci+precf))
// 	io.out.bits := 1.B
// 	io.in.ready := mult1.io.in.ready
// 	mult1.io.in.valid := io.in.valid
// 	mult1.io.out.ready := 1.U
// 	io.out.valid := mult1.io.out.valid
	
// 	mult1.io.math.data1 := w1f
// 	mult1.io.math.data2 := Cat(io.data.i, io.data.f)
// 	io.res.i := mult1.io.math.res(preci+precf+precf-1, precf+precf)
// 	io.res.f := mult1.io.math.res(precf+precf-1, precf)
	
// }





// object sintest extends App{
	
// 	val file = "./generated/suan/Sine"
	
// 	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
// 	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
// 	// 	  )    )))
// 	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
// 		Seq(ChiselGeneratorAnnotation(() => new Sine( 
// 			MultThroughput = 4 ,MultDelay = 4 ,  preci = 4,  precf = 16
// 	  )    )))	
	
// 	//Simulation using vcs or iverilog
// 	sim.iverilog(svtbfile = file+"/Sine.tb.sv", svfiles = Seq(file+"/Sine.v"), svtb = """
	
// 			parameter PRECI = 3; // 整数位宽
// 			parameter PRECF = 5; // 小数位宽
// 			parameter SCALE = 2 ** PRECF; // 缩放因子 32
// 			real r_val = 0.20;
// 			int signed fixed_val; // 定点数结果
// 			real res;
			
// 			initial begin
// 				reset = 0;
// 				io_in_valid = 0;
// 				io_out_ready = 1;
// 				#10;
// 				reset = 1;
// 				#10;
// 				reset = 0;
				
// 				fixed_val = $rtoi(r_val * SCALE);
// 				io_data_i = fixed_val >>> PRECF;
// 				io_data_f = (fixed_val & ((1 << PRECF) - 1))+1;
// 				io_in_valid = 1;
				
// 				@( posedge io_out_valid)
// 				#1;
// 				res = io_res_i +  io_res_f / (real'(SCALE)-1);; 
// 				$display("result: %f", res);
				
				
				
// 				r_val = 0.7;
// 				fixed_val = $rtoi(r_val * SCALE);
// 				io_data_i = fixed_val >>> PRECF;
// 				io_data_f = (fixed_val & ((1 << PRECF) - 1))+1;
// 				@( posedge io_out_valid)
				
// 				#1;
// 				res = io_res_i +  io_res_f / (real'(SCALE)-1);; 
// 				$display("result: %f", res);
// 				$finish;
// 			end
// 	""")
	
	
// }

