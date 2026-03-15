module hdm3_map(

	input pre_prev_parity,
	input pre_hdm_parity,
	output reg prev_parity,
	output reg hdm_parity,

	
	output reg [1:0] hdm_code_0,
	output reg [1:0] hdm_code_1,
	output reg [1:0] hdm_code_2,
	output  reg [1:0] hdm_code_3);


always@(*) begin

    if(pre_hdm_parity == 0)begin
					if(pre_prev_parity == 0) begin

						prev_parity <= +1;
	 	

						hdm_code_0 <= +1;
						hdm_code_1 <= 0;
						hdm_code_2 <= 0;
						hdm_code_3 <= +1;
					end else begin
						prev_parity <= 0;


						hdm_code_0 <= -1;
						hdm_code_1 <= 0;
						hdm_code_2 <= 0;
						hdm_code_3 <= -1;
						
					end 	
				end else begin
					if(pre_prev_parity == 0) begin

						prev_parity <= 0;


						hdm_code_0 <= 0;
						hdm_code_1 <= 0;
						hdm_code_2 <= 0;
						hdm_code_3 <= -1;
					end else begin

												
						prev_parity <= +1;


						hdm_code_0 <= 0;
						hdm_code_1 <= 0;
						hdm_code_2 <= 0;
						hdm_code_3 <= +1;
						
					end 	
				end

end

endmodule


module hdm3(

   input BinaryStream,
   input Clock,
   input Reset,
   output P,
   output N

);


reg signed [1:0] ami;

reg parity;



integer debug_i;

reg state;

reg [3:0] line;
reg [3:0] cnt;

reg [1:0] hdm_code_0;
reg [1:0] hdm_code_1;
reg [1:0] hdm_code_2;
reg [1:0] hdm_code_3;

reg [3:0] down_cnt;

reg [1:0] hdm_encoded;

//1 - odd, 0 - even
reg hdm_parity;
//0= -,1= +
reg prev_parity;


wire  m_pre_prev_parity;
wire  m_pre_hdm_parity;
wire  m_prev_parity;
wire m_hdm_parity;
	
wire [1:0]  m_hdm_code_0;
wire [1:0]  m_hdm_code_1;
wire [1:0]  m_hdm_code_2;
wire [1:0] m_hdm_code_3;

hdm3_map dut(

	.pre_prev_parity(prev_parity),
	.pre_hdm_parity(hdm_parity),
	.prev_parity(m_prev_parity),
	.hdm_parity(m_hdm_parity),
	
	.hdm_code_0(m_hdm_code_0),
.hdm_code_1(m_hdm_code_1),
.hdm_code_2(m_hdm_code_2),
.hdm_code_3(m_hdm_code_3)
	
);

initial begin
	debug_i = -1;
end


always@(posedge Clock or posedge Reset) begin

	if(Reset) begin
		ami <= 0;
		parity <= 0;
	end else begin
		if(BinaryStream == 1)begin
		if(parity == 0)begin
			ami <= +1;
		end else begin
			ami <= -1;
		end
		parity <= ~parity; //flip the parity
		end else begin
			ami <= 0;
		end	
	end	

	if(Reset) begin
		state <= 0;	
		cnt <= 0;	
		hdm_parity <= 0;
		prev_parity <= 0;
	end else begin
		if(cnt <= 4)begin
			cnt <= cnt + 1;
		end

		line[3] <= BinaryStream;
		line[2:0] <= line[3:1];		


		//hdm_parity[3] <= parity;
		//hdm_parity[2:0] <= hdm_parity[3:1];

		if(state == 0)begin
			if(cnt >= 4)begin
			debug_i  = debug_i  + 1;
			//Non-matched 0000		
			if(line == 0)begin
				state<= 1;
				down_cnt<= 2;

				//hdm coding
				$display("%b %b",line, hdm_parity);
				//

						hdm_parity <= 0; //still even

												
						prev_parity <= m_prev_parity;

						hdm_encoded <= m_hdm_code_0;

						hdm_code_0 <= m_hdm_code_0;
						hdm_code_1 <= m_hdm_code_1;
						hdm_code_2 <= m_hdm_code_2;
						hdm_code_3 <= m_hdm_code_3;
				//
				

			end else begin
				state <= 0;
				if(line[0] == 1) begin

					hdm_parity <= ~hdm_parity;
					prev_parity <= ~prev_parity;					

					if(prev_parity == 0) begin
						hdm_encoded <= +1;
					end else begin
						hdm_encoded <= -1;
					end
					
				end else begin
					hdm_encoded <= 0;
				end
			end
			end
		end else if(state == 1) begin
				debug_i  = debug_i  + 1;
			down_cnt <= down_cnt - 1;									
			if(down_cnt == 2)begin
				hdm_encoded <= hdm_code_1;
			end else if(down_cnt == 1) begin
				hdm_encoded <= hdm_code_2;
			end else if(down_cnt == 0) begin
				hdm_encoded <= hdm_code_3;


				state <= 0;




			end 
			
		end 


	end

end

assign P = (ami == +1);
assign N = (ami == -1);

endmodule