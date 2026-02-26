package test
import chisel3._
import chisel3.experimental._

class BITS extends RawModule {

    val io = IO(new Bundle {
	   val a = Output(UInt(32.W))
       val b = Output(UInt(32.W))
       val c = Output(UInt(32.W))
	   
	    val d = Output(SInt(32.W))
		val e = Output(SInt(32.W))
        val f = Output(SInt(32.W))
            
			
		val g = Output(Bool())
		val h = Output(Bool())
		val i = Output(Bool())
			    
	})
	
	val bools = VecInit(123.U(32.W).asBools)
	for(i <- 0 until 31 by 2){
		bools(i) := io.g
	}
	io.a := bools.asUInt
	
	io.b := "ha".asUInt(8.W)
	
    io.c := -1.asUInt

	io.d := -8.asSInt
	io.e := "ha".asUInt.asSInt
	io.f := 123.asSInt

	val boo = VecInit(io.a.asBools)
	
	io.g := boo(15)
	io.h := io.b(2)
	io.i := true.B

}

