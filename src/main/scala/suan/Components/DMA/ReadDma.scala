package suan


import chisel3._
import chisel3.util._
import blocks.FixedBlock


import chisel3._
import chisel3.util._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.sys.process._

import suan._
import helper._

import networks._


//IO

class sramIO(val bw: Int = 64, val depth: Int = 16) extends Bundle{
    val addr = Input(UInt(log2Ceil(depth).W))
    val dataIn = Input(UInt(bw.W))
    val dataOut = Output(UInt(bw.W))
    val wen = Input(Bool()) // 写使能
}

//Master
class dramIO(val bw:Int = 64,val addrPrec:Int = 32) extends Bundle {
	    // 用户写数据通道
	    // val s_axi_awaddr = Input(UInt(32.W))
	    // val s_axi_awvalid = Input(Bool())
	    // val s_axi_awready = Output(Bool())
	    
	    // val s_axi_wdata = Input(UInt(32.W))
	    // val s_axi_wvalid = Input(Bool())
	    // val s_axi_wready = Output(Bool())
	    
	    // 用户读数据通道
	    val araddr = Input(UInt(addrPrec.W))
	    val arvalid = Input(Bool())
	    val arready = Output(Bool())
		val arlen = Input(UInt(8.W))
		
	    val rdata = Output(UInt(bw.W))
	    val rvalid = Output(Bool())
	    val rready = Input(Bool())
		
		val last = Output(Bool())
	
}

class dmaIO(val bw:Int, val sramDepth :Int, val dramPrec:Int, val addrPrec:Int) extends Bundle {
		val out = Decoupled(Bool()) 
		val in = Flipped(Decoupled(Bool()))
		
		val data = new Bundle{
			
			val reuse = Input(Bool())
			val addr = Input(UInt(addrPrec.W))
			val rdata = Output(UInt(bw.W))
		}
		//Implement readIOs first
		val cache = Flipped(new sramIO(bw = bw , depth = sramDepth )  )
		val dram = Flipped(new dramIO(bw = bw , addrPrec = dramPrec ) )
}





//For testing purposes
class counter_address_dma1var(val addrPrec:Int, val idxPrec:Int, val idxTile:Int,
	val bw :Int, val maxlen:Int, val dataPrec:Int ) extends Module{
	
	val io = IO(new Bundle{
		//Counter
		val idx = new Bundle{
			val limit = Input(Vec(1, UInt(idxPrec.W)))
			val rellimit = Input(Vec(1, UInt(idxPrec.W)))
		}	
		val addr = Output( UInt(addrPrec.W) )
	
		//IO
		val in = new EntryIO()
		// val out = new ExitIO()
		
		val done = Output(Bool())
		
		//DMA
		val L2 = Flipped(new dramIO(bw = bw, addrPrec = addrPrec))
		val out = new Bundle{
			val valid = Output(Bool())
			val ready = Input(Bool())
			val data = Output(UInt((bw*maxlen).W))
		}
	})
	
	//Modules
	val dmaMod =  Module(new  mmu1var(
			 bw = bw, addrPrec = addrPrec, maxlen = maxlen
		))
	val addrMod = Module(new address1var( addrPrec = addrPrec, idxPrec = idxPrec  ) )
	val cntMod = Module(new counter( idxCnt = 1, idxPrec = idxPrec, idxTile = List(idxTile) ))		
			
	//io
	io.in.ready := cntMod.io.in.ready
	io.out.valid := dmaMod.io.OUT.valid
	io.addr := addrMod.io.addr
	io.done := cntMod.io.done
	io.out.data := dmaMod.io.OUT.data
	
	//counter
	cntMod.io.idx.limit := io.idx.limit
	cntMod.io.out.ready := addrMod.io.in.ready //RegNext(pipeline.io.pipe_allowin_internal(0))
	cntMod.io.in.valid  := io.in.valid//pipeline.io.validout_internal(0)  
	
	//address
	addrMod.io.idx.rellimit := io.idx.rellimit
	addrMod.io.idx.relcnt   := cntMod.io.idx.relcnt
	addrMod.io.out.ready    := dmaMod.io.AGU.ready //RegNext(pipeline.io.pipe_allowin_internal(1))
	addrMod.io.in.valid     := cntMod.io.out.valid

	//dma read var 1
	dmaMod.io.L2 <> io.L2
	dmaMod.io.AGU.valid := addrMod.io.out.valid
	dmaMod.io.AGU.addr  := (addrMod.io.addr * ((idxTile * dataPrec)/bw).U )
	dmaMod.io.AGU.arlen := ((idxTile * dataPrec)/bw).U 
	dmaMod.io.OUT.ready := io.out.ready
	
}





