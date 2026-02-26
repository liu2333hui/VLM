//Parallel2Serial, Serializer
package networks

import chisel3._
import chisel3.util._
import scala.collection.mutable.Queue
import helper._

import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._

//Used in systolic flows
class GenericParallel2Serial( HardwareConfig:Map[String, String]) extends Module {

   val prec:Int  = HardwareConfig("prec").toInt
   val terms:Int  = HardwareConfig("terms").toInt //Ratio, terms:1
   val fanout:Int  = HardwareConfig("fanout").toInt



	val io = IO(new Bundle{
		val in = Input(Vec(terms, UInt(prec.W)))
		val out = Output(Vec(fanout, UInt(prec.W)))
		val en = Input(Bool())

		val entry = new EntryIO()
		val exit = new ExitIO()
	})


}

class GenericSerializer( HardwareConfig:Map[String, String]) extends Module {

   // val prec:Int  = HardwareConfig("prec").toInt
   // val terms:Int  = HardwareConfig("terms").toInt //Ratio, terms:1
   // val fanout:Int  = HardwareConfig("fanout").toInt
   
   val prec      = HardwareConfig("prec").toInt
   val in_terms  = HardwareConfig("in_terms").toInt 
   val out_terms = HardwareConfig("out_terms").toInt
   
   
	val io = IO(new Bundle{
		val datain = Input(Vec(in_terms, UInt(prec.W)))
		val dataout = Output( Vec(out_terms, UInt(prec.W)  ))
		// val clear = Input(Bool())
		// val en = Input(Bool())
		val maxcnt = Input( UInt(16.W) )
		
		val in = new EntryIO()
		val out = new ExitIO()
	})


}

class FixedShiftSerializerIO(val prec:Int, val in_terms:Int, val out_terms:Int) extends Bundle{
	val datain = Input(Vec(in_terms, UInt(prec.W)))
	val dataout = Output( Vec(out_terms, UInt(prec.W)  ))
	// val clear = Input(Bool())
	// val en = Input(Bool())
	
	val in = new EntryIO()
	val out = new ExitIO()
}
class UniversalShiftSerializerIO(val prec:Int, val in_terms:Int, val out_terms:Int, val maxshift:Int) extends Bundle{
	
// } FixedShiftSerializerIO(
	// prec, in_terms, out_terms
	// ){
	val datain = Input(Vec(in_terms, UInt(prec.W)))
	val dataout = Output( Vec(out_terms, UInt(prec.W)  ))
	val clear = Input(Bool())
	
	val in = new EntryIO()
	val out = new ExitIO()
	// val fixed = new FixedShiftSerializerIO(prec, in_terms, out_terms)
	val shift = Input(UInt(maxshift.W))
}


object Parallel2SerialFactory {
  
  def create_general( HardwareConfig : Map[String, String] ): GenericParallel2Serial = {
		val hardwareType:String  = HardwareConfig("hardwareType").toString

		val out =  hardwareType match {
			case "MuxParallel2Serial" => new MuxParallel2Serial(HardwareConfig)
			case "ShiftParallel2Serial" => new ShiftParallel2Serial(HardwareConfig)
			case "Mux" => new MuxParallel2Serial(HardwareConfig)
			case "Shift" => new ShiftParallel2Serial(HardwareConfig)
			// case "FixedShiftSerializer" => new FixedShiftSerializer(HardwareConfig)
	
			//Other types ...? SRAM or FIFO based?

			case _     => throw new IllegalArgumentException("Unknown Parallel2Serial type")
		}
	  out
	  
  }

  }
  
  
  
object SerializerFactory {
    
    def create( HardwareConfig : Map[String, String] ): GenericSerializer = {
  		val hardwareType:String  = HardwareConfig("hardwareType").toString
  
  		val out =  hardwareType match {
  			case "FixedShiftSerializer" => new FixedShiftSerializer(HardwareConfig)
  	
  			//Other types ...? SRAM or FIFO based?
  
  			case _     => throw new IllegalArgumentException("Unknown Parallel2Serial type")
  		}
  	  out
  	  
    }
  
    }
    
  
//12345678  -> 12 34 56 78
class FixedShiftSerializer(HardwareConfig:Map[String, String]) extends GenericSerializer(HardwareConfig){
	// val prec      = HardwareConfig("prec").toInt
	// val in_terms  = HardwareConfig("in_terms").toInt 
	// val out_terms = HardwareConfig("out_terms").toInt
	
	// val io = new FixedShiftSerializerIO(prec, in_terms, out_terms)
	
	//use maxcnt
	// HardwareConfig.get("use_maxcnt", )
	val Delay = io.maxcnt //in_terms / out_terms
	
	val shiftReg = Reg(Vec(in_terms,UInt(prec.W)))
	
	val counter  = RegInit(0.U(log2Ceil(in_terms / out_terms+1).W))
	
	//Counter is the state
	io.out.valid := counter > 0.U && counter <= Delay
	io.in.ready  := counter === 0.U || counter === Delay
	
	
	//In terms, 8, out terms, 2
	//shift by 2, delay = 4, throughput = 2
	when ( counter === 0.U){
		when( io.in.ready && io.in.valid ) {
			for(i <- 0 until in_terms){
				shiftReg(i) := io.datain(i)
			}
			counter  := 1.U
		}
	} .elsewhen(counter > 0.U){
		when(io.out.valid && io.out.ready) {
		
			//Forwarding
			when(io.in.ready && io.in.valid){
				for(i <- 0 until in_terms){
					shiftReg(i) := io.datain(i)
				}	
				counter := 1.U
			//End Condition
			}.elsewhen(io.in.ready){
				counter := 0.U
			//Update condition
			}.otherwise{
				for(i <- 0 until in_terms){
					if(i < out_terms){
						//need to be shifted
						shiftReg(i) :=  0.U
					}else{
						//need to not be shifted
						shiftReg(i-out_terms) := shiftReg(i)
					}
				}
				counter  := counter + 1.U
			}
		
		}
	}
	
