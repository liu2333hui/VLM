package chap3

import chisel3.stage.ChiselGeneratorAnnotation

object wireMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/wire"), Seq(ChiselGeneratorAnnotation(() => new WIRE)))

}