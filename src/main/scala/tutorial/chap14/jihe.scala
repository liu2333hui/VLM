package chap14


object jihe extends App {
	
	val charArray = Array('a', 'b', 'c')
	println(charArray(0))
	
	val intArray = new Array[Int](3)
	intArray(0) = 1
	intArray(1) = 2
	intArray(2) = 3
	
	
	val intList = List(1, 1, 10, -5)
	println(intList(0))
	println(intList(3))
	val l1 = 1 :: List(2, 3)
	val l2 = List(1,2) ::: List(2,1)
	println(l1(0))
	println(l2(0))
	
	val x = List(1)
	val y = 2 +: x
	val b = x :+ 2
	println(y(0))
	println(b(0))
	
	val n = 1 :: 2 :: 3 :: Nil
	println(n(0))
	
	val m = List(Array(1,2,3), Array(10,100,1000))
	println(m(0)(0))
	
	
	
	
	
	import scala.collection.mutable.{ArrayBuffer, ListBuffer}
	
	val ab = new ArrayBuffer[Int]()
	ab += 10
	-10 +=: ab
	ab -= -10
	
	val lb = new ListBuffer[String]()
	
	lb += "one"
	lb ++= Seq("Abc", "oops")
	lb -= "Abc"
	"scala" +=: lb
	
	
	lb.toArray
	lb.toList
	
	
	val t = ("G", "A", 233)
	println(t._1)
	println(t._2)
	for (item <- t.productIterator) {
			println("item = "+item)
	}
	
	val map = Map(1 -> "+", 2 -> "-")
	val tupleMap = Map(('j','y'), ('z', 'k'))
	println(tupleMap('j'))
	
	println(map.get(0))
	println(map.get(1))
	println(map.get(1).get)
	println(map.getOrElse(0, "moren"))
	
	for((k,v) <- map){
			println(k,v)
	}
	for(k <- map.keys){
			println(k)
	}
	for(v<-map.values){
			println(v)
	}
	for(item<-map){
			println(item._1, item._2)
	}
	
	
	val set = Set(1, 1, 10, 10, 233)
	println(set(100))
	println(set(233))
	
	
	
	
	val seq = Seq(1,2,3,4,5)
	println(seq(0))
	
	
	
	val mmm = Array("ping","cheng").map(_ + "s")
	val lll = List(1,2,3).map(_ * 2)
	for(mm<-mmm){
			println(mm)
	}
	for(ll<-lll){
			println(ll)
	}
	
	var sum = 0
	Set(1,-2,234).foreach(sum += _)
	println(sum)

	val zzz = List(1,2,3) zip Array("1", "2", "3")
	for(zz<-zzz){
			println(zz)
	}
	
	val r1 = (1 to 5).reduce(_ + _)
	val r2 = (1 to 5).reduceLeft(_ + _)
	val r3 = (1 to 5).reduceRight(_ + _)
	
	val f1 = (1 to 5).fold(10)(_ + _)
	val f2 = (1 to 5).foldLeft(10)(_ + _)
	val f3 = (1 to 5).foldRight(10)(_ + _)
	
	println(r1, r2, r3, f1, f2, f3)
	
	val s1 = (1 to 3).scan(10)(_ + _)
	val s2 = (1 to 3).scanLeft(10)(_ + _)
	val s3 = (1 to 3).scanRight(10)(_ + _)

	println(s1,s2,s3)
	println(zzz)
	println(lll)
	println(mmm)

	

}

