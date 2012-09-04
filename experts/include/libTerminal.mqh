/*
		>Ver	:	0.0.16
		>Date	:	2012.08.29
		>Hist:
			@0.0.15@2012.08.29@artamir	[+] info about order lot.
			@0.0.12@2012.08.28@artamir	[+] add some function in extra array block
			@0.0.10@2012.08.13@artamir	[+] Блок установочных функций для экстра массива.
			@0.0.9@2012.08.13@artamir	[+] libT.getCurOPByTicket(), libT.getCurTypeByTicket()
			@0.0.8@2012.08.13@artamir	[+] libT.getExtraMAINPARENTByTicket()
			@0.0.7@2012.08.10@artamir	[+] libT.getOldIndexByTicket()
			@0.0.5@2012.08.10@artamir	[+] libT.End()
			@0.0.4@2012.08.08@artamir	[*] Изменил максимальную размерность массивов
			@0.0.2@2012.08.08@artamir	[*] libT.FillArrayCurOrders()
			@0.0.1@2012.08.08@artamir	[+] libT.FillArrayRowWithSelOrder()
		>Descr:
			Библиотека работы с массивами ордеров.
		>Зависимости:
			#include <libArray.mqh>
			#include <libEvents.mqh>
*/

//.. //=== Global variables
	//.. //=== arrays
	#define	libT.O_TI		1	//Ticket
	#define	libT.O_OP		2	//OpenPrice
	#define	libT.O_SL		3	//Stoploss
	#define	libT.O_TP		4	//Takeprofit
	#define	libT.O_TY		5	//Type
	#define	libT.O_LO		6	//Lot
	#define	libT.O_MN		7	//Magic
	#define	libT.O_HASH		8	//Hash
	#define libT.O_COMM		9	//Comment
	#define	libT.O_WASTY	11	//Initial type.
	#define	libT.O_SY		12	//Symbol
	#define	libT.O_MAX		13	//Max count of column, to initialize in array of orders
	//------------------------------------------------------
	// Arrays of current orders.
	double libT.array_dCurOrders[][libT.O_MAX];
	string libT.array_sCurOrders[][libT.O_MAX];
	//------------------------------------------------------
	// arrays of orders on prev. tick
	double libT.array_dOldOrders[][libT.O_MAX];
	string libT.array_sOldOrders[][libT.O_MAX];
	//------------------------------------------------------
	// Extra order description (Order Extra)
	#define	libT.OE_TI			1							//Ticket
	#define	libT.OE_OP			2							//Open price
	#define	libT.OE_MN			3							//Magic number
	#define	libT.OE_TY			4							//Type
	#define libT.OE_LOT			5							//Lot
	#define	libT.OE_WASTY		6							//first sending type
	#define	libT.OE_MAINPARENT	7							//Ticket of main parent
	#define	libT.OE_PARENT		8							//Ticket of current parent
	#define	libT.OE_GRIDTYPE	9							//Type of grid
	#define libT.OE_ISPARENT	10							//=1 if is parent order
	#define libT.OE_ISCLOSED	11							//flag = 1 if order is closed.
	#define libT.OE_AOM			12							//ID of autoopen method. Inherited from MAINPARENT
	#define	libT.OE_MAX			13							//Count of properties.
	//------------------------------------------------------
	double libT.array_dExtraOrders[][libT.OE_MAX];
	//.
//.

//==================================================================================================
int	libT.CurTicketByIndex(int idx = 0){//..
	return(libT.array_dCurOrders[idx][libT.O_TI]);
}//.

//==================================================================================================
int	libT.OldTicketByIndex(int idx = 0){//..
	return(libT.array_dOldOrders[idx][libT.O_TI]);
}//.

//..	//=== ORDER TYPE ===================================
//==========================================================
int libT.CurTypeByIndex(int idx = 0){//..
	return(libT.array_dCurOrders[idx][libT.O_TY]);
}//.

//==========================================================
int libT.OldTypeByIndex(int idx = 0){//..
	return(libT.array_dOldOrders[idx][libT.O_TY]);
}//.

//==========================================================
int libT.getCurTypeByTicket(int ticket){//..
	int idx = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	return(libT.CurTypeByIndex(idx));
}//.

//==========================================================
int libT.isMarketCurTicket(int ticket){//..
	int thisType = libT.getCurTypeByTicket(ticket);
	
	//------------------------------------------------------
	if(thisType == OP_BUY || thisType == OP_SELL){//..
		return(1);
	}else{
		return(0);
	}//.
}//.
//.

