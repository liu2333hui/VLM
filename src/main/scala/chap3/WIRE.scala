

package chap3
import chisel3._
import chisel3.experimental._
import chisel3.util._

class WIRE extends Module {
	val io = IO(new Bundle{
		val in = Input(UInt(8.W))
	})
	
	val myNode = Wire(UInt(8.W))
	
	myNode := 0.U;
	myNode := io.in + 1.U;;
	
	
	
	val w0 = Wire(UInt())
	val w1 = Wire(UInt(8.W))
	
	val w2 = Wire(Vec(4, UInt()))
	val w3 = Wire(Vec(4, UInt(8.W)))
	
	class MyBundle extends Bundle {
		val unknown = UInt()
		val known = UInt(8.W)
	}
	
	val w4 = Wire(new MyBundle)
	
	
	w0 := 1.U
	w1 := 3.U
	w2(0) := 1.U
	w2(1) := 1.U
	w2(2) := 1.U
	w2(3) := 1.U
	w3(0) := 1.U
	w3(1) := 1.U
	w3(2) := 1.U
	w3(3) := 1.U

	w4.unknown := 312.U
	w4.known := 123.U

}
