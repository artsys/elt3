	/**
		\version	0.0.0.8
		\date		2013.07.02
		\author		Morochin <artamir> Artiom
		\details	Trading functtions.
		\internal
			>Hist:								
	*/


extern string	TR_S = "==== TRADING ======================";
extern double	TR_TwiseLots	= 20.0;						// ����� ������������ �������, ����� �������� ����� ������� ������� �� ���
extern int		TR_MN = 0;									// ���������� ����� �������.
extern string	TR_E = "===================================";

//{	//=== SENDING	====================================

//{	//=== PUBLIC	====================================

//{	//====== PENDING ORDERS ============================

int TR_SendBUYSTOP(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/**
		\version	0.0.1
		\date		2013.04.22
		\author		Morochin <artamir> Artiom
		\details	������� ����������� ����������� ������� ������.
					��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
					���������� � �������� �������������� ������ �� ���� ����������� ������.
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
}

int TR_SendBUYSTOP_array(double &d[], double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.04.22
		>Hist:	
				 @0.0.2@2013.04.22@artamir	[]	TR_SendBUYSTOP_array
		>Desc:
			������� ����������� ���������� ������� �������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
			��������� ������� ������� ������� �� ��������� ������.
		>VARS:
			@double &d[]:	������, � ������� ������������ ������ ������������ �������.
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
	
	ArrayResize(d,0);
	
	
	SendPrice = Norm_symb((StartPrice + AddPips*Point));
	
	//------------------------------------------------------
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice + TPPip*Point);
	}
	
	//--------------
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
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend("", OP_BUYSTOP, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
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
}

int TR_SendBUYLIMIT_array(double &d[], double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.04.22
		>Hist:	
				 @0.0.3@2013.04.22@artamir	[]	TR_SendBUYLIMIT_array
		>Desc:
			������� ����������� ���������� ������� �������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
			��������� ������� ������� ������� �� ��������� ������.
		>VARS:
			@double &d[]:	������, � ������� ������������ ������ ������������ �������.
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
	
	ArrayResize(d,0);
	
	
	SendPrice = Norm_symb((StartPrice + AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice + TPPip*Point);
	}
	
	//--------------
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
	
	//----------------------------------------------------
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend("", OP_BUYLIMIT, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
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
}

int TR_SendBUYLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.07.31
		>History:
			@0.0.1@2012.07.31@artamir	[+] Start
			@0.0.1@2012.07.31@artamir	[*]	�������� ������ ���� �� � �� ������ �� ���� ����������� ������.
		>Description:
			������� ����������� ����������� �������� ������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
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
			@0.0.3@2012.08.03@artamir	[*] ������� ��������� ������
			@0.0.2@2012.08.03@artamir	[]
			@0.0.2@2012.07.31@artamir	[*] �������� ������ ��������� 
			@0.0.1@2012.07.31@artamir	[*]	�������� ������ ���� �� � �� ������ �� ���� ����������� ������.
		>Description:
			������� ����������� ����������� �������� ������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
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

int TR_SendSELLSTOP_array(double &d[], double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.22
		>Hist:
		>Desc:
			������� ����������� ���������� ������� �������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
			��������� ������� ������� ������� �� ��������� ������.
		>VARS:
			@double &d[]:	������, � ������� ������������ ������ ������������ �������.
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
	
	ArrayResize(d,0);
	
	
	SendPrice = Norm_symb((StartPrice - AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice - TPPip*Point);
	}
	
	//--------------
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
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend("", OP_SELLSTOP, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
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
}

int TR_SendSELLLIMIT_array(double &d[], double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.26
		>Hist:
		>Desc:
			������� ����������� ���������� ������� �������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
			��������� ������� ������� ������� �� ��������� ������.
		>VARS:
			@double &d[]:	������, � ������� ������������ ������ ������������ �������.
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
	
	ArrayResize(d,0);
	
	
	SendPrice = Norm_symb((StartPrice - AddPips*Point));
	
	//--------------
	if(TPPip > 0){
		TPPrice	= Norm_symb(SendPrice - TPPip*Point);
	}
	
	//--------------
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
	countSends = _TR_CountOrdersToSend(Vol);
	
	for(ns = 0; ns < countSends; ns++){
		sendVol = MathMin(rest_vol, TR_TwiseLots);
		
		sendVol = Norm_vol(sendVol);
		
		ticket = _OrderSend("", OP_SELLLIMIT, sendVol, SendPrice, 0, SLPrice, TPPrice, Comm, mn);
		
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
}

int TR_SendSELLLIMIT(double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
/*
		>Ver	:	0.0.1
		>Date	:	2012.08.03
		>History:
			@0.0.1@2012.08.03@artamir	[*] ������� ��������� �������
			@0.0.2@2012.07.31@artamir	[*] �������� ������ ��������� 
			@0.0.1@2012.07.31@artamir	[*]	�������� ������ ���� �� � �� ������ �� ���� ����������� ������.
		>Description:
			������� ����������� ����������� ��������� ������.
			��� ��������, ������� ������������ ����������� ������ � ��������� ������������ � ����������.
			���������� � �������� �������������� ������ �� ���� ����������� ������.
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
		>Desc	:	����������� �������, �������� ��������� ������.
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
	
}

int TR_SendPending_array(double &d[], int type, double StartPrice, int AddPips = 0, double Vol = 0.01, int TPPip = 0, int SLPip = 0, string Comm = "", int Magic = -1){
	/**
		\version	0.0.0.1
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.28@artamir	[]	TR_SendPending_array
			>Rev:0
	*/
	
	if(type == OP_BUYSTOP	){return(TR_SendBUYSTOP_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic));}
	if(type == OP_BUYLIMIT	){return(TR_SendBUYLIMIT_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic));}
	if(type == OP_SELLSTOP	){return(TR_SendSELLSTOP_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic));}
	if(type == OP_SELLLIMIT	){return(TR_SendSELLLIMIT_array	(d,StartPrice,AddPips,Vol,TPPip,SLPip,Comm,Magic));}
}
//}

