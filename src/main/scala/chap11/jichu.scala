package chap11

object jichu extends App {

	val x = 1
	var y = 2
	val msg = "Hello, World!"
	
	println(x   )
	println(y   )
	println(msg)
	
	// y = "abc"
	
	println(y)
	
	val t0 : Int = 123
	val t1 : String = "123"
	val t2 : Double = 1.2
	
	val t3 = 200L
	
	val a = 1.2E3
	val b = -3.2f
	val c :Float = -3.2F
	
	val s0 = 'D'
	val s1 = '\u0042'

	println(s"$s0")
	println(s"Sum = ${1+10}")
	
	def add(x:Int, y:Int) = {x + y}
	println(add(1,2))
	
	val f = (_:Int) + (_:Int)
	println(f(1,2))
	
	
	val add = (x: Int) => { (y:Int) => x + y}
	println(add(1)(10))
	
	
	
	
}

