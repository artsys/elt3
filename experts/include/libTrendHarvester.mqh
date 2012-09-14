/*
		>Ver	:	0.0.9
		>Date	:	2012.09.14
		>Hist:
			@0.0.9@2012.09.14@artamir	[*] проверка сетки противонаправленного ордера.
			@0.0.8@2012.09.14@artamir	[]
			@0.0.7@2012.09.14@artamir	[]
			@0.0.6@2012.09.14@artamir	[]
			@0.0.5@2012.09.14@artamir	[*] изменения в связи с переходом на elt3 0.0.45 
			@0.0.3@2012.09.05@artamir	[*] убрано отладочное печатание массивов
			@0.0.2@2012.09.05@artamir	[]
			@0.0.1@2012.09.03@artamir	[]
		>Desc:
			lib Trend Harvester for Vova
*/

extern bool libTH.Use			=	false;					//использовать стратегию сопровождения Trend Harvester
extern int	libTH.BackStepPip	=	10;						//расстояние до ордера противоположного направления.
extern int	libTH.MaxLevels		=	5;						//5 уровней от родителя.
extern int	libTH.StepPip		=	10;						//расстояние между ордерами одного направления.

int libTH.Main(int parent.ticket){//..
	/*
		>Ver	:	0.0.4
		>Date	:	2012.09.14
		>Hist:
			@0.0.4@2012.09.14@artamir	[]
			@0.0.3@2012.09.14@artamir	[]
			@0.0.2@2012.09.05@artamir	[*] изменены максимальные и минимальные цены открытия.
			@0.0.1@2012.09.03@artamir	[+] тестирование выборки бай ордеров.
		>Desc:
			Main function.
		>VARS:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	libA.double_eraseFilter2();								//обнуляем фильтр
	
	//------------------------------------------------------
	//..	//ВЫОРКА БАЙ ОРДЕРОВ
	int f.COL = libT.OE_TY;
	double f.MAX = OP_BUY;
	double f.MIN = OP_BUY;
	int f.OP = libA.SOP.AND;
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);			//Добавили фильтр с условием AND
	
	/*
	//------------------------------------------------------
	f.COL = libT.OE_OP;
	f.MAX = Ask;											//Максимальная цена открытия ордера = Ask
	f.MIN = 0;												//Минимальная цена = 0;\
															//т.е. цена открытия Бай <= БИД
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	*/
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//Выборка Бай ордеров
	
	//------------------------------------------------------
	libTH.checkReversOrders(d);								//проверим на существование противоположных ордеров.
	
	//------------------------------------------------------
	libTH.checkCOOrders(d);									//проверка сонаправленных ордеров.
	//.
		
	//------------------------------------------------------
	libA.double_eraseFilter2();								//очистка фильтра
	
	//------------------------------------------------------
	//..	//ВЫОРКА СЕЛЛ ОРДЕРОВ
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELL;
	f.MAX	= OP_SELL;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
	
	/*
	//------------------------------------------------------
	f.COL	= libT.OE_OP;
	f.MIN	= Bid;
	f.MAX	= 10000;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
	*/
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//Выборка ордеров селл c ценой открытия > Аск

	libTH.checkReversOrders(d);
	
	libTH.checkCOOrders(d);
	//.
	
}//.

//..	//ПРОВЕРКА РАЗНОНАПРАВЛЕННЫХ ОРДЕРОВ
//==========================================================
void libTH.checkReversOrders(double &aParents[][]){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.14
		>Hist:
			@0.0.3@2012.09.14@artamir	[*] Проверка сетки противонаправленного ордера.
			@0.0.2@2012.09.05@artamir	[]
		>Desc:
			Проверка ордеров обратного направления.
		>VARS:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(aParents, 0);						//Кол. строк массива родительских ордеров.
	
	//------------------------------------------------------
	if(ROWS <= 0){//..
		return;
	}//.
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){//..
		//--------------------------------------------------
		int parent.ticket = aParents[idx][libT.OE_TI];
		
		libTH.checkReversOrdersByParent(parent.ticket);
	}//.	
}//.

