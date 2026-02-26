package chap3
import chisel3._
// import chisel3.experimental._
import chisel3.util._

class REG extends Module {
	val io = IO(new Bundle{
		val in = Input(UInt(8.W))
		val asyncClk = Input(Bool())
		val asyncRst = Input(Bool())
	})
	
	
	
	val r0 = Reg(UInt())
	val r1 = Reg(UInt(8.W))
	val r2 = Reg(Vec(4, UInt()))
	val r3 = Reg(Vec(4, UInt(8.W)))
	
	class MyBundle extends Bundle {
			val unknowns = UInt()
			val known = UInt(8.W)
	}
	val r4 = Reg(new MyBundle)
	
	r0 := io.in
	r1 := io.in
	r2(0) := io.in
	r2(1) := io.in
	r2(2) := io.in
	r2(3) := io.in
	
	r3(0) := io.in
	r3(1) := io.in
	r3(2) := io.in
	r3(3) := io.in
	
	r4.unknowns := io.in
	r4.known := io.in
	
	val r11 = RegInit(1.U)
	val r12 = RegInit(1.U(8.W))
	val x = Wire(UInt())
	val y = Wire(UInt(8.W))
	val r21 = RegInit(x)
	val r22 = RegInit(y)
	
	x := 1.U
	y := 1.U
	
	val w2 = RegInit(r4)
	
	r11 := r1
	r12 := r1
	
	
	val r31 = RegNext(r1)
	val r32 = RegNext(w2)
	
	val ena = Wire(Bool())
	ena := r1(0).asBool
	val regWithEnable = RegEnable(r1, ena)
	
	val regWithEnableAndReset = RegEnable(r1, 0.U, ena)
	
	val regDelayTwo = ShiftRegister(r1, 2, ena)
	val regDelayTwoREset = ShiftRegister(r1, 2, 0.U, ena)


	val asyncRegInit = withClockAndReset(io.asyncClk.asBool().asClock(), io.asyncRst.asBool().asAsyncReset())(RegInit(0.U(8.W)))
	asyncRegInit := asyncRegInit + 1.U
	
	val reg0 = RegNext(VecInit(r1, r1))

}