//..	//=== OPEN PRICE ===================================
//==========================================================
double libT.CurOPByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dCurOrders[idx][libT.O_OP]));
}//.

//==========================================================
double libT.OldOPByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dOldOrders[idx][libT.O_OP]));
}//.

//==========================================================
double libT.getCurOPByTicket(int ticket){//..
	int idx = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	return(libNormalize.Digits(libT.CurOPByIndex(idx)));
}//.

//.

//..	//=== SL	========================================
//==========================================================
double libT.CurSLByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dCurOrders[idx][libT.O_SL]));
}//.

//==================================================================================================
double libT.OldSLByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dOldOrders[idx][libT.O_SL]));
}//.

//==========================================================
double libT.CurSLByTicket(int ticket){//..
	int index = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	double sl = libT.CurSLByIndex(index);
	
	//------------------------------------------------------
	return(sl);
}//.
//.

//..	//=== TP	========================================
//==========================================================
double libT.CurTPByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dCurOrders[idx][libT.O_TP]));
}//.

//==========================================================
double libT.OldTPByIndex(int idx = 0){//..
	return(libNormalize.Digits(libT.array_dOldOrders[idx][libT.O_TP]));
}//.

//==========================================================
double libT.CurTPByTicket(int ticket){//..
	int index = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	double tp = libT.CurTPByIndex(index);
	
	//------------------------------------------------------
	return(tp);
}//.
//.

//..	//=== MN	========================================

//==========================================================
int libT.CurMNByIndex(int idx = 0){//..
	return(libT.array_dCurOrders[idx][libT.O_MN]);
}//.

//==========================================================
int libT.CurMNByTicket(int ticket){//..
	int index = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	int mn = libT.CurMNByIndex(index);
	
	//------------------------------------------------------
	return(mn);
}//.
//.

//..	//=== Lot	========================================
//==========================================================
double libT.CurLotByIndex(int idx = 0){//..
	return(libT.array_dCurOrders[idx][libT.O_LO]);
}//.

//==========================================================
double libT.getCurLotByTicket(int ticket){//..
	int index = libT.getCurIndexByTicket(ticket);
	
	//------------------------------------------------------
	double lot = libT.CurLotByIndex(index);
	
	//------------------------------------------------------
	return(lot);
}//.
//.

//==================================================================================================
int libT.getOldIndexByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			return index by ticket from old array of orders.
	*/
	
	int MAX = ArrayRange(libT.array_dOldOrders, 0); 		//Count of ROWS
	int res = -1;											//Initial value
	
	//==============================================================================================
	for(int idx = 0; idx < MAX; idx++){
		if(res >= 0) continue;								//if we find ticket
	
		int OldTicket = libT.OldTicketByIndex(idx);			//get ticket by index.
		
		//------------------------------------------------------------------------------------------
		if(OldTicket != ticket) continue;
		
		//------------------------------------------------------------------------------------------
		res = idx;
	}
	
	//----------------------------------------------------------------------------------------------
	return(res);
}//.

//==================================================================================================
int libT.getCurIndexByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Возвращает индекс из текущего массива по тикету.
	*/
	
	int MAX = ArrayRange(libT.array_dCurOrders, 0); 		//Текущее количество строк в массиве
	int res = -1;											//Значение, возвращаемое по умолчанию
	
	//==============================================================================================
	for(int idx = 0; idx < MAX; idx++){
		if(res >= 0) continue;								//если мы уже нашли нужный тикет
	
		int OldTicket = libT.CurTicketByIndex(idx);			//Получаем значение тикета по индексу.
		
		//------------------------------------------------------------------------------------------
		if(OldTicket != ticket) continue;
		
		//------------------------------------------------------------------------------------------
		res = idx;
	}
	
	//----------------------------------------------------------------------------------------------
	return(res);
}//.

//.. //=== EXTRA ARRAY =============================================================================

//.. 	//=== GET ==========================================

//==========================================================
double libT.getExtraPropByIndex(int Index = 0, int Prop = 1){//..
	double val = libT.array_dExtraOrders[Index][Prop];
	
	//------------------------------------------------------
	return(val);
}//.

//==================================================================================================
int libT.getExtraTicketByIndex(int idx){//..
	return(libT.array_dExtraOrders[idx][libT.OE_TI]);
}//.