//Address -> L1
//Address -> L2 -> L1
//Address -> Dram (-> L2) -> L1

//Weight + Act
//Addr1 + Addr2 -> L1 read L1 read (sync)
//Bits1 + Bits2 
//Addr1 + Addr2 -> L2 read L2 read (sync)


class mmu1var(val bw:Int = 32, val addrPrec :Int = 16, val maxlen:Int = 8) extends Module {

	val io = IO(new Bundle{
		
		val L2 = Flipped(new dramIO(bw = bw, addrPrec = addrPrec))
		val AGU = new Bundle{
			val valid = Input(Bool())
			val ready = Output(Bool())
			val addr  = Input(UInt(addrPrec.W))
			val arlen = Input(UInt(8.W))
		}
		val OUT = new Bundle{
			val valid = Output(Bool())
			val ready = Input(Bool())
			val data = Output(UInt((bw*maxlen).W))
		}
	})
	
	
	io.OUT.data := 0.U
	
	//FSM
	val sIdle :: sDramRead :: Nil = Enum(2)
	
	val state = RegInit(sIdle)
	val cnt = RegInit(0.U(8.W))
	var addr = Wire(UInt(addrPrec.W))
	var addrSaved = Reg(UInt(addrPrec.W))
	var AddrNext = RegNext(io.AGU.addr)//(UInt(addrPrec.W))
	val valid = RegInit(0.U(1.W))
	
	
	//AGU -> AR -> RR -> OUT
	//AGU is ready when ready state + not valid
	when(io.OUT.ready){
		io.AGU.ready := (cnt >= (io.L2.arlen) && io.L2.rvalid) || state === sIdle //&& io.L2.rvalid
	}.otherwise{
		io.AGU.ready := cnt === 0.U && state === sIdle//!io.OUT.valid && (cnt > (io.L2.arlen) || state === sIdle) //&& io.L2.rvalid
	}
	// io.AGU.ready := cnt >= (io.L2.arlen-1.U) || state === sIdle //&& io.L2.rvalid
	
	//send address ready
	
	when(io.OUT.ready){
		io.L2.arvalid := io.AGU.valid//(io.AGU.valid && io.AGU.ready) || cnt > 0.U// (io.L2.arlen-1.U)
	}.otherwise{
		io.L2.arvalid := io.L2.rready && ((io.AGU.valid && io.AGU.ready) || cnt > 0.U)
	}
	//read ready always available
	when(io.OUT.valid && !io.OUT.ready){
		io.L2.rready  := 0.U
	}.otherwise{
		io.L2.rready  := 1.U
	}
	//io.OUT.valid//1.U//io.OUT.ready || !io.OUT.valid
	
	//OUT valid: the count should exeed the length + if(ready) next will be not valid
	val validWire = Wire(UInt(1.W))
	when(io.OUT.ready){
		validWire := cnt >= (io.L2.arlen) && io.L2.rvalid
	}.otherwise{
		when(io.L2.rvalid){
			validWire := cnt >= (io.L2.arlen)
			valid := cnt >= (io.L2.arlen)
		}.otherwise{
			validWire := valid
		}
		 
	}
	//One delay for combiner
	io.OUT.valid := RegNext(validWire)//combiner.io.exit.ready
	
	// io.OUT.valid := cnt >= (io.L2.arlen) && io.L2.rvalid
	
	val arlen = io.AGU.arlen
	io.L2.arlen := arlen
	
	// io.out.valid := cnt >= (Delay).U
	// io.in.ready := (io.out.ready&&io.out.valid || (cnt === 0.U)).asUInt
	
