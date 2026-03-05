
package ops
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.sys.process._

object LearnArray extends App {

	val file = "./generated/ops/LearnArray.sv"
	val writer = new PrintWriter(file)
	val tb = 
	  """
	  	module tb();
		
	// 	bit clock;
	// 	bit reset;
	// 	logic io_out_ready;
	// 	logic io_out_valid;
	// 	logic io_out_bits;
	// 	logic io_in_ready;
	// 	logic io_in_valid;
	// 	logic io_in_bits;
	
	//int b[1:2][1:3] = {{0,1,2},{3,4,5}};
	//2-state shortint, int, longint, byte, bit
	//4-state logic, reg, integer, time
	
	//byte, bit, shortint, integer (signed)
	//logic, reg, bit (unsigned)
	
	// enum integer {IDLE, XX='x, S1, S2} state, next;
	
	// bit [7:0] cl; //压缩
	// real u [7:0]; //非压缩
	// int Array[8][32] = int Array[0:7][0:31]
	//A[i:j]
	//bit [3:0][7:0] j;
	
	byte k[1024*1024];
	integer numbers[5];
		initial begin
		numbers[0] = 3;
		numbers[1] = 7;
		$display(numbers[0]);
		$display(numbers[1]);
		
		$display("----");
		foreach(k[j]) begin
			//$display(j, k[j]);
			k[j] = $urandom;
			
			//$display(j, k[j]);
		end
		
		$display("----");
		// byte d[7][2] = {default:-1};
		// $display("my numbers");
		// $display(d[6][0]);
		// $display(d[0][1]);
		
		// int b[2] = `{3, 7};
		// int c[2][3] = `{ {3,7,1}, {5,1,9} };
		// byte d[7][2] = `{default: -1};
		// bit[31:0] a[2][3] = c;
		
		// $display(b[0]);
		// $display(b[1]);
		$display("dimensions");
		$display($dimensions(numbers));
		$display($size(numbers, 1));
		$display($size(numbers, 2));
		// for(int i = 0 ; i < $dimensions(numbers);)
		// 	$display($size(numbers, i+1));
		
		foreach(numbers[i]) begin
			$display(numbers[i]);
		end
		
		
		end
		
		endmodule
	  """


	writer.print(tb)
	writer.close()


	
	val process = Seq("iverilog", "-g2005-sv", file) // 命令名 + 参数列表
	val process2 = Seq("vvp","a.out") // 命令名 + 参数列表
	var compileResult =	process.!
	print(compileResult)
	compileResult =	process2.!
	print(compileResult)
		
}