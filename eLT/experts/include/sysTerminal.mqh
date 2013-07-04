 	/*
		>Ver	:	0.0.0.18
		>Date	:	2013.05.20
		>Hist	:			
					@0.0.0.18@2013.05.20@artamir	[]	T_End
					@0.0.17@2013.02.15@artamir	[]	T_CurOPByIndex
					@0.0.16@2013.02.15@artamir	[]	T_OldOPByIndex
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
		>Pendings	:
					#include <sysArray.mqh>
	*/


//{	//=== ORDERS ARRAY	================================ 

#define	O_TI	0
#define	O_TY	1
#define	O_OP	2
#define	O_OT	3
#define	O_TP	5
#define	O_SL	6
#define	O_MN	7
#define O_LOT	8

#define	O_MAX	9

//----------------------------------------------------------
double	aCurOrders[][O_MAX];

//----------------------------------------------------------
double	aOldOrders[][O_MAX];
//}


int T_Start(){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.02
		>Hist	:
			@0.0.2@2012.10.02@artamir	[]
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	
	*/
	
	//------------------------------------------------------
	A_d_eraseArray2(aCurOrders);
	
	//------------------------------------------------------
	T_FillArrayCurOrders();
	
	//------------------------------------------------------
	E_Start();
}

int T_End(){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.05.20
		>Hist	:	
					@0.0.0.2@2013.05.20@artamir	[]	T_End
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Copying Cur orders to old orders.
	*/
	
	A_d_eraseArray2(aOldOrders);
	
	//------------------------------------------------------
	if(OrdersTotal() > 0){
		ArrayCopy(aOldOrders, aCurOrders, 0, 0, WHOLE_ARRAY);
	}	
}

//{	//=== PUBLIC FUNCTIONS	============================

int T_CurRows(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(ArrayRange(aCurOrders, 0));
}

int T_OldRows(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(ArrayRange(aOldOrders, 0));
}

//{	//=== GET FROM ARRAY	============================
//{	//====== CURRENT		============================

int T_CurTicketByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(aCurOrders[idx][O_TI]);
}

int T_CurIndexByTicket(int ticket){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = A_d_getIndexByProp2(aCurOrders, O_TI, ticket);
	
	//------------------------------------------------------
	return(idx);
}

int	T_CurTypeByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int	val = aCurOrders[idx][O_TY];
	
	//------------------------------------------------------
	return(val);
}

double T_CurOPByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.15
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double val = Norm_symb(aCurOrders[idx][O_OP]);
	
	//------------------------------------------------------
	return(val);
}

double T_CurSLByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.15
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double val = Norm_symb(aCurOrders[idx][O_SL]);
	
	//------------------------------------------------------
	return(val);
}

//}

//{	//====== OLD			============================

int T_OldTicketByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(aOldOrders[idx][O_TI]);
}

int T_OldIndexByTicket(int ticket){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.03
		>Hist	:
			@0.0.2@2012.10.03@artamir	[]
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = A_d_getIndexByProp2(aOldOrders, O_TI, ticket);
	
	//------------------------------------------------------
	return(idx);
}

int	T_OldTypeByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int	val = aOldOrders[idx][O_TY];
	
	//------------------------------------------------------
	return(val);
}

double T_OldOPByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.15
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double val = Norm_symb(aOldOrders[idx][O_OP]);
	
	//------------------------------------------------------
	return(val);
}

double T_OldSLByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.15
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double val = Norm_symb(aOldOrders[idx][O_SL]);
	
	//------------------------------------------------------
	return(val);
}

//}

//}

//{	//=== TRADING FUNCTIONS ============================

bool	T_SelOrderByIndex(int idx = 0){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	return true, if can select in trades orders
	*/
	
	//------------------------------------------------------
	return(OrderSelect(idx, SELECT_BY_POS, MODE_TRADES));
}

bool	T_SelOrderByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	return(OrderSelect(ti, SELECT_BY_TICKET));
}

//}

//}

//{	//=== PRIVATE FUNCTIONS	============================

//==========================================================
int T_FillArrayCurOrders(){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	«аполнение массива текущих ордеров.
			по текущей валютной паре
			«аполн€ютс€ только числовые данные.
	*///----------------------------------------------------	
	
	string fn = "T_FillArrayCurOrders";
	
	//------------------------------------------------------
	int t = OrdersTotal();
		
	//------------------------------------------------------
	for(int idx = 0; idx <= t; idx++){				
		
		//--------------------------------------------------
		if(!T_SelOrderByIndex(idx))	continue;
		
		//--------------------------------------------------
		if(OrderSymbol() != Symbol()) continue;
		
		//--------------------------------------------------
		T_FillRow();
	}
	
	//******************************************************
	//..	//*** DEBUGGING	********************************
	
	if(Debug){
		
		//--------------------------------------------------
		//A_d_PrintArray2(aCurOrders, 4, "CurOrders_FillArray");
		
	}
	
	//.
}

//==========================================================
int T_FillRow(){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	string fn = "T_FillRow";
	
	//------------------------------------------------------
	A_d_setArray(aCurOrders);	//setting temporar array to work with
	
	//------------------------------------------------------
	int idx = A_d_addRow();		//add new row to temporar array
	
	//------------------------------------------------------
	A_d_setPropByIndex(idx, O_TI, OrderTicket());			// set prop. by index in temporar array
	A_d_setPropByIndex(idx, O_TY, OrderType());
	A_d_setPropByIndex(idx, O_OP, OrderOpenPrice());
	A_d_setPropByIndex(idx, O_OT, OrderOpenTime());
	A_d_setPropByIndex(idx, O_TP, OrderTakeProfit());
	A_d_setPropByIndex(idx, O_SL, OrderStopLoss());
	A_d_setPropByIndex(idx, O_MN, OrderMagicNumber());
	
	//------------------------------------------------------
	A_d_releaseArray(aCurOrders);	// release temporar array and copy temporar array to 

	//------------------------------------------------------
	if(Debug && BP_Terminal){
		A_d_PrintArray2(aCurOrders, 4, fn);
	}
}
	
//}