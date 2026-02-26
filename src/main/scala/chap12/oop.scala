package chap12

object oop extends App {

		class Students {
				var name = "None"
				def register(n:String) = {name = n}
		}
	
		val stu = new Students
		println(stu.name)
		stu.register("zhean")
		println(stu.name)
	
		
		class Students2(n:String) {
			var name = n
			println(s"register student $name")
			println(name)
			override def toString = "a student named " + name
		}
		val stu2 = new Students2("jiayu")
	
		println(stu2)
		
		
		class A {val a = "a multiple"}
		val x = new A
		println(x.a)
		
		object B {val b = "a singleton object" }
		println(B.b)
	
		def registerStu(name:String) = new Students2(name)
		val stu22 = registerStu("ye")
		println(stu22.name)
		
		class Students3(val name:String, var score:Int){
				def apply(s: Int) = score = s
				def display() = println("Current score is " + score + ".")
				override def toString = name + "'s score is " + score + "."
		}
		
		object Students2 {
			def apply(name:String, score:Int) = new Students3(name, score)
		}
		
		val stu3 = Students2("jie", 60)
		stu3(80)
		stu3.display()
		
		
		class MyInt(val x:Int){
			def unary_! = -x
			def unary_* = x * 2
		}
		
		val mi = new MyInt(10)
		println(!mi)
		println(mi.unary_*)

		class MyInt2(val x: Int){
				def +*(y: Int) = (x+y)*y
				def +:(y: Int) = x + y
				def :=(y: Int) = {y+x*2}
		}
		
		val mi2 = new MyInt2(10)
		println(mi2 +* 10)
		println(10 +: mi2)
		println(mi2 := 10)
		
		class MyInt3(val x: Int){
				def display() = println("the ")
		}
		
	
		
}


object inherit extends App {
		val a = List(1, 0, -1)
		val b = List(1, 0, -1)
		val c = List(1, 0, -1)
		val d = a
		println(a==c)
		println(a==b)
		println(a equals b)
		println(a eq b)
		println(a eq d)

		class A {
			val a = "Class A"
		}
		
		class B extends A {
			val b = "Class B inherits from A"
		}
		
		val x = new B
		println(x.a)
		println(x.b)
	
}

object inherit2 extends App {
	class A(val a :Int)
	
	class B(giveA: Int, val b: Int) extends A(giveA)
	
	val x = new B(10, 20)
	println(x.a)
	println(x.b)
}


object abs extends App {
	abstract class A{
			val a: Int
	}
	class B (val b:Int) extends A {
		val a= b*2
		}
	val y = new B(1)
	println(y.a)
	println(y.b)
}

object TRAIT extends App {
	class A {
		val a = "Class A"
	}
	trait B {
		val b = "Trait B"
	}
	trait C {
		def c = "Trait C"
	}
	object D extends A with B with C
	println(D.a, D.b, D.c)
	
	
}





