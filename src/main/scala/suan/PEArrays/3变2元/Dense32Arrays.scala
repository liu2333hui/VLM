

package PEArrays
import primitive._
import helper._

import suan._
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 


 
 

class DenseFixedPointOnlineSoftmaxDenominatorPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1i = HardwareConfig("prec1i").toInt
	val prec1f = HardwareConfig("prec1f").toInt
	val prec1 = prec1i+prec1f
	
	val prec2i = HardwareConfig("prec2i").toInt
	val prec2f = HardwareConfig("prec2f").toInt
	val prec2 = prec2i+prec2f
	
	val prec3i = HardwareConfig("prec3i").toInt
	val prec3f = HardwareConfig("prec3f").toInt
	
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, new FP(prec1i, prec1f)  ) //X
		val in1 =  Vec(I,   new FP(prec2i, prec2f)    )   //M_prev
		val in2 =  Vec(I,   new FP(prec3i, prec3f)    )   //D_prev
		
		val out0 = Vec(I, Flipped(new FP(prec2i, prec2f))) //M
		// val out1 = Vec(I, new FP(prec3i, prec3f)) //D
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	// 1. M += Max(M_prev, X)
	val mp = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntMaxN", 
		Map(
			"prec1" -> prec1.toString,
			"prec_out" -> prec1.toString	,	
			"terms"   -> J.toString
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		mp(i ).io.in0(j) := Cat(io.in0( j+J*i ).i, io.in0( j+J*i ).f).asSInt
		// 	io.out0(i).i := mp(i).io.out(prec1i+prec1f-1,prec1f)
		// 	io.out0(i).f := mp(i).io.out(prec1f-1,0)
			
		// 	io.entry.ready := mp(i).io.entry.ready
		// 	mp(i).io.entry.valid := io.entry.valid

		// 	mp(i).io.exit.ready := io.exit.ready 
		// 	io.exit.valid := mp(i).io.exit.valid 
	}}
	
	val mp2 = List.fill(I)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntMax2", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec2.toString
		)
	)  )  )	
	
	for(i <- 0 until I){
		mp2(i ).io.in0 := mp(i).io.out 
		mp2(i ).io.in1 := Cat(io.in1(i).i, io.in1(i).f).asSInt
		
		io.out0(i).i := mp2(i).io.out(prec2i+prec2f-1,prec2f)
		io.out0(i).f := mp2(i).io.out(prec2f-1,0)

		mp(i).io.entry <> io.entry

		mp(i).io.exit <> mp2(i).io.entry
		
		mp2(i).io.exit <> io.exit
	}
	
	//2. D += Exp(X-M) + D_prev * Exp(M_prev - M)
	// val m10 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
	// 	"SIntBasicSubtract", 
	// 	Map(
	// 		"prec1" -> prec1.toString,
	// 		"prec2" -> prec2.toString,
	// 		"prec_out" -> prec_out.toString
	// 	)
	// )  )  )
	
	// val m11 = List.fill(I*J)( Module( PrimitiveFactory.CreateFixedPointIn1Out1(
	// 	"FixedPointTrigExp", 
	// 	Map(
	// 		"prec1" -> prec_out.toString,
	// 		"prec_out" -> prec_out.toString
	// 	)
	// )  )  )
	
	// val m20 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
	// 	"SIntBasicSubtract", 
	// 	Map(
	// 		"prec1" -> prec1.toString,
	// 		"prec2" -> prec2.toString,
	// 		"prec_out" -> prec_out.toString
	// 	)
	// )  )  )
	
	// val m21 = List.fill(I*J)( Module( PrimitiveFactory.CreateFixedPointIn1Out1(
	// 	"FixedPointTrigExp", 
	// 	Map(
	// 		"prec1" -> prec_out.toString,
	// 		"prec_out" -> prec_out.toString
	// 	)
	// )  )  )
	
	// //D_prev * Exp(M_prev - M)
	// val m22 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
	// 	"SIntBasicMultiplier", 
	// 	Map(
	// 		"prec1" -> prec_out.toString,
	// 		"prec2" -> prec2.toString,
	// 		"prec_out" -> prec_out.toString			
	// 	)
	// )  )  )
	
	// //2. Accumulate
	// //2. += (.)
	// val m31 = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
	// 	"SIntBasicAdderTree", 
	// 	Map(
	// 		"prec1" -> prec_out.toString,
	// 		"prec_out" -> prec_out.toString,			
	// 		"terms" -> J.toString			
	// 	)
	// )  )  )
	
	// val m32 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
	// 	"SIntBasicAdder", 
	// 	Map(
	// 		"prec1" -> prec_out.toString,
	// 		"prec2" -> prec_out.toString,
	// 		"prec_out" -> prec_out.toString		
	// 	)
	// )  )  )
	
	
}




 object DenseFixedPointOnlineSoftmaxDenominatorPEArrayTest extends App{
 	val file = "./generaced/Primitive/DenseFixedPointOnlineSoftmaxDenominatorPEArray"
 	
	val I = 4
	val J = 2
	val prec = 8
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 		Seq(ChiselGeneratorAnnotation(() => 
			new DenseFixedPointOnlineSoftmaxDenominatorPEArray(
			
				Map(
				
					"prec1i" -> prec.toString,
					"prec1f" -> prec.toString, 
					"prec2i" -> prec.toString,
					"prec2f" -> prec.toString, 
					"prec3i" -> prec.toString,
					"prec3f" -> prec.toString, 
					"i"->I.toString,
					"j"->J.toString,
				
				)
			
			)
		)))	
		
		
 	//Simulation using vcs or iverilog
 	sim.iverilog(svtbfile = file+"/DenseFixedPointOnlineSoftmaxDenominatorPEArray.tb.sv", svfiles = Seq(file+"/DenseFixedPointOnlineSoftmaxDenominatorPEArray.v"), svtb = """
 			initial begin
				Reset();
				
				"""+testbench.set_vector("io_in0", Seq(0,1,2,3,4,5,6,7), "_i")+"""
				"""+testbench.set_vector("io_in0", Seq(0,1,2,3,4,5,6,7), "_f")+"""
				
				
				"""+testbench.set_vector("io_in1", Seq(0,8,2,8), "_i")+"""
				"""+testbench.set_vector("io_in1", Seq(0,8,2,8), "_f")+"""
				
				io_entry_valid = 1; 
				io_exit_ready = 1;
				@(posedge clock);
				#1;
				//assert(io_in0*io_in0 == io_out);
				
 			end
 	""")
 }
 
 
 
 


