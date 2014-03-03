	/**
		\version	0.0.0.43
		\date		2014.02.10
		\author		Morochin <artamir> Artiom
		\details	Trading functtions.
		\internal
				$Revision: 287 $
				>Hist:														
						 @0.0.0.43@2014.02.10@artamir	[]	TR_ModifySL
						 @0.0.0.42@2014.02.10@artamir	[]	TR_ModifyTP
						 @0.0.0.41@2014.02.10@artamir	[]	TR_ModifySLByTicket
						 @0.0.0.40@2014.01.15@artamir	[*]	TR_CloseByTicket
						 @0.0.0.39@2013.12.31@artamir	[]	_OrderModify
					 @0.0.0.38@2013.12.24@artamir	[*]	TR_SendBUY
					 @0.0.0.37@2013.12.24@artamir	[*]	TR_SendSELL
	*/

#define TR_MODE_PRICE 1
#define TR_MODE_PIP	2 
	
extern string	TR_S = "==== TRADING ======================";
extern double	TR_TwiseLots	= 20.0;						// Объем выставляемой позиции, после которого объем ордеров делится на два
extern int		TR_MN = 0;									// Магический номер позиции.
extern string	TR_E = "===================================";

//{	//=== SENDING	====================================

//{	//=== PUBLIC	====================================

#define TR_MODE_ASK 0 
#define TR_MODE_BID 1
#define TR_MODE_OOP 2 //Order Open Price (Зависит от типа ордера).
#define TR_MODE_OCP 3 //Order Close Price (Зависит от типа ордера).
#define TR_MODE_AVG 4 //Средняя цена между бид и аск.

//{	//====== PENDING ORDERS ============================

int TR_SendBUYSTOP (	double	StartPrice //{
					,	int		AddPips = 0
					,	double	Vol = 0.01
					,	int		TPPip = 0
					,	int		SLPip = 0
					,	string	Comm = ""
					,	int		Magic = -1){
	/**
		\version	0.0.1
		\date		2013.04.22
		\author		Morochin <artamir> Artiom
		\details	Функция выставления отложенного БайСтоп ордера.
					Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
					Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
		\internal
			>Hist:	
					 @0.0.1@2013.04.22@artamir	[]	TR_SendBUYSTOP
	*/
	
	//------------------------------------------------------
	double SendPrice = Norm_symb((StartPrice + AddPips*Point));
	
	//------------------------------------------------------
	double TPPrice	= 0;
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice + TPPip*Point);
	}
	
	//------------------------------------------------------
	double SLPrice	= 0;
	if(SLPip > 0){
		SLPrice = Norm_symb(SendPrice - SLPip*Point);
	}	

	//------------------------------------------------------	
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//------------------------------------------------------
	Vol = Norm_vol(Vol);
	
	//------------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_BUYSTOP, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
	
	//------------------------------------------------------
	return(ticket);
} //}

int TR_SendBUYSTOP_array(		double &d[] //{
							,	double StartPrice
							,	int AddPips = 0
							,	double Vol = 0.01
							,	double TPPip = 0
							,	double SLPip = 0
							,	string Comm = ""
							,	int Magic = -1 /** по умолчанию магик берется из TR_MN */
							,	string Sy="" /** по умолчанию по текущему инструменту */
							,	int Mode=2 /** по умолчанию тп и сл задаются в пунктах */
							,	int pr_mode=0 /** при старт прайс=0 по умолчанию будет цена аск */){
	/*
		>Ver	:	0.0.0.7
		>Date	:	2013.10.04
		>Hist:						
				 @0.0.0.7@2013.10.04@artamir	[*]	TR_SendBUYSTOP_array
				 @0.0.0.6@2013.10.03@artamir	[+]	добавлена возможность выбора ценового уровня при старт прайс=0.
				 @0.0.0.5@2013.09.18@artamir	[+]	Добавлена возможность задавать сл и тп ценовыми уровнями.
				 @0.0.0.4@2013.09.16@artamir	[*]	TR_SendBUYSTOP_array добавлена валютная пара для выставления ордеров.
				 @0.0.0.3@2013.09.04@artamir	[*]	TR_SendBUYSTOP_array + добавлена возможность выставлять отложенные ордера от текущей цены Аск.
				 @0.0.2@2013.04.22@artamir	[]	TR_SendBUYSTOP_array
		>Desc:
			Функция выставления отложенных БайСтоп ордеров.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
			Добавлено деление объемов ордеров до заданного объема.
		>VARS:
			@double &d[]:	массив, в котором возвращаются тикеты выставленных ордеров.
	*/
	
	//----------------------------------------------------
	double SendPrice = 0;
	double sendVol	= 0;
	int countSends = 0;
	
	int ns = 0;
	int ticket = 0;
	int idx = 0;
	
	double TPPrice	= 0;
	double SLPrice	= 0;
	double rest_vol	= Vol;
	
	if(Sy==""){Sy=Symbol();}
	
	int ROWS = 0;
	
	ArrayResize(d,0);
	
	double _StartPrice = StartPrice;
	if(_StartPrice<=0){
		_StartPrice=TR_getMarketPrice(pr_mode, OP_BUYSTOP, Sy);
	}
	
	SendPrice = Norm_symb((_StartPrice + AddPips*Point));
	
	//------------------------------------------------------
	if(TPPip > 0){
		if(Mode==TR_MODE_PIP){TPPrice=Norm_symb(SendPrice + TPPip*Point);}
		if(Mode==TR_MODE_PRICE){TPPrice=TPPip;}
	}
	
	//--------------
	if(SLPip > 0){
		if(Mode==TR_MODE_PIP){SLPrice=Norm_symb(SendPrice - SLPip*Point);}
		if(Mode==TR_MODE_PRICE){SLPrice=SLPip;}
	}	
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend(Sy, OP_BUYSTOP, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
		if(ticket > 0){
			ROWS++;
			ArrayResize(d, ROWS);
			
			idx = ROWS-1;
			d[idx] = ticket;
			
			rest_vol = rest_vol - sendVol;
		}
	}

	//------------------------------------------------------
	return(ArrayRange(d,0));
} //}

