/*
	>Ver	:	0.0.0.22
	>Date	:	2013.12.24
	>Hist	:							
				@0.0.0.22@2013.12.24@artamir	[*]	T_getTickets
				@0.0.0.21@2013.12.24@artamir	[*]	T_FillRow
				@0.0.0.20@2013.08.29@artamir	[-] удалены отладочныее метки.	
				@0.0.0.19@2013.08.28@artamir	[+]	T_getTickets
				@0.0.0.18@2013.05.20@artamir	[]	T_End
				@0.0.17@2013.02.15@artamir	[]	T_CurOPByIndex
				@0.0.16@2013.02.15@artamir	[]	T_OldOPByIndex
	>Author	:	Morochin <artamir> Artiom
	>Desc	:
	>Pendings	:
				#include <sysArray.mqh>
				#include <sysEvents.mqh>
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
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Вызывается в начале ф-ции start()
	*/
	
	//------------------------------------------------------
	A_d_eraseArray2(aCurOrders);
	
	//------------------------------------------------------
	T_FillArrayCurOrders();
	
	//------------------------------------------------------
	E_Start();	//анализ массивов текущих и старых ордеров.
}

int T_End(){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.05.20
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Copying Cur orders to old orders.
					Вызывается в конце ф-ции start().
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
		>Desc	:	Количество строк массива текущих ордеров.
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
		>Desc	:	Количество строк массива ордеров на предыдущем цикле.
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
		>Desc	:	Получает тикет ордера по его индексу в массиве текущих ордеров.
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
		>Desc	:	Возвращает индекс ордера в массиве текущих ордеров по его (ордера) тикету
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
		>Desc	:	Возвращает тип ордера по его индексу в массиве текущих ордеров
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
		>Desc	:	Возвращает цену открытия ордера по его индексу в массиве текущих ордеров
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
		>Desc	:	Возвращает цену стоплосс а ордера по его индексу в массиве текущих ордеров
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
		>Desc	:	Возвращает тикет ордера по его индексу из массива старых ордеров. 
					Массив старых ордеров соответствует массиву текущих ордеров с предыдущего тика.
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
		>Desc	:	Возвращает индекс ордера по его (ордера) тикету из массива старых ордеров
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
		>Desc	:	Возвращает тип ордера по его индексу из массива старых ордеров
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
		>Desc	:	Возвращает цену открытия ордера по его индексу из массива старых ордеров
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
		>Desc	:	Возвращает уровень стоплосса ордера по его индексу из массива старых ордеров
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
					Выбирает ордер в терминале по его индексу.
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
		>Desc	:	Выбирает ордер в терминале по его тикету
	*/
	
	//------------------------------------------------------
	return(OrderSelect(ti, SELECT_BY_TICKET));
}

int		T_getTickets(double &a[]){
	/**
		\version	0.0.0.2
		\date		2013.12.24
		\author		Morochin <artamir> Artiom
		\details	Заполнение массива тикетов ордеров.
		\internal
			>Hist:		
					 @0.0.0.2@2013.12.24@artamir	[*]	обрабатываются ордера только нашего инструмента.
					 @0.0.0.1@2013.08.28@artamir	[]	T_getTickets
			>Rev:0
	*/
	
	int t = OrdersTotal();
	ArrayResize(a, t);
	
	for(int i = t; i>=0; i--){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		if(OrderSymbol()!=Symbol()) continue; //Пропускаем ордера не нашего инструмента.
		
		a[i] = OrderTicket();
	}
	
	return(ArrayRange(a,0));
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
		>Desc	:	Заполнение массива текущих ордеров.
			по текущей валютной паре
			Заполняются только числовые данные.
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
}

//==========================================================
int T_FillRow(){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.12.24
		>Hist	:	
					@0.0.0.2@2013.12.24@artamir	[+] Добавлена проверка на текущий символ. 	
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Заполнение строки массива текущих ордеров данными выбранного ордера
	*/
	
	//------------------------------------------------------
	string fn = "T_FillRow";
	if(OrderSymbol() != Symbol()) return(0);
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
	

	return(0);
}
	
//}