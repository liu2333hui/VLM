//Parallel2Serial, Serializer
package networks

import chisel3._
import chisel3.util._
import scala.collection.mutable.Queue
import helper._

import chisel3.stage.ChiselGeneratorAnnotation
//Used in systolic flows
class GenericDeserializer( HardwareConfig:Map[String, String]) extends Module {

   val prec:Int  = HardwareConfig("prec").toInt
   val out_terms:Int  = HardwareConfig("out_terms").toInt //Ratio, terms:1
   val fanout:Int  = HardwareConfig("fanout").toInt



	val io = IO(new Bundle{
		val in = Input( UInt(prec.W))
		val out = Output(Vec(out_terms, Vec(fanout, UInt(prec.W))))
		val en = Input(Bool())
		val clear = Input(Bool())
		
		val combined_data = Output( UInt((out_terms*prec).W) )
		
		val entry = new EntryIO()
		val exit = new ExitIO()
	})


}


object DeserializerFactory {
  
  def create_general( HardwareConfig : Map[String, String] ): GenericDeserializer = {
		val hardwareType:String  = HardwareConfig("hardwareType").toString

		val out =  hardwareType match {
			case "MuxDeserializer" => new MuxDeserializer(HardwareConfig)
			case "ShiftDeserializer" => new ShiftDeserializer(HardwareConfig)

			case "Mux" => new MuxDeserializer(HardwareConfig)
			case "Shift" => new ShiftDeserializer(HardwareConfig)
	
			//Other types ...? SRAM or FIFO based?

			case _     => throw new IllegalArgumentException("Unknown GenericDeserializer type")
		}
	  out
	  
  }

  }
  

class MuxDeserializer( HardwareConfig:Map[String, String]) 
	extends GenericDeserializer(HardwareConfig){

		val onehot = RegInit(UIntToOH(0.U, width = out_terms))
		val indata = Wire( UInt(prec.W) )
		indata := io.in
		
		//special case = max_out terms ==1, then cannot use mux, must use the multicast
		if(out_terms == 1){

			io.entry.ready := 1.U
			io.exit.valid := 1.U		

			val multicast : Multicast = Module(new Multicast(HardwareConfig
				+  ("terms" -> 1.toString) 
				+ ("fanout" -> fanout.toString)
				+ ("buffered" -> true.toString)   
			))

			multicast.io.en := io.en
			multicast.io.in(0) := io.in
	
			for(j <- Array.range(0, fanout)){
				io.out(0)(j) := multicast.io.out(0)(j)
			}
	
		}else{	


		for (i <- Array.range(0, out_terms) ){

			
			val multicast : Multicast = Module(new Multicast(HardwareConfig
				+  ("terms" -> 1.toString) 
				+ ("fanout" -> fanout.toString)
				+ ("buffered" -> false.toString)   
			))
			val mux :MuxN= Module(new MuxN(HardwareConfig 
				+ ("terms" -> 2.toString) ))
			val data = Reg(UInt(prec.W))
			
			multicast.io.en := io.en
			multicast.io.in(0) := data
			for(j <- Array.range(0, fanout)){
				io.out(i)(j) := multicast.io.out(0)(j)
			}
			
			mux.io.in(0) := data
			mux.io.in(1) := indata
			mux.io.sel := onehot(i)

			data := mux.io.out

		}

		val valid = Wire(UInt(1.W))
		// io.entry.ready := (cnt == 0) & io.entry.valid
		io.entry.ready := 1.U 
		valid := (onehot(out_terms-1) === 1.U)
		io.exit.valid := valid

		//change the one-hot selector
		// when(io.clear ){
		// 	onehot := 1.U
		// }.otherwise{
			when(io.en){
				onehot := Cat(onehot(out_terms-2, 0), onehot(out_terms-1))
			}
		// }
	}//general case
}



object MuxDeserializer_test extends App {
	
	//clock, input precisions?
	var file = "./generated/networks"
	val mod = "ShiftDeserializer"
	file = file + "/" + mod
	var veri = file + "/" + mod
	
	val bw = 32
	val maxlen = 4

	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir",file),
		Seq(ChiselGeneratorAnnotation(() => DeserializerFactory.create_general(Map(
					"hardwareType" -> mod,
					"prec" -> bw.toString ,
					"out_terms" -> maxlen.toString ,
					 "fanout" -> 1.toString
				)))))
			
				
	//Simulation using vcs or iverilog
	sim.iverilog(svtbfile = veri+".tb.sv", svfiles = Seq(veri+".v"), 
	svtbfile_tasks = """
		task automatic pass_data(input [31:0] data, input [4:0] len, input clear);
		        begin

					io_clear = clear;
					io_in = data;
					io_en = 1;
					repeat(len)begin
						#10;
						io_in = io_in+1; 
						$display("%ds\t%d\t%d\t%d\t%d", $time, io_out_0_0, io_out_1_0, io_out_2_0, io_out_3_0,);
						io_clear = 0;
					end
					if(len >= 1) assert(io_out_0_0 == data);
					if(len >= 2) assert(io_out_1_0 == data+1);
					if(len >= 3) assert(io_out_2_0 == data+2);
					if(len >= 4) assert(io_out_3_0 == data+3);
					
		        end
		    endtask
	""",
	svtb = """
		
			initial begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
				
				pass_data(32, 4, 1);
				pass_data(88, 2, 1);
				pass_data(103, 2, 1);
				pass_data(2, 1, 1);
				pass_data(22, 3, 1);
				
			end
	
	""")
}


class ShiftDeserializer( HardwareConfig:Map[String, String]) 
	extends GenericDeserializer(HardwareConfig){
	
		var data = Reg(Vec(out_terms ,UInt(prec.W)))

		when(io.en){
			data(out_terms - 1) := io.in
		}
		
		for (i <- Array.range(1, out_terms)){
			when(io.en){
				data(i-1) := data(i)
			}
		}
		

		val cnt = Reg(UInt(prec.W))
		when(io.clear){
			cnt := 0.U
		}.otherwise{
			when(io.en){
					when(cnt === (out_terms-1).U){
						cnt := 0.U
					}.otherwise{
						cnt := cnt + 1.U
					}
				}
			
		}


		for (i <- Array.range(0, out_terms) ){

			val multicast : Multicast = Module(new Multicast(HardwareConfig
				+  ("terms" -> 1.toString) 
				+ ("fanout" -> fanout.toString)
				+ ("buffered" -> false.toString)   
			))

			multicast.io.en := io.en
			multicast.io.in(0) := data(i)
			for(j <- Array.range(0, fanout)){
				io.out(i)(j) := multicast.io.out(0)(j)
			}
		}

		val valid = Reg(UInt(1.W))
		// io.entry.ready := (cnt == 0) & io.entry.valid
		io.entry.ready := 1.U 
		valid := (cnt === (out_terms-1).U)
		io.exit.valid := valid

// val combined = Wire(UInt(( prec*out_terms).W ))
		
		
		
		val combined = Wire(Vec(out_terms, UInt(prec.W)))
		
		for(k <- 0 until out_terms){
			combined(k) := io.out(k)(0)
		}
		// combined( := 0.U
		io.combined_data := Cat(combined)//0.U


}

