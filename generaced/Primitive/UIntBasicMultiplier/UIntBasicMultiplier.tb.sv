
 module tb();
	
	 bit         clock ;
 bit         reset ;
 bit   [7:0] io_in0 ;
 bit   [7:0] io_in1 ;
 bit  [7:0] io_out ;
 bit         io_entry_valid ;
 bit        io_entry_ready ;
 bit        io_exit_valid ;
 bit         io_exit_ready ;

	
	

		UIntBasicMultiplier UIntBasicMultiplier0(
		     clock ,
  reset ,
  io_in0 ,
  io_in1 ,
  io_out ,
  io_entry_valid ,
  io_entry_ready ,
  io_exit_valid ,
  io_exit_ready
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
				#15;
				reset = 0;
			end
	    endtask
		
	initial begin
	$dumpfile("./sim.vcd");
	$dumpvars(0);
	end
 			initial begin
				Reset();
				for(int j = 0; j <= 9; j++)begin
				for(int i = 0; i <= 9; i++)begin
					io_in0 = i; io_in1 = j; 
					io_entry_valid = 1; 
					io_exit_ready = 1;
					@(posedge clock);
					#1;
					assert(io_in0*io_in1 == io_out);
				end
				end
 			end
 	

endmodule
