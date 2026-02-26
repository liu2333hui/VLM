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

// import PipelineChainValid._

class MultiplierIO(val Prec1:Int, val Prec2:Int, val Delay:Int) extends Bundle {
		val out =new  ExitIO()//Decoupled(Bool()) 
		val in = new EntryIO()//Flipped(Decoupled(Bool()))
		val math = new Bundle{
			val data1 = Input(UInt(Prec1.W))
			val data2 = Input(UInt(Prec2.W))
			val res = Output(UInt((Prec1+Prec2).W))
		}
		val debug = new Bundle{
			val first_one = Output(UInt(Delay.W))
			val validvecs = Output(UInt(Delay.W))
			val ke = Output(UInt(Delay.W))
		}
}


// object MultiplierFactory {
//   def create( 
// 	val Throughput :Int , 
// 	val Delay :Int, 
// 	val Prec1:Int, 
// 	val Prec2:Int,
// 	val Type:String): GeneralMultiplier = {
// 		// val signed = HardwareConfig("signed").toBoolean
// 		val multiplierType = Type//HardwareConfig("multiplierType")
// 		val out =  multiplierType match {
// 			case "SimpleMultiplier2" => new SimpleMultiplier2(HardwareConfig)
// 			case "HighRadixMultiplier" => new HighRadixMultiplier(HardwareConfig)
// 			case "BitSerialMultiplier" => new BitSerialMultiplier(HardwareConfig)	
// 			case "UIntHighRadixMultiplier" => new UIntHighRadixMultiplier2(HardwareConfig)
// 			case "UIntBitSerialMultiplier" => new UIntBitSerialMultiplier(HardwareConfig)
// 			case _     => throw new IllegalArgumentException("Unknown mult2 type")
// 		}
// 	  out
	  
//   }
  



class MultiplierShift(val Throughput :Int , val Delay :Int, val Prec1:Int, val Prec2:Int) extends Module {

    val io = IO(new MultiplierIO(Prec1, Prec2, Delay))


	// val fb = Module(new FixedBlock(Throughput , Delay ) )
	// io.out <> fb.io.out
	// io.in <> fb.io.in
	
	io.debug.first_one := 0.U
	io.debug.validvecs := 0.U
	io.debug.ke := 0.U
			// io.out.bits := io.in.bits
		val cnt = RegInit(0.U(32.W))
		
