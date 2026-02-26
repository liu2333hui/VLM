package test

import chisel3.stage.ChiselGeneratorAnnotation

object vecMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/vec"), Seq(ChiselGeneratorAnnotation(() => new VEC)))


}
