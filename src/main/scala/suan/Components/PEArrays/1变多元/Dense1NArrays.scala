//Version 1 baseline (All dense arrays)
//No sparsity, no systolic, no fusion, no reconfigurable arrays

//1变1元
package PEArrays
import primitive._
import helper._

import suan._
import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 

	//1变2元
	// val variable : List[String],
	// val relation : List[Relation],
	// val precision: Map[String,Integer],
	// val inputs : List[String],
	// val outputs: List[String],
	
	// val iters: List[String],
	// val variable_iters: Map[String, List[String]],
	// val iters_tilesize: Map[String, Integer],
	
	// val systolic : Map[String,Boolean] = Map(),
	
class DenseUIntTransposeijklmPEArray(HardwareConfig: Map[String,String]) extends Module{
	//variable - x
	//relation - (i,j) -> (j,i)
	//precision - x
	val prec1 = HardwareConfig("prec1").toInt
	val prec_out = HardwareConfig("prec_out").toInt
	//inputs - x
	//outputs - y
	
	//iters = i, j
	//variable_iters y[j,i], x[i,j]
	//iters_tilesize = i = 8
	val I = HardwareConfig("i").toInt
	val J = HardwareConfig("j").toInt
	val K = HardwareConfig("k").toInt
	val L = HardwareConfig("l").toInt
	val M = HardwareConfig("m").toInt
	
	//Custom unit's config
	val io = IO(new Bundle{ 
		val in0 =  Vec(I*J*K*L*M, UInt(prec1.W) ) 
		val out0 = Vec(I*J*K*L*M, UInt(prec_out.W) ) 
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
	
	// 1
	val mod = List.fill(I*J*K*L*M)(  Module( 
	
		new PipelineData(prec1)
		
	))
	
	// 2
	for(i <- 0 until I){
	for(j <- 0 until J){	
	for(k <- 0 until K){
	for(l <- 0 until L){
	for(m <- 0 until M){
		mod( i+I*(j+J*(k + K * (l + L*m) )  ) ).io.in.bits := io.in0( i+I*(j+J*(k + K * (l + L*m) )  ) )
		io.out0( 
			// i+I*(j+J*(k + K * (l + L*m) )  ) 
			j+J*(i+I*(l + L * (k + K*m) ) ) //one possible permutation
		)  := mod(  i+I*(j+J*(k + K * (l + L*m) )  ) ).io.out.bits
	}}}}}
	
	// 3 
	for(i <- 0 until I){
	for(j <- 0 until J){	
	for(k <- 0 until K){
	for(l <- 0 until L){
	for(m <- 0 until M){
		mod(i+I*(j+J*(k + K * (l + L*m) )  )).io.out.ready  := io.exit.ready
		mod(i+I*(j+J*(k + K * (l + L*m) )  )).io.in.valid := io.entry.valid
	}}}}}	// 4
	io.entry.ready := mod(0).io.in.ready //reduce
	io.exit.valid  := mod(0).io.out.valid
}