int TR_SendBUYLIMIT_array(		double &d[] //{
							,	double StartPrice
							,	int AddPips = 0
							,	double Vol = 0.01
							,	double TPPip = 0
							,	double SLPip = 0
							,	string Comm = ""
							,	int Magic = -1
							,	string Sy=""
							,	int Mode=2
							,	int pr_mode=1 /** при старт прайс=0 по умолчанию будет цена бид */){
	/*
		>Ver	:	0.0.0.7
		>Date	:	2013.10.04
		>Hist:					
				 @0.0.0.7@2013.10.04@artamir	[*]	TR_SendBUYLIMIT_array
				 @0.0.0.6@2013.10.03@artamir	[+]	добавлена возможность выбора ценового уровня при старт прайс=0.
				 @0.0.0.5@2013.09.18@artamir	[+]	Добавлена возможность задавать сл и тп ценовыми уровнями.
				 @0.0.0.4@2013.09.16@artamir	[*]	Добавлена валютная пара.
				 @0.0.3@2013.04.22@artamir	[]	TR_SendBUYLIMIT_array
		>Desc:
			Функция выставления отложенных БайСтоп ордеров.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
			Добавлено деление объемов ордеров до заданного объема.
		>VARS:
			@double &d[]:	массив, в котором возвращаются тикеты выставленных ордеров.
	*/
	
	//----------------------------------------------------
	double SendPrice = 0;
	double sendVol	= 0;
	int countSends = 0;
	
	int ns = 0;
	int ticket = 0;
	int idx = 0;
	
	double TPPrice	= 0;
	double SLPrice	= 0;
	double rest_vol	= Vol;
	int ROWS = 0;
	
	if(Sy==""){Sy=Symbol();}
	
	ArrayResize(d,0);
	
	double _StartPrice = StartPrice;
	if(_StartPrice<=0){
		_StartPrice=TR_getMarketPrice(pr_mode, OP_BUYLIMIT, Sy);
	}
	SendPrice = Norm_symb((_StartPrice + AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		if(Mode==TR_MODE_PIP){TPPrice=Norm_symb(SendPrice + TPPip*Point);}
		if(Mode==TR_MODE_PRICE){TPPrice=TPPip;}
	}
	
	//--------------
	if(SLPip > 0){
		if(Mode==TR_MODE_PIP){SLPrice=Norm_symb(SendPrice - SLPip*Point);}
		if(Mode==TR_MODE_PRICE){SLPrice=SLPip;}
	}	
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend(Sy, OP_BUYLIMIT, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
		if(ticket > 0){
			ROWS++;
			ArrayResize(d, ROWS);
			
			idx = ROWS-1;
			d[idx] = ticket;
			
			rest_vol = rest_vol - sendVol;
		}
	}

	//------------------------------------------------------
	return(ArrayRange(d,0));
} //}

int TR_SendBUYLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
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
	
	//------------------------------------------------------
	double SendPrice = Norm_symb((StartPrice - AddPips*Point));
	
	//------------------------------------------------------
	double TPPrice	= 0;
	
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice + TPPip*Point);
	}
	
	//------------------------------------------------------
	double SLPrice	= 0;
	if(SLPip > 0){
		SLPrice = Norm_symb(SendPrice - SLPip*Point);
	}	

	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//------------------------------------------------------
	Vol = Norm_vol(Vol);
	
	//------------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_BUYLIMIT, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
	
	//------------------------------------------------------
	return(ticket);
	
}

int TR_SendSELLSTOP(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.6
		>Date	:	2013.04.22
		>History:	
					@0.0.6@2013.04.22@artamir	[]	TR_SendSELLSTOP
			@0.0.5@2012.09.20@artamir	[]
			@0.0.4@2012.09.14@artamir	[+] libT_Start()
			@0.0.3@2012.08.03@artamir	[*] добавил аргументы функцц
			@0.0.2@2012.08.03@artamir	[]
			@0.0.2@2012.07.31@artamir	[*] Исправил расчет стоплосса 
			@0.0.1@2012.07.31@artamir	[*]	Добавлен расчет цены тп и сл исходя из цены выставления ордера.
		>Description:
			Функция выставления отложенного СеллСтоп ордера.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
	*/
	
	//------------------------------------------------------
	double SendPrice = Norm_symb((StartPrice - AddPips*Point));
	
	//------------------------------------------------------
	double TPPrice	= 0;
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice - TPPip*Point);
	}
	
	//------------------------------------------------------
	double SLPrice	= 0;
	if(SLPip > 0){
		SLPrice = Norm_symb(SendPrice + SLPip*Point);
	}
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//----------------------------------------------------
	Vol = Norm_symb(Vol);
	
	//----------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_SELLSTOP, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, Magic);
	
	//----------------------------------------------------
	return(ticket);
}

