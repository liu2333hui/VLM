package suan
import networks.{Crossbar,MuxN,SerializerFactory}
import chisel3._
import chisel3.util._
import helper._

import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._

// import chisel3.util.{PopCount, BoolToBitP at}

class PipelinedZeroMapNetwork(HardwareConfig:Map[String, String]) extends Module {
	
	val prec:Int  = HardwareConfig("prec").toInt
	val in_terms:Int = HardwareConfig("in_terms").toInt
	val out_terms:Int = HardwareConfig("out_terms").toInt
	
		val io = IO(new Bundle {
			val zeromap = Input( Vec(in_terms, UInt(1.W)  ) ) 
			val out  = Output( Vec(out_terms, UInt(prec.W)))  
			
			val in     = Input(  Vec(in_terms, UInt(prec.W))) 
	
			val valid = Output(Vec(out_terms, Bool() ))
			val top_valid = Output ( UInt(prec.W) ) 
	
			
			val pipeline_ready = Input( Bool())
			val pipeline_valid = Output( Bool())
	 })  
	
}

class ZeromapGatherIO(val in_terms:Int, val out_terms:Int , val prec:Int) extends Bundle{	
	val zeromap = Input( Vec(in_terms, UInt(1.W)  ) ) 
	val data = new Bundle{
		val in = Input(  Vec(in_terms, UInt(prec.W)))
		val out = Output( Vec(out_terms, UInt(prec.W)))
		val popcnt = Output(UInt(log2Ceil(in_terms + 1).W)) 
	}    
	val out = new ExitIO()
	val in = new EntryIO()
}

class DaXiaoNetworkIO(val in_terms:Int, val out_terms:Int , val prec:Int, val serial_out_terms:Int) extends Bundle{	
	val zeromap = Input( Vec(in_terms, UInt(1.W)  ) ) 
	val data = new Bundle{
		val in = Input(  Vec(in_terms, UInt(prec.W)))
		val out = Output( Vec(out_terms, UInt(prec.W)))
		val popcnt = Output(UInt(log2Ceil(in_terms + 1).W)) 
	}    
	val out = new ExitIO()
	val in = new EntryIO()
	
	
	val serialout = Output( Vec(serial_out_terms, UInt(prec.W)) )
}










//1234 + 0110 -> 23
class SingleStageZeromapGather(val terms:Int, val prec:Int, val sel_prec:Int = 8   ) extends Module {
	
	val io = IO(new ZeromapGatherIO(terms, terms, prec))
	
	val in_terms = terms
	val out_terms = terms
	
	//Modules
	val m = Module(new Crossbar(
		Map(
			"prec" -> prec.toString,
			"in_terms"->in_terms  .toString,
			"out_terms"->out_terms.toString
		)
	))
	val x = Module(new PipelineVecData(prec, out_terms))

	//Similar to Cambricon-X Architecture	
	val zeromap = Wire( Vec(in_terms, UInt(1.W)  ) ) 
	for(i <- 0 until in_terms){
		zeromap(i) := io.zeromap(i)
	}
	
	val zeroadd = Wire(Vec( in_terms, UInt(sel_prec.W)  ) )
	val zeromask = Wire(Vec( in_terms, UInt(sel_prec.W) )  )
	zeroadd(0) := zeromap(0) //- cur_start_idx
	for (i <- 1 until in_terms){
		zeroadd(i) := zeroadd(i-1) + zeromap(i)
	}
	
	for (i <- 0 until in_terms){
		zeromask(i) := zeroadd(i) & Cat(Seq.fill(sel_prec)(zeromap(i)))
	}
	
	val onehot = Wire(Vec (out_terms, Vec (in_terms, Bool() ))) // Reg to satisfy timing...
	
	//x module
	x.io.in.valid := io.in.valid
	x.io.in.bits := m.io.out
	x.io.out.ready := io.out.ready 
	
	//m module	
	for (j <- 0 until out_terms){
		for(i <- 0 until in_terms){
			onehot(j)(i) := (zeromask(i) === (j+1).U)
		}
		m.io.sel(j) := PriorityEncoder(onehot(j).asUInt)
	} 
	m.io.in := io.data.in
	
	//Top
	io.data.out  := x.io.out.bits
	io.out.valid := x.io.out.valid 
	io.in.ready := x.io.in.ready

