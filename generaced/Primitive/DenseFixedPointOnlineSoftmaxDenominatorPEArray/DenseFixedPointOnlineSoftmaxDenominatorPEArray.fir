;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit DenseFixedPointOnlineSoftmaxDenominatorPEArray : 
  module PipelineData : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 126:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 127:28]
    io.out.valid <= valid @[pipeline.scala 128:22]
    io.in.ready <= io.out.ready @[pipeline.scala 129:21]
    io.out.bits <= bits @[pipeline.scala 130:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 132:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 132:41]
    when _T_1 : @[pipeline.scala 132:57]
      valid <= io.in.valid @[pipeline.scala 133:23]
      bits <= io.in.bits @[pipeline.scala 134:22]
      skip @[pipeline.scala 132:57]
    else : @[pipeline.scala 135:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 136:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 136:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 136:49]
      when _T_4 : @[pipeline.scala 136:67]
        valid <= io.in.valid @[pipeline.scala 137:31]
        bits <= io.in.bits @[pipeline.scala 138:30]
        skip @[pipeline.scala 136:67]
      skip @[pipeline.scala 135:20]
    
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
    
  module DenseFixedPointOnlineSoftmaxDenominatorPEArray : 
    input clock : Clock
    input reset : UInt<1>
    output io : {in0 : {flip i : UInt<8>, flip f : UInt<8>}[8], in1 : {flip i : UInt<8>, flip f : UInt<8>}[4], in2 : {flip i : UInt<8>, flip f : UInt<8>}[4], flip out0 : {flip i : UInt<8>, flip f : UInt<8>}[4], exit : {valid : UInt<1>, flip ready : UInt<1>}, entry : {flip valid : UInt<1>, ready : UInt<1>}}
    
    inst mp_0 of SIntMaxN @[Dense32Arrays.scala 46:38]
    mp_0.clock <= clock
    mp_0.reset <= reset
    inst mp_1 of SIntMaxN_1 @[Dense32Arrays.scala 46:38]
    mp_1.clock <= clock
    mp_1.reset <= reset
    inst mp_2 of SIntMaxN_2 @[Dense32Arrays.scala 46:38]
    mp_2.clock <= clock
    mp_2.reset <= reset
    inst mp_3 of SIntMaxN_3 @[Dense32Arrays.scala 46:38]
    mp_3.clock <= clock
    mp_3.reset <= reset
    node _T = cat(io.in0[0].i, io.in0[0].f) @[Cat.scala 29:58]
    node _T_1 = asSInt(_T) @[Dense32Arrays.scala 57:79]
    mp_0.io.in0[0] <= _T_1 @[Dense32Arrays.scala 57:34]
    node _T_2 = cat(io.in0[1].i, io.in0[1].f) @[Cat.scala 29:58]
    node _T_3 = asSInt(_T_2) @[Dense32Arrays.scala 57:79]
    mp_0.io.in0[1] <= _T_3 @[Dense32Arrays.scala 57:34]
    node _T_4 = cat(io.in0[2].i, io.in0[2].f) @[Cat.scala 29:58]
    node _T_5 = asSInt(_T_4) @[Dense32Arrays.scala 57:79]
    mp_1.io.in0[0] <= _T_5 @[Dense32Arrays.scala 57:34]
    node _T_6 = cat(io.in0[3].i, io.in0[3].f) @[Cat.scala 29:58]
    node _T_7 = asSInt(_T_6) @[Dense32Arrays.scala 57:79]
    mp_1.io.in0[1] <= _T_7 @[Dense32Arrays.scala 57:34]
    node _T_8 = cat(io.in0[4].i, io.in0[4].f) @[Cat.scala 29:58]
    node _T_9 = asSInt(_T_8) @[Dense32Arrays.scala 57:79]
    mp_2.io.in0[0] <= _T_9 @[Dense32Arrays.scala 57:34]
    node _T_10 = cat(io.in0[5].i, io.in0[5].f) @[Cat.scala 29:58]
    node _T_11 = asSInt(_T_10) @[Dense32Arrays.scala 57:79]
    mp_2.io.in0[1] <= _T_11 @[Dense32Arrays.scala 57:34]
    node _T_12 = cat(io.in0[6].i, io.in0[6].f) @[Cat.scala 29:58]
    node _T_13 = asSInt(_T_12) @[Dense32Arrays.scala 57:79]
    mp_3.io.in0[0] <= _T_13 @[Dense32Arrays.scala 57:34]
    node _T_14 = cat(io.in0[7].i, io.in0[7].f) @[Cat.scala 29:58]
    node _T_15 = asSInt(_T_14) @[Dense32Arrays.scala 57:79]
    mp_3.io.in0[1] <= _T_15 @[Dense32Arrays.scala 57:34]
    inst mp2_0 of SIntMax2_4 @[Dense32Arrays.scala 68:39]
    mp2_0.clock <= clock
    mp2_0.reset <= reset
    inst mp2_1 of SIntMax2_5 @[Dense32Arrays.scala 68:39]
    mp2_1.clock <= clock
    mp2_1.reset <= reset
    inst mp2_2 of SIntMax2_6 @[Dense32Arrays.scala 68:39]
    mp2_2.clock <= clock
    mp2_2.reset <= reset
    inst mp2_3 of SIntMax2_7 @[Dense32Arrays.scala 68:39]
    mp2_3.clock <= clock
    mp2_3.reset <= reset
    mp2_0.io.in0 <= mp_0.io.out @[Dense32Arrays.scala 78:32]
    node _T_16 = cat(io.in1[0].i, io.in1[0].f) @[Cat.scala 29:58]
    node _T_17 = asSInt(_T_16) @[Dense32Arrays.scala 79:65]
    mp2_0.io.in1 <= _T_17 @[Dense32Arrays.scala 79:32]
    node _T_18 = bits(mp2_0.io.out, 15, 8) @[Dense32Arrays.scala 81:46]
    io.out0[0].i <= _T_18 @[Dense32Arrays.scala 81:30]
    node _T_19 = bits(mp2_0.io.out, 7, 0) @[Dense32Arrays.scala 82:46]
    io.out0[0].f <= _T_19 @[Dense32Arrays.scala 82:30]
    io.entry.ready <= mp_0.io.entry.ready @[Dense32Arrays.scala 84:32]
    mp_0.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 84:32]
    mp_0.io.exit.ready <= mp2_0.io.entry.ready @[Dense32Arrays.scala 86:31]
    mp2_0.io.entry.valid <= mp_0.io.exit.valid @[Dense32Arrays.scala 86:31]
    mp2_0.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 88:32]
    io.exit.valid <= mp2_0.io.exit.valid @[Dense32Arrays.scala 88:32]
    mp2_1.io.in0 <= mp_1.io.out @[Dense32Arrays.scala 78:32]
    node _T_20 = cat(io.in1[1].i, io.in1[1].f) @[Cat.scala 29:58]
    node _T_21 = asSInt(_T_20) @[Dense32Arrays.scala 79:65]
    mp2_1.io.in1 <= _T_21 @[Dense32Arrays.scala 79:32]
    node _T_22 = bits(mp2_1.io.out, 15, 8) @[Dense32Arrays.scala 81:46]
    io.out0[1].i <= _T_22 @[Dense32Arrays.scala 81:30]
    node _T_23 = bits(mp2_1.io.out, 7, 0) @[Dense32Arrays.scala 82:46]
    io.out0[1].f <= _T_23 @[Dense32Arrays.scala 82:30]
    io.entry.ready <= mp_1.io.entry.ready @[Dense32Arrays.scala 84:32]
    mp_1.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 84:32]
    mp_1.io.exit.ready <= mp2_1.io.entry.ready @[Dense32Arrays.scala 86:31]
    mp2_1.io.entry.valid <= mp_1.io.exit.valid @[Dense32Arrays.scala 86:31]
    mp2_1.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 88:32]
    io.exit.valid <= mp2_1.io.exit.valid @[Dense32Arrays.scala 88:32]
    mp2_2.io.in0 <= mp_2.io.out @[Dense32Arrays.scala 78:32]
    node _T_24 = cat(io.in1[2].i, io.in1[2].f) @[Cat.scala 29:58]
    node _T_25 = asSInt(_T_24) @[Dense32Arrays.scala 79:65]
    mp2_2.io.in1 <= _T_25 @[Dense32Arrays.scala 79:32]
    node _T_26 = bits(mp2_2.io.out, 15, 8) @[Dense32Arrays.scala 81:46]
    io.out0[2].i <= _T_26 @[Dense32Arrays.scala 81:30]
    node _T_27 = bits(mp2_2.io.out, 7, 0) @[Dense32Arrays.scala 82:46]
    io.out0[2].f <= _T_27 @[Dense32Arrays.scala 82:30]
    io.entry.ready <= mp_2.io.entry.ready @[Dense32Arrays.scala 84:32]
    mp_2.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 84:32]
    mp_2.io.exit.ready <= mp2_2.io.entry.ready @[Dense32Arrays.scala 86:31]
    mp2_2.io.entry.valid <= mp_2.io.exit.valid @[Dense32Arrays.scala 86:31]
    mp2_2.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 88:32]
    io.exit.valid <= mp2_2.io.exit.valid @[Dense32Arrays.scala 88:32]
    mp2_3.io.in0 <= mp_3.io.out @[Dense32Arrays.scala 78:32]
    node _T_28 = cat(io.in1[3].i, io.in1[3].f) @[Cat.scala 29:58]
    node _T_29 = asSInt(_T_28) @[Dense32Arrays.scala 79:65]
    mp2_3.io.in1 <= _T_29 @[Dense32Arrays.scala 79:32]
    node _T_30 = bits(mp2_3.io.out, 15, 8) @[Dense32Arrays.scala 81:46]
    io.out0[3].i <= _T_30 @[Dense32Arrays.scala 81:30]
    node _T_31 = bits(mp2_3.io.out, 7, 0) @[Dense32Arrays.scala 82:46]
    io.out0[3].f <= _T_31 @[Dense32Arrays.scala 82:30]
    io.entry.ready <= mp_3.io.entry.ready @[Dense32Arrays.scala 84:32]
    mp_3.io.entry.valid <= io.entry.valid @[Dense32Arrays.scala 84:32]
    mp_3.io.exit.ready <= mp2_3.io.entry.ready @[Dense32Arrays.scala 86:31]
    mp2_3.io.entry.valid <= mp_3.io.exit.valid @[Dense32Arrays.scala 86:31]
    mp2_3.io.exit.ready <= io.exit.ready @[Dense32Arrays.scala 88:32]
    io.exit.valid <= mp2_3.io.exit.valid @[Dense32Arrays.scala 88:32]
    