	// when((io.AGU.valid && io.AGU.ready) || cnt === 0.U ){
		
	// when((io.AGU.valid && io.AGU.ready) || cnt === 0.U ){
	// 	addr := io.AGU.addr
	// 	addrSaved := io.AGU.addr
	// }.elsewhen(io.L2.rvalid && io.L2.rready){
	// 	addr := addrSaved + 1.U
	// 	addrSaved := addrSaved + 1.U
	// }otherwise{
	// 	addr := addrSaved
	// 	addrSaved := addrSaved
	// }
	
	// cnt := 0.U
	io.L2.araddr  := addr
	addr := addrSaved
	addrSaved := addrSaved
	
	
		switch(state){
			is(sIdle){
				cnt := 0.U
				addr := io.AGU.addr
				addrSaved := io.AGU.addr
				when(io.L2.arready && io.L2.arvalid  ){
					state := sDramRead
					cnt := cnt + 1.U
				}
			}
			is(sDramRead){
			
				
				//Done with one read
				when(io.L2.rvalid && io.L2.rready){
					cnt := cnt + 1.U
					addr := addrSaved + 1.U
					addrSaved := addrSaved + 1.U				

					//Done with total read
					when(cnt >= (arlen) ){
						
						
						when(!io.OUT.ready){
							state := sDramRead
						}.otherwise{
						
							when(io.L2.arready && io.L2.arvalid  ){
								state := sDramRead
								cnt := 1.U
								addr := AddrNext
								addrSaved := AddrNext

							
							}.otherwise{
								state := sIdle
								cnt := 0.U				
							}
							
						} 
					}
					
					
				}
			}
		}
			
	
	//end of main logic
	
	//Need a deserializer
	//32, 32, 32, --> 
	val combiner = Module(DeserializerFactory.create_general(Map(
		"hardwareType" -> "ShiftDeserializer",
		"prec" -> bw.toString ,
		"out_terms" -> maxlen.toString ,
		 "fanout" -> 1.toString
	)))
	combiner.io.in :=  (io.L2.rdata)
	io.OUT.data := combiner.io.combined_data
	combiner.io.en := (io.L2.rvalid)// && io.L2.rready)
	combiner.io.clear := (io.AGU.ready)
	combiner.io.entry.valid := 1.B
	combiner.io.exit.ready  := 1.B
	
	
			
}



































// class mmu1var_compress(val bw:Int = 32, val addrPrec :Int = 16, val maxlen:Int = 8) extends Module {

// 	val io = IO(new Bundle{
		
// 		val L2 = Flipped(new dramIO(bw = bw, addrPrec = addrPrec))
// 		val AGU = new Bundle{
// 			val valid = Input(Bool())
// 			val ready = Output(Bool())
// 			val addr  = Input(UInt(addrPrec.W))
// 			val arlen = Input(UInt(8.W))
// 		}
// 		val OUT = new Bundle{
// 			val valid = Output(Bool())
// 			val ready = Input(Bool())
// 			val data = Output(UInt((bw*maxlen).W))
// 		}
// 	})
	
	
// 	io.OUT.data := 0.U
	
// 	//FSM
// 	val sIdle :: sDramRead :: Nil = Enum(2)
	
// 	val state = RegInit(sIdle)
// 	val cnt = RegInit(0.U(8.W))
// 	var addr = Wire(UInt(addrPrec.W))
// 	var addrSaved = Reg(UInt(addrPrec.W))
// 	var AddrNext = RegNext(io.AGU.addr)//(UInt(addrPrec.W))
// 	val valid = RegInit(0.U(1.W))
	
	
// 	//AGU -> AR -> RR -> OUT
// 	//AGU is ready when ready state + not valid
// 	when(io.OUT.ready){
// 		io.AGU.ready := (cnt >= (io.L2.arlen) && io.L2.rvalid) || state === sIdle //&& io.L2.rvalid
// 	}.otherwise{
// 		io.AGU.ready := cnt === 0.U && state === sIdle//!io.OUT.valid && (cnt > (io.L2.arlen) || state === sIdle) //&& io.L2.rvalid
// 	}
// 	// io.AGU.ready := cnt >= (io.L2.arlen-1.U) || state === sIdle //&& io.L2.rvalid
	
