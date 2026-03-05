

package chap3
import chisel3._
import chisel3.experimental._
import chisel3.util._

class WHEN extends Module {
	val io = IO(new Bundle{
		val sel = Input(UInt(1.W))
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val out = Output(UInt(1.W))
	})
	
	when(io.sel === 1.U){
			io.out := io.in1
	}.elsewhen(io.in0 === 1.U){
			io.out := io.in1
	}.otherwise {
		io.out := io.in0
	}
	
	
	
}
