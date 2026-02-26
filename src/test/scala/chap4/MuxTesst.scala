package chap4

import chisel3.stage.ChiselGeneratorAnnotation

object muxMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/chap4mux"), Seq(ChiselGeneratorAnnotation(() => new MUX)))

}
