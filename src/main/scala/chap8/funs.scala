package chap8

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.util._

class UseFunc extends Module {

	val io = IO(new Bundle {
		val in = Input(UInt(4.W))
		val out1 = Output(Bool())
		val out2 = Output(Bool())
	})
	
	def clb(a:UInt, b :UInt, c :UInt, d:UInt):UInt = (a&b) | (~c & d)
	
	io.out1 := clb(io.in(0), io.in(1), io.in(2), io.in(3))
	io.out2 := and(and(io.in(0), io.in(1)), and(io.in(2), io.in(3)))
	
}

object and {
	def apply(a:UInt, b:UInt) : UInt = a & b
}


class Mux2 extends Module {
	val io = IO(new Bundle {
		val sel = Input(UInt(1.W))
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val out = Output(UInt(1.W))
	})
	io.out := (io.sel & io.in1) | (~io.sel & io.in0)
}

object Mux2 {
	def apply(sel:UInt, in0:UInt, in1:UInt) = {
		val m = Module(new Mux2)
		m.io.in0 := in0
		m.io.in1 := in1
		m.io.sel := sel
		m.io.out
	}
}

class Mux4 extends Module {
	val io = IO(new Bundle {
		val sel = Input(UInt(2.W))
		val in0 = Input(UInt(1.W))
		val in1 = Input(UInt(1.W))
		val in2 = Input(UInt(1.W))
		val in3 = Input(UInt(1.W))
		val out = Output(UInt(1.W))
	})
	
	io.out := Mux2(io.sel(1), Mux2(io.sel(0), io.in0, io.in1),
		Mux2(io.sel(0), io.in2, io.in3))
	
}


class Decoder(n:Int) extends RawModule {

	val io = IO(new Bundle{
		val sel = Input(UInt(n.W))
		val out = Output(UInt((1<<n).W))
	})
	
	val x = for(i <- 0 until (1 << n)) yield io.sel === i.U
	val y = for(i <- 0 until (1 << n)) yield 1.U << i
	io.out := MuxCase(0.U, x zip y)

}

class Reversing extends RawModule {

	Reverse("b1101".U)
	Reverse("b1101".U(8.W))
	// Reverse(myUIntWire)
	
	Cat("b101".U, "b11".U)
	Cat(Seq("b101".U, "b11".U))
	
	PopCount(Seq(true.B, false.B, true.B, true.B))
	PopCount(Seq(false.B, false.B, true.B, false.B))
	PopCount("b1011".U)
	PopCount("b0010".U)
	PopCount("b0010".U)
	
	OHToUInt("b10000".U)
	OHToUInt("b1000_0000".U)
	UIntToOH(3.U)
	UIntToOH(7.U)
	
	"b10101".U === BitPat("b101??")
	"b10111".U === BitPat("b101??")
	"b10001".U === BitPat("b101??")
	
	
	val myDontCare = BitPat.dontCare(4)
	
	//Lookup, ListLookup, how it works?
	
	Fill(2, "b1000".U)
	Fill(2, "b1001".U)
	FillInterleaved(2, Seq(true.B, false.B, false.B, false.B))
	FillInterleaved(2, Seq(true.B, false.B, false.B, true.B))
	FillInterleaved(2, "b1000".U)
	FillInterleaved(2, "b1001".U)
	
	
	
}


class Printing extends RawModule{

	val myUInt = 33.U
	printf(p"myUint = $myUInt")
	printf(p"myUInt = 0x${Hexadecimal(myUInt)}")
	printf(p"myUint = ${Binary(myUInt)}")
	printf(p"myUint = ${Character(myUInt)}")
	
	val myVec = VecInit(5.U, 10.U, 13.U)
	printf(p"myVec = $myVec")
	
	val myBundle = Wire(new Bundle {
		val foo = UInt()
		val bar = UInt()
	})
	
	myBundle.foo := 3.U
	myBundle.bar := 11.U
	printf(p"myBundle = $myBundle")



	val myMessage = Wire(new Message)
	myMessage.valid := true.B
	myMessage.addr := "h1234".U
	myMessage.length := 10.U
	myMessage.data := "htofu".U
	
	printf(p"$myMessage")
	
	val myUInt2 = 32.U
	printf("myUInt = %d", myUInt2)
	//%d, %x, %b, %c, %%
}


class Message extends Bundle {
	val valid = Bool()
	val addr = UInt(32.W)
	val length = UInt(4.W)
	val data = UInt(64.W)
	
	override def toPrintable:Printable = {
		val char = Mux(valid, 'v'.U, '-'.U)
		p"Message:\n" +  
			p"  valid : ${Character(char)}\n" + 
			p"  addr  : 0x${Hexadecimal(addr)}\n" + 
			p"  length : $length\n" + 
			p"  data : 0x${Hexadecimal(data)}\n"
	}
}


object UseFuncGen extends App{
		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap8/UseFunc"),
			Seq(ChiselGeneratorAnnotation(() => new UseFunc)))

		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap8/Mux4"),
			Seq(ChiselGeneratorAnnotation(() => new Mux4)))


		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap8/Decoder"),
			Seq(ChiselGeneratorAnnotation(() => new Decoder(8))))
			
			
			
			
			new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap8/Reversing"),
				Seq(ChiselGeneratorAnnotation(() => new Reversing )))
				
				
}





