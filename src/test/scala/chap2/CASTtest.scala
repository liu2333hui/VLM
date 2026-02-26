package test

import chisel3.stage.ChiselGeneratorAnnotation

object castMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/cast"), Seq(ChiselGeneratorAnnotation(() => new CAST)))


}
