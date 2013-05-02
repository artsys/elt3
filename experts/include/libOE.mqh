	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	void OE.ClearHistory(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.14
		>Hist	:
			@0.0.1@2012.11.14@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	used if testing
	*/
	
		if(!IsTesting()){
			return;
		}
		
		//--------------------------------------------------
		if(OrdersTotal() <= 0){
			ArrayResize(libT.array_dExtraOrders, 0);
		}
	}