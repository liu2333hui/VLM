package chap15


object kongzhi extends App {

		def whichInt(x:Int) = {
				if(x == 0) "Zero"
				else if(x >0) "zheng"
				else "fu"
		}
		
		println(whichInt(-1))
		
		def fac_loop(num:Int) : Int = {
				var res: Int = 1
				var num1:Int = num
				while(num1 != 0) {
					res = res * num1
					num1 = num1 - 1
				}
				res
		}
		
		println(fac_loop(6))
		
		def fac(num:Int):Int = 
			if(num == 1) 1 else num*fac(num-1)
			
		println(fac(6))
		
		class Person(val name: String)
		object yuanchun extends Person("Yuanchun")
		object yingchun extends Person("Yingchun")
		object tanchun extends Person("Tanchun")
		object xichun extends Person("xichun")
		
		val persons = List(yuanchun, yingchun, tanchun, xichun)
		
		val To = for {
				p <- persons
				n = p.name
				if(n startsWith "tan")
		} yield n
	
		println(To)
		
		for {
			i <- 1 to 9
			j <- 1 to 9
		} yield i * j
		
		def something(x:String) = x match {
			case "Apple" => println("Fruit!")
			case "Tomato" => println("Vegetable")
			case "Cola" => println("Beverage!")
			case _ => println("Huh?")
		}
		
		println(something("Cola"))
		println(something("Toy") )
		
		var i = 1
		var sum = 0
		var end_flag = false
		while (i <= 1000 && !end_flag) {
			if(i > 100){
					end_flag = true
			}
			if( !(i%3==0) || (i%5==0) || (i%7==0)){
					sum = sum + i
			}
			else if (i % (3 * 5 * 7) == 0){
					end_flag = true
			}
				i = i + 1
		}
		
		println(sum)
		println(i)
		
}