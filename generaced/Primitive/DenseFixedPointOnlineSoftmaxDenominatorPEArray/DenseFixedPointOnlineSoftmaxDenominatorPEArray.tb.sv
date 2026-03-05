
 module tb();
	
	 bit         clock ;
 bit         reset ;
 bit   [7:0] io_in0_0_i ;
 bit   [7:0] io_in0_0_f ;
 bit   [7:0] io_in0_1_i ;
 bit   [7:0] io_in0_1_f ;
 bit   [7:0] io_in0_2_i ;
 bit   [7:0] io_in0_2_f ;
 bit   [7:0] io_in0_3_i ;
 bit   [7:0] io_in0_3_f ;
 bit   [7:0] io_in0_4_i ;
 bit   [7:0] io_in0_4_f ;
 bit   [7:0] io_in0_5_i ;
 bit   [7:0] io_in0_5_f ;
 bit   [7:0] io_in0_6_i ;
 bit   [7:0] io_in0_6_f ;
 bit   [7:0] io_in0_7_i ;
 bit   [7:0] io_in0_7_f ;
 bit   [7:0] io_in1_0_i ;
 bit   [7:0] io_in1_0_f ;
 bit   [7:0] io_in1_1_i ;
 bit   [7:0] io_in1_1_f ;
 bit   [7:0] io_in1_2_i ;
 bit   [7:0] io_in1_2_f ;
 bit   [7:0] io_in1_3_i ;
 bit   [7:0] io_in1_3_f ;
 bit   [7:0] io_in2_0_i ;
 bit   [7:0] io_in2_0_f ;
 bit   [7:0] io_in2_1_i ;
 bit   [7:0] io_in2_1_f ;
 bit   [7:0] io_in2_2_i ;
 bit   [7:0] io_in2_2_f ;
 bit   [7:0] io_in2_3_i ;
 bit   [7:0] io_in2_3_f ;
 bit  [7:0] io_out0_0_i ;
 bit  [7:0] io_out0_0_f ;
 bit  [7:0] io_out0_1_i ;
 bit  [7:0] io_out0_1_f ;
 bit  [7:0] io_out0_2_i ;
 bit  [7:0] io_out0_2_f ;
 bit  [7:0] io_out0_3_i ;
 bit  [7:0] io_out0_3_f ;
 bit        io_exit_valid ;
 bit         io_exit_ready ;
 bit         io_entry_valid ;
 bit        io_entry_ready ;

	
	

		DenseFixedPointOnlineSoftmaxDenominatorPEArray DenseFixedPointOnlineSoftmaxDenominatorPEArray0(
		     clock ,
  reset ,
  io_in0_0_i ,
  io_in0_0_f ,
  io_in0_1_i ,
  io_in0_1_f ,
  io_in0_2_i ,
  io_in0_2_f ,
  io_in0_3_i ,
  io_in0_3_f ,
  io_in0_4_i ,
  io_in0_4_f ,
  io_in0_5_i ,
  io_in0_5_f ,
  io_in0_6_i ,
  io_in0_6_f ,
  io_in0_7_i ,
  io_in0_7_f ,
  io_in1_0_i ,
  io_in1_0_f ,
  io_in1_1_i ,
  io_in1_1_f ,
  io_in1_2_i ,
  io_in1_2_f ,
  io_in1_3_i ,
  io_in1_3_f ,
  io_in2_0_i ,
  io_in2_0_f ,
  io_in2_1_i ,
  io_in2_1_f ,
  io_in2_2_i ,
  io_in2_2_f ,
  io_in2_3_i ,
  io_in2_3_f ,
  io_out0_0_i ,
  io_out0_0_f ,
  io_out0_1_i ,
  io_out0_1_f ,
  io_out0_2_i ,
  io_out0_2_f ,
  io_out0_3_i ,
  io_out0_3_f ,
  io_exit_valid ,
  io_exit_ready ,
  io_entry_valid ,
  io_entry_ready
		);
	
	
	
	
	initial begin
	forever #5  clock = ~clock;
	end
	
	
	
	//Maximum limit
	initial begin
		#10000;
		$finish;
	end
	
	task automatic Reset();
	        begin
				reset = 0;
				#10;
				reset = 1;
				#10;
				reset = 0;
			end
	    endtask
		
	initial begin
	$dumpfile("./sim.vcd");
	$dumpvars(0);
	end
 			initial begin
				Reset();
				
				io_in0_0_i=0;
io_in0_1_i=1;
io_in0_2_i=2;
io_in0_3_i=3;
io_in0_4_i=4;
io_in0_5_i=5;
io_in0_6_i=6;
io_in0_7_i=7;

				io_in0_0_f=0;
io_in0_1_f=1;
io_in0_2_f=2;
io_in0_3_f=3;
io_in0_4_f=4;
io_in0_5_f=5;
io_in0_6_f=6;
io_in0_7_f=7;

				
				
				io_in1_0_i=0;
io_in1_1_i=8;
io_in1_2_i=2;
io_in1_3_i=8;

				io_in1_0_f=0;
io_in1_1_f=8;
io_in1_2_f=2;
io_in1_3_f=8;

				
				io_entry_valid = 1; 
				io_exit_ready = 1;
				@(posedge clock);
				#1;
				//assert(io_in0*io_in0 == io_out);
				
 			end
 	

endmodule
