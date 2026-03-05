


package chap3
import chisel3._
import chisel3.experimental._
import chisel3.util._

class MyIO extends Bundle{
	val in = Input(Vec(2, UInt(32.W)))
	val out = Output(UInt(32.W))
}

class subAdder extends Module {
	val io = IO(new Bundle{
		val sbuX = new MyIO
	})
	io.sbuX.out := io.sbuX.in(0) + io.sbuX.in(1)
}

class IO extends Module {
	val io = IO(new Bundle{
		val x = new MyIO
		val y = Flipped(new MyIO)
		val supX = new MyIO
	})
	
	io.x <> io.y
	val sub = Module(new subAdder)
	io.supX <> sub.io.sbuX
	
}


class OptionalIO(val flag: Boolean) extends Module {
	val io = IO(new Bundle{
		val in = Input(UInt(12.W))
		val out = Output(UInt(12.W))
		val out2 = if(flag) Some(Output(UInt(12.W))) else None
	})
	io.out := io.in
	if(flag) {
		io.out2.get := io.in
	}
}

class HalfFullAdder(val hasCarry: Boolean) extends Module {
	val io = IO(new Bundle{
		val a = Input(UInt(1.W))
		val b = Input(UInt(1.W))
		val carryIn = Input(if(hasCarry) UInt(1.W) else UInt(0.W))
		val s = Output(UInt(1.W))
		val carryOut = Output(UInt(1.W))
	})
	
	val sum = io.a +& io.b +& io.carryIn
	io.s  := sum(0)
	io.carryOut := sum(1)
}