//{	//====== MARKET ORDERS	============================

int TR_SendBUY(double vol = 0.01){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/

	int ticket = _OrderSend(Symbol(), OP_BUY, vol);
	
	//------------------------------------------------------
	return(ticket);
}

int TR_SendSELL(double vol = 0.01){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/

	int ticket = _OrderSend(Symbol(), OP_SELL, vol);
	
	//------------------------------------------------------
	return(ticket);
}

//}

//{	//====== REVERS ORDERS	============================
int TR_getReversType(int src_ty = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.26
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	��������� ���� ������ ��� ����������� ���������� ������ (������ � ��������������� �����������) �� ��������� ���� � �� ��� �� ������� ������, ��� � �����-��������.
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
		>Desc	:	����������� ��������� ������� �� ��������� ������ �� ��������� ������-��������.
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
int	_TR_CountOrdersToSend(double all_vol = 0){
	/*
		>Ver	:	0.0.0.1
		>Date	:	2013.07.02
		>Hist	:	
					@0.0.0.1@2013.07.02@artamir	[]	������� �������� ���������� ���������� ������������ �������.
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	������ ���������� ������������ ������� ��� ������ ������, ����������� ����������� �������� �����. ������������ ����� �������� � ���������� TR_TwiseLots.
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
		>Ver	:	0.0.6
		>Date	:	2013.04.22
		>History:	
					@0.0.6@2013.04.22@artamir	[]	_OrderSend
			@0.0.3@2012.10.01@artamir	[]
			@0.0.2@2012.09.20@artamir	[+] checking price for sending order.
			@0.0.1@2012.09.20@artamir	[]
		>Description:
			������� �������� ������� �� �������� ������ �� ������.
		>����������� ����������:
			libMarketInfo
			libNormalize
	*/
	
	//-----------------------------------------------------------
	// ���������������� ����������
	//-----------------------------------------------------------
	
	//-----------------------------------------------------------
	// ���� �������� �� ������������ ���������� ����������.
	//-----------------------------------------------------------
	
	//=============================================
	// Check symbol
	//=============================================
	if(symbol == ""){
					//���� �� ����� ���������, ����� ���������� �������
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
		OE_setStandartDataByTicket(res);
	}
	
	//------------------------------------------------------
	int err = GetLastError();
	
	//------------------------------------------------------
	if(err == 130){
		Print("Bad stop", " cmd = ", cmd, " price = ", price, "stoploss = ", stoploss, "takeprofit = ", takeprofit, " Ask = ",Ask, " Bid = ", Bid);
	}
	
	return(res);
}

//}

//}

//{	//=== MODIFY 	====================================

#define TR_MODE_PRICE 1
#define TR_MODE_PIP	2 

bool _OrderModify(int ticket, double price, double stoploss, double takeprofit, datetime expiration, color clr=CLR_NONE){
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
		>����������� ����������:
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
			Print(OrderPrint());
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
		>Ver	:	0.0.2
		>Date	:	2012.09.20
		>History:
			@0.0.2@2012.09.20@artamir	[]
			@0.0.1@2012.08.20@artamir	[]
		>Description:
			����������� ����������� ������. ���������� ����� ���� ����� � ������� �� ���� �������� ������ ��� ������� �������.
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
	}
	
	return(_OrderModify(ticket, -1, -1, newtp, -1, CLR_NONE));
}

