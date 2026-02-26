// package chap9

// import chisel3._
// import chisel3.stage.ChiselGeneratorAnnotation
// import chisel3.util._
// import chisel3.experimental.FixedPoint

// class ExampleBundle(a:Int, b:Int) extends Bundle{
// 	val foo = UInt(a.W)
// 	val bar = UInt(b.W)
	
// 	override def cloneType = (new ExampleBundle(a,b)).asInstanceOf[this.type]
// }

// // class ExampleBundleModule(btype:ExampleBundle) extends Module {
// // 	val io = IO(new Bundle{
// // 		val out = Output(UInt(32.W))
// // 		val b = Input(chiselTypeOf(btype))
// // 	})
// // }


// class MyFixedPoint(n: Int, bp:Int) extends Module {
	
// 	val io = IO(new Bundle{
// 		val in = Input(FixedPoint(n.W, bp.BP))
// 		val in2 = Input(FixedPoint(n.W, bp.BP))
// 		val add = Output(FixedPoint(n.W, bp.BP))
// 		val mul = Output(FixedPoint(n.W, bp.BP))
// 	})
// 	io.add := io.in + io.in2
// 	io.mul := io.in * io.in2
// }


// object OtherSpec extends App{
// 		new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Chap8/Other"),
// 			Seq(ChiselGeneratorAnnotation(() => new ExampleBundle)))

// }
