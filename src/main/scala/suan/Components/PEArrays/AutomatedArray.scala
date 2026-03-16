//1变1元
package AutomatedArrays

import primitive._
import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 


import java.io.PrintWriter


/*
	HighLevelAnalysis (Class for high level analysis of tensor algebra)
	
	HighLevel (Object containing functions to create PE Array code and Blackboxes)
		- parseComplex
		- FindUniqueVars
		- 
*/
class HighLevelAnalysis(

		val ins:List[String],
		val outs:List[String],
		
		val var2iters:Map[String,List[String]] ,
		val all_iters :List[String],
		
		
		val op :String
){
	def display() = {
		print("ins:")
		for(i <- ins){
			print(i+",")
		}
		println()
		print("outs:")
		for(i <- outs){
			print(i+",")
		}
		println()
		
		for(m <- var2iters.keys){
			println(m, var2iters(m))
		}
		
		
		println("op" + " " + op)
		
	}
}

//Three key types: SInt (balance), Fixed Point (good accuracy), Binary (fast)
object HighLevel{
	
	
	//multiple ops
	def parseComplex(exprs : List[String]) = {
		
		
		//Make into a complete tree (todos - automated)
		// var meta2 = HighLevel.parseComplex(List(
		// 		"sum[i] = SIntBasicAdd(in0[i,j])",//Step 1
		// 		"out0[i] = SIntBasicAdd(out0_p[i],sum[i])", //Step 2
		// ))
		
		
		var meta:List[HighLevelAnalysis] = List()
		for(expr <- exprs){
			println(expr)
			val res = parse(expr)
			
			meta = meta ++ List(res)
		}
		meta
	}
	
	def FindUniqueVars( main : List[String] , filter : List[String] ) = {
		//Sum 是重复的
		// List(in0) 
		// List(sum) 
		// List(out0_p, sum)
		// List(out0)
		// --> ins = in0, out0_p, outs = out0
		// println("main "+main)
		// println("filter "+filter)
		var v :List[String] = List()
		for(m <- main){
			if(filter.contains(m)){
				
			}else{
				v = v ++ List(m)
			}
			
		}
		
		v
		
		
	}

	def combineMeta(meta:List[HighLevelAnalysis]): HighLevelAnalysis = {
		
		var idx = 0
		
		var ins:List[String]  = List()
		var outs:List[String] = List()
		
		var var2iters:Map[String,List[String]] = Map()
		var all_iters :List[String] = List()
		var op :String = ""
		println("Combine Meta")
		
		//Algorithm
		//ins:in0,
		//ins:out0_p,
		//ins:out0_p_1,sum,
		//ins: in0, out0_p, out0_p_1, sum
		//outs:sum,out0_p_1,out0,
		//ins` = in0, out0_p
		//outs`= out0
		
		var itmp:List[String]  = List()
		var otmp:List[String]  = List()
		for(m <- meta){
			itmp = itmp ++ m.ins 
			otmp = otmp ++ m.outs
		}
		ins = FindUniqueVars(itmp, otmp).toSet.toList
		outs = FindUniqueVars(otmp,itmp).toSet.toList
		
		//input
		// var midx = 0
		// var nidx = 0
		// for(m <- meta){
		// 	nidx = 0
		// 	for(n <- meta){
		// 		if(nidx != midx){
		// 			var ins_list = FindUniqueVars(main = m.ins, filter = n.outs)
		// 			println("ins_list->" + ins_list)
		// 			ins ++= ins_list
		// 		}
		// 		nidx = nidx + 1
		// 	}
		// 	midx = midx + 1
		// }
		// ins = ins.toSet.toList
		// // println("ins " + ins)
		
		// //output
		// nidx = 0; midx =0 ;
		// for(m <- meta){
		// 	nidx = 0
		// 	for(n <- meta){
		// 		if(nidx != midx){
		// 			var ins_list = FindUniqueVars(main = m.outs, filter = n.ins)
		// 			// println("outs_list->" + ins_list)
		// 			outs ++= ins_list
		// 		}
		// 		nidx = nidx + 1
		// 	}
		// 	midx = midx + 1
		// }
		// outs = outs.toSet.toList
		// println("outs " + outs)
		
		
		//Combining var2iters, all_iters
		for(m <- meta){
			// var raw = HighLevel.createPEArray(m,
			// 	desiredName = "hardware" + idx
			// )
			// idx = idx + 1
			//add in outs	
			// println(m.ins)
			// println(m.outs)
			
			// println("op", m.op)
			op = op + m.op + "_"
			// println(m.all_iters)
			// println(m.var2iters)
			var2iters ++= m.var2iters
			all_iters ++= m.all_iters
		}
		// println(var2iters)
		// println(all_iters.toSet.toList)
		
		new HighLevelAnalysis(
			all_iters=all_iters.toSet.toList,
			ins=ins,
			outs=outs,
			var2iters=var2iters,
			op =op)
	}
	
