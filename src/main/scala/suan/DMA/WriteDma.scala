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




class WriteDramIO(val bw:Int = 64,val addrPrec:Int = 32) extends Bundle {
	    // 用户写数据通道
	    val awaddr = Input(UInt(32.W))
	    val awvalid = Input(Bool())
	    val awready = Output(Bool())

	    val wdata = Input(UInt(32.W))
	    val wvalid = Input(Bool())
	    val wready = Output(Bool())
	    
	    // 用户读数据通道
	 //    val araddr = Input(UInt(addrPrec.W))
	 //    val arvalid = Input(Bool())
	 //    val arready = Output(Bool())
		// val arlen = Input(UInt(8.W))
		
	 //    val rdata = Output(UInt(bw.W))
	 //    val rvalid = Output(Bool())
	 //    val rready = Input(Bool())
		
		// val last = Output(Bool())
	
}



// //A large DRAM model
//AXI - BW = 8, 16, 32, 64, 128, 256, 512, 1024
class ReadWriteDRAMModel(val bw:Int = 32, val addrPrec :Int = 16, val depth : Int = 16000,
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

