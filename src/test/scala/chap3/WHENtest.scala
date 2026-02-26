package chap3

import chisel3.stage.ChiselGeneratorAnnotation

object whenMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/when"), Seq(ChiselGeneratorAnnotation(() => new WHEN)))

}
