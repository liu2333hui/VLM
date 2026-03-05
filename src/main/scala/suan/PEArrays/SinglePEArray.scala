package suan

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._


import primitive._


//1变1元

// class DenseSinPEArray(HardwareConfig: [String,String]) extends Module{

	

// 	val io = IO(new Bundle{
		
// 		val in0 =  
// 		val out0 =  
		
// 		val exit = ExitIO()
// 		val entry = EntryIO()
		
// 	})
	
// 	val tiles = 
	
// 	val m = List.fill(tiles)(  Module(PrimitiveFactory.CreateFixedPointIn1Out1(
	
// 		Map(
// 			"prec1i" -> prec1i.toString,
// 			"prec1f" -> prec1f.toString,
// 			"MultThroughput" -> MultThroughput.toString,
// 			"MultDelay" -> MultDelay.toString,
// 			"stages" = stages.toString			
// 		)
		
// 	)  ))
	
// }


// class DenseCosPEArray extends Module{
	
// }






















//Spec
//给定一个公式   O[i] = Relu(X[i])  ,   mu[i] = mu[i] + x[i,j]  ,   d[i] = d[i]*exp(m[i] -m_prev[i]) + exp(x[i,j] - m[i])
//返回一个Module实现这些功能
//1. PEArray
//2. DMA
//3. Counter
//4. Address Generator
//..等等

//例子1
//O[i] = Relu(X[i]),O[i] = X[i]*X[i]                     Tile = {i = 8, j = 8}, Prec = {X: "UInt16", O: "FP16"}
//1.分析parser      一变一元, output = [O], input = [X], idx = [i], Compute Graph -> Relu(X) = O
//2.创造PEArray
//2.1. 输入输出创造接口   val O = Output( Vec( Tout, UInt(precO.W)  ) ),   val X = Input ( Vec( Tin, UInt(precI.W)  ))
//2.2. 逐步创建Compute Graph. BFS ->   val unit1 = Array.fill( Tall , Module(new Op1(...) ))
//2.3. 连接接口和模块
//2.3.1. Input
//2.3.2. Output
//2.3.3. Systolic
//3.创造Value Sparsity
//4.创造Output Memory Sparsity
//5.创造Input  Memory Sparsity


//例子2
//O[j,i] = X[i,j]
//例子


class Relation ( val Op:String, val Inputs :List[String], val Output:String, 
	val HardwareConfig : Map[String,String])  {
		
	def get_elements(variable_tilesize:Map[String, Integer]):Integer = {
		var tilesize = 1
		for(input <- Inputs){
			if(variable_tilesize(input) > tilesize){
				tilesize = variable_tilesize(input)
			}
		}
		tilesize
	}
	
	
	// def create(val precision: Map[String,Integer]) : = {
		
	// }
	
	
	
		
}




//Act 
//Trig
//Square
//Neg

//Transpose (2 iter, 5 iter)
//Reduce
//Softmax:
//1. Max
//2. Online update
//3. Soln
//Norm:
//




//BinaryPEArray
//UIntPEArray
//SIntPEArray
//FloatPEArray
//FixedPointPEArray




//Leave to DAC2027 general generator
//Act, Trig, Square, Square
// class IntPEArray_1var1iter(
	
// ){
	
	
// }

// //Transpose, Reduce, Softmax, Norm.
// class IntPEArray_1var2iter(
	
// ){
	
// }

// class IntPEArray_2var1iter(
	
// ){
	
// }





