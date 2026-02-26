package test
import chisel3._
import chisel3.experimental._
import chisel3.util._

class FloatBundle extends Bundle{
	val sign = (UInt(1.W))
	val exponent = (UInt(7.W))
	val mantissa = (UInt(8.W))
}

class OPS extends RawModule {
	
	val io = IO(new Bundle{
		val 甲 = Output(UInt(32.W))
		val 乙 = Output(UInt(32.W))
		val 丙 = Output(UInt(32.W))
		val 丁 = Output(UInt(32.W))
		val 戊 = Output(Bool())
		val 己 = Output(Bool())
		val 更 = Output(Bool())
		val 辛 = Output(Bool())
		val 壬 = Output(Bool())
		val 癸 = Output(UInt(32.W))
	
		val 子 = Output(UInt(32.W))
		val 丑 = Output(UInt(1.W))
		val 寅 = Output(Bool())
		val 卬 = Output(UInt(32.W))
		val 辰 = Output(UInt(32.W))
		val 巳 = Output(UInt(32.W))
		val 午 = Output(Bool())
		val 未 = Output(Bool())
		val 申 = Output(Bool())
		val 由 = Output(Bool())
		val 戌 = Output(UInt(32.W))
		val 亥 = Output(UInt(32.W))
		
		val 甲子 = Output(UInt(32.W))
		val 乙丑 = Output(UInt(32.W))
		val 丙寅 = Output(UInt(32.W))
		val 丁卬 = Output(UInt(32.W))
		val 戊辰 = Output(UInt(32.W))
		val 己巳 = Output(Bool())
		val 庚午 = Output(Bool())
		val 辛未 = Output(Bool())
		val 千申 = Output(Bool())
	
	})
	
	
	val x = 123.U
	val y = 123.U
	val flagsIn = 3.U
	val overflow = 2.U
	val toggle = 321.U
	
	io.甲 := ~x
	io.乙 := x & "h_ffff_0000".U
	io.丙 := flagsIn | overflow
	io.丁 := flagsIn ^ toggle
	
	io.戊 := x.andR
	io.己 := x.orR
	io.更 := x.xorR
	
	io.辛 := x === y
	io.壬 := x =/= y
	io.癸 := 1.U << flagsIn
	io.子 := 16.U >> flagsIn
	
	io.丑 := x(0)
	io.寅 := x(0)
	io.卬 := x(15,12)
	io.辰 := Fill(3, "hA".U)
	val b = Wire(new FloatBundle)
	
	b.sign := 1.U
	b.exponent := "hf".U
	b.mantissa := "b1111".U
	
	val sign =  b.sign
	val exponent = b.exponent 
	val mantissa = b.mantissa
	io.巳 := Cat(sign, exponent, mantissa)
	
	val busy = false.B
	val gatMatch = true.B
	val valid = true.B
	
	io.午 := !busy
	io.未 := gatMatch && valid
	io.申 := gatMatch || valid
	io.由 := Mux(busy, gatMatch, valid)
	
	val a = 123.U
	val bb = 321.U
	
	io.戌 :=  a+bb //a +% b
	io.亥 := a +& bb
	
	io.甲子 := a - bb
	io.乙丑 := a -& bb
	io.丙寅 := a*bb
	io.丁卬 := a/bb
	io.戊辰 := a % bb
	io.己巳 := a > bb
	io.庚午 := a >=bb
	io.辛未 := a < bb
	io.千申 := a <=bb

}