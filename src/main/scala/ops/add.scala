package ops

import chisel3._
import chisel3.util._
import scala.collection.mutable.Queue
import play.api.libs.json._
import scala.io.Source
import chisel3.stage.ChiselGeneratorAnnotation
import suan._
import helper._

// class cacheio extends Bundle {
	
// }
// class dramio extends Bundle {
	
// }


class addio(val idxCnt:Int = 2, val idxPrec:Int = 16, val addrPrec:Int = 16,
	val bw:Int = 64, sramDepth:Int = 4096, val dramPrec:Int = 32
) extends Bundle {
	
	val idx = new Bundle{
		val limit = Input(Vec(idxCnt, UInt(idxPrec.W)))
		val rellimit = Input(Vec(idxCnt, UInt(idxPrec.W)))
	}
	val enable = Input(UInt(1.W))
	
	val debug = new Bundle{
		val cnt = Output(Vec(idxCnt, UInt(idxPrec.W)))
		val relcnt = Output(Vec(idxCnt, UInt(idxPrec.W)))
	
		val addr = Output( UInt(addrPrec.W) )
		val ready = Input(UInt(1.W))
	}
	
	
	val cache = (Flipped(new sramIO(bw = bw , depth = sramDepth )))  
	val dram = Flipped(new dramIO(bw = bw , addrPrec = dramPrec ) ) 
	
}

class add(val hw:String) extends Module {
	val rtString = Source.fromFile(hw).mkString
	val parsed = Json.parse(rtString)
	// (parsed \ "" ).as
	
	//HW parameters
 	val addrPrec= 16
	
	val idxCnt  = 2
	val idxPrec = 16
	val idxTile = List(4, 4)
	
	val data0Prec = 8
	val data1Prec = 8
	val memWidth = 64
	val sramDepth = 4096
	val dramPrec = 32
	
	val io = IO(
		new addio( idxCnt = idxCnt, idxPrec = idxPrec , addrPrec = addrPrec )
	)
	
	//1. Counter
	//i,j,k
	//idxCnt:Int,val idxPrec:Int,val idxTile:
	val CounterUnit = Module(new counter( idxCnt = idxCnt, idxPrec = idxPrec, idxTile = idxTile  ) )
	//(Blackbox later)
	// CounterUnit.io.idx.limit := io.idx.limit
	CounterUnit.io.idx.limit := io.idx.limit
	// CounterUnit.io.in.bits := 1.B
	
	//2. Address Unit
	val AddressUnit = Module(new address(  idxCnt=idxCnt , addrPrec=addrPrec, idxPrec=idxPrec, 
		MultThroughput=1, MultDelay=4, MultPrec1=8, MultPrec2=8
	) )
	AddressUnit.io.idx.rellimit := io.idx.rellimit
	AddressUnit.io.idx.relcnt := CounterUnit.io.idx.relcnt
	// AddressUnit.io.in.bits := 1.B
	
	//3. DMA Unit
	val DMAUnit = Module(new dma( bw = memWidth , sramDepth = sramDepth ,  dramPrec = dramPrec , addrPrec = addrPrec))
	DMAUnit.io.cache  <>  io.cache
	DMAUnit.io.dram  <>  io.dram
	DMAUnit.io.in.bits := 1.B
	DMAUnit.io.data.reuse := 0.B
	DMAUnit.io.data.addr := AddressUnit.io.addr
	// DMAUnit.rdata :=
	// val reuseCalcUnit = Module(new reuse() )
	//May need arbiter
	
	//3.5 Sparsity (todos)
	
	
	//4. Computation
	// val ADDUnit = Module(new addunit(  ))
	

	//pipelinining
	CounterUnit.io.in.valid := RegNext(io.enable)
	CounterUnit.io.out.ready := RegNext(AddressUnit.io.in.ready)
	
	AddressUnit.io.in.valid := RegNext(CounterUnit.io.out.valid)
	AddressUnit.io.out.ready := RegNext(DMAUnit.io.in.ready)//1.U	
	
	DMAUnit.io.in.valid := RegNext(AddressUnit.io.in.valid)
	DMAUnit.io.out.ready:= RegNext(io.debug.ready)
	
	//Debug
	io.debug.cnt := CounterUnit.io.idx.cnt
	io.debug.relcnt := CounterUnit.io.idx.relcnt
	io.debug.addr := AddressUnit.io.addr
	
}


object addtest extends App {
	
	
	val hw = args(args.length - 2)
	val rt = args(args.length - 1)
	
	//clock, input precisions?
	val file = "./generated/ops/add"
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  add(  hw   )  )) )
	
	val rtString = Source.fromFile(rt).mkString
	val parsed = Json.parse(rtString)
	
	val in0 = (parsed \ "inTensors0" ).as[ List[Int ] ]
	val in1 = (parsed \ "inTensors1" ).as[ List[Int ] ]

	val hwString = Source.fromFile(hw).mkString
	val arch = Json.parse(hwString)
	
	val itile = (arch \ "add" \ "itile" ).as[ Int  ]
	val btile = (arch \ "add" \ "btile" ).as[ Int  ]
	
	var sum = 1
	in0.slice(0,in0.length-1).foreach(sum *= _)
	val ilim = sum;
	val blim = in0(in0.length -1);
	
	val irellim :Int = ilim / itile
	val brellim :Int = blim / btile
	
	
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = file+"/add.tb.sv", svfiles = Seq(file+"/add.v"), svtb = """
		
			initial begin
				reset = 0;
				io_idx_limit_0 = """+ilim+""";
				io_idx_limit_1 = """+blim+""";
				io_idx_rellimit_0 = """+irellim+""";
				io_idx_rellimit_1 = """+brellim+""";
				io_enable = 0;
				io_debug_ready = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				io_enable = 1;
				
				io_debug_ready = 1;
				//@(posedge io_out_valid);
				#500;
				$finish;
				
			end
			
			
			byte a[4096];
			byte b[4096];
			
			initial
			foreach(a[j]) begin
				a[j] = $urandom;	
			end
			
			initial begin
			    forever @(posedge clock) begin
						
						  // output [31:0] io_dram_araddr,
						  // output        io_dram_arvalid,
						  // input         io_dram_arready,
						  // input  [63:0] io_dram_rdata,
						  // input         io_dram_rvalid,
						  // output        io_dram_rready
						// io_dram_arready = 1;
						// if(io_dram_rvalid){
							io_dram_rdata = #40 a[io_dram_araddr];
						// 	io_dram_rvalid = #40 1;
						// }else{
						// 	io_dram_rvalid = 0;
						// }
						//io_dram_arready
						//io_dram_rvalid
					
				end
			end
	""")
	println(in0)
	println(in1)
}