//O[i] = Relu(X[i]),O[i] = X[i]*X[i]
class UIntPEArray(
	val variable : List[String],
	val relation : List[Relation],
	val precision: Map[String,Integer],
	val inputs : List[String],
	val outputs: List[String],
	
	val iters: List[String],
	val variable_iters: Map[String, List[String]],
	val iters_tilesize: Map[String, Integer],
	
	val systolic : Map[String,Boolean] = Map(),
) extends Module{
	
	//0.1. Calculate variable_tilesize
	var variable_tilesize:Map[String, Integer] = Map()
	for(vari <- variable){
		var tilesize = 1
		for(viters <- variable_iters(vari)){
			tilesize *= iters_tilesize(viters)
		}
		variable_tilesize = variable_tilesize + (vari -> tilesize)
	}
	
	for(vari <- variable){
		println(vari + " " + variable_tilesize(vari))
	}
	
	//1. Define IO
	val io = IO(new Bundle {
		val in0    = Input(Vec( variable_tilesize(inputs(0)) ,    UInt( precision(inputs(0)).toInt.W))  )
		val in1    = if(inputs.length >= 2) Some(
					 Input(Vec( variable_tilesize(inputs(1)) ,    UInt( precision(inputs(1)).toInt.W))  )
			)
			else None
		val in2    = if(inputs.length >= 3) Some(
					 Input(Vec( variable_tilesize(inputs(2)) ,    UInt( precision(inputs(2)).toInt.W))  )
			)
			else None
		
		
		val out0   = Output(Vec( variable_tilesize(outputs(0)) ,    UInt( precision(outputs(0)).toInt.W))  )
		// val entry = new EntryIO()
		// val exit = new ExitIO()
	})
	
	
	//2. Variable 导线
	variable_tilesize = variable_tilesize + ("null" -> 0)
	val prec:Map[String,Integer] = precision + ("null" -> 0)
	var variable_idx: Map[String,Integer] = Map()
	var i = 0
	for(vari <- variable){
		variable_idx = variable_idx + (vari ->i)
		i = i + 1
	}
	
	val wireVecSeq:Seq[Vec[UInt]] = List.tabulate(variable.length) { vecIndex =>
	    // 在每次循环中，创建一个新的 Wire，类型是 Vec(4, UInt(8.W))
	    val wireVec = Wire(Vec( variable_tilesize(variable.lift(vecIndex).getOrElse("null")), UInt(prec(variable.lift(vecIndex).getOrElse("null")).toInt.W)  ))
	    // --- 在这里编写对该组 Vec 的逻辑 ---
	    // 举例：让这组 Vec 的每个元素都赋值为 vecIndex * 10 + 元素索引
	    // for (elemIdx <- 0 until 4) {
	    //   wireVec(elemIdx) := ((vecIndex * 10) + elemIdx).U
	    // }
	    // // ----------------------------------- 
	    // 必须返回创建的 Vec，这样 List.tabulate 才能把它们收集到 Seq 中
	    wireVec
	  }
	
	
	//1.4. 连接接口
	for(i <- 0 until variable_tilesize(inputs(0))){
		wireVecSeq(  variable_idx(inputs(0)) )(i) := io.in0(i)
	}
	if(inputs.length >= 2){
		for(i <- 0 until variable_tilesize(inputs(2))){
			wireVecSeq(  variable_idx(inputs(2)) )(i) := io.in1.get(i)
		}	
	}
	if(inputs.length >= 3){
		for(i <- 0 until variable_tilesize(inputs(3))){
			wireVecSeq(  variable_idx(inputs(3)) )(i) := io.in2.get(i)
		}		
	}
	
	
	//3. 模块
	for(rel:Relation <- relation){
		//1.0 准备
		val elt = rel.get_elements(variable_tilesize)
		// println(elt)
		
		val Ins  = rel.Inputs.length
		val Outs = 1
		val Op = rel.Op
		val extra = rel.HardwareConfig		
		
		if(Ins == 1){
			//1.1. 模块
			val m = Seq.fill( elt )( Module( 
				PrimitiveFactory.CreateUIntIn1Out1(
					Op, Map(  
						"prec1" -> precision(rel.Inputs(0)).toString,  
						"prec_out" -> precision(rel.Output).toString
					) ++ extra
				)
			) ) 
			//1.2. 连接Input0
			for(i <- 0 until variable_tilesize(rel.Inputs(0))){
				m(i).io.in0 := wireVecSeq(  variable_idx(rel.Inputs(0)) )(i) 
			}
			//1.3. 连接Output0
			for(i <- 0 until variable_tilesize(rel.Output)){
				wireVecSeq(  variable_idx(rel.Output) )(i) := m(i).io.out
			}
			

			
		}//End Ins == 1
		else if(Ins == 2){
			//1.1. 模块
			val m = Seq.fill( elt )( Module( 
				PrimitiveFactory.CreateUIntIn2Out1(
					Op, Map(  
						"prec1" -> precision(rel.Inputs(0)).toString, 
						"prec2" -> precision(rel.Inputs(0)).toString, 
						"prec_out" -> precision(rel.Output).toString
					) ++ extra
				)
			) ) 							
			//1.2. 连接
			
			
		}//End Ins == 2
			
	}//End loop all relations


				
// 	// //1.3. 连接输入如果有
	
	
// 	// //1.4. 连接输出如果有
// 	// if(outputs.contain(rel.Output)){
		
// 	// } 
}



 object UIntPEArrayTest extends App{
 	val file = "./generaced/Primitive/UIntPEArray/Square"
	
 	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
 		Seq(ChiselGeneratorAnnotation(() => 
			new UIntPEArray(
				variable = List("in0", "out0"),//: List[String],
				relation = List(  
					new Relation(Op = "UIntBasicSquare", Inputs = List("in0"), Output = "out0", 
						HardwareConfig = Map() )
				),//: List[Relation],
				precision = Map(
					"in0" -> 8,
					"out0" -> 8,
				),//: Map[String,Integer],
				inputs = List("in0") ,//: List[String],
				outputs = List("out0"),//: List[String],
				
				iters   = List("i"),//: List[String],
				variable_iters = Map(
					"in0"  -> List("i"),
					"out0" -> List("i"),
				),//: Map[String, List[String]],
				iters_tilesize = Map(
					"i" -> 8
				),//: Map[String, Integer],
				
				// systolic ///: Map[String,Boolean] = Map(),
			)
		)))	
 }
 