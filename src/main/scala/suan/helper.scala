package helper

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._
	
import java.io.PrintWriter
import scala.io.Source
import scala.util.matching.Regex
import scala.sys.process._
object sim{
	
	
def get_meta(filename:String, id:Int, signed_logic:Seq[String]) : Map[String,String] = {
	// 读取文件内容
	  val lines = Source.fromFile(filename).getLines().mkString("\n")
	  // println(lines)
	  
	  var sslines:Array[String] = lines.split("endmodule\n")
	  // print(sslines)
	  print(sslines.length)
	  if(sslines.length == 1){
		  sslines = sslines(0).split("\n")
	  }
	  else{
		  sslines = sslines(sslines.length-1).split("\n")
	  }
	  // println(sslines(1))
	  val slines = sslines//.split("\n")
	  var l = ""
	  var idx = 0
	  
	  var mod = ""
	  
	  var ioports = List[String]()
	  var portname = List[String]()
	  // var ports_len = 
	  
	  while(!(");" == l)){
		  l = slines(idx)
		  val sl = l.trim.split(" ")
		  // println(sl)
		  if("module" == sl(0)){
			mod = sl(1).replace("(","")//(0,length(sl(1))-1)//.split("(")(0)
		  }else if("input" == sl(0) || "output" == sl(0)){
			  // println(l.trim.split(sl(0))(1).replace(",",""))
			  ioports = ioports ++ List(l.trim.split(sl(0))(1).replace(",",""))
			  val ll = ioports(idx-1).split(" ")
			  // println(String(ll))
			  portname = portname ++ List( ll(ll.length - 1)  )
		  }
		  idx+=1
	  }
	
	var ports = ""
	var iii = 0
	for(p <- ioports){//logic
		// println(p+ portname(iii))
		if(signed_logic.contains(portname(iii))){
			ports = ports + " bit signed " + p + " ;\n"
		}else{
			ports = ports + " bit " + p + " ;\n"
		}
		iii += 1
	}
	
	var instance = ""
	for(n <- 0 until portname.length){
		instance = instance + "  " + portname(n)
		if(n < portname.length -1){
			
			instance = instance +  " ,\n"
		}
		
	}
	
	val modualized = s"""

		$mod $mod$id(
		   $instance
		);
	"""
		
	Map[String,String]("ports"->ports, "modualized"->modualized)
}
	
def iverilog( svtb:String,  svtbfile:String,  svfiles: Seq[String] , extra_top_instance: Seq[Int]
 =Seq(), svtbfile_tasks :String = "",
	signed_logic:Seq[String] = Seq(""),
	simtime:Int=10000,
	macros:Seq[String] = Seq("")) {
	val writer = new PrintWriter(svtbfile) //"./generated/Block/FixedBlockTb.sv")
	
	////////////////////////////////////////////////////////////////////////////
	
	  // 输入的 Verilog 文件路径
	  val filename = svfiles(0) //get first file, assume is top
	
	 val topres =   get_meta(filename, 0, signed_logic)
	  val topports = topres("ports")
	  val topmodualized = topres("modualized")
	
	
	var extramodual = ""
	
	for (e <- extra_top_instance){
		val res = get_meta(svfiles(e), e, signed_logic)
		extramodual += res("modualized")
	}
	
	val testbench = s""" module tb();
	
	$topports
	
	$topmodualized
	
	$extramodual
	
	initial begin
	forever #5  clock = ~clock;
	end
	
	$svtbfile_tasks
	
	//Maximum limit
	initial begin
		#"""+simtime+""";
		$finish;
	end
	
	task automatic Reset();
	        begin
				reset = 0;
				#10;
				reset = 1;
				#15;
				reset = 0;
			end
	    endtask
		
	initial begin
	"""+"""$dumpfile("./sim.vcd");
	"""+"""$dumpvars(0);
	end"""
	
	  //println(testbench)
	
	  
	var tb =  "\n"+ testbench + svtb + "\n\nendmodule\n"
	
	writer.print(tb)
	writer.close()
	
	var process = Seq("iverilog")
	if(macros(0) == ""){
		process = process ++ Seq("-g2005-sv", svtbfile ) ++ svfiles
	}else{
		process = Seq("iverilog") ++ macros ++ Seq("-g2005-sv", svtbfile ) ++ svfiles
	} 

		// "./generated/Block/FixedBlock.v", "./generated/Block/FixedBlockTb.sv") // 命令名 + 参数列表
	val process2 = Seq("vvp","a.out") // 命令名 + 参数列表
	println(process)
	var compileResult =	process.!
	println("Run iverilog status - " + compileResult)
	compileResult =	process2.!
	println("Run vvd generate vcd status - "+compileResult)
	
}

}



	// println(mod)
	 //  println(ioports)
	 //  println(portname)
	  
	//   val moduleRegex = """module\s+(\w+)\s*[^)]*;(.+?)endmodule""".r
	//   val portDeclarationsRegex = """(?i)(input|output|inout)\s+([^;]+);""".r
	
	//   // 提取模块名和主体
	//   val moduleMatch = moduleRegex.findFirstMatchIn(lines)
	//   if (moduleMatch.isEmpty) {
	//     println("Error: Could not find module definition.")
	//     // sys.exit(1)
	//   }
	
	//   val moduleName = moduleMatch.get.group(1)
	//   val moduleBody = moduleMatch.get.group(2)
	
	//   // 存储端口信息
	//   case class Port(dir: String, width: String, name: String)
	
	//   val ports = scala.collection.mutable.ListBuffer[Port]()
	
	//   // 解析每个端口声明
	//   val portRegex = """(?i)(input|output|inout)\s+((?:  $ \s*\d+\s*:\s*\d+\s* $  )?)\s*(\w+)""".r
	//   portRegex.findAllMatchIn(moduleBody).foreach { m =>
	//     val dir = m.group(1).toLowerCase
	//     val width = m.group(2).trim
	//     val name = m.group(3).trim
	//     ports += Port(dir, width, name)
	//   }
	
	//   // 添加额外信号（如 io_enable），如果原模块没有
	//   // 注意：你示例中出现了 io_enable，但原模块没有，这里手动添加
	//   // val extraSignal = "io_enable"
	//   // if (!ports.exists(_.name == extraSignal)) {
	//   //   ports += Port("input", "", extraSignal)
	//   // }
	
	//   // 生成信号声明
	//   def genDeclaration(port: Port): String = {
	//     val widthStr = if (port.width.nonEmpty) s"  $port.width" else ""
	//     val typ = if (port.name == "clock") "bit" else "logic"
	//     s"bit  $widthStr  ${port.name};"
	//   }
	
	//   val declarations = ports.map(genDeclaration).mkString("\n\t\t\t")
	
	//   // 生成实例化列表
	//   val instancePorts = ports.map(p => s"\t\t\t ${p.name}").mkString(",\n")
	
	//   // 生成模块实例化
	//   val instance = s""" ${moduleName} dut(
	//  ${instancePorts}
	// \t\t);"""
	
	//   // 生成时钟和波形 dump
	//   val clockName = ports.find(p => p.name == "clock").map(_.name).getOrElse("clock")
	
	
	// println(tb)
	//   """
	//   	module tb();
		
	// 	bit clock;
	// 	bit reset;
	// 	logic io_out_ready;
	// 	logic io_out_valid;
	// 	logic io_out_bits;
	// 	logic io_in_ready;
	// 	logic io_in_valid;
	// 	logic io_in_bits;
		
	//   	FixedBlock dut(
	// 		clock,
	// 		reset,
	// 		io_out_ready,
	// 		io_out_valid,
	// 		io_out_bits,
	// 		io_in_ready,
	// 		io_in_valid,
	// 		io_in_bits
	//   	);
		
	// 	initial begin
	// 		forever #5 clock = ~clock;
	// 	end
		
	// 	initial begin
	// 		$dumpfile("./sim.vcd");
	// 		$dumpvars(0);
	// 	end
		
	// 	initial begin
	// 		reset = 1;
	// 		io_in_valid = 0;
	// 		#10;
	// 		reset = 0;
	// 		#10;
	// 		reset = 1;
	// 		io_in_valid = 1;
	// 		//@(posedge io_out_valid);
	// 		#50;
	// 		io_in_valid = 0;
	// 		#10;
	// 		io_in_valid = 0;
	// 		#10;
	// 		io_in_valid = 0;
	// 		#10;
	// 		io_in_valid = 1;
	// 		#80;
			
	// 		$finish;
			
	// 	end
		
	// 	endmodule
	//   """
	
	