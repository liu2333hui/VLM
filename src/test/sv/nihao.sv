interface nihao_if(input bit clk);
	logic [7:0] jia, yi;
	logic [7:0] zi;
endinterface

module nihao;
	input clk;
	input [7:0] jia;
	input [7:0] yi;
	output [7:0] zi;
	
	always@(posedge clk) begin
		zi <= jia & yi;
	end
endmodule


module test (nihao_if dut);
   initial begin
      @(posedge dut.clk);
      dut.jia <=  2'b01 ;
	  dut.yi  <=  2'b10 ;
	  $display("%d:begin %d", $time, dut.zi);
	  repeat(2) @(posedge dut.clk);
	  $display("%d:end %d", $time,   dut.zi);
	  $finish;
   end
endmodule

module nihao_top;
	bit clk;
	always #5 clk=~clk;
	nihao_if io(clk);
	nihao a1(io);
	test  t1(io);
endmodule