	if(Throughput == Delay && Throughput == 1){
		io.out.valid := RegNext(io.in.valid)
		io.in.ready := RegNext(io.out.ready)
		io.math.res := RegNext(io.math.data1 * io.math.data2)
	}
	if(Throughput == Delay){
		
		//Multi-cycle 
		
		// cnt := cnt + 1.U
		when(io.in.valid && io.in.ready || ( cnt >= 1.U)){
			when(cnt >= (Delay).U){
				when(io.in.valid && io.out.ready){
					cnt := 1.U;
				}.elsewhen(!io.out.ready){
					cnt := (Delay).U	
				}.otherwise{
					cnt := 0.U;
				}
			}.otherwise{
				cnt := cnt + 1.U
			}
		}.otherwise{
				cnt := 0.U
			}
		
		io.out.valid := cnt >= (Delay).U
		io.in.ready := (io.out.ready&&io.out.valid || (cnt === 0.U)).asUInt

			
			
		//Code
		val ShiftAmount : Int = Prec1 / Delay
		val data1 = Reg(UInt((Prec1+Prec2).W))
		val data2 = Reg(UInt((Prec2+Prec1).W))
		val res = Reg(UInt((Prec1+Prec2).W))

		when((cnt === 0.U && io.in.valid && io.in.ready)  ){
			data1 := io.math.data1 >> ShiftAmount
			data2 := io.math.data2 << ShiftAmount
			res := io.math.data1( ShiftAmount - 1, 0) * io.math.data2//preload
		}.elsewhen(cnt >= Throughput.U ){
			when(io.out.ready && io.in.valid && io.in.ready){
				data1 := io.math.data1 >> ShiftAmount
				data2 := io.math.data2 << ShiftAmount
				res := io.math.data1( ShiftAmount - 1, 0) * io.math.data2//preload
			}.elsewhen(!io.out.ready){
				res := res
				data1 := data1
				data2 := data2
			}.otherwise{
				res := res
				data1 := data1
				data2 := data2
			}
		}.elsewhen(cnt >= 1.U){
			data1 := data1 >> ShiftAmount
			data2 := data2 << ShiftAmount
			res := res + data1(ShiftAmount-1,0) * data2//onload
		}.otherwise{
			res := res
			data1 := data1
			data2 := data2
		}
		
		io.math.res := res
	
	
		// println(ShiftAmount)
		
		// val preload = Wire(UInt((ShiftAmount+Prec2).W))
		// val onload = Wire(UInt((ShiftAmount+Prec2).W))
		
		// val data1pre = Wire(UInt(ShiftAmount.W))
		// val iodata1pre = Wire(UInt(ShiftAmount.W))
		
		// data1pre := data1(ShiftAmount-1,0)
		// iodata1pre := io.math.data1( ShiftAmount - 1, 0)
		
		// onload :=  data1pre * data2
		// preload := iodata1pre * io.math.data2
		
		
				
	}else if(Throughput == 1){

		
		val valid = RegInit(  VecInit( Seq.fill(Delay)(0.U(1.W)  ) ))// VecInit(Delay, 0.U(1.W)))
		val first_one = Wire(UInt(Delay.W))
		val ke = Wire(Vec(Delay, UInt(1.W))) //UInt(Delay.W))
		
		
		val kerev = Wire(Vec(Delay, UInt(1.W))) //UInt(Delay.W))
		
		val validvecs = Wire(UInt(Delay.W))
		val validrev = Wire(  Vec( Delay, UInt(1.W)  ))// VecInit(Delay, 0.U(1.W)))
		
		for(i <- 0 until Delay){
			 validrev(i) := valid(Delay-1-i) //(i)
			 kerev(i) := ke(Delay-1-i)
		}
		
		validvecs := validrev.asUInt
		first_one := ~validvecs & ~(~validvecs - 1.U)
		io.debug.first_one := first_one
		io.debug.validvecs := valid.asUInt
		io.debug.ke := kerev.asUInt
		
		
		// ke[0] := //io.out.ready
		// ke()
		for(i <- 1 until Delay){
			ke(i) := ke(i-1) | first_one(i-1)
		}
		ke(0) := first_one(0) | io.out.ready
		// val valid_vec = (valid-1).asUInt
		// val ke = 
		
		
		// val ready = Reg(Vec(Delay, UInt(1.W)))
		
		io.in.ready := io.out.ready
		// ready(Delay-1) := io.out.ready
		 
		// io.out.bits := io.in.bits
		
		when(kerev(0).asBool){
			valid(0) := io.in.valid
		}.otherwise{
			valid(0) := valid(0)
		}
		
		io.out.valid := valid(Delay-1)
		
		for(i <- 1 until Delay){
			when(kerev(i-1).asBool){
				valid(i) := valid(i-1)
			}.otherwise{
				valid(i) := valid(i)
			}
		}
		// for(i <- 0 until Delay-1){
		// 	ready(i) := ready(i+1)
		// }
		
		//Code
		val ShiftAmount : Int = Prec1 / Delay
		println(ShiftAmount)
		val data1 = Reg( Vec(Delay, UInt((Prec1+Prec2).W)) )
		val data2 = Reg( Vec(Delay, UInt((Prec1+Prec2).W)) )
		val res   = Reg( Vec(Delay, UInt((Prec1+Prec2).W)) )
		
		
		
		io.math.res := res(Delay-1)
		when(kerev(0).asBool){
			data1(0) := io.math.data1 >> ShiftAmount
			data2(0) := io.math.data2 << ShiftAmount
			res(0) := io.math.data1( ShiftAmount - 1, 0) * io.math.data2
		}.otherwise{
			data1(0) :=data1(0)
			data2(0) :=data2(0)
			res(0)   :=res(0)   
		}

		for(i <- 1 until Delay){
			when(kerev(i-1).asBool){
				data1(i) := data1(i-1) >> ShiftAmount
				data2(i) := data2(i-1) << ShiftAmount
				res(i)   := res(i-1) + data1(i-1)(ShiftAmount-1,0) * data2(i-1)
			}.otherwise{
				data1(0) :=data1(0)
				data2(0) :=data2(0)
				res(0)   :=res(0)   
			}	
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}else{
		//Counter
		val cnt = Reg(UInt(32.W))
		// cnt := cnt + 1.U
		when(io.in.valid | ( cnt >= 1.U)){
			when(cnt >= (Throughput).U){
				when(io.in.valid){
					cnt := 1.U;
				}.otherwise{
					cnt := 0.U;
				}
			}.otherwise{
				cnt := cnt + 1.U
			}
		}.otherwise{
				cnt := 0.U
		}
		//Valid pipeline
		val valid = Reg(Vec(Delay, UInt(1.W)))
		// io.out.bits := io.in.bits
		for(i <- 1 until Delay){
			valid(i) := valid(i-1)
		}  
		io.out.valid := valid(Delay-1)
		valid(0) := io.in.valid & io.in.ready
		io.in.ready := (cnt >= (Throughput).U || (cnt === 0.U)).asUInt
				
				
				
		//Code (todos)
		
		
				
				
				
				
	}
	

	// io.in.valid
	// io.in.ready
	// io.out.valid
	// io.out.ready

}





object multiplier_fulltest extends App{
	
