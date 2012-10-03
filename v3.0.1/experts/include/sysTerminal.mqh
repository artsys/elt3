	/*
		>Ver	:	0.0.13
		>Date	:	2012.10.03
		>Hist	:
			@0.0.13@2012.10.03@artamir	[]
			@0.0.12@2012.10.03@artamir	[]
			@0.0.11@2012.10.03@artamir	[]
			@0.0.10@2012.10.03@artamir	[]
			@0.0.9@2012.10.03@artamir	[]
			@0.0.8@2012.10.02@artamir	[]
			@0.0.7@2012.10.02@artamir	[]
			@0.0.6@2012.10.02@artamir	[]
			@0.0.5@2012.10.02@artamir	[]
			@0.0.4@2012.10.02@artamir	[]
			@0.0.3@2012.10.02@artamir	[]
			@0.0.2@2012.10.02@artamir	[]
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
		>Pendings	:
					#include <sysArray.mqh>
	*/

//==========================================================
//..	//=== ORDERS ARRAY	================================ 

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
//.
	
//==========================================================
int T.Start(){//..
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
	A.d.eraseArray2(aCurOrders);
	
	//------------------------------------------------------
	T.FillArrayCurOrders();
	
	//------------------------------------------------------
	E.Start();
}//.

//==========================================================
int T.End(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Copying Cur orders to old orders.
	*/
	
	A.d.eraseArray2(aOldOrders);
	
	//------------------------------------------------------
	ArrayCopy(aOldOrders, aCurOrders, 0, 0, WHOLE_ARRAY);
}//.

//==========================================================
//..	//=== PUBLIC FUNCTIONS	============================

int T.CurRows(){//..
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
}//.--------------------------------------------------------

int T.OldRows(){//..
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
}//.--------------------------------------------------------

//..	//=== GET FROM ARRAY	============================

//..	//====== CURRENT		============================

int T.CurTicketByIndex(int idx = 0){//..
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
}//.--------------------------------------------------------

int T.CurIndexByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = A.d.getIndexByProp2(aCurOrders, O_TI, ticket);
	
	//------------------------------------------------------
	return(idx);
}//.--------------------------------------------------------

int	T.CurTypeByIndex(int idx = 0){//..
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
}//.--------------------------------------------------------

//.---------------------------------------------------------

//..	//====== OLD			============================

int T.OldTicketByIndex(int idx = 0){//..
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
}//.--------------------------------------------------------

int T.OldIndexByTicket(int ticket){//..
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
	int idx = A.d.getIndexByProp2(aOldOrders, O_TI, ticket);
	
	//------------------------------------------------------
	return(idx);
}//.--------------------------------------------------------

int	T.OldTypeByIndex(int idx = 0){//..
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
}//.--------------------------------------------------------

//.---------------------------------------------------------

//.---------------------------------------------------------

//..	//=== TRADING FUNCTIONS ============================

//==========================================================
bool	T.SelOrderByIndex(int idx = 0){//..
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
}//.

//.

//.---------------------------------------------------------

//..	//=== PRIVATE FUNCTIONS	============================
	
//==========================================================
int T.FillArrayCurOrders(){//..
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	«аполнение массива текущих ордеров.
			по текущей валютной паре
			«аполн€ютс€ только числовые данные.
	*///----------------------------------------------------	
	
	string fn = "T.FillArrayCurOrders";
	
	//------------------------------------------------------
	int t = OrdersTotal();
		
	//------------------------------------------------------
	for(int idx = 0; idx <= t; idx++){//..					
		
		//--------------------------------------------------
		if(!T.SelOrderByIndex(idx))	continue;
		
		//--------------------------------------------------
		if(OrderSymbol() != Symbol()) continue;
		
		//--------------------------------------------------
		T.FillRow();
	}//.
	
	//******************************************************
	//..	//*** DEBUGGING	********************************
	
	if(Debug){//..
		
		//--------------------------------------------------
		//A.d.PrintArray2(aCurOrders, 4, "CurOrders_FillArray");
		
	}//.
	
	//.
}//.

//==========================================================
int T.FillRow(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.02
		>Hist	:
			@0.0.1@2012.10.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	string fn = "T.FillRow";
	
	//------------------------------------------------------
	A.d.setArray(aCurOrders);	//setting temporar array to work with
	
	//------------------------------------------------------
	int idx = A.d.addRow();		//add new row to temporar array
	
	//------------------------------------------------------
	A.d.setPropByIndex(idx, O_TI, OrderTicket());			// set prop. by index in temporar array
	A.d.setPropByIndex(idx, O_TY, OrderType());
	A.d.setPropByIndex(idx, O_OP, OrderOpenPrice());
	A.d.setPropByIndex(idx, O_OT, OrderOpenTime());
	A.d.setPropByIndex(idx, O_TP, OrderTakeProfit());
	A.d.setPropByIndex(idx, O_SL, OrderStopLoss());
	A.d.setPropByIndex(idx, O_MN, OrderMagicNumber());
	
	//------------------------------------------------------
	A.d.releaseArray(aCurOrders);	// release temporar array and copy temporar array to 

	//------------------------------------------------------
	if(Debug){//..
		//A.d.PrintArray2(aCurOrders, 4, fn);
	}//.
}//.
	
//.