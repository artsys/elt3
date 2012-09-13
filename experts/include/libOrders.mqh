/* 
		>Ver	:	0.0.11
		>Date	:	2012.09.10
		>History:
			@0.0.11@2012.09.10@artamir	[+] libO.SendBUY
			@0.0.10@2012.09.10@artamir	[+] libO.SendSELL
			@0.0.9@2012.08.20@artamir	[+] ModifyPrice()
			@0.0.7@2012.08.03@artamir	[*] Добавлены аргументы к функциям SendSELLSTOP и SendSELLLIMIT
			@0.0.6@2012.08.03@artamir	[+] libO.SendSELLLIMIT
			@0.0.5@2012.08.03@artamir	[+] libO.SendSELLSTOP
			@0.0.4@2012.07.31@artamir	[]
			@0.0.3@2012.07.31@artamir	[+] libO.SendBUYLIMIT()
			@0.0.2@2012.07.31@artamir	[*] libO.SendBUYSTOP()
		>Description:
			Функции работы с ордерами.
		>Известные ошибки:
			[+][2012.07.31]	1. SendBUYSTOP не выставляет стоплосс. 
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
*/

//=======================================================
// БЛОК ВЫСТАВЛЕНИЯ ОТЛОЖЕННЫХ ОРДЕРОВ
//=======================================================

int libO.SendBUYSTOP(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = 0){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.07.31
		>History:
			@0.0.2@2012.07.31@artamir	[*] Исправил расчет стоплосса 
			@0.0.1@2012.07.31@artamir	[*]	Добавлен расчет цены тп и сл исходя из цены выставления ордера.
		>Description:
			Функция выставления отложенного БайСтоп ордера.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
	*/
	
	//----------------------------------------------------
	double SendPrice = libNormalize.Digits((StartPrice + AddPips*Point));
	//--------------
	double TPPrice	= 0;
	if(TPPip > 0){//..
		TPPrice	= libNormalize.Digits(SendPrice + TPPip*Point);
	}//.
	//--------------
	double SLPrice	= 0;
	if(SLPip > 0){//..
		SLPrice = libNormalize.Digits(SendPrice - SLPip*Point);
	}//.	
	
	//----------------------------------------------------
	Vol = libNormalize.Volume(Vol);
	
	//----------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_BUYSTOP, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, Magic);
	
	//----------------------------------------------------
	return(ticket);
}//.

//-------------------------------------------------------
int libO.SendBUYLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = 0){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.07.31
		>History:
			@0.0.1@2012.07.31@artamir	[+] Start
			@0.0.1@2012.07.31@artamir	[*]	Добавлен расчет цены тп и сл исходя из цены выставления ордера.
		>Description:
			Функция выставления отложенного БайЛимит ордера.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
	*/
	
	//----------------------------------------------------
	double SendPrice = libNormalize.Digits((StartPrice - AddPips*Point));
	//--------------
	double TPPrice	= 0;
	if(TPPip > 0){//..
		TPPrice	= libNormalize.Digits(SendPrice + TPPip*Point);
	}//.
	//--------------
	double SLPrice	= 0;
	if(SLPip > 0){//..
		SLPrice = libNormalize.Digits(SendPrice - SLPip*Point);
	}//.	
	
	//----------------------------------------------------
	Vol = libNormalize.Volume(Vol);
	
	//----------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_BUYLIMIT, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, Magic);
	
	//----------------------------------------------------
	return(ticket);
	
}//.

//-------------------------------------------------------
int libO.SendSELLSTOP(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = 0){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.08.03
		>History:
			@0.0.3@2012.08.03@artamir	[*] добавил аргументы функцц
			@0.0.2@2012.08.03@artamir	[]
			@0.0.2@2012.07.31@artamir	[*] Исправил расчет стоплосса 
			@0.0.1@2012.07.31@artamir	[*]	Добавлен расчет цены тп и сл исходя из цены выставления ордера.
		>Description:
			Функция выставления отложенного СеллСтоп ордера.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
	*/
	
	//----------------------------------------------------
	double SendPrice = libNormalize.Digits((StartPrice - AddPips*Point));
	//--------------
	double TPPrice	= 0;
	if(TPPip > 0){//..
		TPPrice	= libNormalize.Digits(SendPrice - TPPip*Point);
	}//.
	//--------------
	double SLPrice	= 0;
	if(SLPip > 0){//..
		SLPrice = libNormalize.Digits(SendPrice + SLPip*Point);
	}//.	
	
	//----------------------------------------------------
	Vol = libNormalize.Volume(Vol);
	
	//----------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_SELLSTOP, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, Magic);
	
	//----------------------------------------------------
	return(ticket);
}//.

