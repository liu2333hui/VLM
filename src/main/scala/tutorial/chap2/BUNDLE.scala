package test
import chisel3._
import chisel3.experimental._

class MyBundle1 extends Bundle {
	val foo = UInt(4.W)
	val bar = UInt(4.W)
}


class MyBundle2(val l:Int) extends Bundle {
	val foo = UInt(4.W)
	val bar = Vec( l, UInt(4.W) )
}


class MyBundle3 extends Bundle {
	val foo = UInt(4.W)
	val bar = SInt(4.W)
}


class BUNDLE extends Module {
	
	val io = IO(new Bundle{
		
		val in = Input(UInt(32.W))
		val out = Output(UInt(32.W))
		val out2 = Output(UInt(32.W))
		val out3 = Output(UInt(32.W))
	val out4 = Output(UInt(32.W))
	val out5 = Output(UInt(32.W))
		
	})
	
	val bundle = Wire(new MyBundle1)
	bundle.foo := 0xc.U
	bundle.bar := 0x3.U
	
	io.out := bundle.asUInt
	
	val bundle2 = Wire(new MyBundle2(3))
	
	bundle2.foo := 1.U
	bundle2.bar(0) := 123.U
	bundle2.bar(1) := 124.U
	bundle2.bar(2) := 32.U
	
	io.out2 := bundle2.asUInt
	
	
	
	val bundle3 = Wire(new MyBundle3)
	bundle3.foo := 0xc.U
	bundle3.bar := -2.S
	
	io.out3 := bundle3.asUInt
	
	val z = Wire(UInt(8.W))
	
	z := io.in
	val unpacked = z.asTypeOf(new MyBundle1)
	io.out4 := unpacked.foo
	io.out5 := unpacked.bar
	
	
}