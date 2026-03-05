package test
import chisel3._
import chisel3.experimental._

class CAST extends RawModule {

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
	
	io.a := -1.S(3.W).asUInt
	io.b := "ha".asUInt
    io.c := "b01_01".U

	io.d := -8.S
	io.e := -123.S
	io.f := 123.S


	io.g := 0.B
	io.h := false.B
	io.i := true.B

}