// 	//send address ready
	
// 	when(io.OUT.ready){
// 		io.L2.arvalid := io.AGU.valid//(io.AGU.valid && io.AGU.ready) || cnt > 0.U// (io.L2.arlen-1.U)
// 	}.otherwise{
// 		io.L2.arvalid := io.L2.rready && ((io.AGU.valid && io.AGU.ready) || cnt > 0.U)
// 	}
// 	//read ready always available
// 	when(io.OUT.valid && !io.OUT.ready){
// 		io.L2.rready  := 0.U
// 	}.otherwise{
// 		io.L2.rready  := 1.U
// 	}
// 	//io.OUT.valid//1.U//io.OUT.ready || !io.OUT.valid
	
// 	//OUT valid: the count should exeed the length + if(ready) next will be not valid
// 	val validWire = Wire(UInt(1.W))
// 	when(io.OUT.ready){
// 		validWire := cnt >= (io.L2.arlen) && io.L2.rvalid
// 	}.otherwise{
// 		when(io.L2.rvalid){
// 			validWire := cnt >= (io.L2.arlen)
// 			valid := cnt >= (io.L2.arlen)
// 		}.otherwise{
// 			validWire := valid
// 		}
		 
// 	}
// 	//One delay for combiner
// 	io.OUT.valid := RegNext(validWire)//combiner.io.exit.ready
	
// 	// io.OUT.valid := cnt >= (io.L2.arlen) && io.L2.rvalid
	
// 	val arlen = io.AGU.arlen
// 	io.L2.arlen := arlen
	
// 	// io.out.valid := cnt >= (Delay).U
// 	// io.in.ready := (io.out.ready&&io.out.valid || (cnt === 0.U)).asUInt
	
// 	// when((io.AGU.valid && io.AGU.ready) || cnt === 0.U ){
		
// 	// when((io.AGU.valid && io.AGU.ready) || cnt === 0.U ){
// 	// 	addr := io.AGU.addr
// 	// 	addrSaved := io.AGU.addr
// 	// }.elsewhen(io.L2.rvalid && io.L2.rready){
// 	// 	addr := addrSaved + 1.U
// 	// 	addrSaved := addrSaved + 1.U
// 	// }otherwise{
// 	// 	addr := addrSaved
// 	// 	addrSaved := addrSaved
// 	// }
	
// 	// cnt := 0.U
// 	io.L2.araddr  := addr
// 	addr := addrSaved
// 	addrSaved := addrSaved
	
	
// 		switch(state){
// 			is(sIdle){
// 				cnt := 0.U
// 				addr := io.AGU.addr
// 				addrSaved := io.AGU.addr
// 				when(io.L2.arready && io.L2.arvalid  ){
// 					state := sDramRead
// 					cnt := cnt + 1.U
// 				}
// 			}
// 			is(sDramRead){
			
				
// 				//Done with one read
// 				when(io.L2.rvalid && io.L2.rready){
// 					cnt := cnt + 1.U
// 					addr := addrSaved + 1.U
// 					addrSaved := addrSaved + 1.U				

// 					//Done with total read
// 					when(cnt >= (arlen) ){
						
						
// 						when(!io.OUT.ready){
// 							state := sDramRead
// 						}.otherwise{
						
// 							when(io.L2.arready && io.L2.arvalid  ){
// 								state := sDramRead
// 								cnt := 1.U
// 								addr := AddrNext
// 								addrSaved := AddrNext

							
// 							}.otherwise{
// 								state := sIdle
// 								cnt := 0.U				
// 							}
							
// 						} 
// 					}
					
					
// 				}
// 			}
// 		}
			
	
// 	//end of main logic
	