int TR_SendSELLSTOP_array(		double &d[] //{
							,	double StartPrice
							,	int AddPips = 0
							,	double Vol = 0.01
							,	double TPPip = 0
							,	double SLPip = 0
							,	string Comm = ""
							,	int Magic = -1
							,	string Sy=""
							,	int Mode=2
							,	int pr_mode=1 /** при старт прайс=0 по умолчанию будет цена бид */){
	/*
		>Ver	:	0.0.0.6
		>Date	:	2013.10.04
		>Hist:					
				 @0.0.0.6@2013.10.04@artamir	[*]	TR_SendSELLSTOP_array
				 @0.0.0.5@2013.10.03@artamir	[+]	добавлена возможность выбора ценового уровня при старт прайс=0.
				 @0.0.0.4@2013.09.18@artamir	[*]	Добавлена возможность задавать тп и сл ценовыми уровнями.
				 @0.0.0.3@2013.09.16@artamir	[*]	Добавлена валютная пара
				 @0.0.0.2@2013.09.04@artamir	[*]	TR_SendSELLSTOP_array + добавлена возможность выставления отложенных ордеров от текущей цены.
		>Desc:
			Функция выставления отложенных БайСтоп ордеров.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
			Добавлено деление объемов ордеров до заданного объема.
		>VARS:
			@double &d[]:	массив, в котором возвращаются тикеты выставленных ордеров.
	*/
	
	//----------------------------------------------------
	double SendPrice = 0;
	double sendVol	= 0;
	int countSends = 0;
	
	int ns = 0;
	int ticket = 0;
	int idx = 0;
	
	double TPPrice	= 0;
	double SLPrice	= 0;
	double rest_vol	= Vol;
	
	if(Sy==""){Sy=Symbol();}
	
	int ROWS = 0;
	
	ArrayResize(d,0);
	
	double _StartPrice = StartPrice;
	if(_StartPrice<=0){
		_StartPrice=TR_getMarketPrice(pr_mode, OP_SELLSTOP, Sy);
	}
	
	SendPrice = Norm_symb((_StartPrice - AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		if(Mode==TR_MODE_PIP){TPPrice=Norm_symb(SendPrice - TPPip*Point);}
		if(Mode==TR_MODE_PRICE){TPPrice=TPPip;}
	}
	
	//--------------
	if(SLPip > 0){
			if(Mode==TR_MODE_PIP){SLPrice=Norm_symb(SendPrice + SLPip*Point);}
			if(Mode==TR_MODE_PRICE){SLPrice=SLPip;}
	}	
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend(Sy, OP_SELLSTOP, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
		if(ticket > 0){
			ROWS++;
			ArrayResize(d, ROWS);
			
			idx = ROWS-1;
			d[idx] = ticket;
			
			rest_vol = rest_vol - sendVol;
		}
	}

	//------------------------------------------------------
	return(ArrayRange(d,0));
} //}

int TR_SendSELLLIMIT_array(		double &d[]	//{
							,	double StartPrice
							,	int AddPips = 0
							,	double Vol = 0.01
							,	double TPPip = 0
							,	double SLPip = 0
							,	string Comm = ""
							,	int Magic = -1
							,	string Sy=""
							,	int Mode=2
							,	int pr_mode=0){
	/*
		>Ver	:	0.0.0.5
		>Date	:	2013.10.04
		>Hist:			
				 @0.0.0.5@2013.10.04@artamir	[*]	TR_SendSELLLIMIT_array
				 @0.0.0.4@2013.09.18@artamir	[+]	Добавлена возможность задавать сл и тп в виде ценовых уровней.
				 @0.0.0.3@2013.09.16@artamir	[*]	Добавлена валютная пара.
		>Desc:
			Функция выставления отложенных БайСтоп ордеров.
			Для брокеров, которые поддерживают выставление ордера с заданными тейкпрофитом и стоплоссом.
			Тейкпрофит и стоплосс рассчитываются исходя из цены выставления ордера.
			Добавлено деление объемов ордеров до заданного объема.
		>VARS:
			@double &d[]:	массив, в котором возвращаются тикеты выставленных ордеров.
	*/
	
	//----------------------------------------------------
	double SendPrice = 0;
	double sendVol	= 0;
	int countSends = 0;
	
	int ns = 0;
	int ticket = 0;
	int idx = 0;
	
	double TPPrice	= 0;
	double SLPrice	= 0;
	double rest_vol	= Vol;
	
	if(Sy==""){Sy=Symbol();}
	
	int ROWS = 0;
	
	ArrayResize(d,0);
	
	double _StartPrice = StartPrice;
	if(_StartPrice<=0){
		_StartPrice=TR_getMarketPrice(pr_mode, OP_SELLLIMIT, Sy);
	}
	
	SendPrice = Norm_symb((_StartPrice - AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		if(Mode==TR_MODE_PIP){TPPrice=Norm_symb(SendPrice - TPPip*Point);}
		if(Mode==TR_MODE_PRICE){TPPrice=TPPip;}
	}
	
	//--------------
	if(SLPip > 0){
		if(Mode==TR_MODE_PIP){SLPrice=Norm_symb(SendPrice + SLPip*Point);}
		if(Mode==TR_MODE_PRICE){SLPrice=SLPip;}
	}	
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend(Sy, OP_SELLLIMIT, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
		if(ticket > 0){
			ROWS++;
			ArrayResize(d, ROWS);
			
			idx = ROWS-1;
			d[idx] = ticket;
			
			rest_vol = rest_vol - sendVol;
		}
	}

	//------------------------------------------------------
	return(ArrayRange(d,0));
} //}

int TR_SendSELLLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
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
	
	//------------------------------------------------------
	double SendPrice = Norm_symb((StartPrice + AddPips*Point));
	
	//------------------------------------------------------
	double TPPrice	= 0;
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice - TPPip*Point);
	}
	
	//------------------------------------------------------
	double SLPrice	= 0;
	if(SLPip > 0){
		SLPrice = Norm_symb(SendPrice + SLPip*Point);
	}	
	
	//------------------------------------------------------
	int mn = 0;
	if(Magic <= -1){
		mn = TR_MN;
	}else{
		mn = Magic;
	}
	
	//------------------------------------------------------
	Vol = Norm_vol(Vol);
	
	//------------------------------------------------------
	int ticket = -1;
		ticket = _OrderSend("", OP_SELLLIMIT, Vol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
	
	//----------------------------------------------------
	return(ticket);
}

int TR_SendSTOPLikeOrder_array(double &d[], int src_ti = 0, int AddPips = 0, double lot_multi = 2){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.02
		>Hist	:
			@0.0.1@2013.03.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Выставление ордеров, подобных заданному ордеру.
	*/
	
	double	StartPrice = 0.0;
	string	Comm = "like order: ";
	int		Type = -1;
	int		Magic = 0;
	double	Lot = 0;
	
	//------------------------------------------------------
	if(src_ti <= 0) return(-1);
	
	//------------------------------------------------------
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(-1);
	
	//------------------------------------------------------
	StartPrice = Norm_symb(OrderOpenPrice());
	Comm = Comm + OrderTicket();
	Type = OrderType();
	Lot = OrderLots()*lot_multi;
	Magic = OrderMagicNumber();
	
	if(Type == OP_BUY || Type == OP_BUYSTOP){
		return(TR_SendBUYSTOP_array(d, StartPrice, AddPips, Lot, 0, 0, Comm, Magic));
	}
	
	if(Type == OP_SELL || Type == OP_SELLSTOP){
		return(TR_SendSELLSTOP_array(d, StartPrice, AddPips, Lot, 0, 0, Comm, Magic));
	}
	
	return(0);
	
}

