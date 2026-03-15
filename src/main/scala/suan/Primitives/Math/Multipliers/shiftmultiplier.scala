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

//Support negative numbers
class MultiplierShiftIO(val Prec1:Int, val Prec2:Int) extends Bundle {
		val out =new  ExitIO()//Decoupled(Bool()) 
		val in = new EntryIO()//Flipped(Decoupled(Bool()))
		val math = new Bundle{
			val data1 = Input(SInt(Prec1.W))
			val data2 = Input(SInt(Prec2.W))
			val res = Output(SInt((Prec1+Prec2).W))
		}
}


class BoothEncoder(val Prec1:Int, val Prec2:Int, val ShiftAmount:Int,
	val top:String=""
) extends Module {
	override def desiredName = top+"_BoothEncoder"

	val bits = ShiftAmount + 1
	
	val OutPrec = Prec1 + Prec2

	val io = IO(new Bundle{
		val in  = Input(UInt(bits.W))
		val x   = Input(SInt(OutPrec.W))
		val out = Output(SInt(OutPrec.W))
	})

	// println(bits)
	// println(ShiftAmount)

	if(ShiftAmount == 1){
		// Generate the encoded output and validity signal using match-case
		  // when(io.input === "b0001".U) {
		  //   io.out := io.x * 0.S
		  // }.elsewhen(io.input === "b0010".U) {
		  //   io.output := "b01".U
		  //   io.valid := true.B
		  // }.elsewhen(io.input === "b0100".U) {
		  //   io.output := "b10".U
		  //   io.valid := true.B
		  // }.elsewhen(io.input === "b1000".U) {
		  //   io.output := "b11".U
		  //   io.valid := true.B
		  // }.otherwise {
		  //   io.output := "bXX".U // Undefined state if more than one bit is set or no bits are set
		  //   io.valid := false.B
		  // }
		  
		 io.out := 0.S
		switch(io.in){
			is("b00".U){ io.out := (io.x * 0.S )  }
			is("b01".U){ io.out := (io.x * 1.S )  }
			is("b10".U){ io.out := (io.x * -1.S ) }
			is("b11".U){ io.out := (io.x * 0.S )  }
		}
	}else if(ShiftAmount == 2){
		
		io.out := 0.S
		switch(io.in){
			// is("b00".U){ io.out := (io.x * 0.S )  }
			// is("b01".U){ io.out := (io.x * 1.S )  }
			// is("b10".U){ io.out := (io.x * -1.S ) }
			// is("b11".U){ io.out := (io.x * 0.S )  }
		  is("b000".U){ io.out := ( io.x * 0.S ) }
		  is("b001".U){ io.out := ( io.x * 1.S ) }
		  is("b010".U){ io.out := ( io.x * 1.S ) }
		  is("b011".U){ io.out := ( io.x * 2.S ) }
		  is("b100".U){ io.out := ( io.x * -2.S) }
		  is("b101".U){ io.out := ( io.x * -1.S) }
		  is("b110".U){ io.out := ( io.x * -1.S) }
		  is("b111".U){ io.out := ( io.x * 0.S ) }
		  // case _ => "bXX" // Undefined state if more than one bit is set or no bits are set
		}
		// io.out := io.in match {
		//   case "b000" => io.x * 0.S
		//   case "b001" => io.x * 1.S
		//   case "b010" => io.x * 1.S
		//   case "b011" => io.x * 2.S
		//   case "b100" => io.x * -2.S
		//   case "b101" => io.x * -1.S
		//   case "b110" => io.x * -1.S
		//   case "b111" => io.x * 0.S
		//   case _ => "bXX" // Undefined state if more than one bit is set or no bits are set
		// }
	}else if(ShiftAmount == 4){
		 io.out := 0.S
		switch(io.in){
			
					  // is("b000".U){ io.out := ( io.x * 0.S ) }
					  // is("b001".U){ io.out := ( io.x * 1.S ) }
					  // is("b010".U){ io.out := ( io.x * 1.S ) }
					  // is("b011".U){ io.out := ( io.x * 2.S ) }
					  // is("b100".U){ io.out := ( io.x * -2.S) }
					  // is("b101".U){ io.out := ( io.x * -1.S) }
					  // is("b110".U){ io.out := ( io.x * -1.S) }
					  // is("b111".U){ io.out := ( io.x * 0.S ) }
					  
			  is("b00000".U) {io.out := io.x * 0.S  }
			  is("b00001".U) {io.out := io.x * 1.S  }
			  is("b00010".U) {io.out := io.x * 1.S  }
			  is("b00011".U) {io.out := io.x * 2.S  }
			  is("b00100".U) {io.out := io.x * 2.S  }
			  is("b00101".U) {io.out := io.x * 3.S  }
			  is("b00110".U) {io.out := io.x * 3.S  }
			  is("b00111".U) {io.out := io.x * 4.S  }
			  is("b01000".U) {io.out := io.x * 4.S  }
			  is("b01001".U) {io.out := io.x * 5.S  }
			  is("b01010".U) {io.out := io.x * 5.S  }
			  is("b01011".U) {io.out := io.x * 6.S  }
			  is("b01100".U) {io.out := io.x * 6.S  }
			  is("b01101".U) {io.out := io.x * 7.S  }
			  is("b01110".U) {io.out := io.x * 7.S  }
			  is("b01111".U) {io.out := io.x * 8.S  }
			  is("b10000".U) {io.out := io.x * -8.S}
			  is("b10001".U) {io.out := io.x * -7.S}
			  is("b10010".U) {io.out := io.x * -7.S}
			  is("b10011".U) {io.out := io.x * -6.S}
			  is("b10100".U) {io.out := io.x * -6.S}
			  is("b10101".U) {io.out := io.x * -5.S}
			  is("b10110".U) {io.out := io.x * -5.S}
			  is("b10111".U) {io.out := io.x * -4.S}
			  is("b11000".U) {io.out := io.x * -4.S}
			  is("b11001".U) {io.out := io.x * -3.S}
			  is("b11010".U) {io.out := io.x * -3.S}
			  is("b11011".U) {io.out := io.x * -2.S}
			  is("b11100".U) {io.out := io.x * -2.S}
			  is("b11101".U) {io.out := io.x * -1.S}
			  is("b11110".U){ io.out := io.x * -1.S}
			  is("b11111".U){ io.out := io.x * -0.S}		  
		}  
		// //-8 4 2 1 1
		// io.out := io.in match {
		//   case "b00000" => io.x * 0.S
		//   case "b00001" => io.x * 1.S
		//   case "b00010" => io.x * 1.S
		//   case "b00011" => io.x * 2.S
		//   case "b00100" => io.x * 2.S
		//   case "b00101" => io.x * 3.S
		//   case "b00110" => io.x * 3.S
		//   case "b00111" => io.x * 4.S
		//   case "b01000" => io.x * 4.S
		//   case "b01001" => io.x * 5.S
		//   case "b01010" => io.x * 5.S
		//   case "b01011" => io.x * 6.S
		//   case "b01100" => io.x * 6.S
		//   case "b01101" => io.x * 7.S
		//   case "b01110" => io.x * 7.S
		//   case "b01111" => io.x * 8.S
		//   case "b10000" => io.x * -8.S
		//   case "b10001" => io.x * -7.S
		//   case "b10010" => io.x * -7.S
		//   case "b10011" => io.x * -6.S
		//   case "b10100" => io.x * -6.S
		//   case "b10101" => io.x * -5.S
		//   case "b10110" => io.x * -5.S
		//   case "b10111" => io.x * -4.S
		//   case "b11000" => io.x * -4.S
		//   case "b11001" => io.x * -3.S
		//   case "b11010" => io.x * -3.S
		//   case "b11011" => io.x * -2.S
		//   case "b11100" => io.x * -2.S
		//   case "b11101" => io.x * -1.S
		//   case "b11110" => io.x * -1.S
		//   case "b11111" => io.x * -0.S
		//   case _ => "bXX" // Undefined state if more than one bit is set or no bits are set
		// }
	}else if(ShiftAmount == 8){
		//not a good feasible solution
		//Have a 64-1 encoder
	}
	
	
}