// 	//Need a deserializer
// 	//32, 32, 32, --> 
// 	val combiner = Module(DeserializerFactory.create_general(Map(
// 		"hardwareType" -> "ShiftDeserializer",
// 		"prec" -> bw.toString ,
// 		"out_terms" -> maxlen.toString ,
// 		 "fanout" -> 1.toString
// 	)))
// 	combiner.io.in :=  (io.L2.rdata)
// 	io.OUT.data := combiner.io.combined_data
// 	combiner.io.en := (io.L2.rvalid)// && io.L2.rready)
// 	combiner.io.clear := (io.AGU.ready)
// 	combiner.io.entry.valid := 1.B
// 	combiner.io.exit.ready  := 1.B
	
	
			
// }

























object counter_address_dma1var_test extends App{
		
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "counter_address_dma1var"
	file = file + "/" + mod
	var veri = file + "/" + mod
	var dram = file + "/" + "DRAMModel"
	
	
	val idxTile = 8
	val idxPrec = 8
	val dataPrec = 8
	val maxlen = 8
	val bw = 32
	val addrPrec = 8

	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => new counter_address_dma1var( 
			addrPrec = addrPrec, idxPrec = idxPrec, idxTile=idxTile ,
				bw = bw, maxlen = maxlen, dataPrec = dataPrec,
			 )    )))
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  DRAMModel(
			bw = bw, addrPrec = addrPrec, depth = 16000,
				readDelay = 2, writeDelay = 2
		)  )) )
	
	
		
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v", dram+".v"),
		extra_top_instance = Seq(1), 
	svtb = """			
			initial begin
				for(int i = 0; i < 1000; i++) begin
					DRAMModel1.lut[i] = $urandom;	
				end
			end
			
			
			task automatic RESET();
			        begin
							io_in_valid = 0;io_out_ready = 0;
							io_in_valid = 0;
							reset = 0;
							#10;
							reset = 1;
							#10;
							reset = 0;
							
			        end
			    endtask
					
					task automatic TEST0();
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge io_done);
								// assert(io_addr == i);
								#55;
					        end
					    endtask
					
					
					task automatic TEST1(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								// @(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 0;io_out_ready = 0;
								repeat (15) @(posedge clock);
								assert(io_addr == i);
								#5;
					        end
					    endtask

					task automatic TEST2(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								repeat (15) @(posedge clock);
								if(i+1 >= 3)begin
									assert(io_addr == 3);
								end else begin
								assert(io_addr == i+1);
								end
								#5;
					        end
					    endtask

					task automatic TEST3(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								// @(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 1;
								@(posedge io_done);
								assert(io_addr == 3);
								// @(posedge clock);
								#5;
							end
					    endtask
	
					task automatic TEST4(int i);
					        begin
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								repeat(i) @(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 1;
								@(posedge clock);
								io_in_valid = 1;io_out_ready = 0;
								//@(posedge io_done);
								if(i+1>=3) assert(io_addr == 3);
								else assert(io_addr == i+1);
								#5;
								// @(posedge clock);
							end
					    endtask
														
														
			integer testcase;										
			initial begin
				io_idx_limit_0 = 128;io_idx_rellimit_0 = io_idx_limit_0/"""+idxTile+""";
				testcase = 1;
				RESET();
				//Normal
				TEST0();
				
				//Delayed by downstream
				RESET();
				TEST2(0);
				
				// for(int i = 1; i <= 3 ; i ++)begin
				// 	RESET();
				// 	TEST1(i);
				// 	testcase += 1;
				// end
				
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST2(i);
	// 				testcase += 1;
	// 			end					
	
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST3(i);
	// 				testcase += 1;
	// 			end	
									
									
	// 			for(int i = 1; i <= 3 ; i ++)begin
	// 				RESET();
	// 				TEST4(i);
	// 				testcase += 1;
	// 			end										
			end
	""")
	
}


object mmu1var_test extends App {
	
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "mmu1var"
	file = file + "/" + mod
	var veri = file + "/" + mod
	var dram = file + "/" + "DRAMModel"
	