int TR_SendPending_array(		double &d[]	//{
							,	int type
							,	double StartPrice
							,	int AddPips = 0
							,	double Vol = 0.01
							,	double TPPip = 0
							,	double SLPip = 0
							,	string Comm = ""
							,	int Magic = -1
							,	string Sy=""
							,	int Mode=2
							,	int Pr_mode=2){
	/**
		\version	0.0.0.4
		\date		2013.10.04
		\author		Morochin <artamir> Artiom
		\details	Выставляет отложенные ордера до заданного объема.
		\internal
			>Hist:				
					 @0.0.0.4@2013.10.04@artamir	[+]	добавил выбор стартовой цены при старт прайс=0
					 @0.0.0.3@2013.09.18@artamir	[*]	Изменения связанные с возможностью выставлять сл и тп в виде ценового уровня.
					 @0.0.0.2@2013.09.16@artamir	[*]	Добавлена валютная пара для выставления.
					 @0.0.0.1@2013.06.28@artamir	[]	TR_SendPending_array
			>Rev:0
	*/
	
	if(type == OP_BUYSTOP	){return(TR_SendBUYSTOP_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic, Sy, Mode, Pr_mode));}
	if(type == OP_BUYLIMIT	){return(TR_SendBUYLIMIT_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic, Sy, Mode, Pr_mode));}
	if(type == OP_SELLSTOP	){return(TR_SendSELLSTOP_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic, Sy, Mode, Pr_mode));}
	if(type == OP_SELLLIMIT	){return(TR_SendSELLLIMIT_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic, Sy, Mode, Pr_mode));}
	return(0);
}	//}

int TR_SendPendingLikeOrder(double &d[], int src_ti=0, int AddPips=0){
	/**
		\version	0.0.0.3
		\date		2013.09.18
		\author		Morochin <artamir> Artiom
		\details	Выставление похожего ордера в зависимости от цены.
					Если ордер-источник=бай и цена ниже цены ордера, то выставляется байстоп.
					Если ордер-источник=бай и цена выше цены ордера, то выставляется байлимит.
		\internal
			>Hist:			
					 @0.0.0.3@2013.09.18@artamir	[*]	Изменения в связи с возможностью выставлять сл и тп в виде ценового уровня.
					 @0.0.0.2@2013.09.17@artamir	[*]	Исправление, не вытавлялся тп и сл
					 @0.0.0.1@2013.09.16@artamir	[+]	TR_SendPendingLikeOrder
			>Rev:0
	*/

	if(!OrderSelect(src_ti, SELECT_BY_TICKET)){return(-1);}
	
	int src_ty=OrderType();
	double src_op=OrderOpenPrice();
	double src_sl=OrderStopLoss();
	double src_tp=OrderTakeProfit();
	double src_lot=OrderLots();
	double src_mn=OrderMagicNumber();
	string src_sy=OrderSymbol();
	string src_comm=OrderComment();
	
	double _BID = MarketInfo(src_sy, MODE_BID);
	double _ASK = MarketInfo(src_sy, MODE_ASK);
	
	int ty = -1;
	double sl_pip=0;
	double tp_pip=0;
	if(src_sl>0){sl_pip=src_sl;}//=MathAbs((src_op-src_sl)/Point);}
	if(src_tp>0){tp_pip=src_tp;}//=MathAbs((src_op-src_tp)/Point);}
	
	if(src_ty==OP_BUY ){
		if(_ASK<src_op){ty=OP_BUYSTOP;}
		if(_BID>src_op){ty=OP_BUYLIMIT;}
	}
	
	if(src_ty==OP_SELL){
		if(_BID>src_op){ty=OP_SELLSTOP;}
		if(_ASK<src_op){ty=OP_SELLLIMIT;}
	}
	
	return(TR_SendPending_array(d,ty,src_op,AddPips,src_lot,tp_pip,sl_pip,src_comm, src_mn, src_sy, TR_MODE_PRICE));
}
//}

//{	//====== MARKET ORDERS	============================

int TR_SendBUY(double vol = 0.01, int mn=-1){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.12.24
		>Hist:	
				 @0.0.0.2@2013.12.24@artamir	[+]	Добавлено выставление магика для ордера.
	*/

	if(mn==-1)mn=TR_MN;
	double sl=0.0,tp=0.0;
	string comm="";
	int ticket = _OrderSend(Symbol(), OP_BUY, vol, 0,0,sl,tp,comm,mn);
	
	//------------------------------------------------------
	return(ticket);
}

int TR_SendSELL(double vol = 0.01, int mn=-1){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.12.24
		>Hist:	
				 @0.0.0.2@2013.12.24@artamir	[+]	Добавлено выставление магика для ордера.
	*/
	if(mn==-1)mn=TR_MN;
	double sl=0.0,tp=0.0;
	string comm="";
	int ticket = _OrderSend(Symbol(), OP_SELL, vol,0,0,sl,tp,comm,mn);
	
	//------------------------------------------------------
	return(ticket);
}

int TR_SendMarket(int op=OP_BUY, double vol=0.01){
	/**
		\version	0.0.0.1
		\date		2013.12.07
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.07@artamir	[+]	TR_SendMarket
			>Rev:0
	*/
	int res=-1;
	if(op==OP_BUY)res=TR_SendBUY(vol);
	if(op==OP_SELL)res=TR_SendSELL(vol);
	
	//------------------------------------------
	return(res);
}

//}