	def getSubPENames(meta:HighLevelAnalysis, idx:Integer) = {
		
		"hardware_" + idx + "_" + meta.op  
		
	}
	def createSubPEBlackBoxes(meta:List[HighLevelAnalysis], desiredName:String) = {
		var s = ""
		var idx = 0
		var b = ""
		//(todos) maybe name is customizable?
		for(m <- meta){
			var name = getSubPENames(m, idx)
			var raw = HighLevel.createPEArray(m,
				desiredName = name  //"hardware" + idx
			)
			idx = idx + 1
			
			s += "\n	var "+name+" = Module(new BlackBox"+name+"PEArray(HardwareConfig))"
			
			b += raw("b")
			// BlackBoxhardware1PEArray(HardwareConfig: Map[String,String]) 
			
		}
		Map("s" -> s,
			"b" -> b
		)
	}
	
	
	
	//Connect meti ins/outs to the submodules meta.ins/outs automatically
	def connectComplexInputsOutputs(meta:List[HighLevelAnalysis], meti: HighLevelAnalysis) = {
		
		var s = "\n"
		//Inputs
		for(i <- meti.ins){
			// println("meti " + i)
			var midx = 0
			for(m <- meta){
				for(ii <- m.ins){
					// println(i, midx, ii)
					if(i == ii){
						var tag = i+"""("""+get_iter_idx(meti.var2iters(i))+""")"""
						s += "\n	//Connect Input "+i+""
						s += create_begin_for(meti.var2iters(i))
						s += "\n		"+getSubPENames(m, midx) + ".io.io."+tag
						s += """ := io."""+tag
						s += create_end_for(meti.var2iters(i))
						s += "\n"
						// println(i, midx, ii)
					}
				}
				midx = midx + 1
			}
		}
		
		//Outputs
		for(i <- meti.outs){
			// println("meti " + i)
			var midx = 0
			for(m <- meta){
				for(ii <- m.outs){
					// println(i, midx, ii)
					if(i == ii){
						var tag = i+"""("""+get_iter_idx(meti.var2iters(i))+""")"""
						s += "\n	//Connect Output "+i+""
						s += create_begin_for(meti.var2iters(i))
						s += "\n		io."+tag
						s += " := "+getSubPENames(m, midx) + ".io.io."+tag
						s += create_end_for(meti.var2iters(i))
						s += "\n"
						// println(i, midx, ii)
					}
				}
				midx = midx + 1
			}
		}
		
		
		s
	}
	
	def all_vars(meti:HighLevelAnalysis):List[String] = {
		var l:List[String] = List()
		
		for(k <- meti.var2iters.keys){
			l ++= List(k)
		}
		l
	}
	
	def connectComplexIntermediates(meta:List[HighLevelAnalysis], meti: HighLevelAnalysis) = {
		var s = ""
		var inter = get_diff_iters(all_vars(meti), meti.ins ++ meti.outs)
		// println("inter -> ", inter)
		var midx = 0
		var nidx = 0
		for(i <- inter){
			midx = 0
			for(m <- meta){
			nidx = 0
			for(n <- meta){
				if(midx > nidx){
					
					
					

					//find ins, outs
					if(n.ins.contains(i) && m.outs.contains(i)){
						// println("meta pairs " , midx, nidx, m,n)
						s += "\n	//Connect Intermediate "+i+""
						s += create_begin_for(meti.var2iters(i))
						
						var tag = i+"""("""+get_iter_idx(meti.var2iters(i))+""")"""
							
							
						s += "\n		"+getSubPENames(n, nidx)+".io.io."+tag
						s += " := "+getSubPENames(m, midx) + ".io.io."+tag
						
						
						s += create_end_for(meti.var2iters(i))
						s += "\n"
						
					}
					else if(m.ins.contains(i) && n.outs.contains(i)){
						// println("meta pairs " , midx, nidx, m,n)
						s += "\n	//Connect Intermediate "+i+""
						s += create_begin_for(meti.var2iters(i))
						
						var tag = i+"""("""+get_iter_idx(meti.var2iters(i))+""")"""
							
							
						s += "\n		"+getSubPENames(m, midx)+".io.io."+tag
						s += " := "+getSubPENames(n, nidx) + ".io.io."+tag
						
						
						s += create_end_for(meti.var2iters(i))
						s += "\n"
					}else {
						
						
					}
					
					
				}
				nidx = nidx + 1
			}
			midx = midx + 1
			}
		}
		
		
		s
		
		
	}
	
	def findDepModules(meta:List[HighLevelAnalysis], vars: List[String],
		mode:String = "Downstream"):List[Int]
		= {
		var l: List[Int] = List()
		for(v <- vars){
			var midx :Int= 0
			for(m <- meta){
				if(mode=="Downstream"){				
					if(m.ins.contains(v)){
						l ++= List(midx)
					}
				}else if(mode=="Upstream"){
					if(m.outs.contains(v)){
						l ++= List(midx)
					}
				}
				midx = midx+1
			}
		}
		l.toSet.toList
	}
	
	
	def findDepModulesWithTop(meta:List[HighLevelAnalysis], 
		meti:HighLevelAnalysis, vars:List[String],
		mode:String = "Downstream"):List[Int] = {

		var l: List[Int] = List()
		
		if(mode == "Downstream"){
			l ++= findDepModules(meta, vars, mode="Downstream")
			if(findDepModules(List(meti), vars, mode="Upstream").length >= 1){
				l ++= List(meta.length)
			}
		}else{
			l ++= findDepModules(meta, vars, mode="Upstream")
			if(findDepModules(List(meti), vars, mode="Downstream").length >= 1){
				l ++= List(meta.length)
			}
		}
		
		l.toSet.toList
		
	}
	
