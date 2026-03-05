;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit UIntPEArray : 
  module PipelineData : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_1 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_2 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_3 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_4 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_5 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_6 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module PipelineData_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg bits : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[pipeline.scala 31:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 32:28]
    io.out.valid <= valid @[pipeline.scala 33:22]
    io.in.ready <= io.out.ready @[pipeline.scala 34:21]
    io.out.bits <= bits @[pipeline.scala 35:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 37:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 37:41]
    when _T_1 : @[pipeline.scala 37:57]
      valid <= io.in.valid @[pipeline.scala 38:23]
      bits <= io.in.bits @[pipeline.scala 39:22]
      skip @[pipeline.scala 37:57]
    else : @[pipeline.scala 40:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 41:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 41:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 41:49]
      when _T_4 : @[pipeline.scala 41:67]
        valid <= io.in.valid @[pipeline.scala 42:31]
        bits <= io.in.bits @[pipeline.scala 43:30]
        skip @[pipeline.scala 41:67]
      skip @[pipeline.scala 40:20]
    
  module UIntBasicSquare_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : UInt<8>, out : UInt<8>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineData_7 @[Basic.scala 32:23]
    p.clock <= clock
    p.reset <= reset
    node _T = mul(io.in0, io.in0) @[Basic.scala 33:32]
    p.io.in.bits <= _T @[Basic.scala 33:22]
    io.out <= p.io.out.bits @[Basic.scala 34:16]
    p.io.in.valid <= io.entry.valid @[Basic.scala 35:23]
    io.entry.ready <= p.io.in.ready @[Basic.scala 36:24]
    io.exit.valid <= p.io.out.valid @[Basic.scala 38:23]
    p.io.out.ready <= io.exit.ready @[Basic.scala 39:24]
    
  module UIntPEArray : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip in0 : UInt<8>[8], out0 : UInt<8>[8]}
    
    wire wireVecSeq_0 : UInt<8>[8] @[SinglePEArray.scala 204:31]
    wire wireVecSeq_1 : UInt<8>[8] @[SinglePEArray.scala 204:31]
    wireVecSeq_0[0] <= io.in0[0] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[1] <= io.in0[1] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[2] <= io.in0[2] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[3] <= io.in0[3] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[4] <= io.in0[4] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[5] <= io.in0[5] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[6] <= io.in0[6] @[SinglePEArray.scala 218:59]
    wireVecSeq_0[7] <= io.in0[7] @[SinglePEArray.scala 218:59]
    inst UIntBasicSquare of UIntBasicSquare @[SinglePEArray.scala 245:56]
    UIntBasicSquare.clock <= clock
    UIntBasicSquare.reset <= reset
    inst UIntBasicSquare_1 of UIntBasicSquare_1 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_1.clock <= clock
    UIntBasicSquare_1.reset <= reset
    inst UIntBasicSquare_2 of UIntBasicSquare_2 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_2.clock <= clock
    UIntBasicSquare_2.reset <= reset
    inst UIntBasicSquare_3 of UIntBasicSquare_3 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_3.clock <= clock
    UIntBasicSquare_3.reset <= reset
    inst UIntBasicSquare_4 of UIntBasicSquare_4 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_4.clock <= clock
    UIntBasicSquare_4.reset <= reset
    inst UIntBasicSquare_5 of UIntBasicSquare_5 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_5.clock <= clock
    UIntBasicSquare_5.reset <= reset
    inst UIntBasicSquare_6 of UIntBasicSquare_6 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_6.clock <= clock
    UIntBasicSquare_6.reset <= reset
    inst UIntBasicSquare_7 of UIntBasicSquare_7 @[SinglePEArray.scala 245:56]
    UIntBasicSquare_7.clock <= clock
    UIntBasicSquare_7.reset <= reset
    UIntBasicSquare.io.in0 <= wireVecSeq_0[0] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_1.io.in0 <= wireVecSeq_0[1] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_2.io.in0 <= wireVecSeq_0[2] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_3.io.in0 <= wireVecSeq_0[3] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_4.io.in0 <= wireVecSeq_0[4] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_5.io.in0 <= wireVecSeq_0[5] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_6.io.in0 <= wireVecSeq_0[6] @[SinglePEArray.scala 255:45]
    UIntBasicSquare_7.io.in0 <= wireVecSeq_0[7] @[SinglePEArray.scala 255:45]
    wireVecSeq_1[0] <= UIntBasicSquare.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[1] <= UIntBasicSquare_1.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[2] <= UIntBasicSquare_2.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[3] <= UIntBasicSquare_3.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[4] <= UIntBasicSquare_4.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[5] <= UIntBasicSquare_5.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[6] <= UIntBasicSquare_6.io.out @[SinglePEArray.scala 259:76]
    wireVecSeq_1[7] <= UIntBasicSquare_7.io.out @[SinglePEArray.scala 259:76]
    