//{	//====== REVERS ORDERS	============================
int TR_getReversType(int src_ty = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.26
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Получение типа ордера для выставления реверсного ордера (ордера в противоположном направлении) по заданному типу и на том же ценовом уровне, что и ордер-родитель.
	*/
	
	int dest_ty = -1;
	
	if(src_ty == OP_BUYSTOP){
		dest_ty = OP_SELLLIMIT;
	}
	
	if(src_ty == OP_SELLSTOP){
		dest_ty = OP_BUYLIMIT;
	}
	
	if(src_ty == OP_BUYLIMIT){
		dest_ty = OP_SELLSTOP;
	}
	
	if(src_ty == OP_SELLLIMIT){
		dest_ty = OP_BUYSTOP;
	}
	
	return(dest_ty);
}

int TR_SendREVERSOrder(double &d[], int src_ti, double vol = 0.01, double lot_multi = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.03.02
		>Hist	:
			@0.0.3@2013.03.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Выставление реверсных ордеров до заданного объема по заданному тикету-родителю.
	*/
	
	int src_ty = -1;
	double src_pr = 0;
	
	int dest_ty = -1;
	double dest_vol = vol;
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	int addSpread = 0;
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(-1);
	
	src_ty = OrderType();
	src_pr = OrderOpenPrice();
	if(dest_vol <= 0){
		dest_vol = OrderLots() * lot_multi;
	}
	
	dest_ty = TR_getReversType(src_ty);
	
	if(dest_ty == OP_BUYLIMIT){
		return(TR_SendBUYLIMIT_array(d, (src_pr+SPREAD*Point), 0, dest_vol));
	}
	
	if(dest_ty == OP_SELLLIMIT){
		return(TR_SendSELLLIMIT_array(d, (src_pr-SPREAD*Point), 0, dest_vol));
	}
	
	if(dest_ty == OP_BUYSTOP){
		return(TR_SendBUYSTOP_array(d, (src_pr+SPREAD*Point), 0, dest_vol));
	}
	
	if(dest_ty == OP_SELLSTOP){
		return(TR_SendSELLSTOP_array(d,(src_pr-SPREAD*Point), 0, dest_vol));
	}
	
	return(-1);
}
//}

//}

//{	//=== PRIVATE	====================================
double TR_getMarketPrice(int mode, int ty=0, string sy=""){
	/**
		\version	0.0.0.1
		\date		2013.10.03
		\author		Morochin <artamir> Artiom
		\details	В зависимости от метода возвращает текущую рыночную цену.
		\internal
			>Hist:	
					 @0.0.0.1@2013.10.03@artamir	[+]	TR_getMarketPrice
						TR_MODE_AVG, TR_MODE_BID, TR_MODE_ASK, 
						TR_MODE_OOP для OP_BUY, OP_BUYSTOP, OP_SELL, OP_SELLSTOP
			>Rev:0
	*/
	if(sy==""){sy=Symbol();}
	
	double dBid = MarketInfo(sy, MODE_BID);
	double dAsk = MarketInfo(sy, MODE_ASK);
	
	double res = -1.00;
	
	if(mode==TR_MODE_AVG){
		res=(dBid+dAsk)/2;
	}
	
	if(mode==TR_MODE_BID){
		res=dBid;
	}
	
	if(mode==TR_MODE_ASK){
		res=dAsk;
	}
	
	if(mode==TR_MODE_OOP){
		if(ty==OP_BUY || ty==OP_BUYSTOP){
			res=dAsk;
		}
		
		if(ty==OP_SELL || ty==OP_SELLSTOP){
			res=dBid;
		}
	
	}
	
	return(Norm_symb(res));
}

int	_TR_CountOrdersToSend(double all_vol = 0){
	/*
		>Ver	:	0.0.0.1
		>Date	:
	2013.07.02
		>Hist	:	
					@0.0.0.1@2013.07.02@artamir	[]	изменен алгоритм нахождения количества выставляемых ордеров.
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Расчет количества выставляемых ордеров при нужном объеме, превышающем максимально заданный объем. Максимальный объем задается в переменной TR_TwiseLots.
	*/
	
	double count = 0;//all_vol / TR_TwiseLots;
	
	count = all_vol/TR_TwiseLots;
	
	int count_floor = MathRound(count);
	
	if(count - count_floor > 0){
		count_floor++;
	}
	
	return(count_floor);
}

