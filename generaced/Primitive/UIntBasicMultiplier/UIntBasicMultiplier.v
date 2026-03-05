module PipelineData(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [7:0] bits; // @[pipeline.scala 31:27]
  reg  valid; // @[pipeline.scala 32:28]
  wire  _T = io_in_valid & io_in_ready; // @[pipeline.scala 37:26]
  wire  _T_1 = _T & io_out_ready; // @[pipeline.scala 37:41]
  wire  _T_3 = ~io_out_valid; // @[pipeline.scala 41:53]
  wire  _T_4 = _T & _T_3; // @[pipeline.scala 41:49]
  assign io_in_ready = io_out_ready; // @[pipeline.scala 34:21]
  assign io_out_valid = valid; // @[pipeline.scala 33:22]
  assign io_out_bits = bits; // @[pipeline.scala 35:21]
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
  bits = _RAND_0[7:0];
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
      bits <= 8'h0;
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
module UIntBasicMultiplier(
  input        clock,
  input        reset,
  input  [7:0] io_in0,
  input  [7:0] io_in1,
  output [7:0] io_out,
  input        io_entry_valid,
  output       io_entry_ready,
  output       io_exit_valid,
  input        io_exit_ready
);
  wire  p_clock; // @[Basic.scala 45:23]
  wire  p_reset; // @[Basic.scala 45:23]
  wire  p_io_in_ready; // @[Basic.scala 45:23]
  wire  p_io_in_valid; // @[Basic.scala 45:23]
  wire [7:0] p_io_in_bits; // @[Basic.scala 45:23]
  wire  p_io_out_ready; // @[Basic.scala 45:23]
  wire  p_io_out_valid; // @[Basic.scala 45:23]
  wire [7:0] p_io_out_bits; // @[Basic.scala 45:23]
  wire [15:0] _T = io_in0 * io_in1; // @[Basic.scala 46:32]
  PipelineData p ( // @[Basic.scala 45:23]
    .clock(p_clock),
    .reset(p_reset),
    .io_in_ready(p_io_in_ready),
    .io_in_valid(p_io_in_valid),
    .io_in_bits(p_io_in_bits),
    .io_out_ready(p_io_out_ready),
    .io_out_valid(p_io_out_valid),
    .io_out_bits(p_io_out_bits)
  );
  assign io_out = p_io_out_bits; // @[Basic.scala 47:16]
  assign io_entry_ready = p_io_in_ready; // @[Basic.scala 50:24]
  assign io_exit_valid = p_io_out_valid; // @[Basic.scala 52:23]
  assign p_clock = clock;
  assign p_reset = reset;
  assign p_io_in_valid = io_entry_valid; // @[Basic.scala 49:23]
  assign p_io_in_bits = _T[7:0]; // @[Basic.scala 46:22]
  assign p_io_out_ready = io_exit_ready; // @[Basic.scala 53:24]
endmodule
