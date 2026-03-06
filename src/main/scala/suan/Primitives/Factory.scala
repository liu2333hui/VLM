package primitive

import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 
// import chisel3.util.experimental.forceName

//Generic Primitives
class UIntIn2Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec2:Int     = HardwareConfig("prec2").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(UInt(prec1.W))
		val in1    = Input(UInt(prec2.W))
		val out  = Output(UInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class BlackBoxUIntIn2Out1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec2:Int     = HardwareConfig("prec2").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(UInt(prec1.W))
		val in1    = Input(UInt(prec2.W))
		val out  = Output(UInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}

class UIntIn1Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(UInt(prec1.W))
		val out  = Output(UInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class BlackBoxUIntIn1Out1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(UInt(prec1.W))
		val out  = Output(UInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class SIntInNOut1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val terms:Int = HardwareConfig("terms").toInt
	val io = IO(new Bundle {
		val in0    = Input(Vec(terms, SInt(prec1.W)))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class BlackBoxSIntInNOut1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val terms:Int = HardwareConfig("terms").toInt
	val io = IO(new Bundle {
		val in0    = Input(Vec(terms, SInt(prec1.W)))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class SIntIn2Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec2:Int     = HardwareConfig("prec2").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(SInt(prec1.W))
		val in1    = Input(SInt(prec2.W))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class BlackBoxSIntIn2Out1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec2:Int     = HardwareConfig("prec2").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(SInt(prec1.W))
		val in1    = Input(SInt(prec2.W))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}

class SIntIn1Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(SInt(prec1.W))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}
class BlackBoxSIntIn1Out1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1:Int     = HardwareConfig("prec1").toInt
	val prec_out:Int  = HardwareConfig("prec_out").toInt
	val io = IO(new Bundle {
		val in0    = Input(SInt(prec1.W))
		val out  = Output(SInt(prec_out.W))
		val entry = new EntryIO()
		val exit = new ExitIO()
	})
}

class FixedPointIn2Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	val prec1i:Int     = HardwareConfig("prec1i").toInt
	val prec1f:Int     = HardwareConfig("prec1f").toInt
	val prec2i:Int     = HardwareConfig("prec2i").toInt
	val prec2f:Int     = HardwareConfig("prec2f").toInt
	val prec_outi:Int     = HardwareConfig("prec_outi").toInt
	val prec_outf:Int     = HardwareConfig("prec_outf").toInt
	
	val io = IO(new Bundle {
		val in0 = new FP(prec1i, prec1f)
		val in1 = new FP(prec2i, prec2f)
		val out = Flipped( new FP(prec_outi, prec_outf) )
		val exit =new  ExitIO()
		val entry = new EntryIO()
	})
	
}
class BlackBoxFixedPointIn2Out1( HardwareConfig : Map[String, String]) extends BlackBox {
	val prec1i:Int     = HardwareConfig("prec1i").toInt
	val prec1f:Int     = HardwareConfig("prec1f").toInt
	val prec2i:Int     = HardwareConfig("prec2i").toInt
	val prec2f:Int     = HardwareConfig("prec2f").toInt
	val prec_outi:Int     = HardwareConfig("prec_outi").toInt
	val prec_outf:Int     = HardwareConfig("prec_outf").toInt
	
	val io = IO(new Bundle {
		val in0 = new FP(prec1i, prec1f)
		val in1 = new FP(prec2i, prec2f)
		val out = Flipped( new FP(prec_outi, prec_outf) )
		val exit =new  ExitIO()
		val entry = new EntryIO()
	})
	
}
class FixedPointIn1Out1( HardwareConfig : Map[String, String]) extends MultiIOModule {
	override def desiredName = HardwareConfig("desiredName")
	
	val preci:Int     = HardwareConfig("prec1i").toInt
	val precf:Int     = HardwareConfig("prec1f").toInt
	val io = IO(new Bundle {
		// val clock = Input(Clock())
		val in0 = new FP(preci, precf)
		val out = Flipped( new FP(preci, precf) )
		val exit =new  ExitIO()
		val entry = new EntryIO()
	})
	
	// io.forceName("")
}
class BlackBoxFixedPointIn1Out1( HardwareConfig : Map[String, String]) extends BlackBox {	
	override def desiredName = HardwareConfig("desiredName")

	val preci:Int     = HardwareConfig("prec1i").toInt
	val precf:Int     = HardwareConfig("prec1f").toInt
	val io = IO(new Bundle {
		val clock = Input(Clock())
		val reset = Input(Bool())
		val io = new Bundle{
			val in0 = new FP(preci, precf)
			val out = Flipped( new FP(preci, precf) )
			val exit =new  ExitIO()
			val entry = new EntryIO()
		}
	})
	
}

//BinaryIn1Out1
//BinaryIn2Out1

//Factory Method
object PrimitiveFactory {
	def CreateUIntIn1Out1( primitive_name:String,  HardwareConfig : Map[String, String] ): UIntIn1Out1  = {
		val out =   primitive_name match {
			case "UIntBasicSquare" => new UIntBasicSquare(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
	}

	def CreateUIntIn2Out1( primitive_name:String,  HardwareConfig : Map[String, String] ): UIntIn2Out1 = {
		val out =   primitive_name match {
			case "UIntBasicMultiplier" => new UIntBasicMultiplier(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
	}



	def CreateSIntIn1Out1( primitive_name:String,  HardwareConfig : Map[String, String] ): SIntIn1Out1  = {
		val out =   primitive_name match {
			case "SIntBasicSquare" => new SIntBasicSquare(HardwareConfig)
			// case "SIntTrigCos" => new SIntTrigCos(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
	}

	def CreateSIntIn2Out1( primitive_name:String,  HardwareConfig : Map[String, String] ): SIntIn2Out1 = {
		val out =   primitive_name match {
			case "SIntBasicMultiplier" => new SIntBasicMultiplier(HardwareConfig)
			
			case "SIntBasicSubtract" => new SIntBasicSubtract(HardwareConfig)
			
			case "SIntMax2" => new SIntMax2(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
	}
	
	def CreateSIntInNOut1( primitive_name:String,  HardwareConfig : Map[String, String] ): SIntInNOut1 = {
		val out =   primitive_name match {
			case "SIntBasicAdderTree" => new SIntBasicAdderTree(HardwareConfig)
			case "SIntMaxN" => new SIntMaxN(HardwareConfig)
			// case "SIntBasicAdderSum" => new SIntBasicAdderSum(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
	}
	
	
	def CreateBlackBoxFixedPointIn1Out1( primitive_name:String,  HardwareConfig : Map[String, String],
			 save_folder:String,
			 id:Integer = 0,
			desired_name:String = "",
		 ):BlackBoxFixedPointIn1Out1 = {
		
		// val save_folder = "./generaced/Primitive/DenseFixedPointOnlineSoftmaxDenominatorPEArray"
 	
		//Create module?
		println(primitive_name + "\t" + id + "\t" + desired_name)
		if(id == 0){
			"Creating instance ... "
			new (chisel3.stage.ChiselStage).execute(Array("--target-dir", save_folder ),
				Seq(ChiselGeneratorAnnotation(() => 
					CreateFixedPointIn1Out1( primitive_name, HardwareConfig, desired_name  )				
			)))	
			
		}
			
		//Return the Blackbox
		new BlackBoxFixedPointIn1Out1(HardwareConfig + ("desiredName" -> desired_name) )		
	}
	
	def CreateFixedPointIn1Out1( primitive_name:String,  HardwareConfig : Map[String, String]	, desired_name:String = ""	): FixedPointIn1Out1  = {

		var pseudoname = desired_name
		if(desired_name == ""){
			pseudoname = primitive_name
		}
		var hc = HardwareConfig + ("desiredName" -> pseudoname)

		val out =   primitive_name match {
			case "FixedPointTrigExp" => new FixedPointTrigExp(hc)
			case "FixedPointTrigSin" => new FixedPointTrigSin(hc)
			case "FixedPointTrigCos" => new FixedPointTrigCos(hc)
			
			// case "SIntTrigCos" => new SIntTrigCos(HardwareConfig)
			case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
		}
		out
		
	}
	
	
	
	// def CreateFixedPointIn2Out1( primitive_name:String,  HardwareConfig : Map[String, String] ): SIntIn2Out1 = {
	// 	val out =   primitive_name match {
	// 		case "SIntBasicMultiplier" => new SIntBasicMultiplier(HardwareConfig)
	// 		case _     => throw new IllegalArgumentException("Unknown type " + primitive_name)
	// 	}
	// 	out
	// }
	
		
	//CreateFixedPointIn2Out1
	//CreateFloatIn2Out1
	//CreateSignedIn2Out1
	
}
  
  
  
  
 