	def combineAnd(nets:List[String], tail:String="") :String= {
		var s = ""
		var nidx = 0
		for(n <- nets){
			if(nidx + 1 == nets.length){
				s += n+tail
			}else{
				s += n+tail
				s += " & "
			}
			nidx += 1
		}
		s
	}
	
	def getFifoName(meta:HighLevelAnalysis, hardwareid :Integer, inputName:String) = {
		getSubPENames(meta, hardwareid) + "_"+inputName+"_fifo"
	}
	
	def createInputFifos(meta:List[HighLevelAnalysis], 
		module2entries:Map[Int, Int] = Map(),
		default_entries:Int = 8) = {
		
		var s = "\n"		
		var midx = 0
		for(m <- meta){
			var var2type = getVar2type(m)
			for(v <- var2type.keys){
				println(v, var2type(v))
			}
			for(i <- m.ins){
				var data = var2type(i) //SInt(prec0.W)			
				s += "\tval " + getFifoName(m, midx, i) + """ = Module(new Queue("""+data+","+
				 "entries = "+module2entries.getOrElse(midx, default_entries)+")\n"
			}
			midx += 1
		}
		
		s
	}
	
	def connectComplexReadyValid(meta:List[HighLevelAnalysis], meti: HighLevelAnalysis) = {
		
		var s = ""
		
		//链接top entry ready/valid
		//1. io.entry
		// meti.ins
		var l = findDepModules(meta, meti.ins, mode="Downstream")
		// println("io downstream" + l)
		s += "\n	//Connect Top io entry\n"
		var nets:List[String] = List()
		for(vastu <- l){
			nets ++= List(getSubPENames(meta(vastu), vastu) )
			s += "\t"+getSubPENames(meta(vastu), vastu) + 
				".io.io.entry.valid := io.entry.valid\n"
		} 
		println("top nets ", nets)
		s += "\tio.entry.ready := "+combineAnd(nets, tail=".io.io.entry.ready")+"\n"

		//链接submodule ready/valid
		//2. hardware1.io.entry
		//	 hardware1.io.exit
		var midx = 0
		for(m <- meta){
			// println(m.ins)
			var lin = findDepModulesWithTop(meta, meti, m.ins, mode="Upstream")
			// println(getSubPENames(m, midx)+" upstream" + l)
			// println(m.outs)
			var lout = findDepModulesWithTop(meta, meti, m.outs, mode="Downstream")
			// println(getSubPENames(m, midx)+" Downstream" + l)
			
			midx += 1
			//N-1 = meti, the overall module
		}
		
		//链接top exit ready/valid
		// meta.outs
		l = findDepModules(meta, meti.outs, mode="Upstream")
		println("io upstream" + l)
		
		
		s
	}
	
	
	def getLevelize(meta:List[HighLevelAnalysis], meti:HighLevelAnalysis) 
		: Map[Int, List[HighLevelAnalysis]] = {
		
		var m : Map[Int, List[HighLevelAnalysis]] = Map()
		
		// var level = 0
		
		// var cur_ins : List[String] = List()
		
		// cur_ins = meti.ins
		// while(m.length != meta.length){
		// 	var next_ins:List[String] = List()
		// 	var cur_modules:List[HighLevelAnalysis] = List()
		// 	for(i <- cur_ins){
				
		// 		//if in the input of the module, add it
		// 		for(m <- meta){
		// 			if(m.ins.contains(i)){
		// 				cur_modules ++= List(m)
		// 				// next_ins ++= next_ins.//Todos
		// 			}
		// 		}
				
		// 	}
			
		// 	level = level + 1
		// }
		m
		
	}
	// def makeLevel(meta:List[HighLevelAnalysis], meti:HighLevelAnalysis) = {
		
	// }
	
	//Create a complex array (multiple single ararys)
	//Assuming the dependencies are immediate (etc. b = ax, y = b + c). (b = ax, c = reduce(b))
	//Fusion array is another module (see createFusedArray)
	def createComplexArray(meta:List[HighLevelAnalysis], desiredName:String) = {
		println()
		println()
		//combine meta
		
		var support = ""
		
		//(WRITE) 1. Write Chisel Header
		var s = GetChiselHeader()	
		//(WRITE) 2. Class Name and Module Definition
		s += createPEArrayClassName(meta(0), desiredName)

		//(WRITE) 3 tilings + Precisions
		var meti = combineMeta(meta)		
		println("meti in " + meti.ins)
		println("meti out " + meti.outs)
	
		s += createTilingsPrecisions(meti, desiredName)
		
		//(THINK+WRITE) 4. IO and datatype
		var ioanalysis = analyzePEArrayIO(meti, desiredName)
		s += ioanalysis("s")
		
		//(THINK+WRITE) 5. Build
		//Call the Blackboxes
		var subpe =  createSubPEBlackBoxes(meta, desiredName)
		s += subpe("s")
		support += subpe("b")
		
		//(THINK+WRITE) 6. Connect Pure Inputs + Outputs
		s += connectComplexInputsOutputs(meta, meti)
		
		//8. Connect Intermediates
		s += connectComplexIntermediates(meta, meti)
		
		//9. Create Input Fifos
		// s += createInputFifos(meta)
		
		//10. Connect Ready Valid
		s += connectComplexReadyValid(meta, meti)
		
		//(WRITE) 11. end module
		s += "\n}\n"
		
		
		

		Map(
			"s" -> s,
			"support" -> support,
			
		)
	}
	
