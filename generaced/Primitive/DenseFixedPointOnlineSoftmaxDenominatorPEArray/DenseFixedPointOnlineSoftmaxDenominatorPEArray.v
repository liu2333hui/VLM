module PipelineData(
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
  reg [15:0] bits; // @[pipeline.scala 126:27]
  reg  valid; // @[pipeline.scala 127:28]
  wire  _T = io_in_valid & io_in_ready; // @[pipeline.scala 132:26]
  wire  _T_1 = _T & io_out_ready; // @[pipeline.scala 132:41]
  wire  _T_3 = ~io_out_valid; // @[pipeline.scala 136:53]
  wire  _T_4 = _T & _T_3; // @[pipeline.scala 136:49]
  assign io_in_ready = io_out_ready; // @[pipeline.scala 129:21]
  assign io_out_valid = valid; // @[pipeline.scala 128:22]
  assign io_out_bits = bits; // @[pipeline.scala 130:21]
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
module PipelineSIntData(
  input         clock,
  input         reset,
  output        io_in_ready,
  input         io_in_valid,
  input  [15:0] io_in_bits,
  input         io_out_ready,
  output        io_out_valid,
  output [15:0] io_out_bits
);
  wire  m_clock; // @[pipeline.scala 106:23]
  wire  m_reset; // @[pipeline.scala 106:23]
  wire  m_io_in_ready; // @[pipeline.scala 106:23]
  wire  m_io_in_valid; // @[pipeline.scala 106:23]
  wire [15:0] m_io_in_bits; // @[pipeline.scala 106:23]
  wire  m_io_out_ready; // @[pipeline.scala 106:23]
  wire  m_io_out_valid; // @[pipeline.scala 106:23]
  wire [15:0] m_io_out_bits; // @[pipeline.scala 106:23]
  PipelineData m ( // @[pipeline.scala 106:23]
    .clock(m_clock),
    .reset(m_reset),
    .io_in_ready(m_io_in_ready),
    .io_in_valid(m_io_in_valid),
    .io_in_bits(m_io_in_bits),
    .io_out_ready(m_io_out_ready),
    .io_out_valid(m_io_out_valid),
    .io_out_bits(m_io_out_bits)
  );
  assign io_in_ready = m_io_in_ready; // @[pipeline.scala 108:21]
  assign io_out_valid = m_io_out_valid; // @[pipeline.scala 110:22]
  assign io_out_bits = m_io_out_bits; // @[pipeline.scala 114:21]
  assign m_clock = clock;
  assign m_reset = reset;
  assign m_io_in_valid = io_in_valid; // @[pipeline.scala 107:23]
  assign m_io_in_bits = io_in_bits; // @[pipeline.scala 113:22]
  assign m_io_out_ready = io_out_ready; // @[pipeline.scala 111:24]
endmodule
module SIntMax2(
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
  wire  p_clock; // @[MaxMin.scala 30:23]
  wire  p_reset; // @[MaxMin.scala 30:23]
  wire  p_io_in_ready; // @[MaxMin.scala 30:23]
  wire  p_io_in_valid; // @[MaxMin.scala 30:23]
  wire [15:0] p_io_in_bits; // @[MaxMin.scala 30:23]
  wire  p_io_out_ready; // @[MaxMin.scala 30:23]
  wire  p_io_out_valid; // @[MaxMin.scala 30:23]
  wire [15:0] p_io_out_bits; // @[MaxMin.scala 30:23]
  wire  _T = $signed(io_in0) > $signed(io_in1); // @[MaxMin.scala 31:36]
  PipelineSIntData p ( // @[MaxMin.scala 30:23]
    .clock(p_clock),
    .reset(p_reset),
    .io_in_ready(p_io_in_ready),
    .io_in_valid(p_io_in_valid),
    .io_in_bits(p_io_in_bits),
    .io_out_ready(p_io_out_ready),
    .io_out_valid(p_io_out_valid),
    .io_out_bits(p_io_out_bits)
  );
  assign io_out = p_io_out_bits; // @[MaxMin.scala 32:16]
  assign io_entry_ready = p_io_in_ready; // @[MaxMin.scala 34:24]
  assign io_exit_valid = p_io_out_valid; // @[MaxMin.scala 36:23]
  assign p_clock = clock;
  assign p_reset = reset;
  assign p_io_in_valid = io_entry_valid; // @[MaxMin.scala 33:23]
  assign p_io_in_bits = _T ? $signed(io_in0) : $signed(io_in1); // @[MaxMin.scala 31:22]
  assign p_io_out_ready = io_exit_ready; // @[MaxMin.scala 37:24]
endmodule
module SIntMaxN(
  input         clock,
  input         reset,
  input  [15:0] io_in0_0,
  input  [15:0] io_in0_1,
  output [15:0] io_out,
  input         io_entry_valid,
  output        io_entry_ready,
  output        io_exit_valid,
  input         io_exit_ready
);
  wire  SIntMax2_clock; // @[MaxMin.scala 46:37]
  wire  SIntMax2_reset; // @[MaxMin.scala 46:37]
  wire [15:0] SIntMax2_io_in0; // @[MaxMin.scala 46:37]
  wire [15:0] SIntMax2_io_in1; // @[MaxMin.scala 46:37]
  wire [15:0] SIntMax2_io_out; // @[MaxMin.scala 46:37]
  wire  SIntMax2_io_entry_valid; // @[MaxMin.scala 46:37]
  wire  SIntMax2_io_entry_ready; // @[MaxMin.scala 46:37]
  wire  SIntMax2_io_exit_valid; // @[MaxMin.scala 46:37]
  wire  SIntMax2_io_exit_ready; // @[MaxMin.scala 46:37]
  SIntMax2 SIntMax2 ( // @[MaxMin.scala 46:37]
    .clock(SIntMax2_clock),
    .reset(SIntMax2_reset),
    .io_in0(SIntMax2_io_in0),
    .io_in1(SIntMax2_io_in1),
    .io_out(SIntMax2_io_out),
    .io_entry_valid(SIntMax2_io_entry_valid),
    .io_entry_ready(SIntMax2_io_entry_ready),
    .io_exit_valid(SIntMax2_io_exit_valid),
    .io_exit_ready(SIntMax2_io_exit_ready)
  );
  assign io_out = SIntMax2_io_out; // @[MaxMin.scala 47:18]
  assign io_entry_ready = SIntMax2_io_entry_ready; // @[MaxMin.scala 49:20]
  assign io_exit_valid = SIntMax2_io_exit_valid; // @[MaxMin.scala 48:19]
  assign SIntMax2_clock = clock;
  assign SIntMax2_reset = reset;
  assign SIntMax2_io_in0 = io_in0_0; // @[MaxMin.scala 50:23]
  assign SIntMax2_io_in1 = io_in0_1; // @[MaxMin.scala 51:23]
  assign SIntMax2_io_entry_valid = io_entry_valid; // @[MaxMin.scala 49:20]
  assign SIntMax2_io_exit_ready = io_exit_ready; // @[MaxMin.scala 48:19]
endmodule
module DenseFixedPointOnlineSoftmaxDenominatorPEArray(
  input        clock,
  input        reset,
  input  [7:0] io_in0_0_i,
  input  [7:0] io_in0_0_f,
  input  [7:0] io_in0_1_i,
  input  [7:0] io_in0_1_f,
  input  [7:0] io_in0_2_i,
  input  [7:0] io_in0_2_f,
  input  [7:0] io_in0_3_i,
  input  [7:0] io_in0_3_f,
  input  [7:0] io_in0_4_i,
  input  [7:0] io_in0_4_f,
  input  [7:0] io_in0_5_i,
  input  [7:0] io_in0_5_f,
  input  [7:0] io_in0_6_i,
  input  [7:0] io_in0_6_f,
  input  [7:0] io_in0_7_i,
  input  [7:0] io_in0_7_f,
  input  [7:0] io_in1_0_i,
  input  [7:0] io_in1_0_f,
  input  [7:0] io_in1_1_i,
  input  [7:0] io_in1_1_f,
  input  [7:0] io_in1_2_i,
  input  [7:0] io_in1_2_f,
  input  [7:0] io_in1_3_i,
  input  [7:0] io_in1_3_f,
  input  [7:0] io_in2_0_i,
  input  [7:0] io_in2_0_f,
  input  [7:0] io_in2_1_i,
  input  [7:0] io_in2_1_f,
  input  [7:0] io_in2_2_i,
  input  [7:0] io_in2_2_f,
  input  [7:0] io_in2_3_i,
  input  [7:0] io_in2_3_f,
  output [7:0] io_out0_0_i,
  output [7:0] io_out0_0_f,
  output [7:0] io_out0_1_i,
  output [7:0] io_out0_1_f,
  output [7:0] io_out0_2_i,
  output [7:0] io_out0_2_f,
  output [7:0] io_out0_3_i,
  output [7:0] io_out0_3_f,
  output       io_exit_valid,
  input        io_exit_ready,
  input        io_entry_valid,
  output       io_entry_ready
);
  wire  mp_0_clock; // @[Dense32Arrays.scala 46:38]
  wire  mp_0_reset; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_0_io_in0_0; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_0_io_in0_1; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_0_io_out; // @[Dense32Arrays.scala 46:38]
  wire  mp_0_io_entry_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_0_io_entry_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_0_io_exit_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_0_io_exit_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_clock; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_reset; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_1_io_in0_0; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_1_io_in0_1; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_1_io_out; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_io_entry_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_io_entry_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_io_exit_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_1_io_exit_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_clock; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_reset; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_2_io_in0_0; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_2_io_in0_1; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_2_io_out; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_io_entry_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_io_entry_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_io_exit_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_2_io_exit_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_clock; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_reset; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_3_io_in0_0; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_3_io_in0_1; // @[Dense32Arrays.scala 46:38]
  wire [15:0] mp_3_io_out; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_io_entry_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_io_entry_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_io_exit_valid; // @[Dense32Arrays.scala 46:38]
  wire  mp_3_io_exit_ready; // @[Dense32Arrays.scala 46:38]
  wire  mp2_0_clock; // @[Dense32Arrays.scala 68:39]
  wire  mp2_0_reset; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_0_io_in0; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_0_io_in1; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_0_io_out; // @[Dense32Arrays.scala 68:39]
  wire  mp2_0_io_entry_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_0_io_entry_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_0_io_exit_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_0_io_exit_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_clock; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_reset; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_1_io_in0; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_1_io_in1; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_1_io_out; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_io_entry_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_io_entry_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_io_exit_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_1_io_exit_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_clock; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_reset; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_2_io_in0; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_2_io_in1; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_2_io_out; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_io_entry_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_io_entry_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_io_exit_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_2_io_exit_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_clock; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_reset; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_3_io_in0; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_3_io_in1; // @[Dense32Arrays.scala 68:39]
  wire [15:0] mp2_3_io_out; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_io_entry_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_io_entry_ready; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_io_exit_valid; // @[Dense32Arrays.scala 68:39]
  wire  mp2_3_io_exit_ready; // @[Dense32Arrays.scala 68:39]
  SIntMaxN mp_0 ( // @[Dense32Arrays.scala 46:38]
    .clock(mp_0_clock),
    .reset(mp_0_reset),
    .io_in0_0(mp_0_io_in0_0),
    .io_in0_1(mp_0_io_in0_1),
    .io_out(mp_0_io_out),
    .io_entry_valid(mp_0_io_entry_valid),
    .io_entry_ready(mp_0_io_entry_ready),
    .io_exit_valid(mp_0_io_exit_valid),
    .io_exit_ready(mp_0_io_exit_ready)
  );
  SIntMaxN mp_1 ( // @[Dense32Arrays.scala 46:38]
    .clock(mp_1_clock),
    .reset(mp_1_reset),
    .io_in0_0(mp_1_io_in0_0),
    .io_in0_1(mp_1_io_in0_1),
    .io_out(mp_1_io_out),
    .io_entry_valid(mp_1_io_entry_valid),
    .io_entry_ready(mp_1_io_entry_ready),
    .io_exit_valid(mp_1_io_exit_valid),
    .io_exit_ready(mp_1_io_exit_ready)
  );
  SIntMaxN mp_2 ( // @[Dense32Arrays.scala 46:38]
    .clock(mp_2_clock),
    .reset(mp_2_reset),
    .io_in0_0(mp_2_io_in0_0),
    .io_in0_1(mp_2_io_in0_1),
    .io_out(mp_2_io_out),
    .io_entry_valid(mp_2_io_entry_valid),
    .io_entry_ready(mp_2_io_entry_ready),
    .io_exit_valid(mp_2_io_exit_valid),
    .io_exit_ready(mp_2_io_exit_ready)
  );
  SIntMaxN mp_3 ( // @[Dense32Arrays.scala 46:38]
    .clock(mp_3_clock),
    .reset(mp_3_reset),
    .io_in0_0(mp_3_io_in0_0),
    .io_in0_1(mp_3_io_in0_1),
    .io_out(mp_3_io_out),
    .io_entry_valid(mp_3_io_entry_valid),
    .io_entry_ready(mp_3_io_entry_ready),
    .io_exit_valid(mp_3_io_exit_valid),
    .io_exit_ready(mp_3_io_exit_ready)
  );
  SIntMax2 mp2_0 ( // @[Dense32Arrays.scala 68:39]
    .clock(mp2_0_clock),
    .reset(mp2_0_reset),
    .io_in0(mp2_0_io_in0),
    .io_in1(mp2_0_io_in1),
    .io_out(mp2_0_io_out),
    .io_entry_valid(mp2_0_io_entry_valid),
    .io_entry_ready(mp2_0_io_entry_ready),
    .io_exit_valid(mp2_0_io_exit_valid),
    .io_exit_ready(mp2_0_io_exit_ready)
  );
  SIntMax2 mp2_1 ( // @[Dense32Arrays.scala 68:39]
    .clock(mp2_1_clock),
    .reset(mp2_1_reset),
    .io_in0(mp2_1_io_in0),
    .io_in1(mp2_1_io_in1),
    .io_out(mp2_1_io_out),
    .io_entry_valid(mp2_1_io_entry_valid),
    .io_entry_ready(mp2_1_io_entry_ready),
    .io_exit_valid(mp2_1_io_exit_valid),
    .io_exit_ready(mp2_1_io_exit_ready)
  );
  SIntMax2 mp2_2 ( // @[Dense32Arrays.scala 68:39]
    .clock(mp2_2_clock),
    .reset(mp2_2_reset),
    .io_in0(mp2_2_io_in0),
    .io_in1(mp2_2_io_in1),
    .io_out(mp2_2_io_out),
    .io_entry_valid(mp2_2_io_entry_valid),
    .io_entry_ready(mp2_2_io_entry_ready),
    .io_exit_valid(mp2_2_io_exit_valid),
    .io_exit_ready(mp2_2_io_exit_ready)
  );
  SIntMax2 mp2_3 ( // @[Dense32Arrays.scala 68:39]
    .clock(mp2_3_clock),
    .reset(mp2_3_reset),
    .io_in0(mp2_3_io_in0),
    .io_in1(mp2_3_io_in1),
    .io_out(mp2_3_io_out),
    .io_entry_valid(mp2_3_io_entry_valid),
    .io_entry_ready(mp2_3_io_entry_ready),
    .io_exit_valid(mp2_3_io_exit_valid),
    .io_exit_ready(mp2_3_io_exit_ready)
  );
  assign io_out0_0_i = mp2_0_io_out[15:8]; // @[Dense32Arrays.scala 81:30]
  assign io_out0_0_f = mp2_0_io_out[7:0]; // @[Dense32Arrays.scala 82:30]
  assign io_out0_1_i = mp2_1_io_out[15:8]; // @[Dense32Arrays.scala 81:30]
  assign io_out0_1_f = mp2_1_io_out[7:0]; // @[Dense32Arrays.scala 82:30]
  assign io_out0_2_i = mp2_2_io_out[15:8]; // @[Dense32Arrays.scala 81:30]
  assign io_out0_2_f = mp2_2_io_out[7:0]; // @[Dense32Arrays.scala 82:30]
  assign io_out0_3_i = mp2_3_io_out[15:8]; // @[Dense32Arrays.scala 81:30]
  assign io_out0_3_f = mp2_3_io_out[7:0]; // @[Dense32Arrays.scala 82:30]
  assign io_exit_valid = mp2_3_io_exit_valid; // @[Dense32Arrays.scala 88:32 Dense32Arrays.scala 88:32 Dense32Arrays.scala 88:32 Dense32Arrays.scala 88:32]
  assign io_entry_ready = mp_3_io_entry_ready; // @[Dense32Arrays.scala 84:32 Dense32Arrays.scala 84:32 Dense32Arrays.scala 84:32 Dense32Arrays.scala 84:32]
  assign mp_0_clock = clock;
  assign mp_0_reset = reset;
  assign mp_0_io_in0_0 = {io_in0_0_i,io_in0_0_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_0_io_in0_1 = {io_in0_1_i,io_in0_1_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_0_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 84:32]
  assign mp_0_io_exit_ready = mp2_0_io_entry_ready; // @[Dense32Arrays.scala 86:31]
  assign mp_1_clock = clock;
  assign mp_1_reset = reset;
  assign mp_1_io_in0_0 = {io_in0_2_i,io_in0_2_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_1_io_in0_1 = {io_in0_3_i,io_in0_3_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_1_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 84:32]
  assign mp_1_io_exit_ready = mp2_1_io_entry_ready; // @[Dense32Arrays.scala 86:31]
  assign mp_2_clock = clock;
  assign mp_2_reset = reset;
  assign mp_2_io_in0_0 = {io_in0_4_i,io_in0_4_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_2_io_in0_1 = {io_in0_5_i,io_in0_5_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_2_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 84:32]
  assign mp_2_io_exit_ready = mp2_2_io_entry_ready; // @[Dense32Arrays.scala 86:31]
  assign mp_3_clock = clock;
  assign mp_3_reset = reset;
  assign mp_3_io_in0_0 = {io_in0_6_i,io_in0_6_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_3_io_in0_1 = {io_in0_7_i,io_in0_7_f}; // @[Dense32Arrays.scala 57:34]
  assign mp_3_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 84:32]
  assign mp_3_io_exit_ready = mp2_3_io_entry_ready; // @[Dense32Arrays.scala 86:31]
  assign mp2_0_clock = clock;
  assign mp2_0_reset = reset;
  assign mp2_0_io_in0 = mp_0_io_out; // @[Dense32Arrays.scala 78:32]
  assign mp2_0_io_in1 = {io_in1_0_i,io_in1_0_f}; // @[Dense32Arrays.scala 79:32]
  assign mp2_0_io_entry_valid = mp_0_io_exit_valid; // @[Dense32Arrays.scala 86:31]
  assign mp2_0_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 88:32]
  assign mp2_1_clock = clock;
  assign mp2_1_reset = reset;
  assign mp2_1_io_in0 = mp_1_io_out; // @[Dense32Arrays.scala 78:32]
  assign mp2_1_io_in1 = {io_in1_1_i,io_in1_1_f}; // @[Dense32Arrays.scala 79:32]
  assign mp2_1_io_entry_valid = mp_1_io_exit_valid; // @[Dense32Arrays.scala 86:31]
  assign mp2_1_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 88:32]
  assign mp2_2_clock = clock;
  assign mp2_2_reset = reset;
  assign mp2_2_io_in0 = mp_2_io_out; // @[Dense32Arrays.scala 78:32]
  assign mp2_2_io_in1 = {io_in1_2_i,io_in1_2_f}; // @[Dense32Arrays.scala 79:32]
  assign mp2_2_io_entry_valid = mp_2_io_exit_valid; // @[Dense32Arrays.scala 86:31]
  assign mp2_2_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 88:32]
  assign mp2_3_clock = clock;
  assign mp2_3_reset = reset;
  assign mp2_3_io_in0 = mp_3_io_out; // @[Dense32Arrays.scala 78:32]
  assign mp2_3_io_in1 = {io_in1_3_i,io_in1_3_f}; // @[Dense32Arrays.scala 79:32]
  assign mp2_3_io_entry_valid = mp_3_io_exit_valid; // @[Dense32Arrays.scala 86:31]
  assign mp2_3_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 88:32]
endmodule
