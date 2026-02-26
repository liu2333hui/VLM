//Generate Conditions
//Based on sparse mapping


//Phi(x) = (x == 0)
//-> 
//for(i <- 0 until N){
//	zeromap(i) = (x =/= 0)    
//}


//Phi(x) = (x > 0)
//-> 
//for(i <- 0 until N){
//	zeromap(i) = (x > 0)    
//}

//Phi(x) = (x == 0)
//-> 
//for(i <- 0 until N){
//	zeromap(i) = (x =/= 0)    
//}

//Phi(x) = (x < 0)
//-> 
//for(i <- 0 until N){
//	zeromap(i) = (x < 0)    
//}

//Phi(x) = (x == 0) && (w == 0)
//-> 
//for(i <- 0 until N){
//	zeromap(i) = (x === 0) && (w === 0)    
//}

//Phi(x) = (  Avg(x) < delta)
//-> 
//for(ii <- 0 until II by I)
//	zeromap(i) = (x.reduce(_ + _) < delta)    
//}