	val addrPrec = 16
	val bw = 32
	val maxlen = 8
	var time = 5000
	
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  mmu1var(
			 bw = bw, addrPrec = addrPrec, maxlen = maxlen
		)  )) )
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  DRAMModel(
			bw = bw, addrPrec = addrPrec, depth = 16000,
				readDelay = 4, writeDelay = 4
		)  )) )

				
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v", dram+".v"),
	extra_top_instance = Seq(1), simtime = time, 
	svtbfile_tasks = """
		task automatic pass_data(input [15:0] addr , input [4:0] len);
		        begin

					io_AGU_valid = 1;io_AGU_addr = addr;io_AGU_arlen = len;io_OUT_ready = 1;
					for(int i = 0; i < len; i++)begin
						@(posedge io_L2_rvalid);
						assert( io_L2_rdata == DRAMModel1.lut[addr+i] ) ; 
						// $display("%d\t%d\t%d\t%d", io_L2_rdata, i, addr+i, DRAMModel1.lut[addr+i]);
					end
					#10;
		        end
		    endtask
	""",
	svtb = """
		
			initial begin
				// reset = 0;
				// #10;
				// reset = 1;
				// #10;
				// reset = 0;
				
				// //Address = 0, len = 4
				// pass_data(0, 4);
				// pass_data(5, 3);
				// pass_data(0, 2);
				// pass_data(8, 7);
				
				//Pass 2 : No ready
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				
				io_AGU_valid = 1;io_AGU_addr = 23;io_AGU_arlen = 4;io_OUT_ready = 0;
				for(int i = 0; i < io_AGU_arlen; i++)begin
					@(posedge io_L2_rvalid);
					assert( io_L2_rdata == DRAMModel1.lut[io_AGU_addr+i] ) ; 
					// $display("%d\t%d\t%d\t%d", io_L2_rdata, i, io_AGU_addr+i, DRAMModel1.lut[io_AGU_addr+i]);
				end
				io_AGU_valid = 1;io_AGU_addr = 32;io_AGU_arlen = 4;io_OUT_ready = 0;
				
			
			end
			
			initial begin
				for(int i = 0; i < 1000; i++) begin
					DRAMModel1.lut[i] = $urandom;	
				end
				
				
				
				
			end
			
	""")
}




// //A large DRAM model
//AXI - BW = 8, 16, 32, 64, 128, 256, 512, 1024
class DRAMModel(val bw:Int = 32, val addrPrec :Int = 16, val depth : Int = 16000,
	val readDelay:Int = 4, val writeDelay:Int = 4)  extends Module {
	
  val io = IO(new Bundle {
	   val L2 = new dramIO(bw = bw, addrPrec = addrPrec)
	   
  })

	// 初始化一个 256 行、每行 32 位的 Mem 来作为 LUT
	val lut = SyncReadMem(depth, UInt(bw.W))

	val sIdle :: sDramRead :: Nil = Enum(2)
	// val sIdle :: sCacheRead :: sDramRead :: sC :: Nil = Enum(4)

	val state = RegInit(sIdle)
	val cnt = RegInit(0.U(16.W))
	val rdata = Wire(UInt(bw.W))
	val buf_araddr = Reg(UInt(addrPrec.W))
	val araddr = Wire(UInt(addrPrec.W))

	io.L2.rvalid := (cnt >= readDelay.U)
	io.L2.last := (cnt === (readDelay-1).U)
	io.L2.arready := (cnt >= readDelay.U ) || ( state === sIdle)
	io.L2.rdata := rdata 
	rdata := lut(araddr)

	araddr := io.L2.araddr
	switch(state){
 	is(sIdle){
		
 		when(io.L2.arready && io.L2.arvalid ){
 			state := sDramRead
			cnt := 0.U
 		}
		araddr := io.L2.araddr
		buf_araddr := io.L2.araddr
 	}
 	is(sDramRead){
		araddr := buf_araddr
		cnt := cnt + 1.U
		when(cnt >= readDelay.U){
			when(io.L2.arready && io.L2.arvalid){
				state := sDramRead
				cnt := 0.U
			}.otherwise{
				state := sIdle
				cnt := 0.U
			}
			
			araddr := io.L2.araddr
			buf_araddr := io.L2.araddr
		}
 	}
	}
	  
}


object dram_test extends App {
	
