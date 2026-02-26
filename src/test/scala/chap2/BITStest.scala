package test

import chisel3.stage.ChiselGeneratorAnnotation

object bitMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/bits"), Seq(ChiselGeneratorAnnotation(() => new BITS)))


}
