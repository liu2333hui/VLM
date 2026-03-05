

package PEArrays
import primitive._
import helper._

import suan._
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 


class DenseSIntFullEltAddPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) 
		val in1 =  Vec(J*I, SInt(prec2.W) )
		
		val out0 = Vec(I*J, SInt( prec_out.W)) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val m = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		m( j+J*i ).io.in0 := io.in0( j+J*i )	
		m( j+J*i ).io.in1 := io.in1( j+J*i )	
		io.out0(j+J*i)     := m( j+J*i ).io.out
	}
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		m(j+J*i).io.exit.ready  := io.exit.ready
		m(j+J*i).io.entry.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := m(0).io.entry.ready //reduce
	io.exit.valid  := m(0).io.exit.valid
	
}



class DenseSIntPartialEltAddPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) 
		val in1 =  Vec(I, SInt(prec2.W) )
		
		val out0 = Vec(I*J, SInt( prec_out.W)) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val m = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		m( j+J*i ).io.in0 := io.in0( j+J*i )	
		m( j+J*i ).io.in1 := io.in1( i )	//Broadcast, Systolic TODOS
		io.out0(j+J*i)     := m( j+J*i ).io.out
	}
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		m(j+J*i).io.exit.ready  := io.exit.ready
		m(j+J*i).io.entry.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := m(0).io.entry.ready //reduce
	io.exit.valid  := m(0).io.exit.valid
	
}


//Accumulation, mean, layer norm mean
class DenseSIntAccumPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) 
		val in1 =  Vec(I, SInt(prec2.W) )
		
		val out0 = Vec(I, SInt( prec_out.W))
		 
		//For accumulation
		val sel = UInt(2.W)
		 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	//Pipeline = 2
	val m1 = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicAdderTree", 
		Map(
			"prec1" -> prec1.toString,
			"prec_out" -> prec_out.toString,			
			"terms" -> J.toString			
		)
	)  )  )
	
	val m2 = List.fill(I)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec_out" -> prec_out.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		m1( i ).io.in0( j ) := io.in0( j+J*i )
		
		
		
		// io.out0(j+J*i)     := m( j+J*i ).io.out
	}
	
		m2( i ).io.in0 := m1(i).io.out
		
		//From next
		when(io.sel === 0.U){
			m2( i ).io.in1 := io.out0(i)	//Broadcast, Systolic TODOS
		}.elsewhen(io.sel === 1.U){
			m2(i ).io.in1 := 0.U //Reset
		}.otherwise{
			m2(i ).io.in1 := io.in1(i)
		}
		
		io.out0(i) := m2(i).io.out
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		m1(i).io.exit.ready  := io.exit.ready
		m1(i).io.entry.valid := io.entry.valid
		m2(i).io.exit.ready  := io.exit.ready
		m2(i).io.entry.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := m1(0).io.entry.ready //reduce
	io.exit.valid  := m2(0).io.exit.valid
	
}







class DenseSIntStdevPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	val prec3 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) //X
		val in1 =  Vec(I, SInt(prec2.W) )   //Mu
		val in2 =  Vec(I, SInt(prec3.W) )  //Sigma_p
		
		val out0 = Vec(I, SInt( prec_out.W)) //Sigma
		
		
		//For accumulation
		val sel = UInt(2.W)
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	//1. X - M
	val m0 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicSubtract", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m0(j+J*i ).io.in0 := io.in0( j+J*i )
		m0(j+J*i ).io.in1 := io.in1( j+J*i )

		
	}}
	
	//2. (X-M)^2
	val m1 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn1Out1(
		"SIntBasicSquare", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m1(j+J*i ).io.in0 := m0(j+J*i).io.out //io.in0( j+J*i )
	}}
	
	//3. += (.)
	val m2 = List.fill(I)( Module( PrimitiveFactory.CreateSIntInNOut1(
		"SIntBasicAdderTree", 
		Map(
			"prec1" -> prec_out.toString,
			"prec_out" -> prec_out.toString,			
			"terms" -> J.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m2(i ).io.in0(j) := m1(j+J*i).io.out
	}}
	
	val m3 = List.fill(I)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec3.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
		m3(i ).io.in0 := m2(i).io.out
		// 	m3(i ).io.in1 := io.in2(i)//m2(j+J*i).io.out
		//From next
		when(io.sel === 0.U){
			m3( i ).io.in1 := io.out0(i)	//Broadcast, Systolic TODOS
		}.elsewhen(io.sel === 1.U){
			m3(i ).io.in1 := 0.U //Reset
		}.otherwise{
			m3(i ).io.in1 := io.in2(i)
		}		
		io.out0(i) := m3(i).io.out
	}
		
		
	//m0 -> m1 -> m2 -> m3
	for(i <- 0 until I){
	for(j <- 0 until J){
		m0(j+J*i).io.entry.valid := io.entry.valid
		io.entry.ready := m0(j+J*i).io.entry.ready
		
		m0(j+J*i).io.exit.ready  := m1(j+J*i).io.entry.ready//io.exit.ready
		m1(j+J*i).io.entry.valid := m0(j+J*i).io.exit.valid 
	
		m1(j+J*i).io.exit.ready  := m2(i).io.entry.ready//io.exit.ready
		m2(i).io.entry.valid := m1(j+J*i).io.exit.valid 
			
		m2(i).io.exit.ready  := m3(i).io.entry.ready//io.exit.ready
		m3(i).io.entry.valid := m2(i).io.exit.valid 
			
		io.exit.valid := m3(i).io.exit.valid
		m3(i).io.exit.ready := io.exit.ready
	}}

	
}









class DenseSIntMaddPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	val prec3 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) //X
		val in1 =  Vec(I, SInt(prec2.W) )   //Gamma
		val in2 =  Vec(I, SInt(prec3.W) )   //Beta
		
		val out0 = Vec(J*I, SInt( prec_out.W)) //O
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	//1. X * Gamma + Beta
	val m0 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicMultiplier", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m0(j+J*i ).io.in0 := io.in0( j+J*i )
		m0(j+J*i ).io.in1 := io.in1( i )
	}}
	
	//2. X * Gamma + Beta
	val m1 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec3.toString,
			"prec_out" -> prec_out.toString		
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m1(j+J*i ).io.in0 := m0(j+J*i).io.out//io.in0( j+J*i )
		m1(j+J*i ).io.in1 := io.in2( i )
	}}
		
	//m0 -> m1
	for(i <- 0 until I){
	for(j <- 0 until J){
		m0(j+J*i).io.entry.valid := io.entry.valid
		io.entry.ready := m0(j+J*i).io.entry.ready
		
		m0(j+J*i).io.exit.ready  := m1(j+J*i).io.entry.ready//io.exit.ready
		m1(j+J*i).io.entry.valid := m0(j+J*i).io.exit.valid 
		
		io.exit.valid := m1(j+J*i).io.exit.valid
		m1(j+J*i).io.exit.ready := io.exit.ready
	}}

	
}



//For Layernorm, batch norm etc.
class DenseSIntAvgNormMaddPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	val prec2 = HardwareConfig("prec2").toInt
	val prec3 = HardwareConfig("prec2").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) //X
		val in1 =  Vec(I, SInt(prec2.W) )   //Mu
		val in2 =  Vec(I, SInt(prec2.W) )   //G
		val in3 =  Vec(I, SInt(prec2.W) )   //B
		
		val out0 = Vec(J*I, SInt( prec_out.W)) //O
		
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	val mp = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicSubtract", 
		Map(
			"prec1" -> prec1.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		mp(j+J*i ).io.in0 := io.in0( j+J*i )
		mp(j+J*i ).io.in1 := io.in1( i )
	}}
	
	//1. (X-Mu) * Gamma + Beta
	val m0 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicMultiplier", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec2.toString,
			"prec_out" -> prec_out.toString			
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m0(j+J*i ).io.in0 := io.in0( j+J*i )
		m0(j+J*i ).io.in1 := io.in2( i )
	}}
	
	//2. X * Gamma + Beta
	val m1 = List.fill(I*J)( Module( PrimitiveFactory.CreateSIntIn2Out1(
		"SIntBasicAdder", 
		Map(
			"prec1" -> prec_out.toString,
			"prec2" -> prec3.toString,
			"prec_out" -> prec_out.toString		
		)
	)  )  )
	
	for(i <- 0 until I){
	for(j <- 0 until J){
		m1(j+J*i ).io.in0 := m0(j+J*i).io.out//io.in0( j+J*i )
		m1(j+J*i ).io.in1 := io.in3( i )
	}}
		
	//m0 -> m1
	for(i <- 0 until I){
	for(j <- 0 until J){

		mp(j+J*i).io.entry <> io.entry
		// .valid := io.entry.valid
		// io.entry.ready := mp(j+J*i).io.entry.ready

		mp(j+J*i).io.exit <> m0(j+J*i).io.entry //.ready  := mo(j+J*i).io.entry.ready//io.exit.ready
		// mo(j+J*i).io.entry.ready := mp(j+J*i).io.exit.valid 

		m0(j+J*i).io.exit.ready  := m1(j+J*i).io.entry.ready//io.exit.ready
		m1(j+J*i).io.entry.valid := m0(j+J*i).io.exit.valid 
		
		io.exit.valid := m1(j+J*i).io.exit.valid
		m1(j+J*i).io.exit.ready := io.exit.ready
	}}

	
}














class DenseSIntConcatPEArray(HardwareConfig:Map[String,String]) extends Module{
	
	val prec1 = HardwareConfig("prec1").toInt
	
	val prec_out = HardwareConfig("prec_out").toInt
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val io = IO(new Bundle{ 
		val in0 =  Vec(J*I, SInt(prec1.W) ) 
		val in1 =  Vec(J*I, SInt(prec1.W) )
		
		val out0 = Vec(I*(J+J), SInt( prec_out.W)) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	val mod = List.fill(I*(J+J))( Module( 
		
		new PipelineData(prec_out)	
	
	))
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){
		mod( 2*j+2*J*i ).io.in.bits := io.in0( j+J*i )
		mod( 2*j+1+2*J*i ).io.in.bits := io.in1( j+J*i )
		
		io.out0(  2*j+2*J*i )  := mod( 2*(j)+2*J*i ).io.out.bits
		io.out0( 2*j+1+2*J*i )  := mod( 2*(j+1)+2*J*i ).io.out.bits

	}
	}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){
		mod(2*j+2*J*i).io.out.ready  := io.exit.ready
		mod(2*j+2*J*i).io.in.valid := io.entry.valid
		mod(2*j+1+2*J*i).io.out.ready  := io.exit.ready
		mod(2*j+1+2*J*i).io.in.valid := io.entry.valid
	}
	}
	// 4
	io.entry.ready := mod(0).io.in.ready //reduce
	io.exit.valid  := mod(0).io.out.valid
	
}