//==========================================================
void libTH.checkReversOrdersByParent(int parent.ticket){//..
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	
	//------------------------------------------------------
	double revers.price = libTH.getReversPriceByParent(parent.ticket);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	libA.double_eraseFilter2();
	//------------------------------------------------------
	if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
		int f.COL = libT.OE_TY;
		double f.MAX = OP_SELL;
		double f.MIN = OP_SELL;
		int f.OP = libA.SOP.OR;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.MAX = OP_SELLSTOP;
		f.MIN = OP_SELLSTOP;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.COL = libT.OE_OP;
		f.MAX = revers.price + SPREAD*Point;
		f.MIN = revers.price - SPREAD*Point;
		f.OP = libA.SOP.AND;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		libA.double_SelectArray2(libT.array_dExtraOrders, d);
		
		//--------------------------------------------------
		int ROWS = ArrayRange(d, 0);
		
		//--------------------------------------------------
		if(ROWS <= 0){
			int ticket = libO.SendSELLSTOP(revers.price);
			
			libA.double_eraseFilter2();
			
			//----------------------------------------------
			f.COL = libT.OE_TI;
			f.MAX = ticket;
			f.MIN = ticket;
			f.OP = libA.SOP.AND;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
			
			ArrayResize(d, 0);
			libA.double_SelectArray2(libT.array_dExtraOrders, d);
			//----------------------------------------------
			if(ArrayRange(d,0) > 0){
				libTH.checkCOOrders(d);
			}
		}
	}//.
	
	libA.double_eraseFilter2();
	//------------------------------------------------------
	if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
		f.COL = libT.OE_TY;
		f.MAX = OP_BUY;
		f.MIN = OP_BUY;
		f.OP = libA.SOP.OR;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.MAX = OP_BUYSTOP;
		f.MIN = OP_BUYSTOP;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		f.COL = libT.OE_OP;
		f.MAX = revers.price + SPREAD*Point;
		f.MIN = revers.price - SPREAD*Point;
		f.OP = libA.SOP.AND;
		
		libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
		
		//--------------------------------------------------
		libA.double_SelectArray2(libT.array_dExtraOrders, d);
		
		//--------------------------------------------------
		ROWS = ArrayRange(d, 0);
		
		if(ROWS <= 0){
			ticket = libO.SendBUYSTOP(revers.price);
			
			libA.double_eraseFilter2();
			
			//----------------------------------------------
			f.COL = libT.OE_TI;
			f.MAX = ticket;
			f.MIN = ticket;
			f.OP = libA.SOP.AND;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
			
			ArrayResize(d, 0);
			libA.double_SelectArray2(libT.array_dExtraOrders, d);
			//----------------------------------------------
			if(ArrayRange(d,0) > 0){
				libTH.checkCOOrders(d);
			}
		}
	}//.
}//.

//==========================================================
double libTH.getReversPriceByParent(int parent.ticket){//..
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	double parent.op = libT.getExtraOPByTicket(parent.ticket);
	
	if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
		//--------------------------------------------------
		double price = parent.op - libTH.BackStepPip*Point;
		
		//--------------------------------------------------
		price = libNormalize.Digits(price);
		
		//--------------------------------------------------
		return(price);
	}//.
	
	//------------------------------------------------------
	if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
		
		//--------------------------------------------------
		price = parent.op + libTH.BackStepPip*Point;
		
		//--------------------------------------------------
		price = libNormalize.Digits(price);
		
		//--------------------------------------------------
		return(price);
	}//.
	
	return(-1);
}//.
//.

