package chap3

import chisel3.stage.ChiselGeneratorAnnotation

object modMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/mm4"), Seq(ChiselGeneratorAnnotation(() => new MultiMux4)))
	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/m4"), Seq(ChiselGeneratorAnnotation(() => new Mux4)))

}