int _OrderSend(string symbol = "", int cmd = OP_BUY, double volume= 0.0, double price = 0.0, int slippage = 0, double stoploss = 0.0, double takeprofit = 0.0, string comment="", int magic=-1, datetime expiration=0, color arrow_color=CLR_NONE){
	/*
		>Ver	:	0.0.0.7
		>Date	:	2013.09.05
		>History:		
					@0.0.0.7@2013.09.05@artamir	[*]	_OrderSend Добавил установку FOD
					@0.0.6@2013.04.22@artamir	[]	_OrderSend
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
	
	string fn="_OrderSend";
	
	//-----------------------------------------------------------
	// Блок проверок на правильность переданных параметров.
	//-----------------------------------------------------------
	
	//=============================================
	// Check symbol
	//=============================================
	if(symbol == ""){
					//если не задан нструмент, тогда используем текущий
		symbol = Symbol();
	}
	
	//------------------------------------------------------
	double dBid = MarketInfo(symbol, MODE_BID);
	double dAsk = MarketInfo(symbol, MODE_ASK);
	
	int STOPLEVEL = MarketInfo(symbol, MODE_STOPLEVEL);
	
	//=============================================
	// Check volume
	//=============================================
	double MINLOT = MarketInfo(symbol, MODE_MINLOT);
	double MAXLOT = MarketInfo(symbol, MODE_MAXLOT);
	
	//------------------------------------------------------
	int lMN = 0;
	
	//------------------------------------------------------
	if(volume < MINLOT){
		volume = MINLOT;
	}
	
	//------------------------------------------------------
	if(volume > MAXLOT){
		volume = MAXLOT;
	}
	
	//------------------------------------------------------
	if(price <= 0){
		
		//--------------------------------------------------
		if(cmd == OP_BUY){
			price = MarketInfo(symbol, MODE_ASK);
		}
		
		//--------------------------------------------------
		if(cmd == OP_SELL){
			price = MarketInfo(symbol, MODE_BID);
		}
	}
	
	//------------------------------------------------------
	if(slippage == 0){
		slippage = 0;
	}
	
	//------------------------------------------------------
	if(magic <= -1){
		lMN = TR_MN;	
	}else{
		lMN = magic;
	}	
	
	//======================================================
	// Normalizing
	//======================================================
	volume		= Norm_vol(volume);
	price		= Norm_symb(price);
	stoploss	= Norm_symb(stoploss);
	takeprofit	= Norm_symb(takeprofit);
	
	//------------------------------------------------------
	//{	=== Checking ability to send order
	
		//--------------------------------------------------
		if(cmd == OP_BUYSTOP){
			if(price <= (dAsk + STOPLEVEL*Point)){
				
				price = dAsk + STOPLEVEL*Point;
				
				//return(-1);
			}
		}
		
		//--------------------------------------------------
		if(cmd == OP_SELLSTOP){
			if(price >= (dBid - STOPLEVEL*Point)){
				
				price = dBid - STOPLEVEL*Point;
				//return(-1);
			}
		}
	//}
	
	//------------------------------------------------------
	int res = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, lMN, expiration, arrow_color);
	
	if(res > 0){
		OE_setSTD(res);
	}
	
	//------------------------------------------------------
	int err = GetLastError();
	
	if(err>0 && res<=0){
		Print(fn,": ERR send order!");
		Print(fn,". ERR=",err);
	}
	
	//------------------------------------------------------
	if(err == 130){
		Print("Bad stop", " cmd = ", cmd, " price = ", price, "stoploss = ", stoploss, "takeprofit = ", takeprofit, " Ask = ",Ask, " Bid = ", Bid);
	}
	
	return(res);
}

//}

//}

//{	//=== MODIFY 	====================================

bool _OrderModify(int ticket, double price, double stoploss, double takeprofit, datetime expiration, color clr=CLR_NONE){
	/*
		>Ver	:	0.0.0.5
		>Date	:	2013.12.31
		>History:	
					@0.0.0.5@2013.12.31@artamir	[*]	Добавлена проверка, если ордер уже закрыт.
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
	
	if(OrderCloseTime()>0) return(true);	//ордер уже закрыт и нефик его модифицировать.
	
	//------------------------------------------------------
	int type = OrderType();
	double dBid = MarketInfo(Symbol(), MODE_BID);
	double dAsk = MarketInfo(Symbol(), MODE_ASK);
	
	//------------------------------------------------------
	if(price <= -1){
		price = Norm_symb(OrderOpenPrice());
	}
	
	//------------------------------------------------------
	if(stoploss <= -1){
		stoploss = Norm_symb(OrderStopLoss());
	}
	
	//------------------------------------------------------
	if(takeprofit <= -1){
		takeprofit = Norm_symb(OrderTakeProfit());
	}
	
	//------------------------------------------------------
	if(expiration <= -1){
		expiration = OrderExpiration();
	}
	
	//------------------------------------------------------
	bool needModify = false;
	
	//...
	if(Norm_symb(price) != Norm_symb(OrderOpenPrice())){
		needModify = true;
	}
	
	//------------------------------------------------------
	if(Norm_symb(stoploss) != Norm_symb(OrderStopLoss())){
		needModify = true;
	}
	
	//------------------------------------------------------
	if(Norm_symb(takeprofit) != Norm_symb(OrderTakeProfit())){
		needModify = true;
	}
	
	//.
	
	//...	//checking if we could modify
		if(type == OP_BUY || type == OP_BUYSTOP){
			if(takeprofit > 0 && takeprofit < dBid){
				return(false);
			}
		}
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP){
			if(takeprofit > 0 && takeprofit > dAsk){
				return(false);
			}
		}
	//.
	
	//------------------------------------------------------
	if(needModify){
		bool res = OrderModify(ticket, price, stoploss, takeprofit, expiration, clr);
		
		//--------------------------------------------------
		int err = GetLastError();
		
		//--------------------------------------------------
		if(err == 130){
			Print("ti = ", ticket, " p = ",price," s = ",stoploss, " t = ", takeprofit);
		}
		
		//--------------------------------------------------
		if(err == 3){
			OrderPrint();
		}
		
		//--------------------------------------------------
		if(err == 1){
			Print(" ti = ", ticket, " takeprofit = ", DoubleToStr(takeprofit, Digits), " needModify = ",needModify);
		}
		//--------------------------------------------------
		return(res);
	}else{
		return(true);
	}	
}

bool TR_ModifyTP(int ticket, double tp, int mode = 1){
	/*
		>Ver	:	0.0.0.3
		>Date	:	2014.02.10
		>History:	
					@0.0.0.3@2014.02.10@artamir	[*]	Для режима тп в пунктах, если тп=0, то тп на тикет не ставится.
			@0.0.2@2012.09.20@artamir	[]
			@0.0.1@2012.08.20@artamir	[]
		>Description:
			Модификация тейкпрофита ордера. Тейкпрофит может быть задан в пунктах от цены открытия ордера или ценовым уровнем.
	*/
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	double newtp = tp;
	
	if(mode == TR_MODE_PIP){
		int type = OrderType();
		double op = OrderOpenPrice();
		//--------------------------------------------------
		if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){
			newtp = op+tp*Point;
		}
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT){
			newtp = op - tp*Point;
		}
		
		if(tp==0){newtp=0;}
	}
	
	return(_OrderModify(ticket, -1, -1, newtp, -1, CLR_NONE));
}

