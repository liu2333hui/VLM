package test
import chisel3._
import chisel3.experimental._

class VEC extends RawModule {

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
			    
		val ins = Input(Vec(10, UInt(32.W)))
	})
	
	
	val uvec = Wire(Vec(3, UInt(32.W)))
	
	uvec(0) := 1.U
	uvec(1) := 32.U
	uvec(2) := "h123".asUInt
	
	io.a := uvec(0).asUInt
	io.b := uvec(1).asUInt
    io.c := uvec(2).asUInt

	// val ss = Vec((1 to 10) map {i => UInt(i.W)})
	// val svec = Wire( ss )
	
	// 先定义类型
	val svec = VecInit((1 to 10).map(i => 0.U(i.W))) 

	io.d := svec(0).asSInt
	io.e := svec(1).asSInt
	io.f := -(svec(2).asSInt)

	val bvec = VecInit((1 to 10).map(i => false.B))

	io.g := bvec(0).asBool
	io.h := bvec(1).asBool
	io.i := bvec(2)

}