	io.data.popcnt := RegNext(io.zeromap.reduce(_ +& _) )

	//2nd-Stage
	//Parallel2serial
	//Serializer
	// val combiner = Module(DeserializerFactory.create_general(Map(
	// 	"hardwareType" -> "ShiftDeserializer",
	// 	"prec" -> bw.toString ,
	// 	"out_terms" -> maxlen.toString ,
	// 	 "fanout" -> 1.toString
	// )))
	// combiner.io.in :=  (io.L2.rdata)
	// io.OUT.data := combiner.io.combined_data
	// combiner.io.en := (io.L2.rvalid)// && io.L2.rready)
	// combiner.io.clear := (io.AGU.ready)
	// combiner.io.entry.valid := 1.B
	// combiner.io.exit.ready  := 1.B
	
	
	
}




	

// 1234 + 0110 -> 0120
// class SingleStageZeromapScatter(val terms:Int, val prec:Int, val sel_prec:Int = 8   ) extends Module {	
	
// 	val io = IO(new ZeromapCrossbarIO(terms, terms, prec))
	
// }



//SPARSITY NETWORKS
//Case 1: xiao -> da (scatter)   Memory-Sparsity use (compress)
//Case 2: da -> xiao (gather)    Value-Sparsity use (sparse)
//Case 3: xiao -> xiao (none)    sparse + compress
//Case 4: da -> da               0

//Networks
//1. Ratios (In/Out) (tile to tile)
//2. Precision (is data and compute precision the same?)
//3. Pipeline Stages (1, 2, 3) (stages of the pipeline)



//Sparse
class DaXiaoNetwork(val terms:Int, val prec:Int, val sel_prec:Int = 8 ,
	val serial_out_terms:Int
	) extends Module {
	
	val io = IO(new DaXiaoNetworkIO(terms, terms, prec,serial_out_terms))
	
	val gather = Module(new SingleStageZeromapGather(terms, prec, sel_prec   ))
	val serial = Module(SerializerFactory.create(
		Map( 
			"hardwareType"-> "FixedShiftSerializer",
			"prec"-> prec.toString,
			"in_terms"->terms.toString,
			"out_terms"->serial_out_terms.toString
		)
	))
	
	//Gather
	gather.io.zeromap := io.zeromap
	gather.io.data <> io.data
	gather.io.out.ready := serial.io.in.ready
	gather.io.in <> io.in
	
	//Serializer
	serial.io.datain  := gather.io.data.out
	serial.io.maxcnt := (gather.io.data.popcnt + serial_out_terms.U - 1.U) / (serial_out_terms.U)	
	serial.io.in.valid := gather.io.out.valid
	
	io.out <> serial.io.out
	io.serialout := serial.io.dataout
}	
	














//Crossbar purpose
//132 0 132 0 231 0 12 0 
object DaXiaoNetwork_Test extends App{
	
	val file = "./generated/suan/DaXiaoNetwork"
	