	//clock, input precisions?
	var file = "./generated/suan"
	val mod = "DRAMModel"
	file = file + "/" + mod
	var veri = file + "/" + mod
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => new  DRAMModel  )) )

				
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v"),svtb = """
		
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				@(posedge clock); io_L2_araddr = 0; io_L2_arvalid = 1;
				@(posedge io_L2_arready); io_L2_araddr = 1; io_L2_arvalid = 1; assert(io_L2_rdata == dut.lut[0]);
				@(posedge io_L2_arready); io_L2_araddr = 2; io_L2_arvalid = 1; assert(io_L2_rdata == dut.lut[1]);
				@(posedge io_L2_arready); io_L2_araddr = 3; io_L2_arvalid = 0; assert(io_L2_rdata == dut.lut[2]);
				// #100; io_L2_araddr = 3; io_L2_arvalid = 1; assert(io_L2_rdata == dut.lut[2]);
				// @(posedge io_L2_arready); io_L2_araddr = 3; io_L2_arvalid = 1; assert(io_L2_rdata == dut.lut[3]);
				#500;
				$finish;
			end
		
		initial begin
		for(int i = 0; i < 1000; i++) begin
			dut.lut[i] = $urandom;	
		end
		end
		
		
	""")
}




class dma(val bw:Int, val sramDepth :Int, val dramPrec:Int, val addrPrec:Int) extends Module {

    val io = IO(new dmaIO(  bw,  sramDepth, dramPrec, addrPrec:Int   ))

	io.out.bits := io.in.bits

	//(todos) sCacheWrite, sDramWrite
	val sIdle :: sCacheRead :: sDramRead :: sC :: Nil = Enum(4)

	//1 cycle basically
	io.cache.addr    := io.data.addr(log2Ceil(sramDepth)-1, 0)
	io.cache.dataIn  := 0.U
	// io.cache.dataOut := 0.U 
	io.cache.wen     := 0.B
	
	//We are a, we send to the dram or memories
	io.dram.araddr := Cat(0.U(dramPrec-addrPrec), io.data.addr) //io.data.addr //Input(UInt(addrPrec.W))
	io.dram.arvalid := 0.B//Input(Bool())
	// io.dram.arready = 1.B//Output(Bool())
	
	
	// io.dram.rdata = Output(UInt(width.W))
	// io.dram.rvalid = Output(Bool())
	io.dram.rready := 0.B //Input(Bool())
	
	val state = RegInit(sIdle)
	val rdata = Reg(UInt(bw.W))
	io.data.rdata := rdata
	
	io.in.ready := io.out.valid || state === sIdle
	io.out.valid := io.dram.rready && io.dram.rvalid
	
	//Don't consider io.out.ready blocking pipeline yet.
	
	switch(state) {
	    is(sIdle) {
			  when(io.in.valid ) {
					when(io.data.reuse){
						state := sCacheRead
					}.otherwise{
						state := sDramRead
						io.dram.arvalid:= 1.B
					}
			  }
		}
		is(sDramRead) {
			io.dram.rready := 1.B
			//Returned valid
	        when( io.out.valid ){
					when( io.in.valid  ){
							when(io.data.reuse){
								state := sCacheRead
							}.otherwise{
								state := sDramRead
								io.dram.arvalid := 1.B
							}
					}.otherwise{
						state := sIdle
						io.dram.arvalid := 0.B
					}
					rdata := io.dram.rdata
			}//Wait async response
	    }
		is(sCacheRead) {
			// //Returned valid
	  //       when( 1.B ){
			// 		when( io.in.valid ){
			// 				when(io.reuse){
			// 					state := sCacheRead
			// 				}.otherwise{
			// 					state := sDramRead
			// 				}

			// 		}.otherwise{
			// 			state := sIdle
			// 		}
			// }
			
		}//End sCacheRead State
		

	
	}

}









//Old testbenches
			// initial begin
			//     io_L2_arready = 1;
			// 	io_L2_rdata = 0;
			// 	io_L2_rvalid = 0;
			//     forever @(posedge clock) begin
						
			// 			  // output [31:0] io_dram_araddr,
			// 			  // output        io_dram_arvalid,
			// 			  // input         io_dram_arready,
			// 			  // input  [63:0] io_dram_rdata,
			// 			  // input         io_dram_rvalid,
			// 			  // output        io_dram_rready
			// 			// io_dram_arready = 1;
			// 			if(io_L2_arready && io_L2_arvalid) begin
			// 				io_L2_rdata = a[io_L2_araddr];
			// 				io_L2_arready = 0;
			// 				io_L2_rvalid = 0;
			// 				// io_L2_rvalid = #40 1;
			// 				io_L2_arready = #40 1;
			// 			end
			// 			// 	io_dram_rvalid = #40 1;
			// 			// }else{
			// 			// 	io_dram_rvalid = 0;
			// 			// }
			// 			//io_dram_arready
			// 			//io_dram_rvalid
					
			// 	end
			// end
			
			
			
			
			
			class mmu1var2(val bw:Int = 32, val addrPrec :Int = 16, val maxlen:Int = 8) extends Module {
			
				val io = IO(new Bundle{
					
					val L2 = Flipped(new dramIO(bw = bw, addrPrec = addrPrec))
					val AGU = new Bundle{
						val valid = Input(Bool())
						val ready = Output(Bool())
						val addr  = Input(UInt(addrPrec.W))
						val arlen = Input(UInt(8.W))
					}
					val OUT = new Bundle{
						val valid = Output(Bool())
						val ready = Input(Bool())
						val data = Output(UInt((bw*maxlen).W))
					}
				})
				
				io.OUT.data := 0.U
				
				//FSM
				val sIdle :: sDramRead :: Nil = Enum(2)
				
				val state = RegInit(sIdle)
				val cnt = Reg(UInt(8.W))
				var addr = Wire(UInt(addrPrec.W))
				var addrSaved = Reg(UInt(addrPrec.W))
				
				io.AGU.ready := cnt >= (io.L2.arlen-1.U) || state === sIdle //&& io.L2.rvalid
				io.OUT.valid := cnt >= (io.L2.arlen-1.U) && io.L2.rvalid
				
				io.L2.arvalid := (!io.OUT.ready && io.AGU.valid) || (io.OUT.ready && io.AGU.valid && !io.OUT.valid ) 
				io.L2.araddr  := addr
				io.L2.rready  := io.OUT.ready || !io.OUT.valid
				val arlen = RegNext(io.AGU.arlen)
				io.L2.arlen := arlen
				
				when(io.AGU.ready && io.AGU.valid ){
					addr := io.AGU.addr
					addrSaved := io.AGU.addr
				}.elsewhen(io.L2.rvalid && io.L2.rready){
					addr := addrSaved + 1.U
					addrSaved := addrSaved + 1.U
				}otherwise{
					addr := addrSaved
					addrSaved := addrSaved
				}
				
				switch(state){
					is(sIdle){
						cnt := 0.U
						when(io.AGU.ready && io.AGU.valid  ){
							state := sDramRead
						}
					}
					is(sDramRead){
						
						
						
						//Done with one read
						when(io.L2.rvalid && io.L2.rready){
							cnt := cnt + 1.U
							//Done with total read
							when(cnt >= (arlen-1.U) ){
								
								
								when(!io.OUT.ready){
									state := sDramRead
								}.otherwise{
								
									when(io.AGU.ready && io.AGU.valid  ){
										state := sDramRead
										cnt := 0.U
									
									}.otherwise{
										state := sIdle
										cnt := 0.U				
									}
									
								} 
							}
							
							
						}
					}
					
				}
				
				
				//Need a deserializer
				//32, 32, 32, --> 
				val combiner = Module(DeserializerFactory.create_general(Map(
					"hardwareType" -> "ShiftDeserializer",
					"prec" -> bw.toString ,
					"out_terms" -> maxlen.toString ,
					 "fanout" -> 1.toString
				)))
				combiner.io.in :=  (io.L2.rdata)
				io.OUT.data := combiner.io.combined_data
				combiner.io.en := (io.L2.rvalid && io.L2.rready)
				combiner.io.clear := (io.AGU.ready)
				combiner.io.entry.valid := 1.B
				combiner.io.exit.ready  := 1.B
				
				
				
			}
			
			
			
			



