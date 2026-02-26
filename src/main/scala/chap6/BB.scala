package chap6

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation

class Dut extends BlackBox {
		
		val io = IO(new Bundle{
				val a = Input(UInt(32.W))
				val clk = Input(Clock())
				val reset = Input(Bool())
				val b = Output(UInt(4.W))
		})
	
	
}

class UseDut extends Module {
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

object UseDutGen extends App{
		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap6/UseDutGen"),
			Seq(ChiselGeneratorAnnotation(() => new UseDut)))
}