	val terms = 8
	val serial_out_terms = 2
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new DaXiaoNetwork( 
				terms = terms	, prec = 8	,  sel_prec = 8 , serial_out_terms = serial_out_terms
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/DaXiaoNetwork.tb.sv", svfiles = Seq(file+"/DaXiaoNetwork.v"), svtb = """
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				//Trigger
				io_data_in_0 = 18;
				io_data_in_1 = 28;
				io_data_in_2 = 38;
				io_data_in_3 = 48;
				io_data_in_4 = 58;
				io_data_in_5 = 68;
				io_data_in_6 = 78;
				io_data_in_7 = 88;
					
				io_zeromap_0 = 0; 
				io_zeromap_1 = 1;
				io_zeromap_2 = 0;
				io_zeromap_3 = 1;
				io_zeromap_4 = 1;
				io_zeromap_5 = 0;
				io_zeromap_6 = 1;
				io_zeromap_7 = 0;
				
				io_in_valid = 1; 
				io_out_ready = 1;
				
				//Check
				@(posedge clock);
				#1;
				io_in_valid = 0;
				// assert(io_out_bits == io_in_bits);
				// assert(io_out_valid == 1);
				// #1;
				// io_in_bits = 188;
				
			end
	""")
	
	
}



//Crossbar purpose
//132 0 132 0 231 0 12 0 
object SingleStageZeromapGather_Test extends App{
	
	val file = "./generated/suan/SingleStageZeromapGather"
	
	val terms = 8
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new SingleStageZeromapGather( 
				terms = terms	, prec = 8	,  sel_prec = 8 
		  )    )))	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/SingleStageZeromapGather.tb.sv", svfiles = Seq(file+"/SingleStageZeromapGather.v"), svtb = """
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				//Trigger
				io_data_in_0 = 18;
				io_data_in_1 = 28;
				io_data_in_2 = 38;
				io_data_in_3 = 48;
				io_data_in_4 = 58;
				io_data_in_5 = 68;
				io_data_in_6 = 78;
				io_data_in_7 = 88;
					
				io_zeromap_0 = 0; 
				io_zeromap_1 = 1;
				io_zeromap_2 = 0;
				io_zeromap_3 = 1;
				io_zeromap_4 = 1;
				io_zeromap_5 = 0;
				io_zeromap_6 = 1;
				io_zeromap_7 = 0;
				
				io_in_valid = 1; 
				io_out_ready = 1;
				
				//Check
				@(posedge clock);
				#1;
				// assert(io_out_bits == io_in_bits);
				// assert(io_out_valid == 1);
				// #1;
				// io_in_bits = 188;
				
			end
	""")
	
	
}



// class PipelinedZeroMapCrossbar( HardwareConfig:Map[String, String]) extends PipelinedZeroMapNetwork(HardwareConfig) {

//   val sel_prec:Int  = 8 //max 256 input crossbar, HardwareConfig("in_prec").toInt
	
//  // 状态定义
//   val idle :: busy :: Nil = Enum(2)
//   val stateReg = RegInit(idle)      // 初始状态为红灯
  
//   val cur_start_idx =  Reg(UInt(sel_prec.W))
  
//   // val valid = RegInit(0.B)
//   io.pipeline_valid := (io.top_valid+ 1.U === in_terms.U)
//   // io.pipeline_valid  := valid
//   cur_start_idx := 0.U
  
//   // 状态转换逻辑
//   switch(stateReg) {
//     is(idle) {
//       when(io.pipeline_ready) { 
// 		  stateReg := busy   
// 		}
		
//     }
//     is(busy) {
//       when(io.top_valid+ 1.U === in_terms.U){
// 		when(io.pipeline_ready) {
// 		  stateReg := busy 
// 		}.otherwise{
// 		  stateReg := idle   
// 		}
// 		cur_start_idx := 0.U
// 	  }.otherwise{
// 		cur_start_idx := io.top_valid+1.U	
// 	  }
	  
//     }
//   }





// 	val m = Module(new Crossbar(
// 		HardwareConfig
// 	))
// 	m.io.in := RegNext(io.in)
	
// 	val zeromap = Wire( Vec(in_terms, UInt(1.W)  ) ) 
// 	for(i <- 0 until in_terms){
// 		zeromap(i) := RegNext(io.zeromap(i))
// 	}
	
// 	// val out = 
// 	io.out  :=RegNext(m.io.out)
	
	
	
// 	val zeroadd = Wire(Vec( in_terms, UInt(sel_prec.W)  ) )
// 	val zeromask = Wire(Vec( in_terms, UInt(sel_prec.W) )  )
// 	zeroadd(0) := zeromap(0) - cur_start_idx
// 	for (i <- 1 until in_terms){
// 		zeroadd(i) := zeroadd(i-1) + zeromap(i)
// 	}
// 	for (i <- 0 until in_terms){
// 		zeromask(i) := zeroadd(i) & Cat(Seq.fill(sel_prec)(zeromap(i)))
// 	}
// 	val onehot = Reg(Vec (out_terms, Vec (in_terms, Bool() ))) // Reg to satisfy timing...

// 	for (j <- 0 until out_terms){
// 		for(i <- 0 until in_terms){
// 			onehot(j)(i) := (zeromask(i) === (j+1).U)
// 		}
// 		m.io.sel(j) := PriorityEncoder(onehot(j).asUInt)
		
// 		io.valid(j) := (onehot(j).asUInt =/= 0.U)
		
// 		if(j == out_terms-1){
// 			io.top_valid := PriorityEncoder(onehot(j).asUInt) 
// 		}
			
// 	} 
	
// }