//==================================================================================================
int libT.getExtraIndexByTicket(int ticket, int flAddIfNotFind = 0){//..
	/*
		>Ver	:	0.0.0
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Возвращает индекс из экстра массива по тикету.
		>VARS:
			flAddIfNotFind = 1 : флаг установки нового элемента. (1-установить, 0-не устанавливать)
	*/
	
	int	ROWS	= ArrayRange(libT.array_dExtraOrders, 0);	//Получили количество строк в экстра массиве
	
	//------------------------------------------------------
	bool	isFind		= false;
	int		idx_find	= -1;
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){//..
		
		//--------------------------------------------------
		if(isFind){
			continue;
		}
		
		//--------------------------------------------------
		if(libT.getExtraTicketByIndex(idx) == ticket){
			isFind = true;
			idx_find = idx;
		}
	}//.
	
	//------------------------------------------------------
	if(!isFind && flAddIfNotFind == 1){						//Если не нашли тикет в экстра массиве
		idx_find = libT.addExtraTicket(ticket);
		libT.setExtraStandartData(ticket);
	}
	
	//------------------------------------------------------
	return(idx_find);
}//.

//==================================================================================================
int	libT.getExtraMAINPARENTByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.13
		>Hist:
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Возвращает MAINPARENT из экстра массива по тикету.
	*/
	
	int	idx	=	libT.getExtraIndexByTicket(ticket, 1);			//Получаем индекс по тикету экстра массива.
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}else{
		return(libT.getExtraPropByIndex(idx, libT.OE_MAINPARENT));
	}
	
}//.

//==================================================================================================
int	libT.getExtraPARENTByTicket(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.13
		>Hist:
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Возвращает MAINPARENT из экстра массива по тикету.
	*/
	
	int	idx	=	libT.getExtraIndexByTicket(ticket, 1);			//Получаем индекс по тикету экстра массива.
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}else{
		return(libT.getExtraPropByIndex(idx, libT.OE_PARENT));
	}
	
}//.

//==========================================================
int libT.getCountOrdersByParent(int ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.13
		>Hist:
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			return count of orders, which has propertie 
			PARENT = ticket
	*/
	
	int f.COL = libT.OE_PARENT;								//Number of column which store property PARENT
	int f.MAX = ticket;
	int f.MIN = ticket;
	
	//------------------------------------------------------//set filter
	libA.double_eraseFilter2();
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];								// create array with number of colums equal with array of extra order information
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//return array of selected rows by filter.
	
	//------------------------------------------------------
	return (ArrayRange(d, 0));								//Number of ROWS in array d[][]
}//.

//==========================================================
int libT.getTicketByParentAndIndex(int parent, int index){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.28
		>Hist:
			@0.0.2@2012.08.28@artamir	[]
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			return ticket of order by parent ticket and index in result array
	*/
	int f.COL = libT.OE_PARENT;								//Number of column which store property PARENT
	int f.MAX = parent;
	int f.MIN = parent;
	
	//------------------------------------------------------//set filter
	libA.double_eraseFilter2();
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];								// create array with number of colums equal with array of extra order information
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//return array of selected rows by filter.
	
	//------------------------------------------------------
	return (d[index][libT.OE_TI]);							//Number of ROWS in array d[][]
	
}//.

//==========================================================
int libT.getIsParentByIndex(int index){//..
	return(libT.getExtraPropByIndex(index, libT.OE_ISPARENT));
}//.

//==========================================================
int libT.getIsParentByTicket(int ticket){//.. 
	int idx = libT.getExtraIndexByTicket(ticket);
	
	//------------------------------------------------------
	return(libT.getExtraPropByIndex(idx, libT.OE_ISPARENT));
}//.

//==========================================================
int libT.getCountOrdersByGT(int GT){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.13
		>Hist:
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			return count of orders, which has propertie 
			GridType = GT
	*/
	
	int f.COL = libT.OE_GRIDTYPE;							//Number of column which store property PARENT
	int f.MAX = GT;
	int f.MIN = GT;
	
	//------------------------------------------------------//set filter
	libA.double_eraseFilter2();
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];								// create array with number of colums equal with array of extra order information
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//return array of selected rows by filter.
	
	//------------------------------------------------------
	return (ArrayRange(d, 0));								//Number of ROWS in array d[][]
}//.

//==========================================================
int libT.getTicketByGTAndIndex(int GT, int index){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.28
		>Hist:
			@0.0.2@2012.08.28@artamir	[]
			@0.0.1@2012.08.13@artamir	[]
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			return ticket of order by parent ticket and index in result array
	*/
	int f.COL = libT.OE_GRIDTYPE;							//Number of column which store property GridType
	int f.MAX = GT;
	int f.MIN = GT;
	
	//------------------------------------------------------//set filter
	libA.double_eraseFilter2();
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];								// create array with number of colums equal with array of extra order information
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//return array of selected rows by filter.
	
	//------------------------------------------------------
	return (d[index][libT.OE_TI]);							//Number of ROWS in array d[][]
	
}//.