bool TR_ModifyPrice(int ticket, double price, int mode = 1){
	/**
		\version	0.0.0.1
		\date		2013.08.22
		\author		Morochin <artamir> Artiom
		\details	Модификация цены открытия отложенного ордера. Цена задается ценовым уровнем.
		\internal
			>Hist:
			>Rev:0
	*/

	//------------------------------------------------------
	if(mode == TR_MODE_PRICE){
		return(_OrderModify(ticket, price, -1, -1, -1, CLR_NONE));
	}	
	
	return(0);
}

bool TR_ModifyTPByTicket(int src_ti, int dest_ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.11
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Модифицирует тп для заданного тикета, как у тикета-источника
	*/
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(false);
	
	//------------------------------------------------------
	double src_tp = Norm_symb(OrderTakeProfit());
	
	//------------------------------------------------------
	return(TR_ModifyTP(dest_ti, src_tp));
}

bool TR_ModifySLByTicket(int src_ti, int dest_ti){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2014.02.10
		>Hist	:	
					@0.0.0.2@2014.02.10@artamir	[+]	TR_ModifySLByTicket
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Модифицирует тп для заданного тикета, как у тикета-источника
	*/
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(false);
	
	//------------------------------------------------------
	double src_sl = Norm_symb(OrderStopLoss());
	
	//------------------------------------------------------
	return(TR_ModifySL(dest_ti, src_sl));
}


bool TR_ModifySL(int ticket, double sl, int mode = 1){
	/*
		>Ver	:	0.0.0.4
		>Date	:	2014.02.10
		>History:	
					@0.0.0.4@2014.02.10@artamir	[*]	
		>Desc:
			Modify SL
		>Зависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	
	double newsl = sl;
	
	if(mode == TR_MODE_PIP){
		int type = OrderType();
		double op = OrderOpenPrice();
		//--------------------------------------------------
		if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){
			newsl = op-sl*Point;
		}
		
		//--------------------------------------------------
		if(type == OP_SELL || type == OP_SELLSTOP || type == OP_SELLLIMIT){
			newsl = op + sl*Point;
		}
	
		if(sl==0){newsl=0;}
	}
	
	return(_OrderModify(ticket, -1, newsl, -1, -1, CLR_NONE));
}

bool TR_ModifyPriceByTicket(int src_ti, int dest_ti){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.02.26
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	int src_ty = -1;
	double src_pr = 0.0;
	
	int dest_ty = -1;
	double dest_pr = 0.0;
	
	int addSPREAD = 0;
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(false);
	
	src_ty = OrderType();
	src_pr = OrderOpenPrice();
	
	if(!OrderSelect(dest_ti, SELECT_BY_TICKET)) return(false);
	
	dest_ty = OrderType();
	
	if(src_ty == OP_BUY){
		if(dest_ty == OP_SELLLIMIT){
			addSPREAD = -SPREAD;
		}
		
	}
	
	if(src_ty == OP_SELL){
		if(dest_ty == OP_BUYLIMIT){
			addSPREAD = SPREAD;
		}
	}
	
	if(src_ty == OP_BUYLIMIT){
		if(dest_ty == OP_SELLSTOP){
			addSPREAD = -SPREAD;
		}
	}
	
	if(src_ty == OP_SELLLIMIT){
		if(dest_ty == OP_BUYSTOP){
			addSPREAD = SPREAD;
		}
	}
	
	if(src_ty == OP_BUYSTOP){
		if(dest_ty == OP_SELLLIMIT){
			addSPREAD = -SPREAD;
		}
	}
	
	if(src_ty == OP_SELLSTOP){
		if(dest_ty == OP_BUYLIMIT){
			addSPREAD = SPREAD;
		}
	}
	
	return(TR_ModifyPrice(dest_ti, src_pr+addSPREAD*Point));
}

bool TR_ModifySLOnTP(int src_ti, int dest_ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.23
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	Устанавливает стоплосс дл тикета dest_ti на ценовой уровень тейкпрофита тикета src_ti с учетом спреда
	*/
	
	double src_tp = 0;
	int src_ty = -1;
	int addSPREAD = 0;
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(false);
	
	src_tp = OrderTakeProfit();
	src_ty = OrderType();
	
	if(src_ty == OP_BUY || src_ty == OP_BUYSTOP || src_ty == OP_BUYLIMIT){
		addSPREAD = SPREAD;
	}else{
		addSPREAD = -1*SPREAD;
	}
	
	return(TR_ModifySL(dest_ti, (src_tp+addSPREAD*Point), TR_MODE_PRICE));
}

bool TR_MoveOrder(int src_ti, double pr, int mode = 1){
	/**
		\version	0.0.3
		\date		2013.04.25
		\author		Morochin <artamir> Artiom
		\details	Передвигает отложенный ордер на заданную цену или на заданное кол. пунктов
					от цены открытия ордера.
		\warning	В определении дельты тп и сл используется плюсование единицы!!!!			
		\internal
			>Hist:			
					 @0.0.3@2013.04.25@artamir	[]	Изменил расчет новой цены тп и сл
					 @0.0.2@2013.04.25@artamir	[]	Добавил проверку на тип ордера, который нужно двигать
					 @0.0.1@2013.04.25@artamir	[]	TR_MoveOrder
	*/

	double	src_pr, src_tp, src_sl;
	double	new_pr, new_tp, new_sl;
	
	int src_ty; 
	double src_delta_tp, src_delta_sl;
	
	int delta_pips;
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET) ) return(false);
	
	src_pr = OrderOpenPrice();
	src_tp = OrderTakeProfit();
	src_sl = OrderStopLoss();
	src_ty = OrderType();
	
	src_delta_sl = MathAbs((Norm_symb(src_pr,"",2) - Norm_symb(src_sl,"",2)) / Point);
	src_delta_tp = MathAbs((Norm_symb(src_pr,"",2) - Norm_symb(src_tp,"",2)) / Point);
	
	if(mode == TR_MODE_PRICE){
		delta_pips = MathAbs(pr - src_pr);
		
		//--------------------------------------------------
		new_pr = Norm_symb(pr);
	}	
	
	if(mode == TR_MODE_PIP){
		delta_pips = pr;
		
		//--------------------------------------------------
		new_pr = src_pr + delta_pips*Point;
		new_pr = Norm_symb(new_pr);
	}
	
	if(src_tp > 0){
		if(src_ty == OP_BUYSTOP || src_ty == OP_BUYLIMIT){
			new_tp = new_pr + src_delta_tp*Point;
		}

		if(src_ty == OP_SELLSTOP || src_ty == OP_SELLLIMIT){
			new_tp = new_pr - src_delta_tp*Point;
		}	
	}else{
		new_tp = -1;
	}	

	if(src_sl > 0){
		if(src_ty == OP_BUYSTOP || src_ty == OP_BUYLIMIT){
			new_sl = new_pr - src_delta_sl*Point;
		}

		if(src_ty == OP_SELLSTOP || src_ty == OP_SELLLIMIT){
			new_sl = new_pr + src_delta_sl*Point;
		}
	}else{
			new_sl = -1;
	}

	new_tp = Norm_symb(new_tp);
	new_sl = Norm_symb(new_sl);
	
	//------------------------------------------------------
	return(_OrderModify(src_ti, new_pr, new_sl, new_tp, -1));
}

