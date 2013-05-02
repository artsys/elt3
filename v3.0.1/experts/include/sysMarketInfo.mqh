/*
	>ver:0.0.1
	>date: 2012.08.28
	>history:
	>description:
*/

double MI_MarketOpenByCMD(int cmd, string sy = ""){
	/*
		>ver:0.0.0
		>date: 2012.07.18
		>history:
		>description:
			Возвращает рыночную цену для открытия заданного типа ордера.
	*/
	
	if(sy == ""){
		sy = Symbol();
	}
	
	//------------------------------------------------------
	if(cmd == OP_BUY){
		return(MarketInfo(sy, MODE_ASK));
	}
	
	//------------------------------------------------------
	if(cmd == OP_SELL){
		return(MarketInfo(sy, MODE_BID));
	}
}

double MI_MarketCloseByCMD(int cmd, string sy = ""){
	if(sy == ""){
		sy = Symbol();
	}
	
	//------------------------------------------------------
	if(cmd == OP_BUY){
		return(MarketInfo(sy, MODE_ASK));
	}
	
	//------------------------------------------------------
	if(cmd == OP_BUYSTOP){
		return(MarketInfo(sy, MODE_BID));
	}
	
	//------------------------------------------------------
	if(cmd == OP_SELL){
		return(MarketInfo(sy, MODE_BID));
	}
	
	//------------------------------------------------------
	if(cmd == OP_SELLSTOP){
		return(MarketInfo(sy, MODE_ASK));
	}
}