//-------------------------------------------------------
int libO.SendSELLLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = 0){//..
/*
		>Ver	:	0.0.1
		>Date	:	2012.08.03
		>History:
			@0.0.1@2012.08.03@artamir	[*] Добавил аргументы функции
			@0.0.2@2012.07.31@artamir	[*] Исправил расчет стоплосса 
			@0.0.1@2012.07.31@artamir	[*]	Добавлен расчет цены тп и сл исходя из цены выставления ордера.
		>Description:
			Функция выставления отложенного СеллЛимит ордера.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
	*/
	
	//----------------------------------------------------
	double SendPrice = libNormalize.Digits((StartPrice + AddPips*Point));
	//--------------
	double TPPrice	= 0;
	if(TPPip > 0){//..
		TPPrice	= libNormalize.Digits(SendPrice - TPPip*Point);
	}//.
	//--------------
	double SLPrice	= 0;
	if(SLPip > 0){//..
		SLPrice = libNormalize.Digits(SendPrice + SLPip*Point);
	}//.	
	
	//----------------------------------------------------
	Vol = libNormalize.Volume(Vol);
	
	//----------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_SELLLIMIT, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, Magic);
	
	//----------------------------------------------------
	return(ticket);
}//.

//==========================================================
int libO.SendBUY(double vol = 0.01){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/

	int ticket = _OrderSend(Symbol(), OP_BUY, vol);
	
	//------------------------------------------------------
	return(ticket);
}//.

//==========================================================
int libO.SendSELL(double vol = 0.01){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/

	int ticket = _OrderSend(Symbol(), OP_SELL, vol);
	
	//------------------------------------------------------
	return(ticket);
}//.

//=======================================================
// OrderSend()
//=======================================================

int _OrderSend(string symbol = "", int cmd = OP_BUY, double volume= 0.0, double price = 0.0, int slippage = 0, double stoploss = 0.0, double takeprofit = 0.0, string comment="", int magic=0, datetime expiration=0, color arrow_color=CLR_NONE){//..
	/*
		>Ver:0.0.0
		>Date: 2012.07.18
		>History:
		>Description:
			Функция отправки закроса на открытие ордера на сервер.
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	//-----------------------------------------------------------
	// Предопределенные переменные
	//-----------------------------------------------------------
	
	//-----------------------------------------------------------
	// Блок проверок на правильность переданных параметров.
	//-----------------------------------------------------------
	
	//=============================================
	// Определение инструмента
	//=============================================
	if(symbol == ""){//..
					//если не задан нструмент, тогда используем текущий
		symbol = Symbol();
	}//.
	
	//=============================================
	// Определение объема
	//=============================================
	double MINLOT = MarketInfo(symbol, MODE_MINLOT);
	double MAXLOT = MarketInfo(symbol, MODE_MAXLOT);
	
	if(volume < MINLOT){//..
		volume = MINLOT;
	}//.
	//------------------
	if(volume > MAXLOT){//..
		volume = MAXLOT;
	}//.
	
	//============================================
	//Определение цены
	//============================================
	if(price <= 0){//..
		price = libMI.GetMarketPriceByCMD(cmd);
	}//.
	
	//============================================
	// Определение проскальзывания
	//============================================
	if(slippage == 0){//..
		slippage = 0;
	}//.
	
	//===========================================
	// Нормализация дробных переменных
	//===========================================
	volume		= libNormalize.Volume(volume);
	price		= libNormalize.Digits(price);
	stoploss	= libNormalize.Digits(stoploss);
	takeprofit	= libNormalize.Digits(takeprofit);
	//-----------------------------------------------------------
	int res = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic, expiration, arrow_color);
	
	return(res);
}//.

//=== MODIFY ===============================================
//..
#define libO.MODE_PRICE 1
#define libO.MODE_PIP	2 

bool _OrderModify(int ticket, double price, double stoploss, double takeprofit, datetime expiration, color clr=CLR_NONE){//..
	/*
		>Ver:0.0.0
		>Date: 2012.07.18
		>History:
		>Description:
			Modify orders parameters
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	//------------------------------------------------------
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(true);
	
	//------------------------------------------------------
	if(price <= -1){
		price = libNormalize.Digits(OrderOpenPrice());
	}
	
	//------------------------------------------------------
	if(stoploss <= -1){
		stoploss = libNormalize.Digits(OrderStopLoss());
	}
	
	//------------------------------------------------------
	if(takeprofit <= -1){
		takeprofit = libNormalize.Digits(OrderTakeProfit());
	}
	
	//------------------------------------------------------
	if(expiration <= -1){
		expiration = OrderExpiration();
	}
	
	//------------------------------------------------------
	bool res = OrderModify(ticket, price, stoploss, takeprofit, expiration, clr);
	return(res);
}//.

bool libO.ModifyTP(int ticket, double tp, int mode = 1){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.08.20
		>History:
			@0.0.1@2012.08.20@artamir	[]
		>Description:
			Modify TP
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	
	return(_OrderModify(ticket, -1, -1, tp, -1, CLR_NONE));
}//.

bool libO.ModifyPrice(int ticket, double price, int mode = 1){//..

	//------------------------------------------------------
	if(mode == libO.MODE_PRICE){
		return(_OrderModify(ticket, price, -1, -1, -1, CLR_NONE));
	}	
}//.
//.