bool TR_MoveToOrder(	int dest_ti /** тикет-получатель */
					, 	int src_ti	/** тикет-источник*/){
	/**
		\version	0.0.0.1
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	Двигает ордер-получатель к ордеру-источнику с учетом спреда.
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.27@artamir	[]	TR_MoveToOrder
			>Rev:0
	*/
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)){return(false);}
	int src_ty = OrderType();
	double src_op = OrderOpenPrice();
	
	if(!OrderSelect(dest_ti, SELECT_BY_TICKET)){return(false);}
	int dest_ty = OrderType();
	double dest_op = OrderOpenPrice();
	
	int SPREAD = MarketInfo(Symbol(), MODE_SPREAD);
	int addSpread = 0;
	
	if(src_ty == OP_BUY || src_ty == OP_BUYSTOP || src_ty == OP_BUYLIMIT){
		if(dest_ty == OP_SELLSTOP || dest_ty == OP_SELLLIMIT){
			addSpread = -1*SPREAD;
		}
	}
	
	if(src_ty == OP_SELL || src_ty == OP_SELLSTOP || src_ty == OP_SELLLIMIT){
		if(dest_ty == OP_BUYSTOP || dest_ty == OP_BUYLIMIT){
			addSpread = SPREAD;
		}
	}
	
	return(TR_MoveOrder(dest_ti, (src_op+addSpread*Point)));
}

bool TR_ModifySLByPrice(int ti, int minus_pip = 0){
	/**
		\version	0.0.0.2
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Расчитывается стоплосс ордера от цены закрытия ордера.
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.17@artamir	[]	TR_ModifySLByPrice
					 @0.0.0.1@2013.05.15@artamir	[]	TR_ModifySLByPrice
			>Rev:0
	*/

	if(! OrderSelect(ti, SELECT_BY_TICKET)) return(false);
	
	int ty = OrderType();
	
	double new_sl = 0.00;
	
	if(ty == OP_BUY || ty == OP_BUYSTOP || ty == OP_BUYLIMIT){
		new_sl = Norm_symb(OrderClosePrice() - minus_pip*Point);
	}
	
	if(ty == OP_SELL || ty == OP_SELLSTOP || ty == OP_SELLLIMIT){
		new_sl = Norm_symb(OrderClosePrice() + minus_pip*Point);
	}
	
	return(TR_ModifySL(ti, new_sl));
}

//}

//{	//=== CLOSE 	====================================

bool TR_CloseByTicket(int ticket){
	/*
		>Ver	:	0.0.0.8
		>Date	:	2014.01.15
		>Hist:	
				 @0.0.0.8@2014.01.15@artamir	[!]	Добавлена проверка на время закрытия ордера.
			@0.0.6@2012.10.04@artamir	[]
			@0.0.5@2012.10.01@artamir	[]
			@0.0.4@2012.10.01@artamir	[+] add checking on err 138 
			@0.0.3@2012.10.01@artamir	[+] add setExtraIsClosedByTicket
			@0.0.2@2012.10.01@artamir	[]
			@0.0.1@2012.09.14@artamir	[]
		>Desc:
		Закрытие ордера по тикету. Если ордер - рыночный, то закрытие происходит по рынку, если ордер - отложенный, то он удаляется
	*/
	
	string fn="TR_CloseByTicket";
	//------------------------------------------------------
	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(true);
	
	if(OrderCloseTime()>0){
		OE_setSTD(ticket);
		return(true);
	}	
	
	//------------------------------------------------------
	if(OrderType() != OP_BUY && OrderType() != OP_SELL){
		return(OrderDelete(ticket));
	}
	
	//------------------------------------------------------
	double price = 0.00;//MI_MarketCloseByCMD(OrderType());
	
	price = Norm_symb(price);
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
			price = MarketInfo(OrderSymbol(), MODE_BID);
		}else{
			if(OrderType() == OP_SELL){
				price = MarketInfo(OrderSymbol(), MODE_ASK);
			}
		}
		
		//----------------------------------------------
		//price = libMI_getMarketClosePriceByCMD(OrderType());
		
		//----------------------------------------------
		price = Norm_symb(price);
		
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
		OE_setSTD(ticket);
	}
	
	if(!res){
		Print(fn," ERR:"+GetLastError());
	}
	
	//------------------------------------------------------
	return(res);
}

void TR_CloseAll(int mn=-1){
	/**
		\version	0.0.0.1
		\date		2013.09.29
		\author		Morochin <artamir> Artiom
		\details	Закрывает все ордера. Возможна фильтрация по магику
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.29@artamir	[]	TR_CloseAll
			>Rev:0
	*/

	int t=OrdersTotal();
	for(int i=t;i>=0;i--){
		if(!OrderSelect(i,SELECT_BY_POS, MODE_TRADES)){continue;}
		if(mn>0){
			if(OrderMagicNumber() != mn){continue;}
		}
		
		TR_CloseByTicket(OrderTicket());
	}
}

//}