class DenseSIntOnlineSoftmaxDenominatorPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	val prec3 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) //X
		val in1 =  Vec(I, SInt(prec2.W) )   //M_prev
		val in2 =  Vec(I, SInt(prec3.W) )   //D_prev
		
		val out0 = Vec(I, SInt( prec_out.W)) //M
		val out1 = Vec(I, SInt( prec_out.W)) //D
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	//1. M += Max(M_prev, X)
	val mp = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicMax", 
		Map(
			"prec1" -> prec1.toString,
			"prec_out" -> prec_out.toString	,		
			"terms"   -> J.toString
		)
	)  )  )
	// for(i <- 0 until I){
	// for(j <- 0 until J){
	// 	mp(j+J*i ).io.in0 := io.in0( j+J*i )
	// 	mp(j+J*i ).io.in1 := io.in1( i )
	// }}
	
	//2. D += Exp(X-M) + D_prev * Exp(M_prev - M)
	val m10 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicSubtract", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	val m11 = List.fill(I*J)( Module( PrimitiveFactory.CreateFixedPointIn1Out1(
		"FixedPointTrigExp", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	val m20 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicSubtract", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	val m21 = List.fill(I*J)( Module( PrimitiveFactory.CreateFixedPointIn1Out1(
		"FixedPointTrigExp", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	//D_prev * Exp(M_prev - M)
	val m22 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicMultiplier", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	//2. Accumulate
	//2. += (.)
	val m31 = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicAdderTree", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString,			
			"terms" -> J.toString			
		)
	)  )  )
	
	val m32 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec_out.toString,
			"prec_out" -> prec_out.toString		
		)
	)  )  )
	
	
}










class DenseSIntOnlineSoftmaxNominatorPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	val prec3 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) //X
		val in1 =  Vec(I, SInt(prec2.W) )   //M_prev
		val in2 =  Vec(I, SInt(prec3.W) )   //D_prev
		
		val out0 = Vec(J*I, SInt( prec_out.W)) //M
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	//2. D += Exp(X-M) + D_prev * Exp(M_prev - M)
	val m10 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicSubtract", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	val m11 = List.fill(I*J)( Module( PrimitiveFactory.CreateFixedPointIn1Out1(
		"FixedPointTrigExp", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
	val m2 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicDivider", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec3.toString,
			"prec_out" -> prec_out.toString
		)
	)  )  )
	
}
