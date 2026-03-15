module SIntMaxN_mp_SIntMax2_PipelineUInt(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [15:0] io_in_bits,
  input         io_out_ready,
  output        io_out_valid,
  output [15:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [15:0] bits; // @[pipeline.scala 150:27]
  reg  valid; // @[pipeline.scala 151:28]
  wire  _T = io_in_valid & io_in_ready; // @[pipeline.scala 156:26]
  wire  _T_1 = _T & io_out_ready; // @[pipeline.scala 156:41]
  wire  _T_3 = ~io_out_valid; // @[pipeline.scala 160:53]
  wire  _T_4 = _T & _T_3; // @[pipeline.scala 160:49]
  assign io_in_ready = io_out_ready; // @[pipeline.scala 153:21]
  assign io_out_valid = valid; // @[pipeline.scala 152:22]
  assign io_out_bits = bits; // @[pipeline.scala 154:21]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  bits = _RAND_0[15:0];
  _RAND_1 = {1{`RANDOM}};
  valid = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      bits <= 16'h0;
    end else if (_T_1) begin
      bits <= io_in_bits;
    end else if (_T_4) begin
      bits <= io_in_bits;
    end
    if (reset) begin
      valid <= 1'h0;
    end else if (_T_1) begin
      valid <= io_in_valid;
    end else if (_T_4) begin
      valid <= io_in_valid;
    end
  end
endmodule
module SIntMaxN_mp_SIntMax2_PipelineSInt(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [15:0] io_in_bits,
  input         io_out_ready,
  output        io_out_valid,
  output [15:0] io_out_bits
);
  wire  m_clock; // @[pipeline.scala 127:23]
  wire  m_reset; // @[pipeline.scala 127:23]
  wire  m_io_in_ready; // @[pipeline.scala 127:23]
  wire  m_io_in_valid; // @[pipeline.scala 127:23]
  wire [15:0] m_io_in_bits; // @[pipeline.scala 127:23]
  wire  m_io_out_ready; // @[pipeline.scala 127:23]
  wire  m_io_out_valid; // @[pipeline.scala 127:23]
  wire [15:0] m_io_out_bits; // @[pipeline.scala 127:23]
  SIntMaxN_mp_SIntMax2_PipelineUInt m ( // @[pipeline.scala 127:23]
    .clock(m_clock),
    .reset(m_reset),
    .io_in_ready(m_io_in_ready),
    .io_in_valid(m_io_in_valid),
    .io_in_bits(m_io_in_bits),
    .io_out_ready(m_io_out_ready),
    .io_out_valid(m_io_out_valid),
    .io_out_bits(m_io_out_bits)
  );
  assign io_in_ready = m_io_in_ready; // @[pipeline.scala 129:21]
  assign io_out_valid = m_io_out_valid; // @[pipeline.scala 131:22]
  assign io_out_bits = m_io_out_bits; // @[pipeline.scala 135:21]
  assign m_clock = clock;
  assign m_reset = reset;
  assign m_io_in_valid = io_in_valid; // @[pipeline.scala 128:23]
  assign m_io_in_bits = io_in_bits; // @[pipeline.scala 134:22]
  assign m_io_out_ready = io_out_ready; // @[pipeline.scala 132:24]
endmodule
module SIntMaxN_mp_SIntMax2(
  input         clock,
  input         reset,
  input  [15:0] io_in0,
  input  [15:0] io_in1,
  output [15:0] io_out,
  input         io_entry_valid,
  output        io_entry_ready,
  output        io_exit_valid,
  input         io_exit_ready
);
  wire  p_clock; // @[MaxMin.scala 31:23]
  wire  p_reset; // @[MaxMin.scala 31:23]
  wire  p_io_in_ready; // @[MaxMin.scala 31:23]
  wire  p_io_in_valid; // @[MaxMin.scala 31:23]
  wire [15:0] p_io_in_bits; // @[MaxMin.scala 31:23]
  wire  p_io_out_ready; // @[MaxMin.scala 31:23]
  wire  p_io_out_valid; // @[MaxMin.scala 31:23]
  wire [15:0] p_io_out_bits; // @[MaxMin.scala 31:23]
  wire  _T = $signed(io_in0) > $signed(io_in1); // @[MaxMin.scala 33:36]
  SIntMaxN_mp_SIntMax2_PipelineSInt p ( // @[MaxMin.scala 31:23]
    .clock(p_clock),
    .reset(p_reset),
    .io_in_ready(p_io_in_ready),
    .io_in_valid(p_io_in_valid),
    .io_in_bits(p_io_in_bits),
    .io_out_ready(p_io_out_ready),
    .io_out_valid(p_io_out_valid),
    .io_out_bits(p_io_out_bits)
  );
  assign io_out = p_io_out_bits; // @[MaxMin.scala 34:16]
  assign io_entry_ready = p_io_in_ready; // @[MaxMin.scala 36:24]
  assign io_exit_valid = p_io_out_valid; // @[MaxMin.scala 38:23]
  assign p_clock = clock;
  assign p_reset = reset;
  assign p_io_in_valid = io_entry_valid; // @[MaxMin.scala 35:23]
  assign p_io_in_bits = _T ? $signed(io_in0) : $signed(io_in1); // @[MaxMin.scala 33:22]
  assign p_io_out_ready = io_exit_ready; // @[MaxMin.scala 39:24]
endmodule
module SIntMaxN_mp(
  input         clock,
  input         reset,
  input  [15:0] io_in0_0,
  input  [15:0] io_in0_1,
  input  [15:0] io_in0_2,
  input  [15:0] io_in0_3,
  input  [15:0] io_in0_4,
  input  [15:0] io_in0_5,
  input  [15:0] io_in0_6,
  input  [15:0] io_in0_7,
  output [15:0] io_out,
  input         io_entry_valid,
  output        io_entry_ready,
  output        io_exit_valid,
  input         io_exit_ready
);
  wire  SIntMaxN_mp_SIntMax2_clock; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_reset; // @[MaxMin.scala 57:29]
  wire [15:0] SIntMaxN_mp_SIntMax2_io_in0; // @[MaxMin.scala 57:29]
  wire [15:0] SIntMaxN_mp_SIntMax2_io_in1; // @[MaxMin.scala 57:29]
  wire [15:0] SIntMaxN_mp_SIntMax2_io_out; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_io_entry_valid; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_io_entry_ready; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_io_exit_valid; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_io_exit_ready; // @[MaxMin.scala 57:29]
  wire  SIntMaxN_mp_SIntMax2_1_clock; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_1_reset; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_1_io_in0; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_1_io_in1; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_1_io_out; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_1_io_entry_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_1_io_entry_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_1_io_exit_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_1_io_exit_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_2_clock; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_2_reset; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_2_io_in0; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_2_io_in1; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_2_io_out; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_2_io_entry_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_2_io_entry_ready; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_2_io_exit_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_2_io_exit_ready; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_3_clock; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_3_reset; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_3_io_in0; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_3_io_in1; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_3_io_out; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_3_io_entry_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_3_io_entry_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_3_io_exit_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_3_io_exit_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_4_clock; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_4_reset; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_4_io_in0; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_4_io_in1; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_4_io_out; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_4_io_entry_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_4_io_entry_ready; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_4_io_exit_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_4_io_exit_ready; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_5_clock; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_5_reset; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_5_io_in0; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_5_io_in1; // @[MaxMin.scala 70:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_5_io_out; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_5_io_entry_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_5_io_entry_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_5_io_exit_valid; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_5_io_exit_ready; // @[MaxMin.scala 70:55]
  wire  SIntMaxN_mp_SIntMax2_6_clock; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_6_reset; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_6_io_in0; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_6_io_in1; // @[MaxMin.scala 71:55]
  wire [15:0] SIntMaxN_mp_SIntMax2_6_io_out; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_6_io_entry_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_6_io_entry_ready; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_6_io_exit_valid; // @[MaxMin.scala 71:55]
  wire  SIntMaxN_mp_SIntMax2_6_io_exit_ready; // @[MaxMin.scala 71:55]
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2 ( // @[MaxMin.scala 57:29]
    .clock(SIntMaxN_mp_SIntMax2_clock),
    .reset(SIntMaxN_mp_SIntMax2_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_1 ( // @[MaxMin.scala 70:55]
    .clock(SIntMaxN_mp_SIntMax2_1_clock),
    .reset(SIntMaxN_mp_SIntMax2_1_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_1_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_1_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_1_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_1_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_1_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_1_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_1_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_2 ( // @[MaxMin.scala 71:55]
    .clock(SIntMaxN_mp_SIntMax2_2_clock),
    .reset(SIntMaxN_mp_SIntMax2_2_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_2_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_2_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_2_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_2_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_2_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_2_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_2_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_3 ( // @[MaxMin.scala 70:55]
    .clock(SIntMaxN_mp_SIntMax2_3_clock),
    .reset(SIntMaxN_mp_SIntMax2_3_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_3_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_3_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_3_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_3_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_3_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_3_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_3_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_4 ( // @[MaxMin.scala 71:55]
    .clock(SIntMaxN_mp_SIntMax2_4_clock),
    .reset(SIntMaxN_mp_SIntMax2_4_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_4_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_4_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_4_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_4_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_4_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_4_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_4_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_5 ( // @[MaxMin.scala 70:55]
    .clock(SIntMaxN_mp_SIntMax2_5_clock),
    .reset(SIntMaxN_mp_SIntMax2_5_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_5_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_5_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_5_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_5_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_5_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_5_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_5_io_exit_ready)
  );
  SIntMaxN_mp_SIntMax2 SIntMaxN_mp_SIntMax2_6 ( // @[MaxMin.scala 71:55]
    .clock(SIntMaxN_mp_SIntMax2_6_clock),
    .reset(SIntMaxN_mp_SIntMax2_6_reset),
    .io_in0(SIntMaxN_mp_SIntMax2_6_io_in0),
    .io_in1(SIntMaxN_mp_SIntMax2_6_io_in1),
    .io_out(SIntMaxN_mp_SIntMax2_6_io_out),
    .io_entry_valid(SIntMaxN_mp_SIntMax2_6_io_entry_valid),
    .io_entry_ready(SIntMaxN_mp_SIntMax2_6_io_entry_ready),
    .io_exit_valid(SIntMaxN_mp_SIntMax2_6_io_exit_valid),
    .io_exit_ready(SIntMaxN_mp_SIntMax2_6_io_exit_ready)
  );
  assign io_out = SIntMaxN_mp_SIntMax2_io_out; // @[MaxMin.scala 58:10]
  assign io_entry_ready = SIntMaxN_mp_SIntMax2_6_io_entry_ready; // @[MaxMin.scala 62:17 MaxMin.scala 76:41 MaxMin.scala 79:41 MaxMin.scala 76:41 MaxMin.scala 79:41 MaxMin.scala 76:41 MaxMin.scala 79:41]
  assign io_exit_valid = SIntMaxN_mp_SIntMax2_6_io_exit_valid; // @[MaxMin.scala 61:17 MaxMin.scala 75:41 MaxMin.scala 78:41 MaxMin.scala 75:41 MaxMin.scala 78:41 MaxMin.scala 75:41 MaxMin.scala 78:41]
  assign SIntMaxN_mp_SIntMax2_clock = clock;
  assign SIntMaxN_mp_SIntMax2_reset = reset;
  assign SIntMaxN_mp_SIntMax2_io_in0 = SIntMaxN_mp_SIntMax2_1_io_out; // @[MaxMin.scala 72:40]
  assign SIntMaxN_mp_SIntMax2_io_in1 = SIntMaxN_mp_SIntMax2_2_io_out; // @[MaxMin.scala 73:40]
  assign SIntMaxN_mp_SIntMax2_io_entry_valid = io_entry_valid; // @[MaxMin.scala 62:17]
  assign SIntMaxN_mp_SIntMax2_io_exit_ready = io_exit_ready; // @[MaxMin.scala 61:17]
  assign SIntMaxN_mp_SIntMax2_1_clock = clock;
  assign SIntMaxN_mp_SIntMax2_1_reset = reset;
  assign SIntMaxN_mp_SIntMax2_1_io_in0 = SIntMaxN_mp_SIntMax2_3_io_out; // @[MaxMin.scala 72:40]
  assign SIntMaxN_mp_SIntMax2_1_io_in1 = SIntMaxN_mp_SIntMax2_4_io_out; // @[MaxMin.scala 73:40]
  assign SIntMaxN_mp_SIntMax2_1_io_entry_valid = io_entry_valid; // @[MaxMin.scala 76:41]
  assign SIntMaxN_mp_SIntMax2_1_io_exit_ready = io_exit_ready; // @[MaxMin.scala 75:41]
  assign SIntMaxN_mp_SIntMax2_2_clock = clock;
  assign SIntMaxN_mp_SIntMax2_2_reset = reset;
  assign SIntMaxN_mp_SIntMax2_2_io_in0 = SIntMaxN_mp_SIntMax2_5_io_out; // @[MaxMin.scala 72:40]
  assign SIntMaxN_mp_SIntMax2_2_io_in1 = SIntMaxN_mp_SIntMax2_6_io_out; // @[MaxMin.scala 73:40]
  assign SIntMaxN_mp_SIntMax2_2_io_entry_valid = io_entry_valid; // @[MaxMin.scala 79:41]
  assign SIntMaxN_mp_SIntMax2_2_io_exit_ready = io_exit_ready; // @[MaxMin.scala 78:41]
  assign SIntMaxN_mp_SIntMax2_3_clock = clock;
  assign SIntMaxN_mp_SIntMax2_3_reset = reset;
  assign SIntMaxN_mp_SIntMax2_3_io_in0 = io_in0_0; // @[MaxMin.scala 91:24]
  assign SIntMaxN_mp_SIntMax2_3_io_in1 = io_in0_1; // @[MaxMin.scala 92:24]
  assign SIntMaxN_mp_SIntMax2_3_io_entry_valid = io_entry_valid; // @[MaxMin.scala 76:41]
  assign SIntMaxN_mp_SIntMax2_3_io_exit_ready = io_exit_ready; // @[MaxMin.scala 75:41]
  assign SIntMaxN_mp_SIntMax2_4_clock = clock;
  assign SIntMaxN_mp_SIntMax2_4_reset = reset;
  assign SIntMaxN_mp_SIntMax2_4_io_in0 = io_in0_2; // @[MaxMin.scala 91:24]
  assign SIntMaxN_mp_SIntMax2_4_io_in1 = io_in0_3; // @[MaxMin.scala 92:24]
  assign SIntMaxN_mp_SIntMax2_4_io_entry_valid = io_entry_valid; // @[MaxMin.scala 79:41]
  assign SIntMaxN_mp_SIntMax2_4_io_exit_ready = io_exit_ready; // @[MaxMin.scala 78:41]
  assign SIntMaxN_mp_SIntMax2_5_clock = clock;
  assign SIntMaxN_mp_SIntMax2_5_reset = reset;
  assign SIntMaxN_mp_SIntMax2_5_io_in0 = io_in0_4; // @[MaxMin.scala 91:24]
  assign SIntMaxN_mp_SIntMax2_5_io_in1 = io_in0_5; // @[MaxMin.scala 92:24]
  assign SIntMaxN_mp_SIntMax2_5_io_entry_valid = io_entry_valid; // @[MaxMin.scala 76:41]
  assign SIntMaxN_mp_SIntMax2_5_io_exit_ready = io_exit_ready; // @[MaxMin.scala 75:41]
  assign SIntMaxN_mp_SIntMax2_6_clock = clock;
  assign SIntMaxN_mp_SIntMax2_6_reset = reset;
  assign SIntMaxN_mp_SIntMax2_6_io_in0 = io_in0_6; // @[MaxMin.scala 91:24]
  assign SIntMaxN_mp_SIntMax2_6_io_in1 = io_in0_7; // @[MaxMin.scala 92:24]
  assign SIntMaxN_mp_SIntMax2_6_io_entry_valid = io_entry_valid; // @[MaxMin.scala 79:41]
  assign SIntMaxN_mp_SIntMax2_6_io_exit_ready = io_exit_ready; // @[MaxMin.scala 78:41]
endmodule