// class PipelinedMultiplier(val Throughput:Int, val Delay:Int, val Prec1:Int, val Prec2:Int) extends Module{	
// }

class BoothMultiplier(val Delay :Int, val Prec1:Int, val Prec2:Int,
	val top:String = "") extends Module {

	override def desiredName = top+"_BoothMultiplier"


    val io = IO(new MultiplierShiftIO(Prec1, Prec2))
	val cnt = RegInit(0.U(32.W))
	val valid = RegInit(0.U(1.W))
	val outs = RegInit(0.S((Prec1+Prec2).W))
	
	if(Delay==1){
		io.out.valid := valid
		io.in.ready := io.out.ready
		io.math.res := outs 
		when(io.in.valid && io.in.ready && io.out.ready){
			valid := io.in.valid
			outs := io.math.data1 * io.math.data2
		}.otherwise{
			when(io.in.valid  &&  !io.out.valid){
				valid := io.in.valid
				outs := io.math.data1 * io.math.data2
			}
		}
		
	}else{
		val ShiftAmount : Int = Prec1 / Delay
		//Radix
		val be = Module(new BoothEncoder(top=desiredName,
		Prec1= Prec1, Prec2 = Prec2, ShiftAmount = ShiftAmount))
		
		
		//Multi-cycle Booth Multiplier
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
		val data1 = Reg(SInt((Prec1+Prec2).W))
		val data2 = Reg(SInt((Prec2+Prec1).W))
		val res = Reg(SInt((Prec1+Prec2).W))
		
		val math1 = Wire(SInt((Prec1+1).W))
		math1 := (Cat(io.math.data1.asUInt, "b0".U)).asSInt
		
		be.io.in  := 0.U
		be.io.x := 0.S
		when((cnt === 0.U && io.in.valid && io.in.ready)  ){
			data1 := math1 >> ShiftAmount
			data2 := io.math.data2 << ShiftAmount
			be.io.in  := math1( ShiftAmount, 0)
			be.io.x := io.math.data2
			res := be.io.out //io.math.data1( ShiftAmount - 1, 0) * io.math.data2//preload
		}.elsewhen(cnt >= Delay.U ){
			when(io.out.ready && io.in.valid && io.in.ready){
				data1 := math1 >> ShiftAmount
				data2 := io.math.data2 << ShiftAmount
				be.io.in  := math1( ShiftAmount, 0)
				be.io.x := io.math.data2
				res := be.io.out
				// res := io.math.data1( ShiftAmount - 1, 0) * io.math.data2//preload
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
			be.io.in  := data1( ShiftAmount, 0)
			be.io.x := data2
			// res := be.io.out
			res := res + be.io.out// data1(ShiftAmount,0) * data2//onload
		}.otherwise{
			res := res
			data1 := data1
			data2 := data2
		}
		
		io.math.res := res		
	}	
		
}





object BoothMultiplier_test extends App{
	
	val file = "./generated/suan/BoothMultiplier"

	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new BoothMultiplier( 
			Delay = 8 ,  Prec1 = 8,  Prec2 = 8
		  )    )))	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new BoothMultiplier( 
			Delay = 4 ,  Prec1 = 8,  Prec2 = 8
		  )    )))	
			  
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new BoothMultiplier( 
			Delay = 2 ,  Prec1 = 8,  Prec2 = 8
		  )    )))

	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/BoothMultiplier.tb.sv", 
		svfiles = Seq(file+"/BoothMultiplier.v"), 
		signed_logic = Seq("io_math_data1", "io_math_data2"), svtb = """
			initial begin
			
				Reset();
				io_math_data1 = -6;io_math_data2 = 5;
				io_in_valid = 1;io_out_ready = 1;
				@(posedge io_out_valid);
				$display(io_math_res);
				assert(io_math_data1 * io_math_data2 == $signed(io_math_res));
				
				Reset();
				io_math_data1 = -77;io_math_data2 = 15;
				io_in_valid = 1;io_out_ready = 0;
				@(posedge io_out_valid);
				// assert(io_math_data1 * io_math_data2 == io_math_res);
				assert(io_math_data1 * io_math_data2 == $signed(io_math_res));
				
				
				
				repeat(30) begin
				
					// Reset();
					io_math_data1 = $urandom;io_math_data2 = $urandom;
					io_in_valid = 1;io_out_ready = 1;
					@(posedge io_out_valid);
					// assert(io_math_data1 * io_math_data2 == io_math_res);
					assert(io_math_data1 * io_math_data2 == $signed(io_math_res));					
				end
				
				
			end
	""")
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new BoothMultiplier( 
			Delay = 1 ,  Prec1 = 8,  Prec2 = 8
		  )    )))
	sim.iverilog(svtbfile = file+"/BoothMultiplier.tb.sv", 
		svfiles = Seq(file+"/BoothMultiplier.v"), 
		signed_logic = Seq("io_math_data1", "io_math_data2"), svtb = """
			initial begin
			
				Reset();
				io_math_data1 = -6;io_math_data2 = 5;
				io_in_valid = 1;io_out_ready = 1;
				@(negedge clock);
				$display(io_math_res);
				assert(io_math_data1 * io_math_data2 == $signed(io_math_res));
				#1;
				Reset();
				io_math_data1 = -77;io_math_data2 = 15;
				io_in_valid = 1;io_out_ready = 0;
				@(negedge clock);
				// assert(io_math_data1 * io_math_data2 == io_math_res);
				assert(io_math_data1 * io_math_data2 == $signed(io_math_res));
				#1;
				@(negedge clock);
				
				
				repeat(30) begin
				
					// Reset();
					io_math_data1 = $urandom;io_math_data2 = $urandom;
					io_in_valid = 1;io_out_ready = 1;
					@(negedge clock);
					// assert(io_math_data1 * io_math_data2 == io_math_res);
					assert(io_math_data1 * io_math_data2 == $signed(io_math_res));	
					#1;
				end
				
				
			end
	""")						
	
}

