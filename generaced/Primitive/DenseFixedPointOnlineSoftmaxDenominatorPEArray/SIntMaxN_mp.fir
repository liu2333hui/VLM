;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit SIntMaxN_mp : 
  module SIntMaxN_mp_SIntMax2_PipelineUInt : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_1 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_1 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_1 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_2 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_2 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_2 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_3 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_3 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_3 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_4 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_4 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_4 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_5 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_5 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_5 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp_SIntMax2_PipelineUInt_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<16>}}
    
    reg bits : UInt<16>, clock with : (reset => (reset, UInt<16>("h00"))) @[pipeline.scala 150:27]
    reg valid : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[pipeline.scala 151:28]
    io.out.valid <= valid @[pipeline.scala 152:22]
    io.in.ready <= io.out.ready @[pipeline.scala 153:21]
    io.out.bits <= bits @[pipeline.scala 154:21]
    node _T = and(io.in.valid, io.in.ready) @[pipeline.scala 156:26]
    node _T_1 = and(_T, io.out.ready) @[pipeline.scala 156:41]
    when _T_1 : @[pipeline.scala 156:57]
      valid <= io.in.valid @[pipeline.scala 157:23]
      bits <= io.in.bits @[pipeline.scala 158:22]
      skip @[pipeline.scala 156:57]
    else : @[pipeline.scala 159:20]
      node _T_2 = and(io.in.valid, io.in.ready) @[pipeline.scala 160:34]
      node _T_3 = eq(io.out.valid, UInt<1>("h00")) @[pipeline.scala 160:53]
      node _T_4 = and(_T_2, _T_3) @[pipeline.scala 160:49]
      when _T_4 : @[pipeline.scala 160:67]
        valid <= io.in.valid @[pipeline.scala 161:31]
        bits <= io.in.bits @[pipeline.scala 162:30]
        skip @[pipeline.scala 160:67]
      skip @[pipeline.scala 159:20]
    
  module SIntMaxN_mp_SIntMax2_PipelineSInt_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : SInt<16>}}
    
    inst m of SIntMaxN_mp_SIntMax2_PipelineUInt_6 @[pipeline.scala 127:23]
    m.clock <= clock
    m.reset <= reset
    m.io.in.valid <= io.in.valid @[pipeline.scala 128:23]
    io.in.ready <= m.io.in.ready @[pipeline.scala 129:21]
    io.out.valid <= m.io.out.valid @[pipeline.scala 131:22]
    m.io.out.ready <= io.out.ready @[pipeline.scala 132:24]
    node _T = asUInt(io.in.bits) @[pipeline.scala 134:36]
    m.io.in.bits <= _T @[pipeline.scala 134:22]
    node _T_1 = asSInt(m.io.out.bits) @[pipeline.scala 135:38]
    io.out.bits <= _T_1 @[pipeline.scala 135:21]
    
  module SIntMaxN_mp_SIntMax2_6 : 
    input clock : Clock
    input reset : Reset
    output io : {flip in0 : SInt<16>, flip in1 : SInt<16>, out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst p of SIntMaxN_mp_SIntMax2_PipelineSInt_6 @[MaxMin.scala 31:23]
    p.clock <= clock
    p.reset <= reset
    node _T = gt(io.in0, io.in1) @[MaxMin.scala 33:36]
    node _T_1 = mux(_T, io.in0, io.in1) @[MaxMin.scala 33:28]
    p.io.in.bits <= _T_1 @[MaxMin.scala 33:22]
    io.out <= p.io.out.bits @[MaxMin.scala 34:16]
    p.io.in.valid <= io.entry.valid @[MaxMin.scala 35:23]
    io.entry.ready <= p.io.in.ready @[MaxMin.scala 36:24]
    io.exit.valid <= p.io.out.valid @[MaxMin.scala 38:23]
    p.io.out.ready <= io.exit.ready @[MaxMin.scala 39:24]
    
  module SIntMaxN_mp : 
    input clock : Clock
    input reset : UInt<1>
    output io : {flip in0 : SInt<16>[8], out : SInt<16>, entry : {flip valid : UInt<1>, ready : UInt<1>}, exit : {valid : UInt<1>, flip ready : UInt<1>}}
    
    inst SIntMaxN_mp_SIntMax2 of SIntMaxN_mp_SIntMax2 @[MaxMin.scala 57:29]
    SIntMaxN_mp_SIntMax2.clock <= clock
    SIntMaxN_mp_SIntMax2.reset <= reset
    io.out <= SIntMaxN_mp_SIntMax2.io.out @[MaxMin.scala 58:10]
    SIntMaxN_mp_SIntMax2.io.exit.ready <= io.exit.ready @[MaxMin.scala 61:17]
    io.exit.valid <= SIntMaxN_mp_SIntMax2.io.exit.valid @[MaxMin.scala 61:17]
    io.entry.ready <= SIntMaxN_mp_SIntMax2.io.entry.ready @[MaxMin.scala 62:17]
    SIntMaxN_mp_SIntMax2.io.entry.valid <= io.entry.valid @[MaxMin.scala 62:17]
    inst SIntMaxN_mp_SIntMax2_1 of SIntMaxN_mp_SIntMax2_1 @[MaxMin.scala 70:55]
    SIntMaxN_mp_SIntMax2_1.clock <= clock
    SIntMaxN_mp_SIntMax2_1.reset <= reset
    inst SIntMaxN_mp_SIntMax2_2 of SIntMaxN_mp_SIntMax2_2 @[MaxMin.scala 71:55]
    SIntMaxN_mp_SIntMax2_2.clock <= clock
    SIntMaxN_mp_SIntMax2_2.reset <= reset
    SIntMaxN_mp_SIntMax2.io.in0 <= SIntMaxN_mp_SIntMax2_1.io.out @[MaxMin.scala 72:40]
    SIntMaxN_mp_SIntMax2.io.in1 <= SIntMaxN_mp_SIntMax2_2.io.out @[MaxMin.scala 73:40]
    SIntMaxN_mp_SIntMax2_1.io.exit.ready <= io.exit.ready @[MaxMin.scala 75:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_1.io.exit.valid @[MaxMin.scala 75:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_1.io.entry.ready @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_1.io.entry.valid <= io.entry.valid @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_2.io.exit.ready <= io.exit.ready @[MaxMin.scala 78:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_2.io.exit.valid @[MaxMin.scala 78:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_2.io.entry.ready @[MaxMin.scala 79:41]
    SIntMaxN_mp_SIntMax2_2.io.entry.valid <= io.entry.valid @[MaxMin.scala 79:41]
    inst SIntMaxN_mp_SIntMax2_3 of SIntMaxN_mp_SIntMax2_3 @[MaxMin.scala 70:55]
    SIntMaxN_mp_SIntMax2_3.clock <= clock
    SIntMaxN_mp_SIntMax2_3.reset <= reset
    inst SIntMaxN_mp_SIntMax2_4 of SIntMaxN_mp_SIntMax2_4 @[MaxMin.scala 71:55]
    SIntMaxN_mp_SIntMax2_4.clock <= clock
    SIntMaxN_mp_SIntMax2_4.reset <= reset
    SIntMaxN_mp_SIntMax2_1.io.in0 <= SIntMaxN_mp_SIntMax2_3.io.out @[MaxMin.scala 72:40]
    SIntMaxN_mp_SIntMax2_1.io.in1 <= SIntMaxN_mp_SIntMax2_4.io.out @[MaxMin.scala 73:40]
    SIntMaxN_mp_SIntMax2_3.io.exit.ready <= io.exit.ready @[MaxMin.scala 75:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_3.io.exit.valid @[MaxMin.scala 75:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_3.io.entry.ready @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_3.io.entry.valid <= io.entry.valid @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_4.io.exit.ready <= io.exit.ready @[MaxMin.scala 78:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_4.io.exit.valid @[MaxMin.scala 78:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_4.io.entry.ready @[MaxMin.scala 79:41]
    SIntMaxN_mp_SIntMax2_4.io.entry.valid <= io.entry.valid @[MaxMin.scala 79:41]
    inst SIntMaxN_mp_SIntMax2_5 of SIntMaxN_mp_SIntMax2_5 @[MaxMin.scala 70:55]
    SIntMaxN_mp_SIntMax2_5.clock <= clock
    SIntMaxN_mp_SIntMax2_5.reset <= reset
    inst SIntMaxN_mp_SIntMax2_6 of SIntMaxN_mp_SIntMax2_6 @[MaxMin.scala 71:55]
    SIntMaxN_mp_SIntMax2_6.clock <= clock
    SIntMaxN_mp_SIntMax2_6.reset <= reset
    SIntMaxN_mp_SIntMax2_2.io.in0 <= SIntMaxN_mp_SIntMax2_5.io.out @[MaxMin.scala 72:40]
    SIntMaxN_mp_SIntMax2_2.io.in1 <= SIntMaxN_mp_SIntMax2_6.io.out @[MaxMin.scala 73:40]
    SIntMaxN_mp_SIntMax2_5.io.exit.ready <= io.exit.ready @[MaxMin.scala 75:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_5.io.exit.valid @[MaxMin.scala 75:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_5.io.entry.ready @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_5.io.entry.valid <= io.entry.valid @[MaxMin.scala 76:41]
    SIntMaxN_mp_SIntMax2_6.io.exit.ready <= io.exit.ready @[MaxMin.scala 78:41]
    io.exit.valid <= SIntMaxN_mp_SIntMax2_6.io.exit.valid @[MaxMin.scala 78:41]
    io.entry.ready <= SIntMaxN_mp_SIntMax2_6.io.entry.ready @[MaxMin.scala 79:41]
    SIntMaxN_mp_SIntMax2_6.io.entry.valid <= io.entry.valid @[MaxMin.scala 79:41]
    SIntMaxN_mp_SIntMax2_3.io.in0 <= io.in0[0] @[MaxMin.scala 91:24]
    SIntMaxN_mp_SIntMax2_3.io.in1 <= io.in0[1] @[MaxMin.scala 92:24]
    SIntMaxN_mp_SIntMax2_4.io.in0 <= io.in0[2] @[MaxMin.scala 91:24]
    SIntMaxN_mp_SIntMax2_4.io.in1 <= io.in0[3] @[MaxMin.scala 92:24]
    SIntMaxN_mp_SIntMax2_5.io.in0 <= io.in0[4] @[MaxMin.scala 91:24]
    SIntMaxN_mp_SIntMax2_5.io.in1 <= io.in0[5] @[MaxMin.scala 92:24]
    SIntMaxN_mp_SIntMax2_6.io.in0 <= io.in0[6] @[MaxMin.scala 91:24]
    SIntMaxN_mp_SIntMax2_6.io.in1 <= io.in0[7] @[MaxMin.scala 92:24]
    
