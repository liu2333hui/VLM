module FixedPointTrigExp_D12_approx_op_PipelineUInt(
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
module FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder(
  input  [4:0]  io_in,
  input  [31:0] io_x,
  output [31:0] io_out
);
  wire  _T = 5'h0 == io_in; // @[Conditional.scala 37:30]
  wire [32:0] _T_1 = $signed(io_x) * 32'sh0; // @[shiftmultiplier.scala 120:58]
  wire  _T_2 = 5'h1 == io_in; // @[Conditional.scala 37:30]
  wire [33:0] _T_3 = $signed(io_x) * 32'sh1; // @[shiftmultiplier.scala 121:58]
  wire  _T_4 = 5'h2 == io_in; // @[Conditional.scala 37:30]
  wire  _T_6 = 5'h3 == io_in; // @[Conditional.scala 37:30]
  wire [34:0] _T_7 = $signed(io_x) * 32'sh2; // @[shiftmultiplier.scala 123:58]
  wire  _T_8 = 5'h4 == io_in; // @[Conditional.scala 37:30]
  wire  _T_10 = 5'h5 == io_in; // @[Conditional.scala 37:30]
  wire [34:0] _T_11 = $signed(io_x) * 32'sh3; // @[shiftmultiplier.scala 125:58]
  wire  _T_12 = 5'h6 == io_in; // @[Conditional.scala 37:30]
  wire  _T_14 = 5'h7 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_15 = $signed(io_x) * 32'sh4; // @[shiftmultiplier.scala 127:58]
  wire  _T_16 = 5'h8 == io_in; // @[Conditional.scala 37:30]
  wire  _T_18 = 5'h9 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_19 = $signed(io_x) * 32'sh5; // @[shiftmultiplier.scala 129:58]
  wire  _T_20 = 5'ha == io_in; // @[Conditional.scala 37:30]
  wire  _T_22 = 5'hb == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_23 = $signed(io_x) * 32'sh6; // @[shiftmultiplier.scala 131:58]
  wire  _T_24 = 5'hc == io_in; // @[Conditional.scala 37:30]
  wire  _T_26 = 5'hd == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_27 = $signed(io_x) * 32'sh7; // @[shiftmultiplier.scala 133:58]
  wire  _T_28 = 5'he == io_in; // @[Conditional.scala 37:30]
  wire  _T_30 = 5'hf == io_in; // @[Conditional.scala 37:30]
  wire [36:0] _T_31 = $signed(io_x) * 32'sh8; // @[shiftmultiplier.scala 135:58]
  wire  _T_32 = 5'h10 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_33 = $signed(io_x) * -32'sh8; // @[shiftmultiplier.scala 136:58]
  wire  _T_34 = 5'h11 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_35 = $signed(io_x) * -32'sh7; // @[shiftmultiplier.scala 137:58]
  wire  _T_36 = 5'h12 == io_in; // @[Conditional.scala 37:30]
  wire  _T_38 = 5'h13 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_39 = $signed(io_x) * -32'sh6; // @[shiftmultiplier.scala 139:58]
  wire  _T_40 = 5'h14 == io_in; // @[Conditional.scala 37:30]
  wire  _T_42 = 5'h15 == io_in; // @[Conditional.scala 37:30]
  wire [35:0] _T_43 = $signed(io_x) * -32'sh5; // @[shiftmultiplier.scala 141:58]
  wire  _T_44 = 5'h16 == io_in; // @[Conditional.scala 37:30]
  wire  _T_46 = 5'h17 == io_in; // @[Conditional.scala 37:30]
  wire [34:0] _T_47 = $signed(io_x) * -32'sh4; // @[shiftmultiplier.scala 143:58]
  wire  _T_48 = 5'h18 == io_in; // @[Conditional.scala 37:30]
  wire  _T_50 = 5'h19 == io_in; // @[Conditional.scala 37:30]
  wire [34:0] _T_51 = $signed(io_x) * -32'sh3; // @[shiftmultiplier.scala 145:58]
  wire  _T_52 = 5'h1a == io_in; // @[Conditional.scala 37:30]
  wire  _T_54 = 5'h1b == io_in; // @[Conditional.scala 37:30]
  wire [33:0] _T_55 = $signed(io_x) * -32'sh2; // @[shiftmultiplier.scala 147:58]
  wire  _T_56 = 5'h1c == io_in; // @[Conditional.scala 37:30]
  wire  _T_58 = 5'h1d == io_in; // @[Conditional.scala 37:30]
  wire [32:0] _T_59 = $signed(io_x) * -32'sh1; // @[shiftmultiplier.scala 149:58]
  wire  _T_60 = 5'h1e == io_in; // @[Conditional.scala 37:30]
  wire  _T_62 = 5'h1f == io_in; // @[Conditional.scala 37:30]
  wire [32:0] _GEN_0 = _T_62 ? $signed(_T_1) : $signed(33'sh0); // @[Conditional.scala 39:67]
  wire [32:0] _GEN_1 = _T_60 ? $signed(_T_59) : $signed(_GEN_0); // @[Conditional.scala 39:67]
  wire [32:0] _GEN_2 = _T_58 ? $signed(_T_59) : $signed(_GEN_1); // @[Conditional.scala 39:67]
  wire [33:0] _GEN_3 = _T_56 ? $signed(_T_55) : $signed({{1{_GEN_2[32]}},_GEN_2}); // @[Conditional.scala 39:67]
  wire [33:0] _GEN_4 = _T_54 ? $signed(_T_55) : $signed(_GEN_3); // @[Conditional.scala 39:67]
  wire [34:0] _GEN_5 = _T_52 ? $signed(_T_51) : $signed({{1{_GEN_4[33]}},_GEN_4}); // @[Conditional.scala 39:67]
  wire [34:0] _GEN_6 = _T_50 ? $signed(_T_51) : $signed(_GEN_5); // @[Conditional.scala 39:67]
  wire [34:0] _GEN_7 = _T_48 ? $signed(_T_47) : $signed(_GEN_6); // @[Conditional.scala 39:67]
  wire [34:0] _GEN_8 = _T_46 ? $signed(_T_47) : $signed(_GEN_7); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_9 = _T_44 ? $signed(_T_43) : $signed({{1{_GEN_8[34]}},_GEN_8}); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_10 = _T_42 ? $signed(_T_43) : $signed(_GEN_9); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_11 = _T_40 ? $signed(_T_39) : $signed(_GEN_10); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_12 = _T_38 ? $signed(_T_39) : $signed(_GEN_11); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_13 = _T_36 ? $signed(_T_35) : $signed(_GEN_12); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_14 = _T_34 ? $signed(_T_35) : $signed(_GEN_13); // @[Conditional.scala 39:67]
  wire [35:0] _GEN_15 = _T_32 ? $signed(_T_33) : $signed(_GEN_14); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_16 = _T_30 ? $signed(_T_31) : $signed({{1{_GEN_15[35]}},_GEN_15}); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_17 = _T_28 ? $signed({{1{_T_27[35]}},_T_27}) : $signed(_GEN_16); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_18 = _T_26 ? $signed({{1{_T_27[35]}},_T_27}) : $signed(_GEN_17); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_19 = _T_24 ? $signed({{1{_T_23[35]}},_T_23}) : $signed(_GEN_18); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_20 = _T_22 ? $signed({{1{_T_23[35]}},_T_23}) : $signed(_GEN_19); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_21 = _T_20 ? $signed({{1{_T_19[35]}},_T_19}) : $signed(_GEN_20); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_22 = _T_18 ? $signed({{1{_T_19[35]}},_T_19}) : $signed(_GEN_21); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_23 = _T_16 ? $signed({{1{_T_15[35]}},_T_15}) : $signed(_GEN_22); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_24 = _T_14 ? $signed({{1{_T_15[35]}},_T_15}) : $signed(_GEN_23); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_25 = _T_12 ? $signed({{2{_T_11[34]}},_T_11}) : $signed(_GEN_24); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_26 = _T_10 ? $signed({{2{_T_11[34]}},_T_11}) : $signed(_GEN_25); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_27 = _T_8 ? $signed({{2{_T_7[34]}},_T_7}) : $signed(_GEN_26); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_28 = _T_6 ? $signed({{2{_T_7[34]}},_T_7}) : $signed(_GEN_27); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_29 = _T_4 ? $signed({{3{_T_3[33]}},_T_3}) : $signed(_GEN_28); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_30 = _T_2 ? $signed({{3{_T_3[33]}},_T_3}) : $signed(_GEN_29); // @[Conditional.scala 39:67]
  wire [36:0] _GEN_31 = _T ? $signed({{4{_T_1[32]}},_T_1}) : $signed(_GEN_30); // @[Conditional.scala 40:58]
  assign io_out = _GEN_31[31:0]; // @[shiftmultiplier.scala 108:25 shiftmultiplier.scala 120:50 shiftmultiplier.scala 121:50 shiftmultiplier.scala 122:50 shiftmultiplier.scala 123:50 shiftmultiplier.scala 124:50 shiftmultiplier.scala 125:50 shiftmultiplier.scala 126:50 shiftmultiplier.scala 127:50 shiftmultiplier.scala 128:50 shiftmultiplier.scala 129:50 shiftmultiplier.scala 130:50 shiftmultiplier.scala 131:50 shiftmultiplier.scala 132:50 shiftmultiplier.scala 133:50 shiftmultiplier.scala 134:50 shiftmultiplier.scala 135:50 shiftmultiplier.scala 136:50 shiftmultiplier.scala 137:50 shiftmultiplier.scala 138:50 shiftmultiplier.scala 139:50 shiftmultiplier.scala 140:50 shiftmultiplier.scala 141:50 shiftmultiplier.scala 142:50 shiftmultiplier.scala 143:50 shiftmultiplier.scala 144:50 shiftmultiplier.scala 145:50 shiftmultiplier.scala 146:50 shiftmultiplier.scala 147:50 shiftmultiplier.scala 148:50 shiftmultiplier.scala 149:50 shiftmultiplier.scala 150:50 shiftmultiplier.scala 151:50]
endmodule
module FixedPointTrigExp_D12_approx_op_BoothMultiplier(
  input         clock,
  input         reset,
  output        io_out_valid,
  input         io_out_ready,
  input         io_in_valid,
  output        io_in_ready,
  input  [15:0] io_math_data1,
  input  [15:0] io_math_data2,
  output [31:0] io_math_res
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  wire [4:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_in; // @[shiftmultiplier.scala 228:32]
  wire [31:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_x; // @[shiftmultiplier.scala 228:32]
  wire [31:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_out; // @[shiftmultiplier.scala 228:32]
  reg [31:0] cnt; // @[shiftmultiplier.scala 207:26]
  wire  _T = io_in_valid & io_in_ready; // @[shiftmultiplier.scala 233:34]
  wire  _T_1 = cnt >= 32'h1; // @[shiftmultiplier.scala 233:58]
  wire  _T_2 = _T | _T_1; // @[shiftmultiplier.scala 233:49]
  wire  _T_3 = cnt >= 32'h4; // @[shiftmultiplier.scala 234:34]
  wire  _T_4 = io_in_valid & io_out_ready; // @[shiftmultiplier.scala 235:50]
  wire  _T_5 = ~io_out_ready; // @[shiftmultiplier.scala 237:44]
  wire [2:0] _GEN_0 = _T_5 ? 3'h4 : 3'h0; // @[shiftmultiplier.scala 237:58]
  wire [2:0] _GEN_1 = _T_4 ? 3'h1 : _GEN_0; // @[shiftmultiplier.scala 235:66]
  wire [31:0] _T_7 = cnt + 32'h1; // @[shiftmultiplier.scala 243:44]
  wire  _T_9 = io_out_ready & io_out_valid; // @[shiftmultiplier.scala 250:45]
  wire  _T_10 = cnt == 32'h0; // @[shiftmultiplier.scala 250:68]
  reg [31:0] _T_12; // @[shiftmultiplier.scala 253:32]
  reg [31:0] _T_13; // @[shiftmultiplier.scala 254:32]
  reg [31:0] _T_14; // @[shiftmultiplier.scala 255:30]
  wire [16:0] _T_18 = {io_math_data1,1'h0}; // @[shiftmultiplier.scala 258:62]
  wire  _T_20 = _T_10 & io_in_valid; // @[shiftmultiplier.scala 262:35]
  wire  _T_21 = _T_20 & io_in_ready; // @[shiftmultiplier.scala 262:50]
  wire [12:0] _T_22 = _T_18[16:4]; // @[shiftmultiplier.scala 263:40]
  wire [19:0] _T_23 = {$signed(io_math_data2), 4'h0}; // @[shiftmultiplier.scala 264:48]
  wire  _T_26 = io_out_ready & io_in_valid; // @[shiftmultiplier.scala 269:43]
  wire  _T_27 = _T_26 & io_in_ready; // @[shiftmultiplier.scala 269:58]
  wire [31:0] _GEN_8 = _T_27 ? $signed({{12{_T_23[19]}},_T_23}) : $signed(_T_13); // @[shiftmultiplier.scala 269:73]
  wire [4:0] _GEN_9 = _T_27 ? _T_18[4:0] : 5'h0; // @[shiftmultiplier.scala 269:73]
  wire [15:0] _GEN_10 = _T_27 ? $signed(io_math_data2) : $signed(16'sh0); // @[shiftmultiplier.scala 269:73]
  wire [27:0] _T_33 = _T_12[31:4]; // @[shiftmultiplier.scala 286:40]
  wire [35:0] _T_34 = {$signed(_T_13), 4'h0}; // @[shiftmultiplier.scala 287:40]
  wire [31:0] _T_38 = $signed(_T_14) + $signed(FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_out); // @[shiftmultiplier.scala 291:36]
  wire [35:0] _GEN_13 = _T_1 ? $signed(_T_34) : $signed({{4{_T_13[31]}},_T_13}); // @[shiftmultiplier.scala 285:39]
  wire [4:0] _GEN_14 = _T_1 ? _T_12[4:0] : 5'h0; // @[shiftmultiplier.scala 285:39]
  wire [31:0] _GEN_15 = _T_1 ? $signed(_T_13) : $signed(32'sh0); // @[shiftmultiplier.scala 285:39]
  wire [35:0] _GEN_18 = _T_3 ? $signed({{4{_GEN_8[31]}},_GEN_8}) : $signed(_GEN_13); // @[shiftmultiplier.scala 268:44]
  wire [4:0] _GEN_19 = _T_3 ? _GEN_9 : _GEN_14; // @[shiftmultiplier.scala 268:44]
  wire [31:0] _GEN_20 = _T_3 ? $signed({{16{_GEN_10[15]}},_GEN_10}) : $signed(_GEN_15); // @[shiftmultiplier.scala 268:44]
  wire [35:0] _GEN_23 = _T_21 ? $signed({{16{_T_23[19]}},_T_23}) : $signed(_GEN_18); // @[shiftmultiplier.scala 262:68]
  FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder ( // @[shiftmultiplier.scala 228:32]
    .io_in(FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_in),
    .io_x(FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_x),
    .io_out(FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_out)
  );
  assign io_out_valid = cnt >= 32'h4; // @[shiftmultiplier.scala 249:30]
  assign io_in_ready = _T_9 | _T_10; // @[shiftmultiplier.scala 250:29]
  assign io_math_res = _T_14; // @[shiftmultiplier.scala 298:29]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_in = _T_21 ? _T_18[4:0] : _GEN_19; // @[shiftmultiplier.scala 260:27 shiftmultiplier.scala 265:35 shiftmultiplier.scala 272:43 shiftmultiplier.scala 288:35]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_x = _T_21 ? $signed({{16{io_math_data2[15]}},io_math_data2}) : $signed(_GEN_20); // @[shiftmultiplier.scala 261:25 shiftmultiplier.scala 266:33 shiftmultiplier.scala 273:41 shiftmultiplier.scala 289:33]
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
  cnt = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  _T_12 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  _T_13 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  _T_14 = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      cnt <= 32'h0;
    end else if (_T_2) begin
      if (_T_3) begin
        cnt <= {{29'd0}, _GEN_1};
      end else begin
        cnt <= _T_7;
      end
    end else begin
      cnt <= 32'h0;
    end
    if (_T_21) begin
      _T_12 <= {{19{_T_22[12]}},_T_22};
    end else if (_T_3) begin
      if (_T_27) begin
        _T_12 <= {{19{_T_22[12]}},_T_22};
      end
    end else if (_T_1) begin
      _T_12 <= {{4{_T_33[27]}},_T_33};
    end
    _T_13 <= _GEN_23[31:0];
    if (_T_21) begin
      _T_14 <= FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_out;
    end else if (_T_3) begin
      if (_T_27) begin
        _T_14 <= FixedPointTrigExp_D12_approx_op_BoothMultiplier_BoothEncoder_io_out;
      end
    end else if (_T_1) begin
      _T_14 <= _T_38;
    end
  end
endmodule
module FixedPointTrigExp_D12_approx_op(
  input        clock,
  input        reset,
  input  [7:0] io_data_i,
  input  [7:0] io_data_f,
  output [7:0] io_res_i,
  output [7:0] io_res_f,
  output       io_out_valid,
  input        io_out_ready,
  input        io_in_valid,
  output       io_in_ready
);
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_clock; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_reset; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_ready; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_valid; // @[UnaryOp.scala 121:57]
  wire [15:0] FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_bits; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_ready; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_valid; // @[UnaryOp.scala 121:57]
  wire [15:0] FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_bits; // @[UnaryOp.scala 121:57]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_clock; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_reset; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_valid; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_ready; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_valid; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_ready; // @[UnaryOp.scala 137:55]
  wire [15:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data1; // @[UnaryOp.scala 137:55]
  wire [15:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data2; // @[UnaryOp.scala 137:55]
  wire [31:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_res; // @[UnaryOp.scala 137:55]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_clock; // @[UnaryOp.scala 140:56]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_reset; // @[UnaryOp.scala 140:56]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_valid; // @[UnaryOp.scala 140:56]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_ready; // @[UnaryOp.scala 140:56]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_valid; // @[UnaryOp.scala 140:56]
  wire  FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_ready; // @[UnaryOp.scala 140:56]
  wire [15:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data1; // @[UnaryOp.scala 140:56]
  wire [15:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data2; // @[UnaryOp.scala 140:56]
  wire [31:0] FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_res; // @[UnaryOp.scala 140:56]
  wire [31:0] _T_9 = $signed(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_res) + 32'sh10000; // @[UnaryOp.scala 160:63]
  wire [31:0] _T_21 = $signed(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_res) + 32'sh10000; // @[UnaryOp.scala 172:64]
  FixedPointTrigExp_D12_approx_op_PipelineUInt FixedPointTrigExp_D12_approx_op_PipelineUInt ( // @[UnaryOp.scala 121:57]
    .clock(FixedPointTrigExp_D12_approx_op_PipelineUInt_clock),
    .reset(FixedPointTrigExp_D12_approx_op_PipelineUInt_reset),
    .io_in_ready(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_ready),
    .io_in_valid(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_valid),
    .io_in_bits(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_bits),
    .io_out_ready(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_ready),
    .io_out_valid(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_valid),
    .io_out_bits(FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_bits)
  );
  FixedPointTrigExp_D12_approx_op_BoothMultiplier FixedPointTrigExp_D12_approx_op_BoothMultiplier ( // @[UnaryOp.scala 137:55]
    .clock(FixedPointTrigExp_D12_approx_op_BoothMultiplier_clock),
    .reset(FixedPointTrigExp_D12_approx_op_BoothMultiplier_reset),
    .io_out_valid(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_valid),
    .io_out_ready(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_ready),
    .io_in_valid(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_valid),
    .io_in_ready(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_ready),
    .io_math_data1(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data1),
    .io_math_data2(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data2),
    .io_math_res(FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_res)
  );
  FixedPointTrigExp_D12_approx_op_BoothMultiplier FixedPointTrigExp_D12_approx_op_BoothMultiplier_1 ( // @[UnaryOp.scala 140:56]
    .clock(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_clock),
    .reset(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_reset),
    .io_out_valid(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_valid),
    .io_out_ready(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_ready),
    .io_in_valid(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_valid),
    .io_in_ready(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_ready),
    .io_math_data1(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data1),
    .io_math_data2(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data2),
    .io_math_res(FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_res)
  );
  assign io_res_i = _T_21[23:16]; // @[UnaryOp.scala 179:42]
  assign io_res_f = _T_21[15:8]; // @[UnaryOp.scala 180:42]
  assign io_out_valid = FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_valid; // @[UnaryOp.scala 178:46]
  assign io_in_ready = FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_ready; // @[UnaryOp.scala 177:45]
  assign FixedPointTrigExp_D12_approx_op_PipelineUInt_clock = clock;
  assign FixedPointTrigExp_D12_approx_op_PipelineUInt_reset = reset;
  assign FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_valid = FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_valid; // @[UnaryOp.scala 150:57]
  assign FixedPointTrigExp_D12_approx_op_PipelineUInt_io_in_bits = {io_data_i,io_data_f}; // @[UnaryOp.scala 148:56]
  assign FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_ready = FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_ready; // @[UnaryOp.scala 149:58]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_clock = clock;
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_reset = reset;
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_ready = FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_ready; // @[UnaryOp.scala 155:56]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_in_valid = io_in_valid; // @[UnaryOp.scala 156:55]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data1 = {io_data_i,io_data_f}; // @[UnaryOp.scala 153:57]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_math_data2 = 16'sh80; // @[UnaryOp.scala 154:57]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_clock = clock;
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_reset = reset;
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_out_ready = io_out_ready; // @[UnaryOp.scala 167:57]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_in_valid = FixedPointTrigExp_D12_approx_op_BoothMultiplier_io_out_valid; // @[UnaryOp.scala 168:56]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data1 = {_T_9[23:16],_T_9[15:8]}; // @[UnaryOp.scala 165:58]
  assign FixedPointTrigExp_D12_approx_op_BoothMultiplier_1_io_math_data2 = FixedPointTrigExp_D12_approx_op_PipelineUInt_io_out_bits; // @[UnaryOp.scala 166:58]
endmodule
module FixedPointTrigExp_D12(
  input        clock,
  input        reset,
  input  [7:0] io_in0_i,
  input  [7:0] io_in0_f,
  output [7:0] io_out_i,
  output [7:0] io_out_f,
  output       io_exit_valid,
  input        io_exit_ready,
  input        io_entry_valid,
  output       io_entry_ready
);
  wire  main_clock; // @[TrigFixedPoint.scala 45:26]
  wire  main_reset; // @[TrigFixedPoint.scala 45:26]
  wire [7:0] main_io_data_i; // @[TrigFixedPoint.scala 45:26]
  wire [7:0] main_io_data_f; // @[TrigFixedPoint.scala 45:26]
  wire [7:0] main_io_res_i; // @[TrigFixedPoint.scala 45:26]
  wire [7:0] main_io_res_f; // @[TrigFixedPoint.scala 45:26]
  wire  main_io_out_valid; // @[TrigFixedPoint.scala 45:26]
  wire  main_io_out_ready; // @[TrigFixedPoint.scala 45:26]
  wire  main_io_in_valid; // @[TrigFixedPoint.scala 45:26]
  wire  main_io_in_ready; // @[TrigFixedPoint.scala 45:26]
  FixedPointTrigExp_D12_approx_op main ( // @[TrigFixedPoint.scala 45:26]
    .clock(main_clock),
    .reset(main_reset),
    .io_data_i(main_io_data_i),
    .io_data_f(main_io_data_f),
    .io_res_i(main_io_res_i),
    .io_res_f(main_io_res_f),
    .io_out_valid(main_io_out_valid),
    .io_out_ready(main_io_out_ready),
    .io_in_valid(main_io_in_valid),
    .io_in_ready(main_io_in_ready)
  );
  assign io_out_i = main_io_res_i; // @[TrigFixedPoint.scala 53:21]
  assign io_out_f = main_io_res_f; // @[TrigFixedPoint.scala 53:21]
  assign io_exit_valid = main_io_out_valid; // @[TrigFixedPoint.scala 50:21]
  assign io_entry_ready = main_io_in_ready; // @[TrigFixedPoint.scala 51:20]
  assign main_clock = clock;
  assign main_reset = reset;
  assign main_io_data_i = io_in0_i; // @[TrigFixedPoint.scala 52:22]
  assign main_io_data_f = io_in0_f; // @[TrigFixedPoint.scala 52:22]
  assign main_io_out_ready = io_exit_ready; // @[TrigFixedPoint.scala 50:21]
  assign main_io_in_valid = io_entry_valid; // @[TrigFixedPoint.scala 51:20]
endmodule
