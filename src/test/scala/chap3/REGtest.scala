

package chap3

import chisel3.stage.ChiselGeneratorAnnotation

object regMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/reg"), Seq(ChiselGeneratorAnnotation(() => new REG)))

}