	//singleops
	def parse(expr :String=""):HighLevelAnalysis = {
		
		
		
		val e = expr.replaceAll("\\s", "") 
		// println(expr)
		//一
		// println(e)
		//序列out0,[,],=,out0[,],+in0,[,i,]
		var tokens:List[String] = List()
		var prev = ""
		var l = ""
		var special_ops = List("+", "-", "*", "/")
		var seps = List("[", "]", "(", ")", "=", ",")
		var all_seps = seps ++ special_ops
		for(s <- e){
			// println(s)
			
			if(all_seps.contains(s.toString)){
				if(l != ""){
					tokens = tokens ++ List(l)
				}
				tokens = tokens ++ List(s.toString)
				l = ""
			}else{
			
				l += s
			}
		}
		// for(t <- tokens){
		// 	println(t)
		// }
		
		//二
		//分析 ins,outs
		// var in_list = List("in0", "in1", "in2", "in3", "in4", "in5")
		// var out_list = List("out0", "out1", "out2", "out3")
		var in_list:List[String] = List() //(TODOS)
		var out_list:List[String] = List()
		
		
		
		var state = 0
		var prev_token = ""
		for(t <- tokens){
			// println(t, prev_token)
			if(state == 0){
				if(t == "="){
					state = 1
				}
				
				
					// out_list ++= List(t)
					if(t == "["){
						out_list ++= List(prev_token)
					}else{
						
					}
				
			}else{
					
					if(out_list.contains(t)){
						
					}else{
						if(t == "["){
							in_list ++= List(prev_token)
						}else{
							
						}
					}
			}
			prev_token = t
		}
		for(i <- in_list){
			// println(i)
		}
		
		var ins:List[String] = List()
		var outs:List[String] = List()
		state = 0
		for(t <- tokens){
			//Output mode
			if(state == 0){
				if(t == "="){
					state = 1
				}else{
					if(out_list.contains(t)){
						outs = outs ++ List(t)
					}
				}
			}
			//Input mode
			else{
				if(in_list.contains(t)){
					ins = ins ++ List(t)
				}
				if(out_list.contains(t)){
					ins = ins ++ List(t+"_p")
				}
				
			}
		}
		var vars:List[String] = ins ++ outs
		print("ins:")
		for(i <- ins){
			print(i+",")
		}
		println()
		print("outs:")
		for(i <- outs){
			print(i+",")
		}
		println()
		
		//3分析
		//tilesize: out0 = 1, in0 = i
		var var2iters:Map[String,List[String]] = Map()
		//out0 = [], in0 = i
		state = 0
		var output_mode = 0
		var cur_var = ""
		var iters :List[String] = List()
		for(t <- tokens){
			if(output_mode == 0){
				if(t == "="){
					output_mode = 1
				}
			}
			//detect input/output
			if(state == 0){
				if(vars.contains(t)){
					cur_var = t
					if(output_mode == 1 && outs.contains(t)){
						cur_var = t + "_p"
					}
					// cur_var = t
					state = 1
				}
			//detect [
			}else if(state == 1){
				if("[" == t){
					state = 2
				}
			//detect iterator
			}else if(state == 2){
				if(t == "]"){
					//save
					var2iters = var2iters ++ Map(cur_var -> iters)
					state = 0
					cur_var = ""
					iters = List()
					
				}else if(t == ","){
					//continue
				}else{
					iters = iters ++ List(t)
				}
			}
		
		}
		
		
		var all_iters :List[String] = List()
		for(m <- var2iters.keys){
			// println(m, var2iters(m))
			
			for(mm <- var2iters(m)){
				if(all_iters.contains(mm)){
					
				}else{
					all_iters ++= List(mm)
				}
			}
			
			// if(all_iters.contains(m)){
				
			// }else{
			// 	all_iters ++= var2iters(m)
			// }
		}
		// for(m <- all_iters){
		// 	println("iters " + m)
		// }
		
		//4分析 (比较复杂)
		//Op = 
		
		var op :String = ""
		for(t <- tokens){
			// println(t)
			if(seps.contains(t) ||
			   vars.contains(t) ||
			   all_iters.contains(t)
			){
				
			}else{
				// println(t)
				op = t
			}
		}
		println("op" + " " + op)
		//Op = (+,out0_p,in0,out0)
		
		//5分析tilesize的分布（有没有broadcast)
		//out0 = 1, in0 = i
		// val var2innertile:Map[String,List(String)] = Map()
		// val var2outertile:Map[String,List(String)] = Map()
		//outerms:            in0 = 1
		//interms:            in0 = i
		
		new HighLevelAnalysis(
			all_iters=all_iters,
			ins=ins,
			outs=outs,
			var2iters=var2iters,
			op =op)
			
		
	}
	
	
		def get_tilesize(meta: HighLevelAnalysis, iter2tile:Map[String,Int], in:String) = {
			var tilesize = 1
			for(i <- meta.var2iters(in)){
				tilesize *= iter2tile(i)
			}
			tilesize
		}
		
		def get_tilesize(iters:List[String], iter2tile:Map[String,Int]) = {
			var tilesize = 1
			for(i <- iters){
				tilesize *= iter2tile(i)
			}
			tilesize
		}
		