	for(j <- 0 until out_terms){
		io.dataout(j) := shiftReg(j)
	}
  
}


//Crossbar purpose
//132 0 132 0 231 0 12 0 
object FixedShiftSerializer_Test extends App{
	
	val file = "./generated/suan/FixedShiftSerializer"
	
	val in_terms = 8
	val out_terms = 2
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new FixedShiftSerializer( 
				Map(
					"prec"->8.toString,
					"in_terms"->in_terms.toString,
					"out_terms"->out_terms.toString
				)
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/FixedShiftSerializer.tb.sv", svfiles = Seq(file+"/FixedShiftSerializer.v"), svtb = """
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				//Trigger
				io_maxcnt = 2;
				io_datain_0 = 18;
				io_datain_1 = 28;
				io_datain_2 = 38;
				io_datain_3 = 48;
				io_datain_4 = 58;
				io_datain_5 = 68;
				io_datain_6 = 78;
				io_datain_7 = 88;
						
				io_in_valid = 1; 
				io_out_ready = 1;
				
				//Check
				@(posedge clock);
				
				io_in_valid = 0; 
				#1;
				// assert(io_out_bits == io_in_bits);
				// assert(io_out_valid == 1);
				// #1;
				// io_in_bits = 188;
				
			end
	""")
	
	
}


  

class MuxParallel2Serial( HardwareConfig:Map[String, String]) 
	extends GenericParallel2Serial(HardwareConfig){

		//special case = max_out terms ==1, then cannot use mux, must use the multicast
		if(terms == 1){
			io.entry.ready := 1.U
			io.exit.valid := 1.U		

			val multicast : Multicast = Module(new Multicast(HardwareConfig
				+  ("terms" -> 1.toString) 
				+ ("fanout" -> fanout.toString)
				+ ("buffered" -> true.toString)   
			))

			multicast.io.en := io.en
			for (j <- Array.range(0, terms)){

				multicast.io.in(j) := io.in(j)
	
			}

				/*
			for(i <- Array.range(0, fanout)){
				io.out(i) := multicast.io.out(0)(i)
			}
				*/	

			for (l <- Array.range(0, terms)){
				for(k <- Array.range(0, fanout)){
					io.out(k) := multicast.io.out(l)(k)
				}
			}

	
		} else {


		val mux :MuxN= Module(new MuxN(HardwareConfig 
			+ ("terms" -> terms.toString) ))
		val multicast : Multicast = Module(new Multicast(HardwareConfig
			+  ("terms" -> 1.toString) 
			+ ("fanout" -> fanout.toString)
			+ ("buffered" -> false.toString)   
		))
	
		val cnt = Reg(UInt(prec.W))
		val data = Reg(Vec(terms,UInt(prec.W)))

		// io.entry.ready := (cnt == 0) & io.entry.valid
		io.entry.ready := (cnt === 0.U) && io.entry.valid
		io.exit.valid := 1.U

		when(cnt === 0.U){
			data := io.in
		}


		when(io.en){
			when(cnt === (terms-1).U){
				cnt := 0.U
			}.otherwise{
				cnt := cnt + 1.U
			}
		}

		multicast.io.en := io.en
		multicast.io.in(0) := mux.io.out

		for(i <- Array.range(0, fanout)){
			io.out(i) := multicast.io.out(0)(i)
		}
		
		mux.io.in := data
		mux.io.sel := cnt
		
	}
}

class ShiftParallel2Serial( HardwareConfig:Map[String, String]) 
	extends GenericParallel2Serial(HardwareConfig){
	

			// val mux :MuxN= Module(new MuxN(HardwareConfig 
			// + ("terms" -> terms.toString) ))
		val multicast : Multicast = Module(new Multicast(HardwareConfig
			+  ("terms" -> 1.toString) 
			+ ("fanout" -> fanout.toString)
			+ ("buffered" -> false.toString)   
		))
	
		val cnt = Reg(UInt(prec.W))
		val data = Reg(Vec(terms,UInt(prec.W)))

		// io.entry.ready := (cnt == 0) & io.entry.valid
		io.entry.ready := (cnt === 0.U) && io.entry.valid
		io.exit.valid := 1.U

		when(cnt === 0.U){
			data := io.in
		}.otherwise{
			for (i <- Array.range(1, terms)){
				data(i-1) := data(i) 
			}
		}

		multicast.io.in(0) := data(0)

		when(io.en){
			when(cnt === (terms-1).U){
				cnt := 0.U
			}.otherwise{
				cnt := cnt + 1.U
			}
		}

		multicast.io.en := io.en
		// multicast.io.in(0) := mux.io.out

		for(i <- Array.range(0, fanout)){
			io.out(i) := multicast.io.out(0)(i)
		}
		
		// mux.io.in := data
		// mux.io.sel := cnt


	// loading
	// val data = Reg(UInt(prec.W))
	
	// io.out := data(out_prec-1, 0)		

	// when(io.en){
	// when(io.mode === 0.U){
	// 	data := io.in		
	// }.otherwise{
		
	// 	data := Cat(data(out_prec-1, 0)  , data(in_prec-1,out_prec ) ) 
	// }
	// }


}
