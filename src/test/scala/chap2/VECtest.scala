package test

import chisel3.stage.ChiselGeneratorAnnotation

object bundleMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/bundlez"), Seq(ChiselGeneratorAnnotation(() => new BUNDLE)))


}
