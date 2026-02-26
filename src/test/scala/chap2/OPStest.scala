package test

import chisel3.stage.ChiselGeneratorAnnotation

object opsMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/ops"), Seq(ChiselGeneratorAnnotation(() => new OPS)))


}