//..	//ПРОВЕРКА СОНАПАРВЛЕННЫХ ОРДЕРОВ
void libTH.checkCOOrders(double &aParents[][]){//..
	/*
		>Ver	:	0.0.0
		>Date	:	2012.09.05
		>Hist:
		>Desc:
			Проверка ордеров того же направления.
		>VARS:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(aParents, 0);
	
	//------------------------------------------------------
	if(ROWS <= 0){//..
		return;
	}//.
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){//..
		int parent.ticket = aParents[idx][libT.OE_TI];
		BP("ibTH.checkCOOrders","parent.ticket = ",parent.ticket);
		
		//--------------------------------------------------
		libTH.checkCOOrdersByParent(parent.ticket);
	}//.
}//.

//==========================================================
void libTH.checkCOOrdersByParent(int parent.ticket){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.14
		>Hist:
			@0.0.3@2012.09.14@artamir	[+] Добавлена проверка на существование 
											ордеров в заданном количестве,
											на заданных уровнях.
			@0.0.2@2012.09.14@artamir	[]
		>Desc:
			Проверка ордеров обратного направления
			по заданному родителю.
		>VARS:
	*/
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	double parent.op = libT.getExtraOPByTicket(parent.ticket);
	
	for(int thisLevel = 1; thisLevel <= libTH.MaxLevels; thisLevel++){//..
		double co.price = libTH.getCOPriceByParentLevel(parent.ticket, thisLevel);
		
		//--------------------------------------------------
		if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
			
			//----------------------------------------------
			libA.double_eraseFilter2();
			
			//----------------------------------------------
			int		f.COL = libT.OE_TY;
			double	f.MAX = OP_BUY;
			double	f.MIN = OP_BUY;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
			
			//----------------------------------------------
			f.COL = libT.OE_TY;
			f.MAX = OP_BUYSTOP;
			f.MIN = OP_BUYSTOP;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
			
			//----------------------------------------------
			f.COL = libT.OE_OP;
			f.MAX = co.price + SPREAD*Point;
			f.MIN = co.price - SPREAD*Point;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
			
			//----------------------------------------------
			double d[][libT.OE_MAX];
			
			libA.double_SelectArray2(libT.array_dExtraOrders, d);
			
			//----------------------------------------------
			int ROWS = ArrayRange(d, 0);
			
			//----------------------------------------------
			if(ROWS <= 0){//..
				libO.SendBUYSTOP(co.price);
			}//.
		}//.
	
		//--------------------------------------------------
		if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
			
			//----------------------------------------------
			libA.double_eraseFilter2();
			
			//----------------------------------------------
			f.COL = libT.OE_TY;
			f.MAX = OP_SELL;
			f.MIN = OP_SELL;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
			
			//----------------------------------------------
			f.COL = libT.OE_TY;
			f.MAX = OP_SELLSTOP;
			f.MIN = OP_SELLSTOP;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
			
			//----------------------------------------------
			f.COL = libT.OE_OP;
			f.MAX = co.price + SPREAD*Point;
			f.MIN = co.price - SPREAD*Point;
			
			libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
			
			//----------------------------------------------
			ArrayResize(d,0);
			
			libA.double_SelectArray2(libT.array_dExtraOrders, d);
			
			//----------------------------------------------
			ROWS = ArrayRange(d, 0);
			
			//----------------------------------------------
			if(ROWS <= 0){//..
				libO.SendSELLSTOP(co.price);
			}//.
		}//.
	}//.
}//.

//==========================================================
double libTH.getCOPriceByParentLevel(int parent.ticket, int level){//..
	int parent.type = libT.getExtraTypeByTicket(parent.ticket);
	double parent.op = libT.getExtraOPByTicket(parent.ticket);
	
	//------------------------------------------------------
	if(parent.type == OP_BUY || parent.type == OP_BUYSTOP){//..
		double co.price = parent.op + libTH.StepPip*Point*level;
	}//.
	
	//------------------------------------------------------
	if(parent.type == OP_SELL || parent.type == OP_SELLSTOP){//..
		co.price = parent.op - libTH.StepPip*Point*level;
	}//.
	
	co.price = libNormalize.Digits(co.price);
	
	//------------------------------------------------------
	return(co.price);
}//.
//.