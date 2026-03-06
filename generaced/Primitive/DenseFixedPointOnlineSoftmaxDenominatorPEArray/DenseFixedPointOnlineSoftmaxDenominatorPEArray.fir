;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit DenseFixedPointOnlineSoftmaxDenominatorPEArray : 
  module PipelineData : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module SIntMaxN : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>[2], out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst SIntMax2 of SIntMax2 @[MaxMin.scala 46:37]
    SIntMax2.clock <= clock
    SIntMax2.reset <= reset
    io.out <= SIntMax2.io.out @[MaxMin.scala 47:18]
    SIntMax2.io.exit.ready <= io.exit.ready @[MaxMin.scala 48:19]
    io.exit.valid <= SIntMax2.io.exit.valid @[MaxMin.scala 48:19]
    io.entry.ready <= SIntMax2.io.entry.ready @[MaxMin.scala 49:20]
    SIntMax2.io.entry.valid <= io.entry.valid @[MaxMin.scala 49:20]
    SIntMax2.io.in0 <= io.in0[0] @[MaxMin.scala 50:23]
    SIntMax2.io.in1 <= io.in0[1] @[MaxMin.scala 51:23]
    
  module PipelineData_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_1 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_1 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module SIntMaxN_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>[2], out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst SIntMax2 of SIntMax2_1 @[MaxMin.scala 46:37]
    SIntMax2.clock <= clock
    SIntMax2.reset <= reset
    io.out <= SIntMax2.io.out @[MaxMin.scala 47:18]
    SIntMax2.io.exit.ready <= io.exit.ready @[MaxMin.scala 48:19]
    io.exit.valid <= SIntMax2.io.exit.valid @[MaxMin.scala 48:19]
    io.entry.ready <= SIntMax2.io.entry.ready @[MaxMin.scala 49:20]
    SIntMax2.io.entry.valid <= io.entry.valid @[MaxMin.scala 49:20]
    SIntMax2.io.in0 <= io.in0[0] @[MaxMin.scala 50:23]
    SIntMax2.io.in1 <= io.in0[1] @[MaxMin.scala 51:23]
    
  module PipelineData_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_2 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_2 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module SIntMaxN_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>[2], out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst SIntMax2 of SIntMax2_2 @[MaxMin.scala 46:37]
    SIntMax2.clock <= clock
    SIntMax2.reset <= reset
    io.out <= SIntMax2.io.out @[MaxMin.scala 47:18]
    SIntMax2.io.exit.ready <= io.exit.ready @[MaxMin.scala 48:19]
    io.exit.valid <= SIntMax2.io.exit.valid @[MaxMin.scala 48:19]
    io.entry.ready <= SIntMax2.io.entry.ready @[MaxMin.scala 49:20]
    SIntMax2.io.entry.valid <= io.entry.valid @[MaxMin.scala 49:20]
    SIntMax2.io.in0 <= io.in0[0] @[MaxMin.scala 50:23]
    SIntMax2.io.in1 <= io.in0[1] @[MaxMin.scala 51:23]
    
  module PipelineData_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_3 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_3 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module SIntMaxN_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>[2], out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst SIntMax2 of SIntMax2_3 @[MaxMin.scala 46:37]
    SIntMax2.clock <= clock
    SIntMax2.reset <= reset
    io.out <= SIntMax2.io.out @[MaxMin.scala 47:18]
    SIntMax2.io.exit.ready <= io.exit.ready @[MaxMin.scala 48:19]
    io.exit.valid <= SIntMax2.io.exit.valid @[MaxMin.scala 48:19]
    io.entry.ready <= SIntMax2.io.entry.ready @[MaxMin.scala 49:20]
    SIntMax2.io.entry.valid <= io.entry.valid @[MaxMin.scala 49:20]
    SIntMax2.io.in0 <= io.in0[0] @[MaxMin.scala 50:23]
    SIntMax2.io.in1 <= io.in0[1] @[MaxMin.scala 51:23]
    
  module PipelineData_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_4 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_4 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module PipelineData_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_5 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_5 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module PipelineData_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_6 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_6 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module PipelineData_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_7 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntMax2_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_7 @[MaxMin.scala 30:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 31:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 31:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 31:22]
    io.out <= p.io.out.bits @[MaxMin.scala 32:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 33:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 34:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 36:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 37:24]
    
  module PipelineData_8 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_8 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_8 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_9 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_9 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_9 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_10 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_10 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_10 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_11 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_11 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_11 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_12 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_12 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_12 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_13 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_13 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_13 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_14 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_14 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_14 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_15 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_15 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_15 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_16 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_16 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_16 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_16 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_17 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_17 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_17 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_17 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_18 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_18 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_18 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_18 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_19 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_19 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_19 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_19 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_20 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_20 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_20 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_20 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_21 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_21 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_21 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_21 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_22 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_22 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_22 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_22 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_23 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_23 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_23 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_7 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_23 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  extmodule FixedPointTrigExp_D12 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_1 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_2 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_3 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_4 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_5 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_6 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  extmodule FixedPointTrigExp_D12_7 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D12
    
    
  module PipelineData_24 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_24 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_24 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_25 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_25 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_25 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_26 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_26 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_26 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_27 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_27 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_27 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module PipelineData_28 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_28 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_28 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_8 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_28 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_29 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_29 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_29 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_9 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_29 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_30 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_30 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_30 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_10 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_30 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  module PipelineData_31 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 177:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 178:28]
    io.out.valid <= valid @[pipeline.scala 179:22]
    io.in.ready <= io.out.ready @[pipeline.scala 180:21]
    io.out.bits <= bits @[pipeline.scala 181:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 183:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 183:41]
    when _T_1 : @[pipeline.scala 183:57]
      valid <= io.in.valid @[pipeline.scala 184:23]
      bits <= io.in.bits @[pipeline.scala 185:22]
      skip @[pipeline.scala 183:57]
    else : @[pipeline.scala 186:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 187:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 187:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 187:49]
      when _T_4 : @[pipeline.scala 187:67]
        valid <= io.in.valid @[pipeline.scala 188:31]
        bits <= io.in.bits @[pipeline.scala 189:30]
        skip @[pipeline.scala 187:67]
      skip @[pipeline.scala 186:20]
    
  module PipelineSIntData_31 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of PipelineData_31 @[pipeline.scala 106:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 107:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 108:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 110:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 111:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 113:36]
    m.io.in.bits <= _T @[pipeline.scala 113:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 114:38]
    io.out.bits <= _T_1 @[pipeline.scala 114:21]
    
  module SIntBasicSubtract_11 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of PipelineSIntData_31 @[BasicSInt.scala 69:23]
    p.clock <= clock
    p.reset <= reset
    node _T = sub(io.in0, io.in1) @[BasicSInt.scala 70:32]
    node _T_1 = tail(_T, 1) @[BasicSInt.scala 70:32]
    node _T_2 = asSInt(_T_1) @[BasicSInt.scala 70:32]
    p.io.in.bits <= _T_2 @[BasicSInt.scala 70:22]
    io.out <= p.io.out.bits @[BasicSInt.scala 71:16]
    p.io.in.valid <= io.entry.valid @[BasicSInt.scala 73:23]
    io.entry.ready <= p.io.in.ready @[BasicSInt.scala 74:24]
    io.exit.valid <= p.io.out.valid @[BasicSInt.scala 76:23]
    p.io.out.ready <= io.exit.ready @[BasicSInt.scala 77:24]
    
  extmodule FixedPointTrigExp_D22 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D22
    
    
  extmodule FixedPointTrigExp_D22_1 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D22
    
    
  extmodule FixedPointTrigExp_D22_2 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D22
    
    
  extmodule FixedPointTrigExp_D22_3 : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}, flip out : {flip i : UInt<8>, flip f : UInt<8>}, exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    defname = FixedPointTrigExp_D22
    
    
  module DenseFixedPointOnlineSoftmaxDenominatorPEArray : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}[8], in1 : {flip i : UInt<8>, flip f : UInt<8>}[4], in2 : {flip i : UInt<8>, flip f : UInt<8>}[4], flip out0 : {flip i : UInt<8>, flip f : UInt<8>}[4], flip tmp : {flip i : UInt<8>, flip f : UInt<8>}[8], tmpSInt : SInt<16>[8], exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    inst mp_0 of SIntMaxN @[Dense32Arrays.scala 54:38]
    mp_0.clock <= clock
    mp_0.reset <= reset
    inst mp_1 of SIntMaxN_1 @[Dense32Arrays.scala 54:38]
    mp_1.clock <= clock
    mp_1.reset <= reset
    inst mp_2 of SIntMaxN_2 @[Dense32Arrays.scala 54:38]
    mp_2.clock <= clock
    mp_2.reset <= reset
    inst mp_3 of SIntMaxN_3 @[Dense32Arrays.scala 54:38]
    mp_3.clock <= clock
    mp_3.reset <= reset
    node _T = cat(io.in0[0].i, io.in0[0].f) @[Cat.scala 29:58]
    node _T_1 = asSInt(_T) @[Dense32Arrays.scala 65:79]
    mp_0.io.in0[0] <= _T_1 @[Dense32Arrays.scala 65:34]
    node _T_2 = cat(io.in0[1].i, io.in0[1].f) @[Cat.scala 29:58]
    node _T_3 = asSInt(_T_2) @[Dense32Arrays.scala 65:79]
    mp_0.io.in0[1] <= _T_3 @[Dense32Arrays.scala 65:34]
    node _T_4 = cat(io.in0[2].i, io.in0[2].f) @[Cat.scala 29:58]
    node _T_5 = asSInt(_T_4) @[Dense32Arrays.scala 65:79]
    mp_1.io.in0[0] <= _T_5 @[Dense32Arrays.scala 65:34]
    node _T_6 = cat(io.in0[3].i, io.in0[3].f) @[Cat.scala 29:58]
    node _T_7 = asSInt(_T_6) @[Dense32Arrays.scala 65:79]
    mp_1.io.in0[1] <= _T_7 @[Dense32Arrays.scala 65:34]
    node _T_8 = cat(io.in0[4].i, io.in0[4].f) @[Cat.scala 29:58]
    node _T_9 = asSInt(_T_8) @[Dense32Arrays.scala 65:79]
    mp_2.io.in0[0] <= _T_9 @[Dense32Arrays.scala 65:34]
    node _T_10 = cat(io.in0[5].i, io.in0[5].f) @[Cat.scala 29:58]
    node _T_11 = asSInt(_T_10) @[Dense32Arrays.scala 65:79]
    mp_2.io.in0[1] <= _T_11 @[Dense32Arrays.scala 65:34]
    node _T_12 = cat(io.in0[6].i, io.in0[6].f) @[Cat.scala 29:58]
    node _T_13 = asSInt(_T_12) @[Dense32Arrays.scala 65:79]
    mp_3.io.in0[0] <= _T_13 @[Dense32Arrays.scala 65:34]
    node _T_14 = cat(io.in0[7].i, io.in0[7].f) @[Cat.scala 29:58]
    node _T_15 = asSInt(_T_14) @[Dense32Arrays.scala 65:79]
    mp_3.io.in0[1] <= _T_15 @[Dense32Arrays.scala 65:34]
    inst mp2_0 of SIntMax2_4 @[Dense32Arrays.scala 76:39]
    mp2_0.clock <= clock
    mp2_0.reset <= reset
    inst mp2_1 of SIntMax2_5 @[Dense32Arrays.scala 76:39]
    mp2_1.clock <= clock
    mp2_1.reset <= reset
    inst mp2_2 of SIntMax2_6 @[Dense32Arrays.scala 76:39]
    mp2_2.clock <= clock
    mp2_2.reset <= reset
    inst mp2_3 of SIntMax2_7 @[Dense32Arrays.scala 76:39]
    mp2_3.clock <= clock
    mp2_3.reset <= reset
    mp2_0.io.in0 <= mp_0.io.out @[Dense32Arrays.scala 86:32]
    node _T_16 = cat(io.in1[0].i, io.in1[0].f) @[Cat.scala 29:58]
    node _T_17 = asSInt(_T_16) @[Dense32Arrays.scala 87:65]
    mp2_0.io.in1 <= _T_17 @[Dense32Arrays.scala 87:32]
    node _T_18 = bits(mp2_0.io.out, 15, 8) @[Dense32Arrays.scala 89:46]
    io.out0[0].i <= _T_18 @[Dense32Arrays.scala 89:30]
    node _T_19 = bits(mp2_0.io.out, 7, 0) @[Dense32Arrays.scala 90:46]
    io.out0[0].f <= _T_19 @[Dense32Arrays.scala 90:30]
    mp_0.io.exit.ready <= mp2_0.io.entry.ready @[Dense32Arrays.scala 93:31]
    mp2_0.io.entry.valid <= mp_0.io.exit.valid @[Dense32Arrays.scala 93:31]
    mp_0.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 95:38]
    mp2_1.io.in0 <= mp_1.io.out @[Dense32Arrays.scala 86:32]
    node _T_20 = cat(io.in1[1].i, io.in1[1].f) @[Cat.scala 29:58]
    node _T_21 = asSInt(_T_20) @[Dense32Arrays.scala 87:65]
    mp2_1.io.in1 <= _T_21 @[Dense32Arrays.scala 87:32]
    node _T_22 = bits(mp2_1.io.out, 15, 8) @[Dense32Arrays.scala 89:46]
    io.out0[1].i <= _T_22 @[Dense32Arrays.scala 89:30]
    node _T_23 = bits(mp2_1.io.out, 7, 0) @[Dense32Arrays.scala 90:46]
    io.out0[1].f <= _T_23 @[Dense32Arrays.scala 90:30]
    mp_1.io.exit.ready <= mp2_1.io.entry.ready @[Dense32Arrays.scala 93:31]
    mp2_1.io.entry.valid <= mp_1.io.exit.valid @[Dense32Arrays.scala 93:31]
    mp_1.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 95:38]
    mp2_2.io.in0 <= mp_2.io.out @[Dense32Arrays.scala 86:32]
    node _T_24 = cat(io.in1[2].i, io.in1[2].f) @[Cat.scala 29:58]
    node _T_25 = asSInt(_T_24) @[Dense32Arrays.scala 87:65]
    mp2_2.io.in1 <= _T_25 @[Dense32Arrays.scala 87:32]
    node _T_26 = bits(mp2_2.io.out, 15, 8) @[Dense32Arrays.scala 89:46]
    io.out0[2].i <= _T_26 @[Dense32Arrays.scala 89:30]
    node _T_27 = bits(mp2_2.io.out, 7, 0) @[Dense32Arrays.scala 90:46]
    io.out0[2].f <= _T_27 @[Dense32Arrays.scala 90:30]
    mp_2.io.exit.ready <= mp2_2.io.entry.ready @[Dense32Arrays.scala 93:31]
    mp2_2.io.entry.valid <= mp_2.io.exit.valid @[Dense32Arrays.scala 93:31]
    mp_2.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 95:38]
    mp2_3.io.in0 <= mp_3.io.out @[Dense32Arrays.scala 86:32]
    node _T_28 = cat(io.in1[3].i, io.in1[3].f) @[Cat.scala 29:58]
    node _T_29 = asSInt(_T_28) @[Dense32Arrays.scala 87:65]
    mp2_3.io.in1 <= _T_29 @[Dense32Arrays.scala 87:32]
    node _T_30 = bits(mp2_3.io.out, 15, 8) @[Dense32Arrays.scala 89:46]
    io.out0[3].i <= _T_30 @[Dense32Arrays.scala 89:30]
    node _T_31 = bits(mp2_3.io.out, 7, 0) @[Dense32Arrays.scala 90:46]
    io.out0[3].f <= _T_31 @[Dense32Arrays.scala 90:30]
    mp_3.io.exit.ready <= mp2_3.io.entry.ready @[Dense32Arrays.scala 93:31]
    mp2_3.io.entry.valid <= mp_3.io.exit.valid @[Dense32Arrays.scala 93:31]
    mp_3.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 95:38]
    inst XStage1_0 of PipelineSIntData_8 @[Dense32Arrays.scala 106:45]
    XStage1_0.clock <= clock
    XStage1_0.reset <= reset
    inst XStage1_1 of PipelineSIntData_9 @[Dense32Arrays.scala 106:45]
    XStage1_1.clock <= clock
    XStage1_1.reset <= reset
    inst XStage1_2 of PipelineSIntData_10 @[Dense32Arrays.scala 106:45]
    XStage1_2.clock <= clock
    XStage1_2.reset <= reset
    inst XStage1_3 of PipelineSIntData_11 @[Dense32Arrays.scala 106:45]
    XStage1_3.clock <= clock
    XStage1_3.reset <= reset
    inst XStage1_4 of PipelineSIntData_12 @[Dense32Arrays.scala 106:45]
    XStage1_4.clock <= clock
    XStage1_4.reset <= reset
    inst XStage1_5 of PipelineSIntData_13 @[Dense32Arrays.scala 106:45]
    XStage1_5.clock <= clock
    XStage1_5.reset <= reset
    inst XStage1_6 of PipelineSIntData_14 @[Dense32Arrays.scala 106:45]
    XStage1_6.clock <= clock
    XStage1_6.reset <= reset
    inst XStage1_7 of PipelineSIntData_15 @[Dense32Arrays.scala 106:45]
    XStage1_7.clock <= clock
    XStage1_7.reset <= reset
    node _T_32 = cat(io.in0[0].i, io.in0[0].f) @[Cat.scala 29:58]
    node _T_33 = asSInt(_T_32) @[Dense32Arrays.scala 109:88]
    XStage1_0.io.in.bits <= _T_33 @[Dense32Arrays.scala 109:43]
    XStage1_0.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_34 = cat(io.in0[1].i, io.in0[1].f) @[Cat.scala 29:58]
    node _T_35 = asSInt(_T_34) @[Dense32Arrays.scala 109:88]
    XStage1_1.io.in.bits <= _T_35 @[Dense32Arrays.scala 109:43]
    XStage1_1.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_36 = cat(io.in0[2].i, io.in0[2].f) @[Cat.scala 29:58]
    node _T_37 = asSInt(_T_36) @[Dense32Arrays.scala 109:88]
    XStage1_2.io.in.bits <= _T_37 @[Dense32Arrays.scala 109:43]
    XStage1_2.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_38 = cat(io.in0[3].i, io.in0[3].f) @[Cat.scala 29:58]
    node _T_39 = asSInt(_T_38) @[Dense32Arrays.scala 109:88]
    XStage1_3.io.in.bits <= _T_39 @[Dense32Arrays.scala 109:43]
    XStage1_3.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_40 = cat(io.in0[4].i, io.in0[4].f) @[Cat.scala 29:58]
    node _T_41 = asSInt(_T_40) @[Dense32Arrays.scala 109:88]
    XStage1_4.io.in.bits <= _T_41 @[Dense32Arrays.scala 109:43]
    XStage1_4.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_42 = cat(io.in0[5].i, io.in0[5].f) @[Cat.scala 29:58]
    node _T_43 = asSInt(_T_42) @[Dense32Arrays.scala 109:88]
    XStage1_5.io.in.bits <= _T_43 @[Dense32Arrays.scala 109:43]
    XStage1_5.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_44 = cat(io.in0[6].i, io.in0[6].f) @[Cat.scala 29:58]
    node _T_45 = asSInt(_T_44) @[Dense32Arrays.scala 109:88]
    XStage1_6.io.in.bits <= _T_45 @[Dense32Arrays.scala 109:43]
    XStage1_6.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    node _T_46 = cat(io.in0[7].i, io.in0[7].f) @[Cat.scala 29:58]
    node _T_47 = asSInt(_T_46) @[Dense32Arrays.scala 109:88]
    XStage1_7.io.in.bits <= _T_47 @[Dense32Arrays.scala 109:43]
    XStage1_7.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 111:44]
    inst D11_0 of SIntBasicSubtract @[Dense32Arrays.scala 117:41]
    D11_0.clock <= clock
    D11_0.reset <= reset
    inst D11_1 of SIntBasicSubtract_1 @[Dense32Arrays.scala 117:41]
    D11_1.clock <= clock
    D11_1.reset <= reset
    inst D11_2 of SIntBasicSubtract_2 @[Dense32Arrays.scala 117:41]
    D11_2.clock <= clock
    D11_2.reset <= reset
    inst D11_3 of SIntBasicSubtract_3 @[Dense32Arrays.scala 117:41]
    D11_3.clock <= clock
    D11_3.reset <= reset
    inst D11_4 of SIntBasicSubtract_4 @[Dense32Arrays.scala 117:41]
    D11_4.clock <= clock
    D11_4.reset <= reset
    inst D11_5 of SIntBasicSubtract_5 @[Dense32Arrays.scala 117:41]
    D11_5.clock <= clock
    D11_5.reset <= reset
    inst D11_6 of SIntBasicSubtract_6 @[Dense32Arrays.scala 117:41]
    D11_6.clock <= clock
    D11_6.reset <= reset
    inst D11_7 of SIntBasicSubtract_7 @[Dense32Arrays.scala 117:41]
    D11_7.clock <= clock
    D11_7.reset <= reset
    D11_0.io.in0 <= XStage1_0.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_0.io.in1 <= mp2_0.io.out @[Dense32Arrays.scala 128:36]
    node _T_48 = and(mp2_0.io.exit.valid, XStage1_0.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_0.io.entry.valid <= _T_48 @[Dense32Arrays.scala 131:43]
    node _T_49 = and(D11_0.io.entry.ready, XStage1_0.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_0.io.exit.ready <= _T_49 @[Dense32Arrays.scala 132:38]
    D11_0.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_0.io.out.ready <= D11_0.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_1.io.in0 <= XStage1_1.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_1.io.in1 <= mp2_0.io.out @[Dense32Arrays.scala 128:36]
    node _T_50 = and(mp2_0.io.exit.valid, XStage1_1.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_1.io.entry.valid <= _T_50 @[Dense32Arrays.scala 131:43]
    node _T_51 = and(D11_0.io.entry.ready, XStage1_1.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_0.io.exit.ready <= _T_51 @[Dense32Arrays.scala 132:38]
    D11_1.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_1.io.out.ready <= D11_1.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_2.io.in0 <= XStage1_2.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_2.io.in1 <= mp2_1.io.out @[Dense32Arrays.scala 128:36]
    node _T_52 = and(mp2_1.io.exit.valid, XStage1_2.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_2.io.entry.valid <= _T_52 @[Dense32Arrays.scala 131:43]
    node _T_53 = and(D11_2.io.entry.ready, XStage1_2.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_1.io.exit.ready <= _T_53 @[Dense32Arrays.scala 132:38]
    D11_2.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_2.io.out.ready <= D11_2.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_3.io.in0 <= XStage1_3.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_3.io.in1 <= mp2_1.io.out @[Dense32Arrays.scala 128:36]
    node _T_54 = and(mp2_1.io.exit.valid, XStage1_3.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_3.io.entry.valid <= _T_54 @[Dense32Arrays.scala 131:43]
    node _T_55 = and(D11_2.io.entry.ready, XStage1_3.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_1.io.exit.ready <= _T_55 @[Dense32Arrays.scala 132:38]
    D11_3.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_3.io.out.ready <= D11_3.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_4.io.in0 <= XStage1_4.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_4.io.in1 <= mp2_2.io.out @[Dense32Arrays.scala 128:36]
    node _T_56 = and(mp2_2.io.exit.valid, XStage1_4.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_4.io.entry.valid <= _T_56 @[Dense32Arrays.scala 131:43]
    node _T_57 = and(D11_4.io.entry.ready, XStage1_4.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_2.io.exit.ready <= _T_57 @[Dense32Arrays.scala 132:38]
    D11_4.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_4.io.out.ready <= D11_4.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_5.io.in0 <= XStage1_5.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_5.io.in1 <= mp2_2.io.out @[Dense32Arrays.scala 128:36]
    node _T_58 = and(mp2_2.io.exit.valid, XStage1_5.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_5.io.entry.valid <= _T_58 @[Dense32Arrays.scala 131:43]
    node _T_59 = and(D11_4.io.entry.ready, XStage1_5.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_2.io.exit.ready <= _T_59 @[Dense32Arrays.scala 132:38]
    D11_5.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_5.io.out.ready <= D11_5.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_6.io.in0 <= XStage1_6.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_6.io.in1 <= mp2_3.io.out @[Dense32Arrays.scala 128:36]
    node _T_60 = and(mp2_3.io.exit.valid, XStage1_6.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_6.io.entry.valid <= _T_60 @[Dense32Arrays.scala 131:43]
    node _T_61 = and(D11_6.io.entry.ready, XStage1_6.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_3.io.exit.ready <= _T_61 @[Dense32Arrays.scala 132:38]
    D11_6.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_6.io.out.ready <= D11_6.io.entry.ready @[Dense32Arrays.scala 141:45]
    D11_7.io.in0 <= XStage1_7.io.out.bits @[Dense32Arrays.scala 127:36]
    D11_7.io.in1 <= mp2_3.io.out @[Dense32Arrays.scala 128:36]
    node _T_62 = and(mp2_3.io.exit.valid, XStage1_7.io.out.valid) @[Dense32Arrays.scala 131:67]
    D11_7.io.entry.valid <= _T_62 @[Dense32Arrays.scala 131:43]
    node _T_63 = and(D11_6.io.entry.ready, XStage1_7.io.out.valid) @[Dense32Arrays.scala 132:69]
    mp2_3.io.exit.ready <= _T_63 @[Dense32Arrays.scala 132:38]
    D11_7.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 140:42]
    XStage1_7.io.out.ready <= D11_7.io.entry.ready @[Dense32Arrays.scala 141:45]
    inst D12_0 of FixedPointTrigExp_D12 @[Dense32Arrays.scala 166:23]
    D12_0.io is invalid
    D12_0.reset is invalid
    D12_0.clock is invalid
    inst D12_1 of FixedPointTrigExp_D12_1 @[Dense32Arrays.scala 166:23]
    D12_1.io is invalid
    D12_1.reset is invalid
    D12_1.clock is invalid
    inst D12_2 of FixedPointTrigExp_D12_2 @[Dense32Arrays.scala 166:23]
    D12_2.io is invalid
    D12_2.reset is invalid
    D12_2.clock is invalid
    inst D12_3 of FixedPointTrigExp_D12_3 @[Dense32Arrays.scala 166:23]
    D12_3.io is invalid
    D12_3.reset is invalid
    D12_3.clock is invalid
    inst D12_4 of FixedPointTrigExp_D12_4 @[Dense32Arrays.scala 166:23]
    D12_4.io is invalid
    D12_4.reset is invalid
    D12_4.clock is invalid
    inst D12_5 of FixedPointTrigExp_D12_5 @[Dense32Arrays.scala 166:23]
    D12_5.io is invalid
    D12_5.reset is invalid
    D12_5.clock is invalid
    inst D12_6 of FixedPointTrigExp_D12_6 @[Dense32Arrays.scala 166:23]
    D12_6.io is invalid
    D12_6.reset is invalid
    D12_6.clock is invalid
    inst D12_7 of FixedPointTrigExp_D12_7 @[Dense32Arrays.scala 166:23]
    D12_7.io is invalid
    D12_7.reset is invalid
    D12_7.clock is invalid
    D12_0.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_0.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_64 = bits(D11_0.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_0.io.in0.i <= _T_64 @[Dense32Arrays.scala 188:41]
    node _T_65 = bits(D11_0.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_0.io.in0.f <= _T_65 @[Dense32Arrays.scala 189:41]
    D12_0.io.entry.valid <= D11_0.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_0.io.exit.ready <= D12_0.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_0.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_66 = and(XStage1_0.io.in.ready, mp_0.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_66 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_0.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[0].i <= D12_0.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[0].f <= D12_0.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_67 = cat(D12_0.io.out.i, D12_0.io.out.f) @[Cat.scala 29:58]
    node _T_68 = asSInt(_T_67) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[0] <= _T_68 @[Dense32Arrays.scala 207:35]
    D12_1.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_1.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_69 = bits(D11_1.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_1.io.in0.i <= _T_69 @[Dense32Arrays.scala 188:41]
    node _T_70 = bits(D11_1.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_1.io.in0.f <= _T_70 @[Dense32Arrays.scala 189:41]
    D12_1.io.entry.valid <= D11_1.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_1.io.exit.ready <= D12_1.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_1.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_71 = and(XStage1_1.io.in.ready, mp_0.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_71 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_1.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[1].i <= D12_1.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[1].f <= D12_1.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_72 = cat(D12_1.io.out.i, D12_1.io.out.f) @[Cat.scala 29:58]
    node _T_73 = asSInt(_T_72) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[1] <= _T_73 @[Dense32Arrays.scala 207:35]
    D12_2.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_2.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_74 = bits(D11_2.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_2.io.in0.i <= _T_74 @[Dense32Arrays.scala 188:41]
    node _T_75 = bits(D11_2.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_2.io.in0.f <= _T_75 @[Dense32Arrays.scala 189:41]
    D12_2.io.entry.valid <= D11_2.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_2.io.exit.ready <= D12_2.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_2.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_76 = and(XStage1_2.io.in.ready, mp_1.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_76 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_2.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[2].i <= D12_2.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[2].f <= D12_2.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_77 = cat(D12_2.io.out.i, D12_2.io.out.f) @[Cat.scala 29:58]
    node _T_78 = asSInt(_T_77) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[2] <= _T_78 @[Dense32Arrays.scala 207:35]
    D12_3.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_3.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_79 = bits(D11_3.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_3.io.in0.i <= _T_79 @[Dense32Arrays.scala 188:41]
    node _T_80 = bits(D11_3.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_3.io.in0.f <= _T_80 @[Dense32Arrays.scala 189:41]
    D12_3.io.entry.valid <= D11_3.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_3.io.exit.ready <= D12_3.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_3.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_81 = and(XStage1_3.io.in.ready, mp_1.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_81 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_3.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[3].i <= D12_3.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[3].f <= D12_3.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_82 = cat(D12_3.io.out.i, D12_3.io.out.f) @[Cat.scala 29:58]
    node _T_83 = asSInt(_T_82) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[3] <= _T_83 @[Dense32Arrays.scala 207:35]
    D12_4.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_4.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_84 = bits(D11_4.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_4.io.in0.i <= _T_84 @[Dense32Arrays.scala 188:41]
    node _T_85 = bits(D11_4.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_4.io.in0.f <= _T_85 @[Dense32Arrays.scala 189:41]
    D12_4.io.entry.valid <= D11_4.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_4.io.exit.ready <= D12_4.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_4.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_86 = and(XStage1_4.io.in.ready, mp_2.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_86 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_4.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[4].i <= D12_4.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[4].f <= D12_4.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_87 = cat(D12_4.io.out.i, D12_4.io.out.f) @[Cat.scala 29:58]
    node _T_88 = asSInt(_T_87) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[4] <= _T_88 @[Dense32Arrays.scala 207:35]
    D12_5.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_5.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_89 = bits(D11_5.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_5.io.in0.i <= _T_89 @[Dense32Arrays.scala 188:41]
    node _T_90 = bits(D11_5.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_5.io.in0.f <= _T_90 @[Dense32Arrays.scala 189:41]
    D12_5.io.entry.valid <= D11_5.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_5.io.exit.ready <= D12_5.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_5.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_91 = and(XStage1_5.io.in.ready, mp_2.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_91 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_5.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[5].i <= D12_5.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[5].f <= D12_5.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_92 = cat(D12_5.io.out.i, D12_5.io.out.f) @[Cat.scala 29:58]
    node _T_93 = asSInt(_T_92) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[5] <= _T_93 @[Dense32Arrays.scala 207:35]
    D12_6.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_6.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_94 = bits(D11_6.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_6.io.in0.i <= _T_94 @[Dense32Arrays.scala 188:41]
    node _T_95 = bits(D11_6.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_6.io.in0.f <= _T_95 @[Dense32Arrays.scala 189:41]
    D12_6.io.entry.valid <= D11_6.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_6.io.exit.ready <= D12_6.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_6.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_96 = and(XStage1_6.io.in.ready, mp_3.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_96 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_6.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[6].i <= D12_6.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[6].f <= D12_6.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_97 = cat(D12_6.io.out.i, D12_6.io.out.f) @[Cat.scala 29:58]
    node _T_98 = asSInt(_T_97) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[6] <= _T_98 @[Dense32Arrays.scala 207:35]
    D12_7.clock <= clock @[Dense32Arrays.scala 185:37]
    D12_7.reset <= reset @[Dense32Arrays.scala 186:37]
    node _T_99 = bits(D11_7.io.out, 15, 8) @[Dense32Arrays.scala 188:61]
    D12_7.io.in0.i <= _T_99 @[Dense32Arrays.scala 188:41]
    node _T_100 = bits(D11_7.io.out, 7, 0) @[Dense32Arrays.scala 189:61]
    D12_7.io.in0.f <= _T_100 @[Dense32Arrays.scala 189:41]
    D12_7.io.entry.valid <= D11_7.io.exit.valid @[Dense32Arrays.scala 192:46]
    D11_7.io.exit.ready <= D12_7.io.entry.ready @[Dense32Arrays.scala 193:42]
    D12_7.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 195:45]
    node _T_101 = and(XStage1_7.io.in.ready, mp_3.io.entry.ready) @[Dense32Arrays.scala 199:62]
    io.entry.ready <= _T_101 @[Dense32Arrays.scala 199:32]
    io.exit.valid <= D12_7.io.exit.valid @[Dense32Arrays.scala 202:31]
    io.tmp[7].i <= D12_7.io.out.i @[Dense32Arrays.scala 204:33]
    io.tmp[7].f <= D12_7.io.out.f @[Dense32Arrays.scala 205:33]
    node _T_102 = cat(D12_7.io.out.i, D12_7.io.out.f) @[Cat.scala 29:58]
    node _T_103 = asSInt(_T_102) @[Dense32Arrays.scala 207:90]
    io.tmpSInt[7] <= _T_103 @[Dense32Arrays.scala 207:35]
    inst MStage1_0 of PipelineSIntData_24 @[Dense32Arrays.scala 213:43]
    MStage1_0.clock <= clock
    MStage1_0.reset <= reset
    inst MStage1_1 of PipelineSIntData_25 @[Dense32Arrays.scala 213:43]
    MStage1_1.clock <= clock
    MStage1_1.reset <= reset
    inst MStage1_2 of PipelineSIntData_26 @[Dense32Arrays.scala 213:43]
    MStage1_2.clock <= clock
    MStage1_2.reset <= reset
    inst MStage1_3 of PipelineSIntData_27 @[Dense32Arrays.scala 213:43]
    MStage1_3.clock <= clock
    MStage1_3.reset <= reset
    node _T_104 = cat(io.in1[0].i, io.in1[0].f) @[Cat.scala 29:58]
    node _T_105 = asSInt(_T_104) @[Dense32Arrays.scala 215:76]
    MStage1_0.io.in.bits <= _T_105 @[Dense32Arrays.scala 215:39]
    MStage1_0.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 216:40]
    node _T_106 = cat(io.in1[1].i, io.in1[1].f) @[Cat.scala 29:58]
    node _T_107 = asSInt(_T_106) @[Dense32Arrays.scala 215:76]
    MStage1_1.io.in.bits <= _T_107 @[Dense32Arrays.scala 215:39]
    MStage1_1.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 216:40]
    node _T_108 = cat(io.in1[2].i, io.in1[2].f) @[Cat.scala 29:58]
    node _T_109 = asSInt(_T_108) @[Dense32Arrays.scala 215:76]
    MStage1_2.io.in.bits <= _T_109 @[Dense32Arrays.scala 215:39]
    MStage1_2.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 216:40]
    node _T_110 = cat(io.in1[3].i, io.in1[3].f) @[Cat.scala 29:58]
    node _T_111 = asSInt(_T_110) @[Dense32Arrays.scala 215:76]
    MStage1_3.io.in.bits <= _T_111 @[Dense32Arrays.scala 215:39]
    MStage1_3.io.in.valid <= io.entry.valid @[Dense32Arrays.scala 216:40]
    inst D21_0 of SIntBasicSubtract_8 @[Dense32Arrays.scala 219:39]
    D21_0.clock <= clock
    D21_0.reset <= reset
    inst D21_1 of SIntBasicSubtract_9 @[Dense32Arrays.scala 219:39]
    D21_1.clock <= clock
    D21_1.reset <= reset
    inst D21_2 of SIntBasicSubtract_10 @[Dense32Arrays.scala 219:39]
    D21_2.clock <= clock
    D21_2.reset <= reset
    inst D21_3 of SIntBasicSubtract_11 @[Dense32Arrays.scala 219:39]
    D21_3.clock <= clock
    D21_3.reset <= reset
    D21_0.io.in0 <= MStage1_0.io.out.bits @[Dense32Arrays.scala 228:32]
    D21_0.io.in1 <= mp2_0.io.out @[Dense32Arrays.scala 229:32]
    node _T_112 = and(mp2_0.io.exit.valid, MStage1_0.io.out.valid) @[Dense32Arrays.scala 232:63]
    D21_0.io.entry.valid <= _T_112 @[Dense32Arrays.scala 232:39]
    node _T_113 = and(D21_0.io.entry.ready, MStage1_0.io.out.valid) @[Dense32Arrays.scala 233:63]
    mp2_0.io.exit.ready <= _T_113 @[Dense32Arrays.scala 233:38]
    D21_0.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 235:38]
    MStage1_0.io.out.ready <= D21_0.io.entry.ready @[Dense32Arrays.scala 236:41]
    D21_1.io.in0 <= MStage1_1.io.out.bits @[Dense32Arrays.scala 228:32]
    D21_1.io.in1 <= mp2_1.io.out @[Dense32Arrays.scala 229:32]
    node _T_114 = and(mp2_1.io.exit.valid, MStage1_1.io.out.valid) @[Dense32Arrays.scala 232:63]
    D21_1.io.entry.valid <= _T_114 @[Dense32Arrays.scala 232:39]
    node _T_115 = and(D21_1.io.entry.ready, MStage1_1.io.out.valid) @[Dense32Arrays.scala 233:63]
    mp2_1.io.exit.ready <= _T_115 @[Dense32Arrays.scala 233:38]
    D21_1.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 235:38]
    MStage1_1.io.out.ready <= D21_1.io.entry.ready @[Dense32Arrays.scala 236:41]
    D21_2.io.in0 <= MStage1_2.io.out.bits @[Dense32Arrays.scala 228:32]
    D21_2.io.in1 <= mp2_2.io.out @[Dense32Arrays.scala 229:32]
    node _T_116 = and(mp2_2.io.exit.valid, MStage1_2.io.out.valid) @[Dense32Arrays.scala 232:63]
    D21_2.io.entry.valid <= _T_116 @[Dense32Arrays.scala 232:39]
    node _T_117 = and(D21_2.io.entry.ready, MStage1_2.io.out.valid) @[Dense32Arrays.scala 233:63]
    mp2_2.io.exit.ready <= _T_117 @[Dense32Arrays.scala 233:38]
    D21_2.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 235:38]
    MStage1_2.io.out.ready <= D21_2.io.entry.ready @[Dense32Arrays.scala 236:41]
    D21_3.io.in0 <= MStage1_3.io.out.bits @[Dense32Arrays.scala 228:32]
    D21_3.io.in1 <= mp2_3.io.out @[Dense32Arrays.scala 229:32]
    node _T_118 = and(mp2_3.io.exit.valid, MStage1_3.io.out.valid) @[Dense32Arrays.scala 232:63]
    D21_3.io.entry.valid <= _T_118 @[Dense32Arrays.scala 232:39]
    node _T_119 = and(D21_3.io.entry.ready, MStage1_3.io.out.valid) @[Dense32Arrays.scala 233:63]
    mp2_3.io.exit.ready <= _T_119 @[Dense32Arrays.scala 233:38]
    D21_3.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 235:38]
    MStage1_3.io.out.ready <= D21_3.io.entry.ready @[Dense32Arrays.scala 236:41]
    inst D22_0 of FixedPointTrigExp_D22 @[Dense32Arrays.scala 240:23]
    D22_0.io is invalid
    D22_0.reset is invalid
    D22_0.clock is invalid
    inst D22_1 of FixedPointTrigExp_D22_1 @[Dense32Arrays.scala 240:23]
    D22_1.io is invalid
    D22_1.reset is invalid
    D22_1.clock is invalid
    inst D22_2 of FixedPointTrigExp_D22_2 @[Dense32Arrays.scala 240:23]
    D22_2.io is invalid
    D22_2.reset is invalid
    D22_2.clock is invalid
    inst D22_3 of FixedPointTrigExp_D22_3 @[Dense32Arrays.scala 240:23]
    D22_3.io is invalid
    D22_3.reset is invalid
    D22_3.clock is invalid
    D22_0.clock <= clock @[Dense32Arrays.scala 276:33]
    D22_0.reset <= reset @[Dense32Arrays.scala 277:33]
    node _T_120 = bits(D21_0.io.out, 15, 8) @[Dense32Arrays.scala 279:53]
    D22_0.io.in0.i <= _T_120 @[Dense32Arrays.scala 279:37]
    node _T_121 = bits(D21_0.io.out, 7, 0) @[Dense32Arrays.scala 280:53]
    D22_0.io.in0.f <= _T_121 @[Dense32Arrays.scala 280:37]
    D22_0.io.entry.valid <= D21_0.io.exit.valid @[Dense32Arrays.scala 283:42]
    D21_0.io.exit.ready <= D22_0.io.entry.ready @[Dense32Arrays.scala 284:38]
    D22_0.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 286:41]
    D22_1.clock <= clock @[Dense32Arrays.scala 276:33]
    D22_1.reset <= reset @[Dense32Arrays.scala 277:33]
    node _T_122 = bits(D21_1.io.out, 15, 8) @[Dense32Arrays.scala 279:53]
    D22_1.io.in0.i <= _T_122 @[Dense32Arrays.scala 279:37]
    node _T_123 = bits(D21_1.io.out, 7, 0) @[Dense32Arrays.scala 280:53]
    D22_1.io.in0.f <= _T_123 @[Dense32Arrays.scala 280:37]
    D22_1.io.entry.valid <= D21_1.io.exit.valid @[Dense32Arrays.scala 283:42]
    D21_1.io.exit.ready <= D22_1.io.entry.ready @[Dense32Arrays.scala 284:38]
    D22_1.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 286:41]
    D22_2.clock <= clock @[Dense32Arrays.scala 276:33]
    D22_2.reset <= reset @[Dense32Arrays.scala 277:33]
    node _T_124 = bits(D21_2.io.out, 15, 8) @[Dense32Arrays.scala 279:53]
    D22_2.io.in0.i <= _T_124 @[Dense32Arrays.scala 279:37]
    node _T_125 = bits(D21_2.io.out, 7, 0) @[Dense32Arrays.scala 280:53]
    D22_2.io.in0.f <= _T_125 @[Dense32Arrays.scala 280:37]
    D22_2.io.entry.valid <= D21_2.io.exit.valid @[Dense32Arrays.scala 283:42]
    D21_2.io.exit.ready <= D22_2.io.entry.ready @[Dense32Arrays.scala 284:38]
    D22_2.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 286:41]
    D22_3.clock <= clock @[Dense32Arrays.scala 276:33]
    D22_3.reset <= reset @[Dense32Arrays.scala 277:33]
    node _T_126 = bits(D21_3.io.out, 15, 8) @[Dense32Arrays.scala 279:53]
    D22_3.io.in0.i <= _T_126 @[Dense32Arrays.scala 279:37]
    node _T_127 = bits(D21_3.io.out, 7, 0) @[Dense32Arrays.scala 280:53]
    D22_3.io.in0.f <= _T_127 @[Dense32Arrays.scala 280:37]
    D22_3.io.entry.valid <= D21_3.io.exit.valid @[Dense32Arrays.scala 283:42]
    D21_3.io.exit.ready <= D22_3.io.entry.ready @[Dense32Arrays.scala 284:38]
    D22_3.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 286:41]
    