		def get_iters(meta: HighLevelAnalysis, in:String) = {
			var iters = ""
			var idx = 0
			
			// println("get_iters ", meta.var2iters(in).length)
			// println("get_iters ", meta.var2iters(in))
			for(i <- meta.var2iters(in)){
				iters = iters + i.toUpperCase()
				
				if(idx + 1 == meta.var2iters(in).length){
					
				}else{
					iters = iters + "*"
				}
				idx = idx + 1
			}
			if(iters == ""){
				iters = "1"
			}
			iters
		}
		
		def get_iters(iterLIst:List[String]) = {
			var iters = ""
			var idx = 0
			for(i <- iterLIst){
				iters = iters + i.toUpperCase()
				if(idx + 1 == iterLIst.length){
				}else{
					iters = iters + "*"
				}
				idx = idx + 1
			}
			if(iters == ""){
				iters = "1"
			}				
			iters
		}
		
		def get_iter_idx(iters:List[String] = List("i","j","k")) = {
			
			//[j,i]
			//j + J*(i)
			//[i,j,k]
			//i + I*(j + J*(k + K*0))
			var prev = "0"
			var s = ""
			for(i <- iters.length-1 to 0 by -1){
				// println(i, iters(i))
				prev = "("+iters(i)+"+"+iters(i).toUpperCase()+"*"+prev+")"
				
			}
			
			prev
		}
	

		def create_end_for(in_iters:List[String]) = {
			var s = ""
					for(i <- in_iters)
						s += """
	}"""

			s
		}
	
		def create_begin_for(in_iters:List[String]) = {
			var s = ""
			for(i <- in_iters)
			s += """
	for("""+i+""" <- 0 until """+i.toUpperCase()+"""){"""
				
			s
		}


		def get_diff_iters(in_iters:List[String], filter:List[String]) = {
			var inner_iters:List[String] = List()
			for(i <- in_iters){
				if(filter.contains(i)){
					
				}else{
					inner_iters = inner_iters ++ List(i)
				}
			}
			inner_iters
		}
		
		
		
		def GetChiselHeader(
		
		) = {
			"""
package AutomatedArrays

import primitive._
import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 
						"""
		}

		
		def createPEArrayClassName(
		meta: HighLevelAnalysis, 
		desiredName:String
		) = {
			var s = ""
			s += """
class """+desiredName+"""PEArray(HardwareConfig: Map[String,String]) extends Module{
		
	override def desiredName = HardwareConfig("desiredName")
	
				"""
			s
		}
		
		def createBlackboxPEArrayClassName(
		meta: HighLevelAnalysis, 
		desiredName:String
		) = {
			var s = ""
			s += """
class BlackBox"""+desiredName+"""PEArray(HardwareConfig: Map[String,String]) extends BlackBox{
	
		override def desiredName = HardwareConfig("desiredName")
	
	
				"""
			s
		}
		
			
		def createTilingsPrecisions(
		meta: HighLevelAnalysis, 
		desiredName:String) = {
			var s = ""
			var tilings = ""
			for(v <- meta.all_iters){
				tilings += "\n	val "+v.toUpperCase()+" = HardwareConfig(\""+v.toUpperCase()+"\").toInt\n"
			}
			s += tilings
			
			//(WRITE) 4.2 precisions
			var precs = ""
			for(v <- meta.var2iters.keys){
				precs += "\n	val "+v+"prec = HardwareConfig(\""+v+"prec\").toInt\n"
			}
			s += precs		
			s
		}
		
		def getVar2type(
			meta: HighLevelAnalysis,
		) = {
			var var2type:Map[String,String] = Map()
			if(meta.op.contains("SInt")){
				for (in <- meta.ins){
					var precs = in.split("_")(0) + "prec"	
					var v = in//+"var"
					var r = "SInt("+precs+".W)"
					var2type = var2type + (v -> r) 
				}
				for (in <- meta.outs){
					var precs = in + "prec"
					var v = in//+"var"
					var r = "SInt("+precs+".W)"
					var2type = var2type + (v -> r) 
				}
			}else if(meta.op.contains("UInt")){
			}else if(meta.op.contains("FixedPoint")){
			}else if(meta.op.contains("Floating")){
			}else if(meta.op.contains("Binary")){
			}
			
			var2type
		}
					
		def analyzePEArrayIO(
			meta: HighLevelAnalysis, 
			desiredName:String,
			isBlackBox :Boolean =  false
		) = {
			var io_inouts = "\n"
			var dtype = "SInt"
			
			var var2type:Map[String,String] = getVar2type(meta)//Map()
			
			if(meta.op.contains("SInt")){
				dtype = "SInt"
				
				for (in <- meta.ins){
					var iters = get_iters(meta, in)
					var precs = in.split("_")(0) + "prec"	
					io_inouts += "		val " + in + " = Input(Vec("+iters+", SInt("+precs+".W)))\n"
				}
				
				for (in <- meta.outs){
					var iters = get_iters(meta, in)
					var precs = in + "prec"
					io_inouts += "		val " + in + " = Output(Vec("+iters+", SInt("+precs+".W)))\n"
				}
				
			}else if(meta.op.contains("UInt")){
				dtype = "UInt"
			}else if(meta.op.contains("FixedPoint")){
				dtype = "FixedPoint"
				// val in0 =  Vec(i_tilesize, new FP(prec1i, prec1f) ) 
				// 		val out0 = Vec(i_tilesize, new FP(prec_outi, prec_outf) ) 
					
			}else if(meta.op.contains("Floating")){
				dtype = "Floating"
			}else if(meta.op.contains("Binary")){
				dtype = "Binary"
			}
			
			if(isBlackBox){
				io_inouts = "\n		val clock = Input(Clock())\n		val reset = Input(Bool())\n		val io = new Bundle{\n" + io_inouts + "\n		}\n"
			}
			
			var s = ""
			//(WRITE) 4.2 IO def and writing
			s += """
	val io = IO(new Bundle{
		"""+io_inouts+"""
		val exit = new ExitIO()   
		val entry = new EntryIO() 
	})
				"""
				
			Map(
				"dtype" -> dtype,
				"io_inouts" -> io_inouts,
				"s" -> s,
			) ++ var2type
		}
		