	val file = "./generated/suan/MultiplierShift"
	
	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
	// 	  )    )))
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
			Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/MultiplierShift.tb.sv", svfiles = Seq(file+"/MultiplierShift.v"), svtb = """
			initial begin
			
				Reset();
				io_math_data1 = $urandom;io_math_data2 = $urandom;
				io_in_valid = 1;io_out_ready = 1;
				@(posedge io_out_valid);
				assert(io_math_data1 * io_math_data2 == io_math_res);
				
				Reset();
				io_math_data1 = $urandom;io_math_data2 = $urandom;
				io_in_valid = 1;io_out_ready = 0;
				@(posedge io_out_valid);
				assert(io_math_data1 * io_math_data2 == io_math_res);
				
				
			end
	""")
	
	
}


object multipliertest extends App{
	
	val file = "./generated/suan/MultiplierShift"
	
	// new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
	// 	Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
	// 		Throughput = 4 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
	// 	  )    )))
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new MultiplierShift( 
			Throughput = 1 ,Delay = 4 ,  Prec1 = 8,  Prec2 = 8
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/MultiplierShift.tb.sv", svfiles = Seq(file+"/MultiplierShift.v"), svtb = """
			initial begin
				reset = 0;
				io_math_data1 = 8;
				io_math_data2 = 9;
				io_in_valid = 0;
				io_out_ready = 1;
				#10;
				reset = 1;
				#10;
				reset = 0;
				io_math_data1 = 8;
				io_math_data2 = 9;
				io_in_valid = 1;
				// io_out_ready = 0;
				#10;
				io_math_data1 = 7;
				io_math_data2 = 11;
				io_in_valid = 0;
				#10;
				io_math_data1 = 13;
				io_math_data2 = 14;
				io_in_valid = 1;
				io_out_ready = 0;
				#10;
				io_math_data1 = 2;
				io_math_data2 = 12;
				io_out_ready = 0;
				#100;
				io_math_data1 = 22;
				io_math_data2 = 7;
				#100;
				io_out_ready = 1;
				#100;
				$finish;
			end
	""")
	
	
}