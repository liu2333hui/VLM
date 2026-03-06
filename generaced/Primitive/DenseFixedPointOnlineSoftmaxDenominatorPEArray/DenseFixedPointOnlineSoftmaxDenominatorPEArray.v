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
  reg [15:0] bits; // @[pipeline.scala 177:27]
  reg  valid; // @[pipeline.scala 178:28]
  wire  _T = io_in_valid & io_in_ready; // @[pipeline.scala 183:26]
  wire  _T_1 = _T & io_out_ready; // @[pipeline.scala 183:41]
  wire  _T_3 = ~io_out_valid; // @[pipeline.scala 187:53]
  wire  _T_4 = _T & _T_3; // @[pipeline.scala 187:49]
  assign io_in_ready = io_out_ready; // @[pipeline.scala 180:21]
  assign io_out_valid = valid; // @[pipeline.scala 179:22]
  assign io_out_bits = bits; // @[pipeline.scala 181:21]
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
module SIntBasicSubtract(
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
  wire  p_clock; // @[BasicSInt.scala 69:23]
  wire  p_reset; // @[BasicSInt.scala 69:23]
  wire  p_io_in_ready; // @[BasicSInt.scala 69:23]
  wire  p_io_in_valid; // @[BasicSInt.scala 69:23]
  wire [15:0] p_io_in_bits; // @[BasicSInt.scala 69:23]
  wire  p_io_out_ready; // @[BasicSInt.scala 69:23]
  wire  p_io_out_valid; // @[BasicSInt.scala 69:23]
  wire [15:0] p_io_out_bits; // @[BasicSInt.scala 69:23]
  PipelineSIntData p ( // @[BasicSInt.scala 69:23]
    .clock(p_clock),
    .reset(p_reset),
    .io_in_ready(p_io_in_ready),
    .io_in_valid(p_io_in_valid),
    .io_in_bits(p_io_in_bits),
    .io_out_ready(p_io_out_ready),
    .io_out_valid(p_io_out_valid),
    .io_out_bits(p_io_out_bits)
  );
  assign io_out = p_io_out_bits; // @[BasicSInt.scala 71:16]
  assign io_entry_ready = p_io_in_ready; // @[BasicSInt.scala 74:24]
  assign io_exit_valid = p_io_out_valid; // @[BasicSInt.scala 76:23]
  assign p_clock = clock;
  assign p_reset = reset;
  assign p_io_in_valid = io_entry_valid; // @[BasicSInt.scala 73:23]
  assign p_io_in_bits = $signed(io_in0) - $signed(io_in1); // @[BasicSInt.scala 70:22]
  assign p_io_out_ready = io_exit_ready; // @[BasicSInt.scala 77:24]
endmodule
module DenseFixedPointOnlineSoftmaxDenominatorPEArray(
  input         clock,
  input         reset,
  input  [7:0]  io_in0_0_i,
  input  [7:0]  io_in0_0_f,
  input  [7:0]  io_in0_1_i,
  input  [7:0]  io_in0_1_f,
  input  [7:0]  io_in0_2_i,
  input  [7:0]  io_in0_2_f,
  input  [7:0]  io_in0_3_i,
  input  [7:0]  io_in0_3_f,
  input  [7:0]  io_in0_4_i,
  input  [7:0]  io_in0_4_f,
  input  [7:0]  io_in0_5_i,
  input  [7:0]  io_in0_5_f,
  input  [7:0]  io_in0_6_i,
  input  [7:0]  io_in0_6_f,
  input  [7:0]  io_in0_7_i,
  input  [7:0]  io_in0_7_f,
  input  [7:0]  io_in1_0_i,
  input  [7:0]  io_in1_0_f,
  input  [7:0]  io_in1_1_i,
  input  [7:0]  io_in1_1_f,
  input  [7:0]  io_in1_2_i,
  input  [7:0]  io_in1_2_f,
  input  [7:0]  io_in1_3_i,
  input  [7:0]  io_in1_3_f,
  input  [7:0]  io_in2_0_i,
  input  [7:0]  io_in2_0_f,
  input  [7:0]  io_in2_1_i,
  input  [7:0]  io_in2_1_f,
  input  [7:0]  io_in2_2_i,
  input  [7:0]  io_in2_2_f,
  input  [7:0]  io_in2_3_i,
  input  [7:0]  io_in2_3_f,
  output [7:0]  io_out0_0_i,
  output [7:0]  io_out0_0_f,
  output [7:0]  io_out0_1_i,
  output [7:0]  io_out0_1_f,
  output [7:0]  io_out0_2_i,
  output [7:0]  io_out0_2_f,
  output [7:0]  io_out0_3_i,
  output [7:0]  io_out0_3_f,
  output [7:0]  io_tmp_0_i,
  output [7:0]  io_tmp_0_f,
  output [7:0]  io_tmp_1_i,
  output [7:0]  io_tmp_1_f,
  output [7:0]  io_tmp_2_i,
  output [7:0]  io_tmp_2_f,
  output [7:0]  io_tmp_3_i,
  output [7:0]  io_tmp_3_f,
  output [7:0]  io_tmp_4_i,
  output [7:0]  io_tmp_4_f,
  output [7:0]  io_tmp_5_i,
  output [7:0]  io_tmp_5_f,
  output [7:0]  io_tmp_6_i,
  output [7:0]  io_tmp_6_f,
  output [7:0]  io_tmp_7_i,
  output [7:0]  io_tmp_7_f,
  output [15:0] io_tmpSInt_0,
  output [15:0] io_tmpSInt_1,
  output [15:0] io_tmpSInt_2,
  output [15:0] io_tmpSInt_3,
  output [15:0] io_tmpSInt_4,
  output [15:0] io_tmpSInt_5,
  output [15:0] io_tmpSInt_6,
  output [15:0] io_tmpSInt_7,
  output        io_exit_valid,
  input         io_exit_ready,
  input         io_entry_valid,
  output        io_entry_ready
);
  wire  mp_0_clock; // @[Dense32Arrays.scala 54:38]
  wire  mp_0_reset; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_0_io_in0_0; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_0_io_in0_1; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_0_io_out; // @[Dense32Arrays.scala 54:38]
  wire  mp_0_io_entry_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_0_io_entry_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_0_io_exit_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_0_io_exit_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_clock; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_reset; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_1_io_in0_0; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_1_io_in0_1; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_1_io_out; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_io_entry_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_io_entry_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_io_exit_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_1_io_exit_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_clock; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_reset; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_2_io_in0_0; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_2_io_in0_1; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_2_io_out; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_io_entry_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_io_entry_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_io_exit_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_2_io_exit_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_clock; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_reset; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_3_io_in0_0; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_3_io_in0_1; // @[Dense32Arrays.scala 54:38]
  wire [15:0] mp_3_io_out; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_io_entry_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_io_entry_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_io_exit_valid; // @[Dense32Arrays.scala 54:38]
  wire  mp_3_io_exit_ready; // @[Dense32Arrays.scala 54:38]
  wire  mp2_0_clock; // @[Dense32Arrays.scala 76:39]
  wire  mp2_0_reset; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_0_io_in0; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_0_io_in1; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_0_io_out; // @[Dense32Arrays.scala 76:39]
  wire  mp2_0_io_entry_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_0_io_entry_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_0_io_exit_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_0_io_exit_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_clock; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_reset; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_1_io_in0; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_1_io_in1; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_1_io_out; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_io_entry_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_io_entry_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_io_exit_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_1_io_exit_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_clock; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_reset; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_2_io_in0; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_2_io_in1; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_2_io_out; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_io_entry_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_io_entry_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_io_exit_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_2_io_exit_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_clock; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_reset; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_3_io_in0; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_3_io_in1; // @[Dense32Arrays.scala 76:39]
  wire [15:0] mp2_3_io_out; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_io_entry_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_io_entry_ready; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_io_exit_valid; // @[Dense32Arrays.scala 76:39]
  wire  mp2_3_io_exit_ready; // @[Dense32Arrays.scala 76:39]
  wire  XStage1_0_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_0_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_0_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_0_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_0_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_0_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_0_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_0_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_1_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_1_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_1_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_2_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_2_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_2_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_3_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_3_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_3_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_4_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_4_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_4_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_5_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_5_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_5_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_6_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_6_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_6_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_clock; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_reset; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_io_in_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_io_in_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_7_io_in_bits; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_io_out_ready; // @[Dense32Arrays.scala 106:45]
  wire  XStage1_7_io_out_valid; // @[Dense32Arrays.scala 106:45]
  wire [15:0] XStage1_7_io_out_bits; // @[Dense32Arrays.scala 106:45]
  wire  D11_0_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_0_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_0_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_0_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_0_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_0_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_0_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_0_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_0_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_1_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_1_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_1_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_1_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_2_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_2_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_2_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_2_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_3_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_3_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_3_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_3_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_4_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_4_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_4_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_4_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_5_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_5_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_5_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_5_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_6_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_6_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_6_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_6_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_clock; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_reset; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_7_io_in0; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_7_io_in1; // @[Dense32Arrays.scala 117:41]
  wire [15:0] D11_7_io_out; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_io_entry_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_io_entry_ready; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_io_exit_valid; // @[Dense32Arrays.scala 117:41]
  wire  D11_7_io_exit_ready; // @[Dense32Arrays.scala 117:41]
  wire  D12_0_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_0_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_0_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_0_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_0_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_0_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_0_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_0_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_0_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_0_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_1_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_1_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_1_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_1_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_1_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_2_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_2_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_2_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_2_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_2_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_3_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_3_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_3_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_3_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_3_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_4_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_4_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_4_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_4_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_4_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_5_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_5_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_5_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_5_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_5_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_6_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_6_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_6_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_6_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_6_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_clock; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_reset; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_7_io_in0_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_7_io_in0_f; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_7_io_out_i; // @[Dense32Arrays.scala 166:23]
  wire [7:0] D12_7_io_out_f; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_io_exit_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_io_exit_ready; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_io_entry_valid; // @[Dense32Arrays.scala 166:23]
  wire  D12_7_io_entry_ready; // @[Dense32Arrays.scala 166:23]
  wire  MStage1_0_clock; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_0_reset; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_0_io_in_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_0_io_in_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_0_io_in_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_0_io_out_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_0_io_out_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_0_io_out_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_clock; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_reset; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_io_in_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_io_in_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_1_io_in_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_io_out_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_1_io_out_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_1_io_out_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_clock; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_reset; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_io_in_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_io_in_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_2_io_in_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_io_out_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_2_io_out_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_2_io_out_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_clock; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_reset; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_io_in_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_io_in_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_3_io_in_bits; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_io_out_ready; // @[Dense32Arrays.scala 213:43]
  wire  MStage1_3_io_out_valid; // @[Dense32Arrays.scala 213:43]
  wire [15:0] MStage1_3_io_out_bits; // @[Dense32Arrays.scala 213:43]
  wire  D21_0_clock; // @[Dense32Arrays.scala 219:39]
  wire  D21_0_reset; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_0_io_in0; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_0_io_in1; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_0_io_out; // @[Dense32Arrays.scala 219:39]
  wire  D21_0_io_entry_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_0_io_entry_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_0_io_exit_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_0_io_exit_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_clock; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_reset; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_1_io_in0; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_1_io_in1; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_1_io_out; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_io_entry_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_io_entry_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_io_exit_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_1_io_exit_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_clock; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_reset; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_2_io_in0; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_2_io_in1; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_2_io_out; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_io_entry_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_io_entry_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_io_exit_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_2_io_exit_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_clock; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_reset; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_3_io_in0; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_3_io_in1; // @[Dense32Arrays.scala 219:39]
  wire [15:0] D21_3_io_out; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_io_entry_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_io_entry_ready; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_io_exit_valid; // @[Dense32Arrays.scala 219:39]
  wire  D21_3_io_exit_ready; // @[Dense32Arrays.scala 219:39]
  wire  D22_0_clock; // @[Dense32Arrays.scala 240:23]
  wire  D22_0_reset; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_0_io_in0_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_0_io_in0_f; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_0_io_out_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_0_io_out_f; // @[Dense32Arrays.scala 240:23]
  wire  D22_0_io_exit_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_0_io_exit_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_0_io_entry_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_0_io_entry_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_clock; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_reset; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_1_io_in0_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_1_io_in0_f; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_1_io_out_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_1_io_out_f; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_io_exit_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_io_exit_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_io_entry_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_1_io_entry_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_clock; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_reset; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_2_io_in0_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_2_io_in0_f; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_2_io_out_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_2_io_out_f; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_io_exit_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_io_exit_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_io_entry_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_2_io_entry_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_clock; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_reset; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_3_io_in0_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_3_io_in0_f; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_3_io_out_i; // @[Dense32Arrays.scala 240:23]
  wire [7:0] D22_3_io_out_f; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_io_exit_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_io_exit_ready; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_io_entry_valid; // @[Dense32Arrays.scala 240:23]
  wire  D22_3_io_entry_ready; // @[Dense32Arrays.scala 240:23]
  SIntMaxN mp_0 ( // @[Dense32Arrays.scala 54:38]
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
  SIntMaxN mp_1 ( // @[Dense32Arrays.scala 54:38]
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
  SIntMaxN mp_2 ( // @[Dense32Arrays.scala 54:38]
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
  SIntMaxN mp_3 ( // @[Dense32Arrays.scala 54:38]
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
  SIntMax2 mp2_0 ( // @[Dense32Arrays.scala 76:39]
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
  SIntMax2 mp2_1 ( // @[Dense32Arrays.scala 76:39]
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
  SIntMax2 mp2_2 ( // @[Dense32Arrays.scala 76:39]
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
  SIntMax2 mp2_3 ( // @[Dense32Arrays.scala 76:39]
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
  PipelineSIntData XStage1_0 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_0_clock),
    .reset(XStage1_0_reset),
    .io_in_ready(XStage1_0_io_in_ready),
    .io_in_valid(XStage1_0_io_in_valid),
    .io_in_bits(XStage1_0_io_in_bits),
    .io_out_ready(XStage1_0_io_out_ready),
    .io_out_valid(XStage1_0_io_out_valid),
    .io_out_bits(XStage1_0_io_out_bits)
  );
  PipelineSIntData XStage1_1 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_1_clock),
    .reset(XStage1_1_reset),
    .io_in_ready(XStage1_1_io_in_ready),
    .io_in_valid(XStage1_1_io_in_valid),
    .io_in_bits(XStage1_1_io_in_bits),
    .io_out_ready(XStage1_1_io_out_ready),
    .io_out_valid(XStage1_1_io_out_valid),
    .io_out_bits(XStage1_1_io_out_bits)
  );
  PipelineSIntData XStage1_2 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_2_clock),
    .reset(XStage1_2_reset),
    .io_in_ready(XStage1_2_io_in_ready),
    .io_in_valid(XStage1_2_io_in_valid),
    .io_in_bits(XStage1_2_io_in_bits),
    .io_out_ready(XStage1_2_io_out_ready),
    .io_out_valid(XStage1_2_io_out_valid),
    .io_out_bits(XStage1_2_io_out_bits)
  );
  PipelineSIntData XStage1_3 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_3_clock),
    .reset(XStage1_3_reset),
    .io_in_ready(XStage1_3_io_in_ready),
    .io_in_valid(XStage1_3_io_in_valid),
    .io_in_bits(XStage1_3_io_in_bits),
    .io_out_ready(XStage1_3_io_out_ready),
    .io_out_valid(XStage1_3_io_out_valid),
    .io_out_bits(XStage1_3_io_out_bits)
  );
  PipelineSIntData XStage1_4 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_4_clock),
    .reset(XStage1_4_reset),
    .io_in_ready(XStage1_4_io_in_ready),
    .io_in_valid(XStage1_4_io_in_valid),
    .io_in_bits(XStage1_4_io_in_bits),
    .io_out_ready(XStage1_4_io_out_ready),
    .io_out_valid(XStage1_4_io_out_valid),
    .io_out_bits(XStage1_4_io_out_bits)
  );
  PipelineSIntData XStage1_5 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_5_clock),
    .reset(XStage1_5_reset),
    .io_in_ready(XStage1_5_io_in_ready),
    .io_in_valid(XStage1_5_io_in_valid),
    .io_in_bits(XStage1_5_io_in_bits),
    .io_out_ready(XStage1_5_io_out_ready),
    .io_out_valid(XStage1_5_io_out_valid),
    .io_out_bits(XStage1_5_io_out_bits)
  );
  PipelineSIntData XStage1_6 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_6_clock),
    .reset(XStage1_6_reset),
    .io_in_ready(XStage1_6_io_in_ready),
    .io_in_valid(XStage1_6_io_in_valid),
    .io_in_bits(XStage1_6_io_in_bits),
    .io_out_ready(XStage1_6_io_out_ready),
    .io_out_valid(XStage1_6_io_out_valid),
    .io_out_bits(XStage1_6_io_out_bits)
  );
  PipelineSIntData XStage1_7 ( // @[Dense32Arrays.scala 106:45]
    .clock(XStage1_7_clock),
    .reset(XStage1_7_reset),
    .io_in_ready(XStage1_7_io_in_ready),
    .io_in_valid(XStage1_7_io_in_valid),
    .io_in_bits(XStage1_7_io_in_bits),
    .io_out_ready(XStage1_7_io_out_ready),
    .io_out_valid(XStage1_7_io_out_valid),
    .io_out_bits(XStage1_7_io_out_bits)
  );
  SIntBasicSubtract D11_0 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_0_clock),
    .reset(D11_0_reset),
    .io_in0(D11_0_io_in0),
    .io_in1(D11_0_io_in1),
    .io_out(D11_0_io_out),
    .io_entry_valid(D11_0_io_entry_valid),
    .io_entry_ready(D11_0_io_entry_ready),
    .io_exit_valid(D11_0_io_exit_valid),
    .io_exit_ready(D11_0_io_exit_ready)
  );
  SIntBasicSubtract D11_1 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_1_clock),
    .reset(D11_1_reset),
    .io_in0(D11_1_io_in0),
    .io_in1(D11_1_io_in1),
    .io_out(D11_1_io_out),
    .io_entry_valid(D11_1_io_entry_valid),
    .io_entry_ready(D11_1_io_entry_ready),
    .io_exit_valid(D11_1_io_exit_valid),
    .io_exit_ready(D11_1_io_exit_ready)
  );
  SIntBasicSubtract D11_2 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_2_clock),
    .reset(D11_2_reset),
    .io_in0(D11_2_io_in0),
    .io_in1(D11_2_io_in1),
    .io_out(D11_2_io_out),
    .io_entry_valid(D11_2_io_entry_valid),
    .io_entry_ready(D11_2_io_entry_ready),
    .io_exit_valid(D11_2_io_exit_valid),
    .io_exit_ready(D11_2_io_exit_ready)
  );
  SIntBasicSubtract D11_3 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_3_clock),
    .reset(D11_3_reset),
    .io_in0(D11_3_io_in0),
    .io_in1(D11_3_io_in1),
    .io_out(D11_3_io_out),
    .io_entry_valid(D11_3_io_entry_valid),
    .io_entry_ready(D11_3_io_entry_ready),
    .io_exit_valid(D11_3_io_exit_valid),
    .io_exit_ready(D11_3_io_exit_ready)
  );
  SIntBasicSubtract D11_4 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_4_clock),
    .reset(D11_4_reset),
    .io_in0(D11_4_io_in0),
    .io_in1(D11_4_io_in1),
    .io_out(D11_4_io_out),
    .io_entry_valid(D11_4_io_entry_valid),
    .io_entry_ready(D11_4_io_entry_ready),
    .io_exit_valid(D11_4_io_exit_valid),
    .io_exit_ready(D11_4_io_exit_ready)
  );
  SIntBasicSubtract D11_5 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_5_clock),
    .reset(D11_5_reset),
    .io_in0(D11_5_io_in0),
    .io_in1(D11_5_io_in1),
    .io_out(D11_5_io_out),
    .io_entry_valid(D11_5_io_entry_valid),
    .io_entry_ready(D11_5_io_entry_ready),
    .io_exit_valid(D11_5_io_exit_valid),
    .io_exit_ready(D11_5_io_exit_ready)
  );
  SIntBasicSubtract D11_6 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_6_clock),
    .reset(D11_6_reset),
    .io_in0(D11_6_io_in0),
    .io_in1(D11_6_io_in1),
    .io_out(D11_6_io_out),
    .io_entry_valid(D11_6_io_entry_valid),
    .io_entry_ready(D11_6_io_entry_ready),
    .io_exit_valid(D11_6_io_exit_valid),
    .io_exit_ready(D11_6_io_exit_ready)
  );
  SIntBasicSubtract D11_7 ( // @[Dense32Arrays.scala 117:41]
    .clock(D11_7_clock),
    .reset(D11_7_reset),
    .io_in0(D11_7_io_in0),
    .io_in1(D11_7_io_in1),
    .io_out(D11_7_io_out),
    .io_entry_valid(D11_7_io_entry_valid),
    .io_entry_ready(D11_7_io_entry_ready),
    .io_exit_valid(D11_7_io_exit_valid),
    .io_exit_ready(D11_7_io_exit_ready)
  );
  FixedPointTrigExp_D12 D12_0 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_0_clock),
    .reset(D12_0_reset),
    .io_in0_i(D12_0_io_in0_i),
    .io_in0_f(D12_0_io_in0_f),
    .io_out_i(D12_0_io_out_i),
    .io_out_f(D12_0_io_out_f),
    .io_exit_valid(D12_0_io_exit_valid),
    .io_exit_ready(D12_0_io_exit_ready),
    .io_entry_valid(D12_0_io_entry_valid),
    .io_entry_ready(D12_0_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_1 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_1_clock),
    .reset(D12_1_reset),
    .io_in0_i(D12_1_io_in0_i),
    .io_in0_f(D12_1_io_in0_f),
    .io_out_i(D12_1_io_out_i),
    .io_out_f(D12_1_io_out_f),
    .io_exit_valid(D12_1_io_exit_valid),
    .io_exit_ready(D12_1_io_exit_ready),
    .io_entry_valid(D12_1_io_entry_valid),
    .io_entry_ready(D12_1_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_2 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_2_clock),
    .reset(D12_2_reset),
    .io_in0_i(D12_2_io_in0_i),
    .io_in0_f(D12_2_io_in0_f),
    .io_out_i(D12_2_io_out_i),
    .io_out_f(D12_2_io_out_f),
    .io_exit_valid(D12_2_io_exit_valid),
    .io_exit_ready(D12_2_io_exit_ready),
    .io_entry_valid(D12_2_io_entry_valid),
    .io_entry_ready(D12_2_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_3 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_3_clock),
    .reset(D12_3_reset),
    .io_in0_i(D12_3_io_in0_i),
    .io_in0_f(D12_3_io_in0_f),
    .io_out_i(D12_3_io_out_i),
    .io_out_f(D12_3_io_out_f),
    .io_exit_valid(D12_3_io_exit_valid),
    .io_exit_ready(D12_3_io_exit_ready),
    .io_entry_valid(D12_3_io_entry_valid),
    .io_entry_ready(D12_3_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_4 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_4_clock),
    .reset(D12_4_reset),
    .io_in0_i(D12_4_io_in0_i),
    .io_in0_f(D12_4_io_in0_f),
    .io_out_i(D12_4_io_out_i),
    .io_out_f(D12_4_io_out_f),
    .io_exit_valid(D12_4_io_exit_valid),
    .io_exit_ready(D12_4_io_exit_ready),
    .io_entry_valid(D12_4_io_entry_valid),
    .io_entry_ready(D12_4_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_5 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_5_clock),
    .reset(D12_5_reset),
    .io_in0_i(D12_5_io_in0_i),
    .io_in0_f(D12_5_io_in0_f),
    .io_out_i(D12_5_io_out_i),
    .io_out_f(D12_5_io_out_f),
    .io_exit_valid(D12_5_io_exit_valid),
    .io_exit_ready(D12_5_io_exit_ready),
    .io_entry_valid(D12_5_io_entry_valid),
    .io_entry_ready(D12_5_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_6 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_6_clock),
    .reset(D12_6_reset),
    .io_in0_i(D12_6_io_in0_i),
    .io_in0_f(D12_6_io_in0_f),
    .io_out_i(D12_6_io_out_i),
    .io_out_f(D12_6_io_out_f),
    .io_exit_valid(D12_6_io_exit_valid),
    .io_exit_ready(D12_6_io_exit_ready),
    .io_entry_valid(D12_6_io_entry_valid),
    .io_entry_ready(D12_6_io_entry_ready)
  );
  FixedPointTrigExp_D12 D12_7 ( // @[Dense32Arrays.scala 166:23]
    .clock(D12_7_clock),
    .reset(D12_7_reset),
    .io_in0_i(D12_7_io_in0_i),
    .io_in0_f(D12_7_io_in0_f),
    .io_out_i(D12_7_io_out_i),
    .io_out_f(D12_7_io_out_f),
    .io_exit_valid(D12_7_io_exit_valid),
    .io_exit_ready(D12_7_io_exit_ready),
    .io_entry_valid(D12_7_io_entry_valid),
    .io_entry_ready(D12_7_io_entry_ready)
  );
  PipelineSIntData MStage1_0 ( // @[Dense32Arrays.scala 213:43]
    .clock(MStage1_0_clock),
    .reset(MStage1_0_reset),
    .io_in_ready(MStage1_0_io_in_ready),
    .io_in_valid(MStage1_0_io_in_valid),
    .io_in_bits(MStage1_0_io_in_bits),
    .io_out_ready(MStage1_0_io_out_ready),
    .io_out_valid(MStage1_0_io_out_valid),
    .io_out_bits(MStage1_0_io_out_bits)
  );
  PipelineSIntData MStage1_1 ( // @[Dense32Arrays.scala 213:43]
    .clock(MStage1_1_clock),
    .reset(MStage1_1_reset),
    .io_in_ready(MStage1_1_io_in_ready),
    .io_in_valid(MStage1_1_io_in_valid),
    .io_in_bits(MStage1_1_io_in_bits),
    .io_out_ready(MStage1_1_io_out_ready),
    .io_out_valid(MStage1_1_io_out_valid),
    .io_out_bits(MStage1_1_io_out_bits)
  );
  PipelineSIntData MStage1_2 ( // @[Dense32Arrays.scala 213:43]
    .clock(MStage1_2_clock),
    .reset(MStage1_2_reset),
    .io_in_ready(MStage1_2_io_in_ready),
    .io_in_valid(MStage1_2_io_in_valid),
    .io_in_bits(MStage1_2_io_in_bits),
    .io_out_ready(MStage1_2_io_out_ready),
    .io_out_valid(MStage1_2_io_out_valid),
    .io_out_bits(MStage1_2_io_out_bits)
  );
  PipelineSIntData MStage1_3 ( // @[Dense32Arrays.scala 213:43]
    .clock(MStage1_3_clock),
    .reset(MStage1_3_reset),
    .io_in_ready(MStage1_3_io_in_ready),
    .io_in_valid(MStage1_3_io_in_valid),
    .io_in_bits(MStage1_3_io_in_bits),
    .io_out_ready(MStage1_3_io_out_ready),
    .io_out_valid(MStage1_3_io_out_valid),
    .io_out_bits(MStage1_3_io_out_bits)
  );
  SIntBasicSubtract D21_0 ( // @[Dense32Arrays.scala 219:39]
    .clock(D21_0_clock),
    .reset(D21_0_reset),
    .io_in0(D21_0_io_in0),
    .io_in1(D21_0_io_in1),
    .io_out(D21_0_io_out),
    .io_entry_valid(D21_0_io_entry_valid),
    .io_entry_ready(D21_0_io_entry_ready),
    .io_exit_valid(D21_0_io_exit_valid),
    .io_exit_ready(D21_0_io_exit_ready)
  );
  SIntBasicSubtract D21_1 ( // @[Dense32Arrays.scala 219:39]
    .clock(D21_1_clock),
    .reset(D21_1_reset),
    .io_in0(D21_1_io_in0),
    .io_in1(D21_1_io_in1),
    .io_out(D21_1_io_out),
    .io_entry_valid(D21_1_io_entry_valid),
    .io_entry_ready(D21_1_io_entry_ready),
    .io_exit_valid(D21_1_io_exit_valid),
    .io_exit_ready(D21_1_io_exit_ready)
  );
  SIntBasicSubtract D21_2 ( // @[Dense32Arrays.scala 219:39]
    .clock(D21_2_clock),
    .reset(D21_2_reset),
    .io_in0(D21_2_io_in0),
    .io_in1(D21_2_io_in1),
    .io_out(D21_2_io_out),
    .io_entry_valid(D21_2_io_entry_valid),
    .io_entry_ready(D21_2_io_entry_ready),
    .io_exit_valid(D21_2_io_exit_valid),
    .io_exit_ready(D21_2_io_exit_ready)
  );
  SIntBasicSubtract D21_3 ( // @[Dense32Arrays.scala 219:39]
    .clock(D21_3_clock),
    .reset(D21_3_reset),
    .io_in0(D21_3_io_in0),
    .io_in1(D21_3_io_in1),
    .io_out(D21_3_io_out),
    .io_entry_valid(D21_3_io_entry_valid),
    .io_entry_ready(D21_3_io_entry_ready),
    .io_exit_valid(D21_3_io_exit_valid),
    .io_exit_ready(D21_3_io_exit_ready)
  );
  FixedPointTrigExp_D22 D22_0 ( // @[Dense32Arrays.scala 240:23]
    .clock(D22_0_clock),
    .reset(D22_0_reset),
    .io_in0_i(D22_0_io_in0_i),
    .io_in0_f(D22_0_io_in0_f),
    .io_out_i(D22_0_io_out_i),
    .io_out_f(D22_0_io_out_f),
    .io_exit_valid(D22_0_io_exit_valid),
    .io_exit_ready(D22_0_io_exit_ready),
    .io_entry_valid(D22_0_io_entry_valid),
    .io_entry_ready(D22_0_io_entry_ready)
  );
  FixedPointTrigExp_D22 D22_1 ( // @[Dense32Arrays.scala 240:23]
    .clock(D22_1_clock),
    .reset(D22_1_reset),
    .io_in0_i(D22_1_io_in0_i),
    .io_in0_f(D22_1_io_in0_f),
    .io_out_i(D22_1_io_out_i),
    .io_out_f(D22_1_io_out_f),
    .io_exit_valid(D22_1_io_exit_valid),
    .io_exit_ready(D22_1_io_exit_ready),
    .io_entry_valid(D22_1_io_entry_valid),
    .io_entry_ready(D22_1_io_entry_ready)
  );
  FixedPointTrigExp_D22 D22_2 ( // @[Dense32Arrays.scala 240:23]
    .clock(D22_2_clock),
    .reset(D22_2_reset),
    .io_in0_i(D22_2_io_in0_i),
    .io_in0_f(D22_2_io_in0_f),
    .io_out_i(D22_2_io_out_i),
    .io_out_f(D22_2_io_out_f),
    .io_exit_valid(D22_2_io_exit_valid),
    .io_exit_ready(D22_2_io_exit_ready),
    .io_entry_valid(D22_2_io_entry_valid),
    .io_entry_ready(D22_2_io_entry_ready)
  );
  FixedPointTrigExp_D22 D22_3 ( // @[Dense32Arrays.scala 240:23]
    .clock(D22_3_clock),
    .reset(D22_3_reset),
    .io_in0_i(D22_3_io_in0_i),
    .io_in0_f(D22_3_io_in0_f),
    .io_out_i(D22_3_io_out_i),
    .io_out_f(D22_3_io_out_f),
    .io_exit_valid(D22_3_io_exit_valid),
    .io_exit_ready(D22_3_io_exit_ready),
    .io_entry_valid(D22_3_io_entry_valid),
    .io_entry_ready(D22_3_io_entry_ready)
  );
  assign io_out0_0_i = mp2_0_io_out[15:8]; // @[Dense32Arrays.scala 89:30]
  assign io_out0_0_f = mp2_0_io_out[7:0]; // @[Dense32Arrays.scala 90:30]
  assign io_out0_1_i = mp2_1_io_out[15:8]; // @[Dense32Arrays.scala 89:30]
  assign io_out0_1_f = mp2_1_io_out[7:0]; // @[Dense32Arrays.scala 90:30]
  assign io_out0_2_i = mp2_2_io_out[15:8]; // @[Dense32Arrays.scala 89:30]
  assign io_out0_2_f = mp2_2_io_out[7:0]; // @[Dense32Arrays.scala 90:30]
  assign io_out0_3_i = mp2_3_io_out[15:8]; // @[Dense32Arrays.scala 89:30]
  assign io_out0_3_f = mp2_3_io_out[7:0]; // @[Dense32Arrays.scala 90:30]
  assign io_tmp_0_i = D12_0_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_0_f = D12_0_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_1_i = D12_1_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_1_f = D12_1_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_2_i = D12_2_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_2_f = D12_2_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_3_i = D12_3_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_3_f = D12_3_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_4_i = D12_4_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_4_f = D12_4_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_5_i = D12_5_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_5_f = D12_5_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_6_i = D12_6_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_6_f = D12_6_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmp_7_i = D12_7_io_out_i; // @[Dense32Arrays.scala 204:33]
  assign io_tmp_7_f = D12_7_io_out_f; // @[Dense32Arrays.scala 205:33]
  assign io_tmpSInt_0 = {D12_0_io_out_i,D12_0_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_1 = {D12_1_io_out_i,D12_1_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_2 = {D12_2_io_out_i,D12_2_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_3 = {D12_3_io_out_i,D12_3_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_4 = {D12_4_io_out_i,D12_4_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_5 = {D12_5_io_out_i,D12_5_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_6 = {D12_6_io_out_i,D12_6_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_tmpSInt_7 = {D12_7_io_out_i,D12_7_io_out_f}; // @[Dense32Arrays.scala 207:35]
  assign io_exit_valid = D12_7_io_exit_valid; // @[Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31 Dense32Arrays.scala 202:31]
  assign io_entry_ready = XStage1_7_io_in_ready & mp_3_io_entry_ready; // @[Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32 Dense32Arrays.scala 199:32]
  assign mp_0_clock = clock;
  assign mp_0_reset = reset;
  assign mp_0_io_in0_0 = {io_in0_0_i,io_in0_0_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_0_io_in0_1 = {io_in0_1_i,io_in0_1_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_0_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 95:38]
  assign mp_0_io_exit_ready = mp2_0_io_entry_ready; // @[Dense32Arrays.scala 93:31]
  assign mp_1_clock = clock;
  assign mp_1_reset = reset;
  assign mp_1_io_in0_0 = {io_in0_2_i,io_in0_2_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_1_io_in0_1 = {io_in0_3_i,io_in0_3_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_1_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 95:38]
  assign mp_1_io_exit_ready = mp2_1_io_entry_ready; // @[Dense32Arrays.scala 93:31]
  assign mp_2_clock = clock;
  assign mp_2_reset = reset;
  assign mp_2_io_in0_0 = {io_in0_4_i,io_in0_4_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_2_io_in0_1 = {io_in0_5_i,io_in0_5_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_2_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 95:38]
  assign mp_2_io_exit_ready = mp2_2_io_entry_ready; // @[Dense32Arrays.scala 93:31]
  assign mp_3_clock = clock;
  assign mp_3_reset = reset;
  assign mp_3_io_in0_0 = {io_in0_6_i,io_in0_6_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_3_io_in0_1 = {io_in0_7_i,io_in0_7_f}; // @[Dense32Arrays.scala 65:34]
  assign mp_3_io_entry_valid = io_entry_valid; // @[Dense32Arrays.scala 95:38]
  assign mp_3_io_exit_ready = mp2_3_io_entry_ready; // @[Dense32Arrays.scala 93:31]
  assign mp2_0_clock = clock;
  assign mp2_0_reset = reset;
  assign mp2_0_io_in0 = mp_0_io_out; // @[Dense32Arrays.scala 86:32]
  assign mp2_0_io_in1 = {io_in1_0_i,io_in1_0_f}; // @[Dense32Arrays.scala 87:32]
  assign mp2_0_io_entry_valid = mp_0_io_exit_valid; // @[Dense32Arrays.scala 93:31]
  assign mp2_0_io_exit_ready = D21_0_io_entry_ready & MStage1_0_io_out_valid; // @[Dense32Arrays.scala 132:38 Dense32Arrays.scala 132:38 Dense32Arrays.scala 233:38]
  assign mp2_1_clock = clock;
  assign mp2_1_reset = reset;
  assign mp2_1_io_in0 = mp_1_io_out; // @[Dense32Arrays.scala 86:32]
  assign mp2_1_io_in1 = {io_in1_1_i,io_in1_1_f}; // @[Dense32Arrays.scala 87:32]
  assign mp2_1_io_entry_valid = mp_1_io_exit_valid; // @[Dense32Arrays.scala 93:31]
  assign mp2_1_io_exit_ready = D21_1_io_entry_ready & MStage1_1_io_out_valid; // @[Dense32Arrays.scala 132:38 Dense32Arrays.scala 132:38 Dense32Arrays.scala 233:38]
  assign mp2_2_clock = clock;
  assign mp2_2_reset = reset;
  assign mp2_2_io_in0 = mp_2_io_out; // @[Dense32Arrays.scala 86:32]
  assign mp2_2_io_in1 = {io_in1_2_i,io_in1_2_f}; // @[Dense32Arrays.scala 87:32]
  assign mp2_2_io_entry_valid = mp_2_io_exit_valid; // @[Dense32Arrays.scala 93:31]
  assign mp2_2_io_exit_ready = D21_2_io_entry_ready & MStage1_2_io_out_valid; // @[Dense32Arrays.scala 132:38 Dense32Arrays.scala 132:38 Dense32Arrays.scala 233:38]
  assign mp2_3_clock = clock;
  assign mp2_3_reset = reset;
  assign mp2_3_io_in0 = mp_3_io_out; // @[Dense32Arrays.scala 86:32]
  assign mp2_3_io_in1 = {io_in1_3_i,io_in1_3_f}; // @[Dense32Arrays.scala 87:32]
  assign mp2_3_io_entry_valid = mp_3_io_exit_valid; // @[Dense32Arrays.scala 93:31]
  assign mp2_3_io_exit_ready = D21_3_io_entry_ready & MStage1_3_io_out_valid; // @[Dense32Arrays.scala 132:38 Dense32Arrays.scala 132:38 Dense32Arrays.scala 233:38]
  assign XStage1_0_clock = clock;
  assign XStage1_0_reset = reset;
  assign XStage1_0_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_0_io_in_bits = {io_in0_0_i,io_in0_0_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_0_io_out_ready = D11_0_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_1_clock = clock;
  assign XStage1_1_reset = reset;
  assign XStage1_1_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_1_io_in_bits = {io_in0_1_i,io_in0_1_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_1_io_out_ready = D11_1_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_2_clock = clock;
  assign XStage1_2_reset = reset;
  assign XStage1_2_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_2_io_in_bits = {io_in0_2_i,io_in0_2_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_2_io_out_ready = D11_2_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_3_clock = clock;
  assign XStage1_3_reset = reset;
  assign XStage1_3_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_3_io_in_bits = {io_in0_3_i,io_in0_3_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_3_io_out_ready = D11_3_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_4_clock = clock;
  assign XStage1_4_reset = reset;
  assign XStage1_4_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_4_io_in_bits = {io_in0_4_i,io_in0_4_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_4_io_out_ready = D11_4_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_5_clock = clock;
  assign XStage1_5_reset = reset;
  assign XStage1_5_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_5_io_in_bits = {io_in0_5_i,io_in0_5_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_5_io_out_ready = D11_5_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_6_clock = clock;
  assign XStage1_6_reset = reset;
  assign XStage1_6_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_6_io_in_bits = {io_in0_6_i,io_in0_6_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_6_io_out_ready = D11_6_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign XStage1_7_clock = clock;
  assign XStage1_7_reset = reset;
  assign XStage1_7_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 111:44]
  assign XStage1_7_io_in_bits = {io_in0_7_i,io_in0_7_f}; // @[Dense32Arrays.scala 109:43]
  assign XStage1_7_io_out_ready = D11_7_io_entry_ready; // @[Dense32Arrays.scala 141:45]
  assign D11_0_clock = clock;
  assign D11_0_reset = reset;
  assign D11_0_io_in0 = XStage1_0_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_0_io_in1 = mp2_0_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_0_io_entry_valid = mp2_0_io_exit_valid & XStage1_0_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_0_io_exit_ready = D12_0_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_1_clock = clock;
  assign D11_1_reset = reset;
  assign D11_1_io_in0 = XStage1_1_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_1_io_in1 = mp2_0_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_1_io_entry_valid = mp2_0_io_exit_valid & XStage1_1_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_1_io_exit_ready = D12_1_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_2_clock = clock;
  assign D11_2_reset = reset;
  assign D11_2_io_in0 = XStage1_2_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_2_io_in1 = mp2_1_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_2_io_entry_valid = mp2_1_io_exit_valid & XStage1_2_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_2_io_exit_ready = D12_2_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_3_clock = clock;
  assign D11_3_reset = reset;
  assign D11_3_io_in0 = XStage1_3_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_3_io_in1 = mp2_1_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_3_io_entry_valid = mp2_1_io_exit_valid & XStage1_3_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_3_io_exit_ready = D12_3_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_4_clock = clock;
  assign D11_4_reset = reset;
  assign D11_4_io_in0 = XStage1_4_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_4_io_in1 = mp2_2_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_4_io_entry_valid = mp2_2_io_exit_valid & XStage1_4_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_4_io_exit_ready = D12_4_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_5_clock = clock;
  assign D11_5_reset = reset;
  assign D11_5_io_in0 = XStage1_5_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_5_io_in1 = mp2_2_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_5_io_entry_valid = mp2_2_io_exit_valid & XStage1_5_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_5_io_exit_ready = D12_5_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_6_clock = clock;
  assign D11_6_reset = reset;
  assign D11_6_io_in0 = XStage1_6_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_6_io_in1 = mp2_3_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_6_io_entry_valid = mp2_3_io_exit_valid & XStage1_6_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_6_io_exit_ready = D12_6_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D11_7_clock = clock;
  assign D11_7_reset = reset;
  assign D11_7_io_in0 = XStage1_7_io_out_bits; // @[Dense32Arrays.scala 127:36]
  assign D11_7_io_in1 = mp2_3_io_out; // @[Dense32Arrays.scala 128:36]
  assign D11_7_io_entry_valid = mp2_3_io_exit_valid & XStage1_7_io_out_valid; // @[Dense32Arrays.scala 131:43]
  assign D11_7_io_exit_ready = D12_7_io_entry_ready; // @[Dense32Arrays.scala 140:42 Dense32Arrays.scala 193:42]
  assign D12_0_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_0_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_0_io_in0_i = D11_0_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_0_io_in0_f = D11_0_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_0_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_0_io_entry_valid = D11_0_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_1_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_1_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_1_io_in0_i = D11_1_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_1_io_in0_f = D11_1_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_1_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_1_io_entry_valid = D11_1_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_2_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_2_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_2_io_in0_i = D11_2_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_2_io_in0_f = D11_2_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_2_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_2_io_entry_valid = D11_2_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_3_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_3_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_3_io_in0_i = D11_3_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_3_io_in0_f = D11_3_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_3_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_3_io_entry_valid = D11_3_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_4_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_4_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_4_io_in0_i = D11_4_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_4_io_in0_f = D11_4_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_4_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_4_io_entry_valid = D11_4_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_5_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_5_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_5_io_in0_i = D11_5_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_5_io_in0_f = D11_5_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_5_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_5_io_entry_valid = D11_5_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_6_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_6_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_6_io_in0_i = D11_6_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_6_io_in0_f = D11_6_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_6_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_6_io_entry_valid = D11_6_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign D12_7_clock = clock; // @[Dense32Arrays.scala 185:37]
  assign D12_7_reset = reset; // @[Dense32Arrays.scala 186:37]
  assign D12_7_io_in0_i = D11_7_io_out[15:8]; // @[Dense32Arrays.scala 188:41]
  assign D12_7_io_in0_f = D11_7_io_out[7:0]; // @[Dense32Arrays.scala 189:41]
  assign D12_7_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 195:45]
  assign D12_7_io_entry_valid = D11_7_io_exit_valid; // @[Dense32Arrays.scala 192:46]
  assign MStage1_0_clock = clock;
  assign MStage1_0_reset = reset;
  assign MStage1_0_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 216:40]
  assign MStage1_0_io_in_bits = {io_in1_0_i,io_in1_0_f}; // @[Dense32Arrays.scala 215:39]
  assign MStage1_0_io_out_ready = D21_0_io_entry_ready; // @[Dense32Arrays.scala 236:41]
  assign MStage1_1_clock = clock;
  assign MStage1_1_reset = reset;
  assign MStage1_1_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 216:40]
  assign MStage1_1_io_in_bits = {io_in1_1_i,io_in1_1_f}; // @[Dense32Arrays.scala 215:39]
  assign MStage1_1_io_out_ready = D21_1_io_entry_ready; // @[Dense32Arrays.scala 236:41]
  assign MStage1_2_clock = clock;
  assign MStage1_2_reset = reset;
  assign MStage1_2_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 216:40]
  assign MStage1_2_io_in_bits = {io_in1_2_i,io_in1_2_f}; // @[Dense32Arrays.scala 215:39]
  assign MStage1_2_io_out_ready = D21_2_io_entry_ready; // @[Dense32Arrays.scala 236:41]
  assign MStage1_3_clock = clock;
  assign MStage1_3_reset = reset;
  assign MStage1_3_io_in_valid = io_entry_valid; // @[Dense32Arrays.scala 216:40]
  assign MStage1_3_io_in_bits = {io_in1_3_i,io_in1_3_f}; // @[Dense32Arrays.scala 215:39]
  assign MStage1_3_io_out_ready = D21_3_io_entry_ready; // @[Dense32Arrays.scala 236:41]
  assign D21_0_clock = clock;
  assign D21_0_reset = reset;
  assign D21_0_io_in0 = MStage1_0_io_out_bits; // @[Dense32Arrays.scala 228:32]
  assign D21_0_io_in1 = mp2_0_io_out; // @[Dense32Arrays.scala 229:32]
  assign D21_0_io_entry_valid = mp2_0_io_exit_valid & MStage1_0_io_out_valid; // @[Dense32Arrays.scala 232:39]
  assign D21_0_io_exit_ready = D22_0_io_entry_ready; // @[Dense32Arrays.scala 235:38 Dense32Arrays.scala 284:38]
  assign D21_1_clock = clock;
  assign D21_1_reset = reset;
  assign D21_1_io_in0 = MStage1_1_io_out_bits; // @[Dense32Arrays.scala 228:32]
  assign D21_1_io_in1 = mp2_1_io_out; // @[Dense32Arrays.scala 229:32]
  assign D21_1_io_entry_valid = mp2_1_io_exit_valid & MStage1_1_io_out_valid; // @[Dense32Arrays.scala 232:39]
  assign D21_1_io_exit_ready = D22_1_io_entry_ready; // @[Dense32Arrays.scala 235:38 Dense32Arrays.scala 284:38]
  assign D21_2_clock = clock;
  assign D21_2_reset = reset;
  assign D21_2_io_in0 = MStage1_2_io_out_bits; // @[Dense32Arrays.scala 228:32]
  assign D21_2_io_in1 = mp2_2_io_out; // @[Dense32Arrays.scala 229:32]
  assign D21_2_io_entry_valid = mp2_2_io_exit_valid & MStage1_2_io_out_valid; // @[Dense32Arrays.scala 232:39]
  assign D21_2_io_exit_ready = D22_2_io_entry_ready; // @[Dense32Arrays.scala 235:38 Dense32Arrays.scala 284:38]
  assign D21_3_clock = clock;
  assign D21_3_reset = reset;
  assign D21_3_io_in0 = MStage1_3_io_out_bits; // @[Dense32Arrays.scala 228:32]
  assign D21_3_io_in1 = mp2_3_io_out; // @[Dense32Arrays.scala 229:32]
  assign D21_3_io_entry_valid = mp2_3_io_exit_valid & MStage1_3_io_out_valid; // @[Dense32Arrays.scala 232:39]
  assign D21_3_io_exit_ready = D22_3_io_entry_ready; // @[Dense32Arrays.scala 235:38 Dense32Arrays.scala 284:38]
  assign D22_0_clock = clock; // @[Dense32Arrays.scala 276:33]
  assign D22_0_reset = reset; // @[Dense32Arrays.scala 277:33]
  assign D22_0_io_in0_i = D21_0_io_out[15:8]; // @[Dense32Arrays.scala 279:37]
  assign D22_0_io_in0_f = D21_0_io_out[7:0]; // @[Dense32Arrays.scala 280:37]
  assign D22_0_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 286:41]
  assign D22_0_io_entry_valid = D21_0_io_exit_valid; // @[Dense32Arrays.scala 283:42]
  assign D22_1_clock = clock; // @[Dense32Arrays.scala 276:33]
  assign D22_1_reset = reset; // @[Dense32Arrays.scala 277:33]
  assign D22_1_io_in0_i = D21_1_io_out[15:8]; // @[Dense32Arrays.scala 279:37]
  assign D22_1_io_in0_f = D21_1_io_out[7:0]; // @[Dense32Arrays.scala 280:37]
  assign D22_1_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 286:41]
  assign D22_1_io_entry_valid = D21_1_io_exit_valid; // @[Dense32Arrays.scala 283:42]
  assign D22_2_clock = clock; // @[Dense32Arrays.scala 276:33]
  assign D22_2_reset = reset; // @[Dense32Arrays.scala 277:33]
  assign D22_2_io_in0_i = D21_2_io_out[15:8]; // @[Dense32Arrays.scala 279:37]
  assign D22_2_io_in0_f = D21_2_io_out[7:0]; // @[Dense32Arrays.scala 280:37]
  assign D22_2_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 286:41]
  assign D22_2_io_entry_valid = D21_2_io_exit_valid; // @[Dense32Arrays.scala 283:42]
  assign D22_3_clock = clock; // @[Dense32Arrays.scala 276:33]
  assign D22_3_reset = reset; // @[Dense32Arrays.scala 277:33]
  assign D22_3_io_in0_i = D21_3_io_out[15:8]; // @[Dense32Arrays.scala 279:37]
  assign D22_3_io_in0_f = D21_3_io_out[7:0]; // @[Dense32Arrays.scala 280:37]
  assign D22_3_io_exit_ready = io_exit_ready; // @[Dense32Arrays.scala 286:41]
  assign D22_3_io_entry_valid = D21_3_io_exit_valid; // @[Dense32Arrays.scala 283:42]
endmodule
