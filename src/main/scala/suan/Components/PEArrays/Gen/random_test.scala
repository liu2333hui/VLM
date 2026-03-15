
package jiuzhang

import primitive._
import helper._

import chisel3._
import chisel3.stage.ChiselGeneratorAnnotation
import chisel3.experimental._
import chisel3.util._ 

import AutomatedArrays._


object fangtian33 extends App {

		def fang(cong:Int, guang:Int) = {
			
			(cong*guang, cong*guang/240)
		}
		println(fang(15,16))
		println(fang(12,14))
		
		def li(cong:Int, guang:Int) = {
			(cong*guang, cong*guang*375)
		}
		println(li(1,1))
		println(li(2,3))
		
		def yue(mu:Int, zi:Int) = {
			var yue:Int = 0
			var yue2:Int = 0
			if(mu > zi){
				yue = mu
				yue2 = zi
			}else{
				yue = zi
				yue2 = mu
			}
			while(yue != yue2){
				if(yue > yue2){
					yue=yue-yue2
				}else{
					yue2=yue2-yue
				}
			}
			(yue, mu/yue, zi/yue)
		}
		println(yue(18,12))
		println(yue(91,49))
	
		
		def 分( 母:Int, 子:Int) = new fen(母,子)
		class fen(val 母:Int, val 子:Int)
		
		def 合分( 分数 : List[fen]) = {
		   val 子 =	分数.map(_.子)
		   val 母 = 分数.map(_.母)
		   
		   
		   var 法 = 母.reduce(_ * _)
		   var 实 :Int = 0
		   for(数 <- 分数){
			   实 = 实 +  数.子 * 法 / 数.母 
			}
		   // val 母子 = 子.map(_ * 法)
		   // 法子 zip 母
		   // val 法子 = 子.map(_ * 法)
		   
		   val 数 :Int= 实/法
		   val 达姆 :Int= 法 
		   val 达子 :Int= 实 % 法 
		   
		   // ((数,达姆, 达子),yue( 达姆, 达子))
		   val 约 = yue( 达姆, 达子)
		   (数, 约._2, 约._3 )
		  
		}
		println(合分(List(  分(3,1), 分(5,2)  )))
		println(合分(List(  分(3,2), 分(7,4), 分(9,5)  )))
		println(合分(List(  分(2,1), 分(3,2), 分(4,3),分(5,4)  )))
		
		
		
		
		
		
		
}