	def analyzePEDataflow(	meta: HighLevelAnalysis, 
			desiredName:String) = {
					//modules, blackbox modules 		//For fast compile, use blackbox modules
					// var total_tilesize = get_tilesize(meta.all_iters, iter2tile)
					var num_in = meta.ins.length
					var num_out = meta.outs.length
					
					//(THINK) 6. Determine if there is reduction in the computation, Reduce issue
					var in_iters :List[String] = List()
					for(m <- meta.ins){
						for(mm <- meta.var2iters(m)){
							if(in_iters.contains(mm)){
								
							}else{
								in_iters ++= List(mm)//meta.var2iters(m)
							}
						}
						
					}
					var out_iters :List[String] = List()
					for(m <- meta.outs){
						// out_iters ++= meta.var2iters(m)
						
						for(mm <- meta.var2iters(m)){
							if(out_iters.contains(mm)){
								
							}else{
								out_iters ++= List(mm)//meta.var2iters(m)
							}
						}
						
						
					}		
					// var in_tilesize = get_tilesize(in_iters, iter2tile)
					// var out_tilesize = get_tilesize(out_iters, iter2tile)
					// println(in_tilesize, out_tilesize)
					// var is_reduce = out_tilesize < in_tilesize
					var is_reduce = out_iters.length < in_iters.length
					// println(is_reduce)
					var num_in_s = num_in.toString
					if(is_reduce){
						num_in_s = "N"
					}
					
					Map(
						("in_iters" -> in_iters),
						  ("out_iters"->out_iters),
						  ("is_reduce"->is_reduce),
						  ("num_in"->num_in),
						  ("num_in_s"->num_in_s),
						  ("num_out"->num_out),
					)
				}
				
				
				
				
	def createPEArraySubModules(meta: HighLevelAnalysis, 
			desiredName:String, ioanalysis:Map[String,String] ,df:Map[String,Any]) = {
		
		var in_iters = df("in_iters").asInstanceOf [List[String]];var out_iters = df("out_iters").asInstanceOf [List[String]];
		var is_reduce = df("is_reduce").asInstanceOf [Boolean];
		var num_in = df("num_in");var num_in_s = df("num_in_s");var num_out = df("num_out");
		var dtype = ioanalysis("dtype");var io_inouts = ioanalysis("io_inouts");// var io_inouts = ""
		
		var s = ""
		var mprec = "prec1 -> 8.toString"
	if(dtype == "SInt"){
		var in1 = meta.ins(0)
		var out1 = meta.outs(0)
		// var prec1 = var2prec.getOrElse(in1, var2precision.getOrElse(in1, 8))
		// var prec_out = var2prec.getOrElse(out1, var2precision.getOrElse(out1, 8))
		if(is_reduce){	
			//每个值的tilesize
			
			var terms = ""
			if(num_in == 1){
				terms = get_iters(meta, in1)
			}else if(num_in == 2){
				var in2 = meta.ins(1)
				terms = get_iters(meta, in1) + "+" + get_iters(meta, in2)
			}
			
			// var terms = num_in
			//log2
			mprec = """
			"terms" -> ("""+terms+""").toString,
			"prec1" -> """+in1.split("_")(0)+"""prec.toString,
			"prec_out" -> """+out1.split("_")(0)+"""prec.toString,"""
		}else{					
			if(num_in == 1){
				mprec = """
				"prec1" -> """+in1.split("_")(0)+"""prec.toString,
				"prec_out" -> """+out1.split("_")(0)+"""prec.toString,"""
			}else if(num_in == 2){
				var in2 = meta.ins(1)
				// var prec2 = var2prec.getOrElse(in2, var2precision.getOrElse(in2, 8))
				mprec = """
				"prec1" -> """+in1.split("_")(0)+"""prec.toString,
				"prec2" -> """+in2.split("_")(0)+"""prec.toString,
				"prec_out" -> """+out1.split("_")(0)+"""prec.toString,"""
			}
		}
	}//(TODOS other dtypes)
				
				
	//General Case
	var op = meta.op
	if(op == ""){
		op = dtype+"Buffer"
	}
	//Other cases?
	
	
				//(WRITE) 7. Write configuration of subhardware modules, PE elements
				var total_iters = get_iters(out_iters)//meta.all_iters)
		s += """
	val save_folder = HardwareConfig("save_folder")
	val m =  Seq.tabulate("""+total_iters+""")( i => 
		Module( PrimitiveFactory.CreateBlackBox"""+dtype+"""In"""+num_in_s+"""Out"""+num_out+"""(
			primitive_name=""""+meta.op+"""",
			desired_name=""""+desiredName+"""",
			HardwareConfig=Map(
"""+mprec+"""
			) ++ HardwareConfig,
			save_folder = save_folder,
			id = i
		))
	)		
		"""
		s
	}
				