bool TR_ModifyPrice(int ticket, double price, int mode = 1){
	/**
		\version	0.0.0.1
		\date		2013.08.22
		\author		Morochin <artamir> Artiom
		\details	����������� ���� �������� ����������� ������. ���� �������� ������� �������.
		\internal
			>Hist:
			>Rev:0
	*/

	//------------------------------------------------------
	if(mode == TR_MODE_PRICE){
		return(_OrderModify(ticket, price, -1, -1, -1, CLR_NONE));
	}	
}

bool TR_ModifyTPByTicket(int src_ti, int dest_ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.11
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:	������������ �� ��� ��������� ������, ��� � ������-���������
	*/
	
	if(!OrderSelect(src_ti, SELECT_BY_TICKET)) return(false);
	
	//------------------------------------------------------
	double src_tp = Norm_symb(OrderTakeProfit());
	
	//------------------------------------------------------
	return(TR_ModifyTP(dest_ti, src_tp));
}

bool TR_ModifySL(int ticket, double sl, int mode = 1){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.02.15
		>History:
		>Desc:
			Modify SL
		>����������� ����������:
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
		>Desc	:	������������� �������� �� ������ dest_ti �� ������� ������� ����������� ������ src_ti � ������ ������
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
		\details	����������� ���������� ����� �� �������� ���� ��� �� �������� ���. �������
					�� ���� �������� ������.
		\warning	� ����������� ������ �� � �� ������������ ���������� �������!!!!			
		\internal
			>Hist:			
					 @0.0.3@2013.04.25@artamir	[]	������� ������ ����� ���� �� � ��
					 @0.0.2@2013.04.25@artamir	[]	������� �������� �� ��� ������, ������� ����� �������
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

bool TR_MoveToOrder(	int dest_ti /** �����-���������� */
					, 	int src_ti	/** �����-��������*/){
	/**
		\version	0.0.0.1
		\date		2013.06.27
		\author		Morochin <artamir> Artiom
		\details	������� �����-���������� � ������-��������� � ������ ������.
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
		\details	������������� �������� ������ �� ���� �������� ������.
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
		>Ver	:	0.0.7
		>Date	:	2013.02.24
		>Hist:
			@0.0.6@2012.10.04@artamir	[]
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
			price = MarketInfo(Symbol(), MODE_BID);
		}else{
			if(OrderType() == OP_SELL){
				price = MarketInfo(Symbol(), MODE_ASK);
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
		OE_setCloseByTicket(ticket);
	}
	
	//------------------------------------------------------
	return(res);
}

//}