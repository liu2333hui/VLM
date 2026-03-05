package chap4
import chisel3._
import chisel3.util._

// import chisel3.experimental._
// 
class MUX extends RawModule {

    val io = IO(new Bundle {
	   val selector = Input(UInt(4.W))
	   val OhotValue = Output(UInt(8.W))
	   val OhotValue2 = Output(UInt(8.W))
	   val OhotValue3 = Output(UInt(8.W))
    })
	
    val hotValue = Mux1H(io.selector, Seq(2.U, 4.U, 8.U, 11.U))
	val hotValue2 = Mux1H(Seq(io.selector(0), io.selector(1), io.selector(2), io.selector(3)), Seq(2.U, 4.U, 8.U, 11.U))
	val hotValue3 = Mux1H(Seq(
		io.selector(0) -> 2.U,
		io.selector(1) -> 4.U,
		io.selector(2) -> 8.U,
		io.selector(3) -> 11.U
	))
	
	io.OhotValue := hotValue
	io.OhotValue2 := hotValue2
	io.OhotValue3 := hotValue3

}


// class MuxSmall(val n : Int ) extends Module {
	
	
// 	val io = IO(new Bundle {
//        val a = Input(Vec(n, UInt(32.W)))
// 	   val sel = Input(UInt(n.W))
// 	   val o = Input(UInt(32.W))
// 	})
	
	
	
// }
// import chisel3.stage.ChiselGeneratorAnnotation

// object MuxSmall extends App{
// 		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/MuxSmall"),
// 			Seq(ChiselGeneratorAnnotation(() => new MuxSmall(8))))
// }