	def createConnectNetlists(meta: HighLevelAnalysis, 
			desiredName:String, ioanalysis:Map[String,String] ,df:Map[String,Any]) = {
		
		var s = ""
		
				var in_iters = df("in_iters").asInstanceOf [List[String]];var out_iters = df("out_iters").asInstanceOf [List[String]];
				var is_reduce = df("is_reduce").asInstanceOf [Boolean];
				var num_in = df("num_in");var num_in_s = df("num_in_s");var num_out = df("num_out");
				var dtype = ioanalysis("dtype");var io_inouts = ioanalysis("io_inouts");// var io_inouts = ""		
				
				
				//1. Module input
				var inner_iters = get_diff_iters(in_iters, filter=out_iters)
				s += "\n	//Module Input \n"
				s += create_begin_for(meta.all_iters)
				if(dtype == "SInt"){
					//case N
					if(is_reduce){	
						//[j]  [j,i] -> only in iters = [i]
						s += """		
		m("""+get_iter_idx(out_iters)+""").io.io.in0("""+get_iter_idx(inner_iters)+
					""") := io."""+meta.ins(0)+"""("""+get_iter_idx(inner_iters)+""")"""
						
					}else{
						//Case 1
						if(num_in == 1){
						s += """
		m("""+get_iter_idx(out_iters)+""").io.io.in0 := io."""+meta.ins(0)+"""("""+get_iter_idx(in_iters)+""")"""
						
						}
						//Case 2
						else if(num_in == 2){
						s += """
		m("""+get_iter_idx(out_iters)+""").io.io.in0 := io."""+meta.ins(0)+"""("""+get_iter_idx(meta.var2iters(meta.ins(0)))+""")"""
						s += """
		m("""+get_iter_idx(out_iters)+""").io.io.in1 := io."""+meta.ins(1)+"""("""+get_iter_idx(meta.var2iters(meta.ins(1)))+""")"""
						
						}
						
					}
				}
				s += create_end_for(meta.all_iters)
				s += "\n\n"
		
				//(WRITE) 9. Connect module to io output ports
				//2. Module output
				s += "	//Module Output \n"
				s += create_begin_for(out_iters)
				s += """
		io."""+meta.outs(0)+"""("""+get_iter_idx(out_iters)+""") := m("""+get_iter_idx(out_iters)+""").io.io.out"""
				s += create_end_for(out_iters)
				s += "\n\n"
				
				//(WRITE) 10. Connect module to io exit/entry handshaking signals
				//(WRITE) 10.1 Connection of io.exit/entries
				s += "	//Connection of io.exit/entries\n"
				s += create_begin_for(out_iters)
				s += "\n		m("+get_iter_idx(out_iters)+").io.io.exit.ready  := io.exit.ready\n"
				s += "\n		m("+get_iter_idx(out_iters)+").io.io.entry.valid := io.entry.valid\n"
				s += create_end_for(out_iters)
				s += "\n"
				
				//(WRITE) 10.2 Connection of io.exit/entries
				s += "\n	io.entry.ready := m(0).io.io.entry.ready\n" //reduce
				s += "\n	io.exit.valid  := m(0).io.io.exit.valid\n"
				
				
		s
	}
				
		////////////////////////////////////////////////////////////////////////////////
		//CREATE SINGLE OPERATION PE ARRAY AUTOMATICLALY
		def createPEArray(meta: HighLevelAnalysis, 
			// var2prec :Map[String,Int],
			// iter2tile :Map[String,Int],
			// var2systolic :Map[String,Int],
			desiredName:String
		) = {
			
			//The main module (PE ARRAY)
			println("Creating " + meta.op)
			// meta.display()
			
			//(WRITE) 1. Write Chisel Header
			var s = GetChiselHeader()
	
			//(WRITE) 2. Class Name and Module Definition
			s += createPEArrayClassName(meta, desiredName)
			
			//(WRITE) 3 tilings + Precisions
			s += createTilingsPrecisions(meta, desiredName)
			
			//(THINK+WRITE) 4. IO and datatype
			var ioanalysis = analyzePEArrayIO(meta, desiredName)
			s += ioanalysis("s")
			
			//(THINK) 5. tile sizing, number of outputs, inputs
			var df = analyzePEDataflow(meta, desiredName)
			
			//(THINK) 6. Determine configuration of subhardware modules, PE elements
			s += createPEArraySubModules(meta, desiredName, ioanalysis, df)
			
			//(WRITE) 7. Connect module to io input ports
			s += createConnectNetlists(meta, desiredName, ioanalysis, df)
				
			//(WRITE) 8. end module
			s += "\n}\n"
			//println(s)


			
			//The Blackbox of the main module
			//blackbox for upper hierarchieis (todos)
			var b = ""
			b += GetChiselHeader()
			b += createBlackboxPEArrayClassName(meta, desiredName)
			b += createTilingsPrecisions(meta, desiredName)
			var blackbox_ioanalysis = analyzePEArrayIO(meta, desiredName, isBlackBox = true)
			b += blackbox_ioanalysis("s")
			b += "\n}\n"
			
		Map(
		    "s" -> s,
			"b" -> b,
		)
	
	}
	
