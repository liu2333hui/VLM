package chap3
import chisel3._
import chisel3.experimental._
import chisel3.util._

class Mux2 extends Module {
	val io = IO(new Bundle{
		val sel = Input(UInt(1.W))
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val out = Output(UInt(1.W))
	})
	
	io.out := (io.sel & io.in1) | (io.sel & io.in0)
	
}

class Mux4 extends Module {
	val io = IO(new Bundle{
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val in2 = Input(UInt(1.W))
		val in3 = Input(UInt(1.W))
		val sel = Input(UInt(2.W))
		val out = Output(UInt(1.W))	
	})
	
	val m0 = Module(new Mux2)
	val m1 = Module(new Mux2)
	val m2 = Module(new Mux2)
	
	m0.io.sel := io.sel(0)
	m0.io.in0 := io.in0
	m0.io.in1 := io.in1
	
	m1.io.sel := io.sel(0)
	m1.io.in0 := io.in2
	m1.io.in1 := io.in3

	m2.io.sel := io.sel(1)
	m2.io.in0 := m0.io.out
	m2.io.in1 := m1.io.out
	
	io.out := m2.io.out

	
}

class MultiMux4 extends Module {
	val io = IO(new Bundle{
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val in2 = Input(UInt(1.W))
		val in3 = Input(UInt(1.W))
		val sel = Input(UInt(2.W))
		val out = Output(UInt(1.W))	
	})
	
	val m = VecInit(Seq.fill(3)(Module(new Mux2).io))
	
	m(0).sel := io.sel(0)
	m(0).in0 := io.in0
	m(0).in1 := io.in1
	
	m(1).sel := io.sel(0)
	m(1).in0 := io.in2
	m(1).in1 := io.in3

	m(2).sel := io.sel(1)
	m(2).in0 := m(0).out
	m(2).in1 := m(1).out
	
	io.out := m(2).out

	
}

