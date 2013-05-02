/* 
		>Ver	:	0.0.32
		>Date	:	2012.11.16
		>History:
			@0.0.32@2012.11.16@artamir	[]
			@0.0.30@2012.11.16@artamir	[]
			@0.0.29@2012.11.13@artamir	[]
			@0.0.28@2012.10.01@artamir	[]
			@0.0.27@2012.10.01@artamir	[]
			@0.0.26@2012.10.01@artamir	[]
			@0.0.25@2012.10.01@artamir	[]
			@0.0.24@2012.10.01@artamir	[]
			@0.0.23@2012.10.01@artamir	[]
			@0.0.22@2012.09.20@artamir	[]
			@0.0.21@2012.09.20@artamir	[]
			@0.0.20@2012.09.20@artamir	[]
			@0.0.19@2012.09.20@artamir	[]
			@0.0.18@2012.09.20@artamir	[]
			@0.0.17@2012.09.20@artamir	[*] add normalizing for order modify.
			@0.0.16@2012.09.20@artamir	[]
			@0.0.15@2012.09.20@artamir	[]
			@0.0.14@2012.09.14@artamir	[]
			@0.0.13@2012.09.14@artamir	[]
			@0.0.12@2012.09.14@artamir	[]
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
		>Ver	:	0.0.4
		>Date	:	2012.09.20
		>History:
			@0.0.4@2012.09.20@artamir	[]
			@0.0.3@2012.09.14@artamir	[+] libT.Start()
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
	
	//------------------------------------------------------
	//if(ticket > 0){
		//libT.Start();
	//}
	
	//------------------------------------------------------
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
		>Ver	:	0.0.5
		>Date	:	2012.09.20
		>History:
			@0.0.5@2012.09.20@artamir	[]
			@0.0.4@2012.09.14@artamir	[+] libT.Start()
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
	
	//if(ticket > 0){
	//	libT.Start();
	//}
	
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
		>Ver	:	0.0.3
		>Date	:	2012.10.01
		>History:
			@0.0.3@2012.10.01@artamir	[]
			@0.0.2@2012.09.20@artamir	[+] checking price for sending order.
			@0.0.1@2012.09.20@artamir	[]
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
	// Check symbol
	//=============================================
	if(symbol == ""){//..
					//если не задан нструмент, тогда используем текущий
		symbol = Symbol();
	}//.
	
	//------------------------------------------------------
	double dBid = MarketInfo(symbol, MODE_BID);
	double dAsk = MarketInfo(symbol, MODE_ASK);
	
	//=============================================
	// Check volume
	//=============================================
	double MINLOT = MarketInfo(symbol, MODE_MINLOT);
	double MAXLOT = MarketInfo(symbol, MODE_MAXLOT);
	
	//------------------------------------------------------
	if(volume < MINLOT){//..
		volume = MINLOT;
	}//.
	
	//------------------------------------------------------
	if(volume > MAXLOT){//..
		volume = MAXLOT;
	}//.
	
	//------------------------------------------------------
	if(price <= 0){//..
		price = libMI.GetMarketPriceByCMD(cmd);
	}//.
	
	//------------------------------------------------------
	if(slippage == 0){//..
		slippage = 0;
	}//.
	
	//======================================================
	// Normalizing
	//======================================================
	volume		= libNormalize.Volume(volume);
	price		= libNormalize.Digits(price);
	stoploss	= libNormalize.Digits(stoploss);
	takeprofit	= libNormalize.Digits(takeprofit);
	
	//------------------------------------------------------
	//..	//Checking ability to send order
	
		//--------------------------------------------------
		if(cmd == OP_BUYSTOP){//..
			if(price <= dBid){
				return(-1);
			}
		}//.
		
		//--------------------------------------------------
		if(cmd == OP_SELLSTOP){//..
			if(price >= dAsk){
				return(-1);
			}
		}//.
	//.
	
	//------------------------------------------------------
	int res = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic, expiration, arrow_color);
	
	if(res > 0){//..
		libT.setExtraStandartData(res);
	}//.
	
	//------------------------------------------------------
	int err = GetLastError();
	
	//------------------------------------------------------
	if(err == 130){
		Print("Bad stop", " cmd = ", cmd, " price = ", price, "stoploss = ", stoploss, "takeprofit = ", takeprofit, " Ask = ",Ask, " Bid = ", Bid);
	}
	
	return(res);
}//.

//=== MODIFY ===============================================
//..
#define libO.MODE_PRICE 1
#define libO.MODE_PIP	2 

bool _OrderModify(int ticket, double price, double stoploss, double takeprofit, datetime expiration, color clr=CLR_NONE){//..
	/*
		>Ver	:	0.0.4
		>Date	:	2012.10.01
		>History:
			@0.0.4@2012.10.01@artamir	[*] critical change
			@0.0.3@2012.09.20@artamir	[]
			@0.0.2@2012.09.20@artamir	[+] add normalizing for double values
			@0.0.1@2012.09.20@artamir	[+] add chicking needModify
		>Description:
			Modify orders parameters
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	//------------------------------------------------------
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(true);
	
	//------------------------------------------------------
	int type = OrderType();
	double dBid = MarketInfo(Symbol(), MODE_BID);
	double dAsk = MarketInfo(Symbol(), MODE_ASK);
	
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
	bool needModify = false;//..
	if(libNormalize.Digits(price) != libNormalize.Digits(OrderOpenPrice())){//..
		needModify = true;
		//BP("_OrderModify","ticket = ",ticket, " needModify = ",needModify);
	}//.
	
	//------------------------------------------------------
	if(libNormalize.Digits(stoploss) != libNormalize.Digits(OrderStopLoss())){//..
		needModify = true;
	}//.
	
	//------------------------------------------------------
	if(libNormalize.Digits(takeprofit) != libNormalize.Digits(OrderTakeProfit())){//..
			
		//--------------------------------------------------	
		needModify = true;
	}//.
	
	//.
	
	//------------------------------------------------------
	//..	//checking if we could modify
		if(type == OP_BUY || type == OP_BUYSTOP){//..
			if(takeprofit > 0 && takeprofit < dBid){
				return(false);
			}
		}//.
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP){//..
			if(takeprofit > 0 && takeprofit > dAsk){
				return(false);
			}
		}//.
	//.
	
	//------------------------------------------------------
	if(needModify){//..
		bool res = OrderModify(ticket, price, stoploss, takeprofit, expiration, clr);
		
		//--------------------------------------------------
		int err = GetLastError();
		
		//--------------------------------------------------
		if(err == 130){
			Print("ti = ", ticket, " p = ",price," s = ",stoploss, " t = ", takeprofit);
		}
		
		//--------------------------------------------------
		if(err == 3){
			Print(OrderPrint());
		}
		
		//--------------------------------------------------
		if(err == 1){
			Print(" ti = ", ticket, " takeprofit = ", DoubleToStr(takeprofit, Digits), " needModify = ",needModify);
		}
		//--------------------------------------------------
		
		if(res){//..
			libT.setExtraTPByTicket(ticket, takeprofit);
		}//.
		return(res);
	}else{
		return(true);
	}//.	
}//.

bool libO.ModifyTP(int ticket, double tp, int mode = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.16
		>History:
			@0.0.3@2012.11.16@artamir	[]
			@0.0.2@2012.09.20@artamir	[]
			@0.0.1@2012.08.20@artamir	[]
		>Description:
			Modify TP
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	double newtp = tp;
	
	if(mode == libO.MODE_PIP){
		int type = OrderType();
		double op = OrderOpenPrice();
		//--------------------------------------------------
		if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){//..
			newtp = op+tp*Point;
		}//.
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT){//..
			newtp = op - tp*Point;
		}//.
	}
	
	return(_OrderModify(ticket, -1, -1, newtp, -1, CLR_NONE));
}

bool libO.ModifyPrice(int ticket, double price, int mode = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.16
		>Hist	:
			@0.0.1@2012.11.16@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	//------------------------------------------------------
	
	if(mode == libO.MODE_PRICE){
		return(_OrderModify(ticket, price, -1, -1, -1, CLR_NONE));
	}	
}

bool libO.ModifySL(int ticket, double sl, int mode = 1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.16
		>History:
			@0.0.1@2012.11.16@artamir	[]
		>Description:
			Modify SL
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	double newsl = sl;
	
	if(mode == libO.MODE_PIP){
		int type = OrderType();
		double op = OrderOpenPrice();
		//--------------------------------------------------
		if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){
			newsl = op - sl*Point;
		}
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT){
			newsl = op + sl*Point;
		}
	}
	
	return(_OrderModify(ticket, -1, newsl, -1, -1, CLR_NONE));
}

//.

//=== CLOSE ================================================
//..
bool libO.CloseByTicket(int ticket){
	/*
		>Ver	:	0.0.5
		>Date	:	2012.10.01
		>Hist:
			@0.0.5@2012.10.01@artamir	[]
			@0.0.4@2012.10.01@artamir	[+] add checking on err 138 
			@0.0.3@2012.10.01@artamir	[+] add setExtraIsClosedByTicket
			@0.0.2@2012.10.01@artamir	[]
			@0.0.1@2012.09.14@artamir	[]
		>Desc:
	*/
	
	//------------------------------------------------------
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	//------------------------------------------------------
	if(OrderType() != OP_BUY && OrderType() != OP_SELL){
		return(false);
	}
	
	//------------------------------------------------------
	double price = libMI.getMarketClosePriceByCMD(OrderType());
	
	price = libNormalize.Digits(price);
	//------------------------------------------------------
	double lot = OrderLots();
	
	//------------------------------------------------------
	int tryCount = 0;
	
	//------------------------------------------------------
	bool res = false;
	
	//------------------------------------------------------
	while(!res && tryCount < 5 && !IsTradeContextBusy()){
		
		//----------------------------------------------
		RefreshRates();
		
		if(OrderType() == OP_BUY){
			price = MarketInfo(Symbol(), MODE_BID);
		}else{
			if(OrderType() == OP_SELL){
				price = MarketInfo(Symbol(), MODE_ASK);
			}
		}
		
		//----------------------------------------------
		//price = libMI.getMarketClosePriceByCMD(OrderType());
		
		//----------------------------------------------
		price = libNormalize.Digits(price);
		
		//--------------------------------------------------
		res = OrderClose(ticket, lot, price, 0, CLR_NONE);
		
		//--------------------------------------------------
		int err = GetLastError();
		
		//--------------------------------------------------
		if(err == 138){
			
			//----------------------------------------------
			//Sleep(11000);
			Print("X3");
		}
		
		//--------------------------------------------------
		tryCount++;
	}
	
	//------------------------------------------------------
	if(res){
		libT.setExtraIsClosedByTicket(ticket);
	}
	
	//------------------------------------------------------
	return(res);
}
//.

//..	@DELETE PENDING@
bool libO.DeleteByTicket(int ticket){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.11.13
		>Hist	:
			@0.0.1@2012.11.13@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	if(OrderType() <= 1) return(false);
	
	return(OrderDelete(ticket));
}
//.