//==========================================================
int libT.SelectExtraParents(double& d[][]){//..
	libA.double_eraseFilter2();
	
	//--- Select if IsParent = 1 ---------------------------
	int f.COL = libT.OE_ISPARENT;
	int f.MAX = 1;
	int f.MIN = 1;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//--- OR
	//--- Select if Parent <= 0 ---------------------------
	f.COL = libT.OE_PARENT;
	f.MAX = 0;
	f.MIN = -1;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d, libA.SOP.OR);
}//.

//==========================================================
double libT.getExtraLotByTicket(int ticket){//..
	int idx = libT.getExtraIndexByTicket(ticket);
	
	//------------------------------------------------------
	return(libT.getExtraPropByIndex(idx, libT.OE_LOT));
}//.

//==========================================================
int libT.getExtraTypeByTicket(int ticket){//..
	
	//------------------------------------------------------
	int idx = libT.getExtraIndexByTicket(ticket);
	
	//------------------------------------------------------
	int type = libT.getExtraPropByIndex(idx, libT.OE_TY);
	
	//------------------------------------------------------
	return(type);
}//.

//==========================================================
double libT.getExtraOPByTicket(int ticket){//..
	
	//------------------------------------------------------
	int idx = libT.getExtraIndexByTicket(ticket);
	
	//------------------------------------------------------
	double op = libT.getExtraPropByIndex(idx, libT.OE_OP);
	
	//------------------------------------------------------
	return(op);
}//.

//.

//..	//=== SET ==========================================

//==========================================================
int libT.addExtraTicket(int ticket){//..
	/*
		>Ver	:	0.0.0
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Добавляет новую строку в экстра массив с заданным тикетом
			Возвращает индекс добавленной строки.
	*/
	
	int ROWS	=	ArrayRange(libT.array_dExtraOrders, 0);	//Получаем количество строк в экстра массиве.
	int	thisIDX	=	ROWS;
	
	//------------------------------------------------------
	ArrayResize(libT.array_dExtraOrders, (ROWS+1));			//Увеличили количество строк
	
	//------------------------------------------------------
	libT.array_dExtraOrders[thisIDX][libT.OE_TI] = ticket;	//Задали тикет.
	
	//------------------------------------------------------
	return(thisIDX);										// Вернули индекс нового элемента.	
}//.

//==========================================================
int libT.setExtraPropByIndex(int IDX, int PROP, double VAL){//..
	libT.array_dExtraOrders[IDX][PROP] = VAL;
}//.

