	/*
		>Ver	:	0.0.0.51
		>Date	:	2014.01.08	
		>Hist	:																						
					@0.0.0.51@2014.01.08@artamir	[+]	OE_delClosed
			Необходимо исправление библиотеки для поиска значений функционалом библиотеки sysIndexedArray.mqh
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/

#define OE_VER	"0.0.0.51_2014.01.08"
#define OE_DATE	"2013.09.06"
	
//{	//=== ARRAY	
#define OE_NULL -19801028
//--- Main info
#define	OE_TI	0	//OrderTicket()
#define	OE_TY	1	//OrderType()
#define	OE_OP	2	//OrderOpenPrice()
#define OE_OOP	2	//то же самое что и пункт выше.
#define	OE_OT	3	//OrderOpenTime()
#define	OE_TP	4	//OrderTakeProfit()
#define	OE_SL	5	//OrderStopLoss()
#define	OE_MN	6	//OrderMagicNumber()
#define	OE_LOT	7	//OrderLots()
#define OE_OPR	8	//OrderProfit()
#define	OE_IT	9	//Is in Terminal() if order is in terminal
#define	OE_IM	10	//IsMarket() if order type is OP_BUY || OP_SELL
#define	OE_IP	11	//IsPending() if order type >= 2
#define OE_CT	12	//CloseTime()
#define OE_CP	13	//ClosePrice()
#define OE_IC	14	//IsClosed()

//--- Aditional info
//------ Parents
#define	OE_MP		15	//Main parent of the grid
#define	OE_LP		16	//Local parent
#define	OE_LP2		17	//Local parent
#define 	OE_SID		18	//ИД сессии.
#define OE_SSP		19	//Session Start Price/(для eOIW2. Цена старта новой сессии.)
//------ Partial close
#define	OE_FROM		20	//If was partial close 
//------ Grid
#define	OE_GT		25	//Grid type
#define	OE_GL		26	//Grid level
//------ First open data (FOD)
#define	OE_FOP		30	//First open price
#define	OE_FOT		31	//First	open time
#define	OE_FOOT		31	//First	open time
#define	OE_FOTY		32	//First open type
#define	OE_FOTI		33	//First open ticket
#define	OE_FOL		34	//First open lot
#define OE_FIR		35	//First is Revers? 0-main order, 1-revers order.
//------ Auto open data (AOD)
#define OE_AOM		40	//Auto open method
#define OE_AOTY		41	//Auto open type
//------ Close data
#define OE_CPP		45	//Close profit in pips with sign (-/+)
#define	OE_CTY		46	//Closed by sl/tp/from market (1,2,3);
#define OE_CP2SL	47	//Разность между ценой закрытия и сл в пунктах
#define OE_CP2TP	48	//Разность между ценой закрытия и тп в пунктах
#define OE_CP2OP	49	//Разность между ценой закрытия и ценой открытия в пунктах

//------ Other
#define	OE_OFF		50	//If expert do not work with this order
  

#define	OE_MAX		51
//----------------------------------------------------------
double	aOE[][OE_MAX];
//}

string OE2Str(int i){
	switch(i){
		case 0: return("OE_TI");
		case 1: return("OE_TY");
		case 2: return("OE_OOP");
		case 3: return("OE_OOT");
		case 4: return("OE_TP");
		case 5: return("OE_SL");
		case 6: return("OE_MN");
		case 7: return("OE_LOT");
		case 8: return("OE_OPR");
		case 9: return("OE_IT");
		case 10: return("OE_IM");
		case 11: return("OE_IP");
		case 12: return("OE_CT");
		case 13: return("OE_CP");
		case 14: return("OE_IC");
		
		case 45: return("OE_CPP(close profit in pips)");
		case 46: return("OE_CTY(closing type)");
		case 47: return("OE_CP2SL");
		case 48: return("OE_CP2TP");
		case 49: return("OE_CP2OP");
		default: return("UDF");
	}
}

//{	//=== PRIVATE
int OE_FIBT(int ti){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	return(OE_findIndexByTicket(ti));
}

int	OE_findIndexByTicket(int ticket){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(aOE, 0);
	
	//------------------------------------------------------
	int idx = -1;
	
	//------------------------------------------------------
	bool isFind = false;
	
	//------------------------------------------------------
	while(!isFind && idx < ROWS){
		
		//--------------------------------------------------
		idx++;
		
		//--------------------------------------------------
		int aOE_TI = aOE[idx][OE_TI];
		
		//--------------------------------------------------
		if(aOE_TI == ticket){
			
			//----------------------------------------------
			isFind = true;
		}
	}
	
	//------------------------------------------------------
	if(!isFind){
	
		//--------------------------------------------------
		return(-1);
	}
	
	//------------------------------------------------------
	return(idx);
}

int OE_ClosePriceSL(){
	/**
		\version	0.0.0.1
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Возвращает разность между ценой закрытия ордера и сл в пунктах с учетом типа ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.17@artamir	[]	OE_ClosePriceSL
			>Rev:0
	*/

	double sl = Norm_symb(OrderStopLoss());
	double cp = Norm_symb(OrderClosePrice());
	int ty = OrderType();
	
	int res = 0;
	
	if(sl == 0){
		return(0);
	}
	
	if(ty == OP_BUY || ty == OP_BUYSTOP || ty == OP_BUYLIMIT){
		res = (cp - sl)/Point;
	}
	
	if(ty == OP_SELL || ty == OP_SELLSTOP || ty == OP_SELLLIMIT){
		res = (sl - cp)/Point;
	}
	
	return(res);
}

