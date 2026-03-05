;buildInfoPackage: chisel3, version: 3.3.1, scalaVersion: 2.12.11, sbtVersion: 1.3.10
circuit UIntBasicSquare : 
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
    input reset : UInt<1>
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
    
