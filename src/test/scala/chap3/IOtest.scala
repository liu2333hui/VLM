package chap3

import chisel3.stage.ChiselGeneratorAnnotation

object ioMain extends App {

	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/io"), Seq(ChiselGeneratorAnnotation(() => new IO)))
	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/io"), Seq(ChiselGeneratorAnnotation(() => new HalfFullAdder(false))))
	(new chisel3.stage.ChiselStage).execute(Array("--target-dir", "generated/io"), Seq(ChiselGeneratorAnnotation(() => new OptionalIO(true))))


}