//==========================================================
int libT.setExtraMAINPARENTByIndex(int idx, int mainparent = -1){//..
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	if(mainparent <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	libT.setExtraPropByIndex(idx, libT.OE_MAINPARENT, mainparent);
}//.

//==========================================================
int libT.setExtraPARENTByIndex(int idx, int parent = -1){//..
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	if(parent <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	libT.setExtraPropByIndex(idx, libT.OE_PARENT, parent);
}//.

//==========================================================
int libT.setExtraGridTypeByIndex(int idx, int GT = -1){//..
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	if(GT <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	libT.setExtraPropByIndex(idx, libT.OE_GRIDTYPE, GT);
}//.

//==========================================================
int libT.setExtraIsParentByIndex(int idx, int IsParent = 0){//..
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	if(IsParent <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	libT.setExtraPropByIndex(idx, libT.OE_ISPARENT, IsParent);
}//.

//==========================================================
int libT.setExtraIsClosedByTicket(int ticket){//..
	int idx = libT.getExtraIndexByTicket(ticket);
	
	libT.setExtraPropByIndex(idx, libT.OE_ISCLOSED, 1);
}//.

//==========================================================
int libT.setExtraStandartData(int ticket){//..
	
	//------------------------------------------------------
	int idx = libT.getExtraIndexByTicket(ticket, 1);
	
	//------------------------------------------------------
	int		type	= libT.getCurTypeByTicket(ticket);
	int		mn		= libT.CurMNByTicket(ticket);
	double	op		= libT.getCurOPByTicket(ticket);
	double	lot		= libT.getCurLotByTicket(ticket);
	
	//------------------------------------------------------
	libT.setExtraPropByIndex(idx, libT.OE_TY, type);
	libT.setExtraPropByIndex(idx, libT.OE_MN, mn);
	libT.setExtraPropByIndex(idx, libT.OE_OP, op);
	libT.setExtraPropByIndex(idx, libT.OE_LOT, lot);
	
}//.
//.

//.

//==================================================================================================
bool libT.OrderSelectByIndex(int idx = 0){//..
	return(OrderSelect(idx, SELECT_BY_POS, MODE_TRADES));
}//.

//==================================================================================================
void libT.Start(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.08
			>Hist:
			@0.0.1@2012.08.08@artamir	[]
			>Descr:
				Функция менеджер модуля
	*/	
		
	//----------------------------------------------------------------------------------------------
	libT.FillArrayCurOrders();
	
	//----------------------------------------------------------------------------------------------
	//Events
	libE.Start();
	
	//----------------------------------------------------------------------------------------------
	//End
	//libT.End();
}//.

//==================================================================================================
void libT.FillArrayCurOrders(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.08
		>Hist:
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Заполнение массива текущих ордеров.
	*/
	
	//----------------------------------------------------------------------------------------------
	libA.double_eraseArray2(libT.array_dCurOrders);
	
	//---------------------------------------------
	libA.string_eraseArray2(libT.array_sCurOrders);
	
	int iOT = OrdersTotal();
	//----------------------------------------------------------------------------------------------
	// изменяем размерность массива = количеству ордеров.
	ArrayResize(libT.array_dCurOrders, iOT);
	ArrayResize(libT.array_sCurOrders, iOT);
	
	for(int idxCO	=	0;	//индекс текущего ордера
			idxCO	<=	iOT;
			idxCO++			){//..
			
			//--------------------------------------------------------------------------------------
			// Проверим, что ордер предназначен для этого советника
			if(!libT.OrderSelectByIndex(idxCO)) continue;
			
			//-------------------------------------------
			if(Symbol() != OrderSymbol()) continue;
			
			//-------------------------------------------
			//if(MN != OrderMagicNumber) continue;
			
			//--------------------------------------------------------------------------------------
			// Заполним текущую строку выбранным ордером
			libT.FillArrayRowWithSelOrder(idxCO);
			
			/** BreakPoint
			BP("libT.FillArrayCurOrders"
				,"idxCO = ", idxCO
				, "O_TI = ",libT.array_dCurOrders[idxCO][libT.O_TI]
				, "O_SY = ",libT.array_sCurOrders[idxCO][libT.O_SY]);
			*/	
	}//.

	
}//. 

//==================================================================================================
void libT.FillArrayRowWithSelOrder(int idxROW){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.29
		>Hist:
			@0.0.2@2012.08.29@artamir	[+] OrderLots
			@0.0.1@2012.08.08@artamir	[]
		>Descr:
			Заполнение текущей строки массивов выбранным ордером.
	*/
	
	//----------------------------------------------------------------------------------------------
	libT.array_dCurOrders[idxROW][libT.O_TI]	= OrderTicket();
	libT.array_dCurOrders[idxROW][libT.O_TY]	= OrderType();
	libT.array_dCurOrders[idxROW][libT.O_OP]	= OrderOpenPrice();
	libT.array_dCurOrders[idxROW][libT.O_MN]	= OrderMagicNumber();
	libT.array_dCurOrders[idxROW][libT.O_LO]	= OrderLots();
	//---------------------------------------------------------------
	libT.array_sCurOrders[idxROW][libT.O_COMM]	= OrderComment();
	libT.array_sCurOrders[idxROW][libT.O_SY]	= OrderSymbol();
}//.

//==================================================================================================
void libT.End(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.10
		>Hist:
			@0.0.1@2012.08.10@artamir	[]
		>Descr:
			Копирование массива текущих ордеров в массив старых ордеров.
	*/
	
	//----------------------------------------------------------------------------------------------
	ArrayCopy(libT.array_dOldOrders, libT.array_dCurOrders, 0, 0, WHOLE_ARRAY);
	ArrayCopy(libT.array_sOldOrders, libT.array_sCurOrders, 0, 0, WHOLE_ARRAY);
	
	//------------------------------------------------------
	int h = FileOpen("testWriteArray", FILE_BIN|FILE_WRITE);
	if(h > 0){
		FileWriteArray(h, libT.array_dExtraOrders, 0, ArrayRange(libT.array_dExtraOrders,0)*libT.OE_MAX);
		FileFlush(h);
		FileClose(h);
	}

	double t[10000][libT.OE_MAX];
	h = FileOpen("testWriteArray", FILE_BIN|FILE_READ);
	if(h > 0){
		FileReadArray(h, t, 0, 10000*libT.OE_MAX);
		FileFlush(h);
		FileClose(h);
	}
	
}//.

