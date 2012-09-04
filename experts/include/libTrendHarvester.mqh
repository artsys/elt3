/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>Hist:
			@0.0.1@2012.09.03@artamir	[]
		>Desc:
			lib Trend Harvester for Vova
*/

extern bool libTH.Use			=	false;					//использовать стратегию сопровождения Trend Harvester
extern int	libTH.BackStepPip	=	10;						//расстояние до ордера противоположного направления.

int libTH.Main(int parent.ticket){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>Hist:
			@0.0.1@2012.09.03@artamir	[+] тестирование выборки бай ордеров.
		>Desc:
			Main function.
		>VARS:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	libA.double_eraseFilter2();						//обнуляем фильтр
	
	//------------------------------------------------------
	int f.COL = libT.OE_TY;
	double f.MAX = OP_BUY;
	double f.MIN = OP_BUY;
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);			//Добавили фильтр с условием AND
	
	//------------------------------------------------------
	f.COL = libT.OE_OP;
	f.MAX = Bid;											//Максимальная цена открытия ордера = Бид
	f.MIN = 0;												//Минимальная цена = 0;
															//т.е. цена открытия Бай <= БИД
	libA.double_addFilter2(f.COL, f.MAX, f.MIN);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//Выборка Бай ордеров
	
	//------------------------------------------------------
	libA.double_eraseFilter2();								//очистка фильтра
	
	//------------------------------------------------------
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELL;
	f.MAX	= OP_SELL;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);

	//------------------------------------------------------
	f.COL	= libT.OE_TY;
	f.MIN	= OP_SELLSTOP;
	f.MAX	= OP_SELLSTOP;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.OR);
	
	//------------------------------------------------------
	f.COL	= libT.OE_OP;
	f.MIN	= 0;
	f.MAX	= Ask;
	
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, libA.SOP.AND);
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders, d);	//Выборка ордеров селл и селлстоп с ценой открытия меньше Аск
	
	//------------------------------------------------------
	libA.double_PrintArray2(d, 4, "TH_SelectSELL_SELLSTOP_");
	
	//------------------------------------------------------
	libA.double_SaveToFile2(d, "test_save");
	
	//------------------------------------------------------
	double t[][libT.OE_MAX];
	libA.double_ReadFromFile2(t, "test_save");
	
	//------------------------------------------------------
	libA.double_PrintArray2(t, 4, "test_read_from_file");
}//.

//==========================================================
void libTH.checkReversOrders(double &aParents[][]){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>Hist:
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
		libA.double_PrintArray2(d, 4, "TH_Select_Revers_");
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