int OE_ClosePriceTP(){
	/**
		\version	0.0.0.1
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Возвращает разность между ценой закрытия ордера и tp в пунктах с учетом типа ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.17@artamir	[]	OE_ClosePriceSL
			>Rev:0
	*/

	double tp = Norm_symb(OrderTakeProfit());
	double cp = Norm_symb(OrderClosePrice());
	int ty = OrderType();
	
	int res = 0;
	
	if(tp == 0){
		return(0);
	}
	
	if(ty == OP_BUY || ty == OP_BUYSTOP || ty == OP_BUYLIMIT){
		res = (tp - cp)/Point;
	}
	
	if(ty == OP_SELL || ty == OP_SELLSTOP || ty == OP_SELLLIMIT){
		res = (cp - tp)/Point;
	}
	
	return(res);
}

int OE_ClosePriceOP(){
	/**
		\version	0.0.0.1
		\date		2013.05.17
		\author		Morochin <artamir> Artiom
		\details	Возвращает разность между ценой закрытия ордера и сл в пунктах с учетом типа ордера.
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.17@artamir	[]	OE_ClosePriceSL
			>Rev:0
	*/

	double op = Norm_symb(OrderOpenPrice());
	double cp = Norm_symb(OrderClosePrice());
	int ty = OrderType();
	
	int res = 0;
	
	if(op == 0){
		return(0);
	}
	
	if(ty == OP_BUY || ty == OP_BUYSTOP || ty == OP_BUYLIMIT){
		res = (cp - op)/Point;
	}
	
	if(ty == OP_SELL || ty == OP_SELLSTOP || ty == OP_SELLLIMIT){
		res = (op - cp)/Point;
	}
	
	return(res);
}

//}

//{	//=== ADD ROW

int OE_addRow(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	int idx = Ad_AddRow2(aOE);
	
	aOE[idx][OE_TI] = ti;
	//------------------------------------------------------
	return(idx);
}

//}

//{	//=== STANDART DATA

int OE_setStandartDataByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int	idx = OE_FIBT(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		idx = OE_addRow(ti);
	}
	
	//------------------------------------------------------
	T_SelOrderByTicket(ti);
	
	//------------------------------------------------------
	OE_setStandartDataByOrder(idx);
	
	//------------------------------------------------------
	return(idx);
}