		def save(s :String, f:String) = {
			var writer = new PrintWriter(s)
				try {writer.write(s)} finally {writer.close()}
			
		}
		
		def GenerateMainFunction( g :List[String]) = {
		
			var s = ""
			
			s += GetChiselHeader()
			
			s += """
object Main extends App {
					

"""
			for(gg <- g){
			
				s += gg
				
			}
			
			
			s += """
}
			"""
			
			s
		}
	
	
		def GeneratePEArrayVerilog(meta: HighLevelAnalysis, 
			var2prec :Map[String,Int],
			iter2tile :Map[String,Int],
			var2systolic :Map[String,Int],
			desiredName:String
		) = {
			
			
			
			//(WRITE) 4.1 tilings
			var tilings = ""
			for(v <- meta.all_iters){
				tilings += "\n"+"\t"*5+"\""+v.toUpperCase()+"\" -> "+iter2tile(v)+".toString,"
			}
			// s += tilings
			
			//(WRITE) 4.2 precisions
			var precs = ""
			for(v <- meta.var2iters.keys){
				precs += "\n"+"\t"*5+"\""+v+"prec\" -> "+var2prec(v)+".toString,"
			}
			// s += precs	
			
			
			var g = """
	
	var file = """+"\"./generated/latest/"+desiredName+"\""+"""
	new (chisel3.stage.ChiselStage).execute(Array("--target-dir", file),
		Seq(ChiselGeneratorAnnotation(() => 
			new """+desiredName+"""PEArray(
				Map("""+tilings+"""
					"""+precs+"""
					
					"save_folder" -> file,
					
					"desiredName" -> """"+desiredName+"""",
			))		
		)))	
			"""
			Map("g" -> g)
		}
		
		
}




//(THINK) 0. fix precision of inputs which are the output
			//etc.  output[i] = output[i] + input[i]
			// var var2precision:Map[String,Int] = Map()
			// for(in <- meta.ins){
			// 	//stripped
			// 	var i = in.split("_")(0)
			// 	if(meta.outs.contains(i)){
			// 		var2precision ++= Map(in -> var2prec(i))
			// 	}
			// }
			// for(t <- var2precision.keys){
			// 	println(t + " " + var2precision(t))
			// }










































//Version 1
//1 expression only + 1 variable + 1 iterator
class Automated11SIntArray(HardwareConfig: Map[String,String]) extends RawModule{
	val expr = HardwareConfig("expr")
	//"out0[i] = SInt(in0[i])"

	
	//out0[]+=in0[i]
	//Gate(in0=0)
	//Value(in0=0)
	//Memory(in0)
	//序列out0,[,],=,out0[,],+in0,[,i,]
	//分析
	//tilesize: out0 = 1, in0 = i
	//Op = (+,out0_p,in0,out0)
	//outerms:            in0 = 1
	//interms:            in0 = i

	HighLevel.parse(expr)
	
	//out0[i]=Fn(in0[i])
	//out0[i]=Fn2(Fn1(in0[i]))
	
	
	
	
	
	//variable - x
	//relation - sin
	//precision - x
	// val prec1i = HardwareConfig("prec1i").toInt
	// val prec1f = HardwareConfig("prec1f").toInt
	// val prec_outi = HardwareConfig("prec_outi").toInt
	// val prec_outf = HardwareConfig("prec_outf").toInt
	// //inputs - x
	// //outputs - y
	
	// //iters = i
	// //variable_iters y[i], x[i]
	// //iters_tilesize = i = 8
	
	// val i_tilesize = HardwareConfig("i").toInt
	
	// //Custom unit's config
	// val MultThroughput = HardwareConfig("MultThroughput")
	// val MultDelay = HardwareConfig("MultDelay")
	// val stages = HardwareConfig("stages")
	
	// val io = IO(new Bundle{ 
	// 	val in0 =  Vec(i_tilesize, new FP(prec1i, prec1f) ) 
	// 	val out0 = Vec(i_tilesize, new FP(prec_outi, prec_outf) ) 
		
	// 	val exit = new ExitIO()   
	// 	val entry = new EntryIO() 
	// })
	
	// // 1
	
	
	
	// val m = List.fill(i_tilesize)(  Module( PrimitiveFactory.CreateFixedPointIn1Out1(
	// 	"FixedPointTrigSin", 
	
	// 	Map(
	// 		"prec1i" -> prec1i.toString,
	// 		"prec1f" -> prec1f.toString,
	// 		"MultThroughput" -> MultThroughput.toString,
	// 		"MultDelay" -> MultDelay.toString,
	// 		"stages" -> stages.toString			
	// 	)
		
	// )  ))
	
	// // 2
	// for(i <- 0 until i_tilesize){
	// 	m(i).io.in0 := io.in0(i)
	// 	io.out0(i)  := m(i).io.out
	// }
	
	// // 3 
	// for(i <- 0 until i_tilesize){
	// 	m(i).io.exit.ready  := io.exit.ready
	// 	m(i).io.entry.valid := io.entry.valid
	// }
	
	// // 4
	// io.entry.ready := m(0).io.entry.ready //reduce
	// io.exit.valid  := m(0).io.exit.valid

}



