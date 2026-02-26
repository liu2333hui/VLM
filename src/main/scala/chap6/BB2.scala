package chap6

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._

class Dut2 extends BlackBox(
	Map("DATA_WIDTH" -> 32, "MODE" -> "Sequential", "RESET" -> "Asynchronous")
		){
		
		val io = IO(new Bundle{
				val a = Input(UInt(32.W))
				val clk = Input(Clock())
				val reset = Input(Bool())
				val b = Output(UInt(4.W))
		})
	
	
}

class UseDut2 extends Module {
	val io = IO(new Bundle{
			val toDut_a = Input(UInt(32.W))
			val toDut_b = Output(UInt(4.W))
	})
	
	val u0 = Module(new Dut)
	
	u0.io.a := io.toDut_a
	u0.io.clk := clock
	u0.io.reset := reset
	io.toDut_b := u0.io.b
	
}

object UseDut2Gen extends App{
		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap6/UseDutGen2"),
			Seq(ChiselGeneratorAnnotation(() => new UseDut2)))
}