int OE_setStandartDataByOrder(int idx){
	/*
		>Ver	:	0.0.0.4
		>Date	:	2013.09.30
		>Hist	:	
					@0.0.0.4@2013.09.30@artamir	[+]	Добавлен OrderProfit()
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	string fn="OE_setStandartDataByOrder";
	//------------------------------------------------------
	aOE[idx][OE_TI] = OrderTicket();
	//------------------------------------------------------
	aOE[idx][OE_TY]	= OrderType();
	
	aOE[idx][OE_OP] = OrderOpenPrice();
	
	aOE[idx][OE_OT] = OrderOpenTime();
	
	aOE[idx][OE_TP] = OrderTakeProfit();
	
	aOE[idx][OE_SL] = OrderStopLoss();
	
	aOE[idx][OE_MN] = OrderMagicNumber();
	
	aOE[idx][OE_LOT] = OrderLots();
	
	aOE[idx][OE_CP] = OrderClosePrice();
	
	aOE[idx][OE_OPR] = OrderProfit();

	if(OrderCloseTime() <= 0){
		aOE[idx][OE_IT] = 1;
		aOE[idx][OE_IC] = 0;
	}else{
		aOE[idx][OE_IT] = 0;
		aOE[idx][OE_IC] = 1;
	}	
	
	if(OrderType() <= 1){
		aOE[idx][OE_IM] = 1;
		aOE[idx][OE_IP] = 0;
	}
	
	if(OrderType() >= 2){
		aOE[idx][OE_IM] = 0;
		aOE[idx][OE_IP] = 1;
	}
	
	
	//{	=== Расчетные данные по цене закрытия
	aOE[idx][OE_CP2SL] = OE_ClosePriceSL();
	aOE[idx][OE_CP2TP] = OE_ClosePriceTP();
	aOE[idx][OE_CP2OP] = OE_ClosePriceOP();
	//}
	
	//------------------------------------------------------
	return(0);
	
}

int OE_setFODByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.14
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(ti <= 0){
		return(-1);
	}

	int	idx = OE_findIndexByTicket(ti);	

	if(idx <= -1){
		idx = OE_addRow(ti);
	}
	
	//------------------------------------------------------
	T_SelOrderByTicket(ti);
	
	aOE[idx][OE_FOP] = OrderOpenPrice();
	
	aOE[idx][OE_FOTY] = OrderType();

	aOE[idx][OE_FOTI] = OrderTicket();

	aOE[idx][OE_FOL] = OrderLots();
	
	aOE[idx][OE_FOT] = OrderOpenTime();

	//------------------------------------------------------
	return(idx);
}

int OE_setChangeTYBuTicket(int ti, int new_ty = -1, int old_ty = -1){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/

	OE_setTYByTicket(ti, new_ty);
	
	if(new_ty <= 1){
		OE_setIMByTicket(ti, 1);
		OE_setIPByTicket(ti, 0);
	}else{
		OE_setIMByTicket(ti, 0);
		OE_setIPByTicket(ti, 1);
	}
}
//}

//{	//=== SET PROPERTIES

int	OE_setTYByTicket(int ti, int ty){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ty <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_TY] = ty;
	
	//------------------------------------------------------
	return(idx);
}

int	OE_setOPByTicket(int ti, double op){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(op < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_OP] = op;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setOTByTicket(int ti, int ot){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ot < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_OT] = ot;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setTPByTicket(int ti, double tp){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(tp < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_TP] = tp;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setSLByTicket(int ti, double sl){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(sl < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_SL] = sl;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setMNByTicket(int ti, int mn){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_MN] = mn;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setLOTByTicket(int ti, double lot){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(lot < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_LOT] = lot;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setMPByTicket(int ti, int mp){
	/*
		>Ver	:	0.0.0
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(mp < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_MP] = mp;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setLPByTicket(int ti, int lp){
	/*
		>Ver	:	0.0.0
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(lp < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_LP] = lp;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setLP2ByTicket(int ti, int lp){
	/*
		>Ver	:	0.0.0
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(lp < 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_LP2] = lp;
	
	//------------------------------------------------------
	return(idx);
}

int	OE_setIMByTicket(int ti, int status = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.06
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(status <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_IM] = status;
	
	//------------------------------------------------------
	return(idx);
}

int	OE_setIPByTicket(int ti, int status = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.06
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(status <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_IP] = status;
	
	//------------------------------------------------------
	return(idx);
}

int	OE_setGLByTicket(int ti, int gl = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.03.06
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(gl <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_GL] = gl;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setFIRByTicket(int ti, int fir = 0){
	/**
		\version	0.0.0.1
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.28@artamir	[]	OE_setFIRByTicket
			>Rev:0
	*/

	
	//------------------------------------------------------
	if(fir <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_FIR] = fir;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setFOOTByTicket(int ti, int foot = 0){
	/**
		\version	0.0.0.1
		\date		2013.06.28
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.06.28@artamir	[]	OE_setFOOTByTicket
			>Rev:0
	*/

	
	//------------------------------------------------------
	if(foot <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_FOOT] = foot;
	
	//------------------------------------------------------
	return(idx);
}


int OE_setSIDByTicket(int ti, int sid = 0){
	/**
		\version	0.0.0.1
		\date		2013.09.30
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.1@2013.09.30@artamir	[+]	OE_setSIDByTicket
			>Rev:0
	*/

	
	//------------------------------------------------------
	if(sid <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_SID] = sid;
	
	//------------------------------------------------------
	return(idx);
}

//}

//{	//=== SET AOM
int	OE_setAOMByTicket(int ti, int aom){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.20
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(aom <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_AOM] = aom;
	
	//------------------------------------------------------
	return(idx);
}
//}

//{	//=== CLOSE PROPS

int	OE_setITByTicket(int ti, int status = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.21
		>Hist	:
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	
	if(ti <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	if(status <= -1){
		
		//--------------------------------------------------
		if(!T_SelOrderByTicket(ti)){
			return(-1);
		}
		
		//--------------------------------------------------
		if(OrderCloseTime() > 0){
			status = 0;
		
		}else{
			status = 1;
		}
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
		
	//------------------------------------------------------
	aOE[idx][OE_IT] = status;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setCTByTicket(int ti, int ct = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.04
		>Hist	:
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(ct <= -1){
		
		//--------------------------------------------------
		if(!T_SelOrderByTicket(ti)){
			return(-1);
		}
		
		//--------------------------------------------------
		ct = OrderCloseTime();
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
		
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_CT] = ct;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setCPByTicket(int ti, double cp = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.04
		>Hist	:
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ti <= 0){
		return(-1);
	}
	
	//------------------------------------------------------
	if(cp <= -1){
		
		//--------------------------------------------------
		if(!T_SelOrderByTicket(ti)){
			return(-1);
		}
		
		//--------------------------------------------------
		cp = OrderClosePrice();
	}
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	aOE[idx][OE_CP] = cp;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setICByTicket(int ti, int status = -1){
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.04
		>Hist	:
			@0.0.2@2012.10.04@artamir	[]
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(ti <= 0) return(-1);
	
	//------------------------------------------------------
	if(status <= -1){
		
		//--------------------------------------------------
		if(!T_SelOrderByTicket(ti)){
			return(-1);
		}
		
		//--------------------------------------------------
		if(OrderCloseTime() > 0){
			status = 1;
		}else{
			status = 0;
		}
	}

	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	if(idx <= -1){
		return(-1);
	}
	
	//------------------------------------------------------
	aOE[idx][OE_IC] = status;
	
	//------------------------------------------------------
	return(idx);
}

int OE_setCPPByTicket(int ti){
	/*
		>Ver	:	0.0.2
		>Date	:	2013.02.22
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(ti < 0) return(OE_NULL);
	
	if(!T_SelOrderByTicket(ti)) return(OE_NULL);
	
	int idx = OE_findIndexByTicket(ti);
	
	if(idx <= -1){
		return(OE_NULL);
	}
	
	int pips = MathAbs((Norm_symb(OrderOpenPrice()) - Norm_symb(OrderClosePrice()))/Point);
	if(OrderProfit() < 0){
		pips = -1*pips;
	}
	
	aOE[idx][OE_CPP] = pips;
	
}

int OE_setCTYByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.22
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(ti < 0) return(-1);
	
	if(!T_SelOrderByTicket(ti)) return(-1);
	
	int idx = OE_findIndexByTicket(ti);
	
	if(idx <= -1){
		return(-1);
	}
	
	int ty = 0;
	
	if(Norm_symb(OrderClosePrice()) == Norm_symb(OrderStopLoss())){
		ty = 1;
	}else{
		if(Norm_symb(OrderClosePrice()) == Norm_symb(OrderTakeProfit())){
			ty = 2;
		}else{
			ty = 3;
		}
	}	
	
	aOE[idx][OE_CTY] = ty;
	
	return(idx);
}

int OE_setCloseByTicket(int ti){
	/*
		>Ver	:	0.0.0.6
		>Date	:	2013.09.30
		>Hist	:	
					@0.0.0.6@2013.09.30@artamir	[+]	Добавлена установка стандартных данных по тикету.
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = -1;
	
	//------------------------------------------------------
	OE_setStandartDataByTicket(ti);
	idx = OE_setITByTicket(ti, 0);
	idx = OE_setCTByTicket(ti);
	idx = OE_setCPByTicket(ti);
	
	idx = OE_setICByTicket(ti, 1);
	idx = OE_setCPPByTicket(ti);
	idx = OE_setCTYByTicket(ti);
	
	//------------------------------------------------------
	return(idx);
}

//}

//{	//=== GET

double	OE_getPropByIndex(int idx, int prop){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	//------------------------------------------------------
	if(idx <= -1){
		
		//--------------------------------------------------
		return(-1);
	}
	
	//------------------------------------------------------
	double val = aOE[idx][prop];
	
	//------------------------------------------------------
	return(val);
}
//}

//{	//====== BY TICKET
int		OE_getTYByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE_getPropByIndex(idx, OE_TY);
	
	//------------------------------------------------------
	return(val);
}

double	OE_getOPByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE_getPropByIndex(idx, OE_OP);
	
	//------------------------------------------------------
	val = Norm_symb(val);
	
	//------------------------------------------------------
	return(val);
}

double	OE_getOOPByTicket(int ti){
	return(OE_getOPByTicket(ti));
}

int		OE_getOTByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE_getPropByIndex(idx, OE_OT);
	
	//------------------------------------------------------
	return(val);
}

double	OE_getTPByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE_getPropByIndex(idx, OE_TP);
	
	//------------------------------------------------------
	val = Norm_symb(val);
	
	//------------------------------------------------------
	return(val);
}

double	OE_getSLByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE_getPropByIndex(idx, OE_SL);
	
	//------------------------------------------------------
	val = Norm_symb(val);
	
	//------------------------------------------------------
	return(val);
}

int		OE_getMNByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	int val = OE_getPropByIndex(idx, OE_MN);
	
	//------------------------------------------------------
	return(val);
}

double	OE_getLOTByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.10.03
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = OE_findIndexByTicket(ti);
	
	//------------------------------------------------------
	double val = OE_getPropByIndex(idx, OE_LOT);
	
	//------------------------------------------------------
	val = Norm_vol(val);
	
	//------------------------------------------------------
	return(val);
}

int		OE_getICByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.23
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_findIndexByTicket(ti);
	int val = OE_getPropByIndex(idx, OE_IC);
	
	return(val);
}

int		OE_getAOMByTicket(int ti){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.07.02
		>Hist	:	
					@0.0.0.2@2013.07.02@artamir	[]	OE_getAOMByTicket
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_FIBT(ti);
	int val = OE_getPropByIndex(idx, OE_AOM);
	
	return(val);
}

int		OE_getMPByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.01
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_FIBT(ti);
	int val = OE_getPropByIndex(idx, OE_MP);
	
	return(val);
}

int		OE_getGLByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.01
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_FIBT(ti);
	int val = OE_getPropByIndex(idx, OE_GL);
	
	return(val);
}

int		OE_getFOTYByTicket(int ti){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.01
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_FIBT(ti);
	int val = OE_getPropByIndex(idx, OE_FOTY);
	
	return(val);
}
//}


void OE_SortDesc(int col=0){
	/**
		\version	0.0.0.2
		\date		2013.11.05
		\author		Morochin <artamir> Artiom
		\details	Сортирует массив aOE по умолчанию по измерению OE_TI по убыванию.
		\internal
			>Hist:		
					 @0.0.0.2@2013.11.05@artamir	[]	OE_SortDesc
					 @0.0.0.1@2013.08.29@artamir	[]	OE_SortDesc
			>Rev:0
	*/

	//Ad_QuickSort2(aOE, -1,-1,col, A_MODE_DESC);
	//A_d_Sort2(aOE, ""+col+" >;");
	Ad_SortShell2(aOE, ""+col+" >;");
}

void OE_RecheckStatuses(){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.26
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	int ROWS = 0;
	int idx = 0;
	int ti = 0;
	
	ROWS = ArrayRange(aOE, 0);
	for(idx = 0; idx < ROWS; idx++){
		ti = aOE[idx][OE_TI];
		
		OE_setITByTicket(ti);
		OE_setICByTicket(ti);
		
		if(!T_SelOrderByTicket(ti)) continue;
		
		OE_setChangeTYBuTicket(ti, OrderType());
	}
}

int OE_CountIT(){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.21
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double d[][OE_MAX];
	
	A_eraseFilter();
	A_FilterAdd_AND(OE_IT,1,-1,AS_OP_EQ);
	
	A_d_Select(aOE, d);
	
	return(ArrayRange(d, 0));
}

int OE_CountLP(int lp = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.02
		>Hist	:
			@0.0.1@2013.03.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double d[][OE_MAX];
	A_eraseFilter();
	A_FilterAdd_AND(OE_LP, lp, -1, AS_OP_EQ);
	
	A_d_Select(aOE, d);
	
	return(ArrayRange(d, 0));
}

int OE_CountMP_NOT_LP(int mp = -1){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.02
		>Hist	:
			@0.0.1@2013.03.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double d[][OE_MAX];
	A_eraseFilter();
	A_FilterAdd_AND(OE_MP, mp, -1, AS_OP_EQ);
	A_FilterAdd_AND(OE_LP, mp, -1, AS_OP_NOT);
	
	A_d_Select(aOE, d);
	
	return(ArrayRange(d, 0));
}

void OE_eraseArray(){
	/*
		>Ver	:	0.0.0
		>Date	:
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	if(IsTesting()){
		if(OrdersTotal() == 0){
			ArrayResize(aOE, 0);
		}
	}
}

void OE_delClosed(){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Удаление закрытых ордеров из массива.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[]	OE_delClosed
			>Rev:0
	*/

	string fn="OE_delClosed";
	double t[][OE_MAX];
	ArrayResize(t,0);
	
	string f="";
	f=StringConcatenate(	OE_IT,"==1");
		
		int aI[];
		ArrayResize(aI,0);
		AId_Init2(aOE, aI);
		
		//-------------------------------------------
		OE_Select(aOE, aI, f);
		int rows=ArrayRange(aI,0);
		
		if(rows<=0)return;
		
		for(int idx = 0; idx < rows; idx++){
			Ad_CopyRow2To2(aOE, t, aI[idx]);
		}	
		
		ArrayResize(aOE,0);
		ArrayCopy(aOE,t,0,0,WHOLE_ARRAY);
}

void OE_Select(double &a[][], int &aI[], string f){
	/**
		\version	0.0.0.1
		\date		2013.12.13
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.12.13@artamir	[!]	Добавлен разбор >> и ==
			>Rev:0
	*/

	AId_eraseFilter();
	
	//1. Раскладываем строку f по разделителю " AND "
	string del=" AND ";
	string aAnd[];
	ArrayResize(aAnd,0);
	StringToArray(aAnd, f, del);
	int and_rows=ArrayRange(aAnd,0);

	for(int i=0;i<and_rows;i++){
		string e=aAnd[i];
		string aE[];
		
		//{		EQ "=="
		ArrayResize(aE,0);
		StringToArray(aE,e,"==");
		int e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			int col=StrToInteger(aE[0]);
			double val=StrToDouble(aE[1]);
			
			AId_FilterAdd_AND(col,val,val,AI_AS_OP_EQ);	
		}
		
		//..	GREAT ">>"
		ArrayResize(aE,0);
		StringToArray(aE,e,">>");
		e_rows=ArrayRange(aE,0);
		if(e_rows>1){
			col=StrToInteger(aE[0]);
			val=StrToDouble(aE[1]);
			
			AId_FilterAdd_AND(col,val,val,AI_AS_OP_GREAT);	
		}	
		//}
	
	}
	
	//-------------------------------------------
	AId_Select2(a,aI);
}
