
package blocks
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.sys.process._

object TestFixedBlock extends App {
	
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", "./generated/Block"),
		Seq(ChiselGeneratorAnnotation(() => new FixedBlock(4, 8)  )))
	

	val writer = new PrintWriter("./generated/Block/FixedBlockTb.sv")
	val tb = 
	  """
	  	module tb();
		
		bit clock;
		bit reset;
		logic io_out_ready;
		logic io_out_valid;
		logic io_out_bits;
		logic io_in_ready;
		logic io_in_valid;
		logic io_in_bits;
		
	  	FixedBlock dut(
			clock,
			reset,
			io_out_ready,
			io_out_valid,
			io_out_bits,
			io_in_ready,
			io_in_valid,
			io_in_bits
	  	);
		
		initial begin
			forever #5 clock = ~clock;
		end
		
		initial begin
			$dumpfile("./sim.vcd");
			$dumpvars(0);
		end
		
		initial begin
			reset = 1;
			io_in_valid = 0;
			#10;
			reset = 0;
			#10;
			reset = 1;
			io_in_valid = 1;
			//@(posedge io_out_valid);
			#50;
			io_in_valid = 0;
			#10;
			io_in_valid = 0;
			#10;
			io_in_valid = 0;
			#10;
			io_in_valid = 1;
			#80;
			
			$finish;
			
		end
		
		endmodule
	  """


	writer.print(tb)
	writer.close()


	
	val process = Seq("iverilog", "-g2005-sv", "./generated/Block/FixedBlock.v", "./generated/Block/FixedBlockTb.sv") // 命令名 + 参数列表
	val process2 = Seq("vvp","a.out") // 命令名 + 参数列表
	var compileResult =	process.!
	print(compileResult)
	compileResult =	process2.!
	print(compileResult)
		
}

class FixedBlock(Throughput :Int , Delay :Int) extends Module {

    val io = IO(new Bundle {
	   val out = Decoupled(Bool()) 
	   val in = Flipped(Decoupled(Bool()))
	   // val ctrl = new Bundle{
		   
	   // }
    })


	//4 4
	//1 4
	//2 4
	if(Throughput == Delay){
		
		val cnt = Reg(UInt(32.W))
		// cnt := cnt + 1.U
		when(io.in.valid | ( cnt >= 1.U)){
			when(cnt >= (Delay).U){
				when(io.in.valid){
					cnt := 1.U;
				}.otherwise{
					cnt := 0.U;
				}
			}.otherwise{
				cnt := cnt + 1.U
			}
		}.otherwise{
				cnt := 0.U
			}
		
		
		io.out.valid := cnt >= (Delay).U
		io.in.ready := (io.out.valid || (cnt === 0.U)).asUInt
		io.out.bits := io.in.bits
				
	}else if(Throughput == 1){
		
		val valid = Reg(Vec(Delay, UInt(1.W)))
		io.in.ready := 1.U
		io.out.bits := io.in.bits
		
		for(i <- 1 until Delay){
			valid(i) := valid(i-1)
		}
		io.out.valid := valid(Delay-1)
		valid(0) := io.in.valid
		
		
	}else{
		//Counter
		val cnt = Reg(UInt(32.W))
		// cnt := cnt + 1.U
		when(io.in.valid | ( cnt >= 1.U)){
			when(cnt >= (Throughput).U){
				when(io.in.valid){
					cnt := 1.U;
				}.otherwise{
					cnt := 0.U;
				}
			}.otherwise{
				cnt := cnt + 1.U
			}
		}.otherwise{
				cnt := 0.U
		}
		
		//Valid pipeline
		val valid = Reg(Vec(Delay, UInt(1.W)))
		
		io.out.bits := io.in.bits
		
		for(i <- 1 until Delay){
			valid(i) := valid(i-1)
		}  
		io.out.valid := valid(Delay-1)
		valid(0) := io.in.valid & io.in.ready
		
		
		io.in.ready := (cnt >= (Throughput).U || (cnt === 0.U)).asUInt
				
	}
	

	// io.in.valid
	// io.in.ready
	// io.out.valid
	// io.out.ready

}




