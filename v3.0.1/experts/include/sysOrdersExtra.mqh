	/*
		>Ver	:	0.0.40
		>Date	:	2013.04.16
		>Hist	:																						
					@0.0.39@2013.03.06@artamir	[]	OE_setGLByTicket
					@0.0.38@2013.03.06@artamir	[]	OE_setIMByTicket
					@0.0.37@2013.03.06@artamir	[]	OE_setIPByTicket
					@0.0.36@2013.03.06@artamir	[]	
			@0.0.35@2013.03.02@artamir	[]
					@0.0.34@2013.02.26@artamir	[]	OE_RecheckStatuses
					@0.0.33@2013.02.26@artamir	[]	OE_setCloseByTicket
					@0.0.32@2013.02.26@artamir	[]	OE_setStandartDataByOrder
					@0.0.31@2013.02.25@artamir	[]	
					@0.0.30@2013.02.23@artamir	[]	OE_getICByTicket
					@0.0.29@2013.02.22@artamir	[]	OE_setCPPByTicket
					@0.0.28@2013.02.22@artamir	[*]	OE_setCloseByTicket
					@0.0.27@2013.02.22@artamir	[+]	OE_setCTYByTicket
					@0.0.26@2013.02.22@artamir	[+]	OE_setCPPByTicket
					@0.0.25@2013.02.22@artamir	[]	
					@0.0.24@2013.02.21@artamir	[]	OE_CountIT
					@0.0.23@2013.02.21@artamir	[]	OE_setITByTicket
					@0.0.22@2013.02.20@artamir	[]	OE_setAOMByTicket
					@0.0.21@2013.02.20@artamir	[]	OE_setStandartDataByOrder
					@0.0.20@2013.02.20@artamir	[+] Добавлены новые колонки	
					@0.0.19@2013.02.16@artamir	[*]	OE_setCloseByTicket
						Исправлены функции установки данных закрытия ордера.
					@0.0.17@2013.02.14@artamir	[+]	OE_setFODByTicket
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
//{	//=== ARRAY	
#define OE_NULL -19801028
//--- Main info
#define	OE_TI	0	//OrderTicket()
#define	OE_TY	1	//OrderType()
#define	OE_OP	2	//OrderOpenPrice()
#define	OE_OT	3	//OrderOpenTime()
#define	OE_TP	4	//OrderTakeProfit()
#define	OE_SL	5	//OrderStopLoss()
#define	OE_MN	6	//OrderMagicNumber()
#define	OE_LOT	7	//OrderLots()
#define OE_OP	8	//OrderProfit()
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
#define OE_LP2		17	//Local parent
//------ Partial close
#define	OE_FROM		20	//If was partial close 
//------ Grid
#define	OE_GT		25	//Grid type
#define	OE_GL		26	//Grid level
//------ First open data (FOD)
#define	OE_FOP		30	//First open price
#define	OE_FOT		31	//First	open time
#define	OE_FOTY		32	//First open type
#define	OE_FOTI		33	//First open ticket
#define	OE_FOL		34	//First open lot
//------ Auto open data (AOD)
#define OE_AOM		40	//Auto open method
#define OE_AOTY		41	//Auto open type
//------ Close data
#define OE_CPP		45	//Close profit in pips with sign (-/+)
#define	OE_CTY		46	//Closed by sl/tp/from market (1,2,3);
//------ Other
#define	OE_OFF		50	//If expert do not work with this order
  

#define	OE_MAX		51
//----------------------------------------------------------
double	aOE[][OE_MAX];
//}

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
	
	//------------------------------------------------------
	A_d_setArray(aOE);
	
	//------------------------------------------------------
	int idx = A_d_addRow();
	
	//------------------------------------------------------
	A_d_setPropByIndex(idx, OE_TI, ti);
	
	//------------------------------------------------------
	A_d_releaseArray(aOE);
	
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
	int	idx = OE_findIndexByTicket(ti);
	
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
		>Ver	:	0.0.3
		>Date	:	2013.02.26
		>Hist	:
			@0.0.1@2012.10.03@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
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
	
	if(Debug && BP_OE){
		BP("setStandartDataByOrder", "idx = ", idx, "OCP = ", OrderClosePrice());
	}
	
	if(OrderCloseTime() <= 0){
		aOE[idx][OE_IT] = 1;
		aOE[idx][OE_IC] = 0;
	}	
	
	if(OrderType() <= 1){
		aOE[idx][OE_IM] = 1;
		aOE[idx][OE_IP] = 0;
	}
	
	if(OrderType() >= 2){
		aOE[idx][OE_IM] = 0;
		aOE[idx][OE_IP] = 1;
	}
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
	
	if(Debug && BP_OE){
		BP("setITByTicket", "status = ", status);
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
	
	if(Debug && BP_OE){
		BP("setCTByTicket()","idx = ",idx,"ct = ",ct);
	}	
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
	
	if(Debug && BP_OE){
		BP("setCTYByTicket", "ty = ", ty);
	}
	
	return(idx);
}

int OE_setCloseByTicket(int ti){
	/*
		>Ver	:	0.0.5
		>Date	:	2013.02.26
		>Hist	:
			@0.0.1@2012.10.04@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	int idx = -1;
	
	//------------------------------------------------------
	idx = OE_setITByTicket(ti, 0);
	idx = OE_setCTByTicket(ti);
	idx = OE_setCPByTicket(ti);
	if(Debug && BP_OE){
		BP("setCloseByTicket()","idx = ",idx);
	}	
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
		>Ver	:	0.0.1
		>Date	:	2013.03.01
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int idx = OE_FIBT(ti);
	int val = OE_getPropByIndex(idx, OE_IC);
	
	return(val);
}
//}


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
	
	if(Debug && BP_OE){
		BP("OE_CountIT");
	}
	
	A_d_Select(aOE, d);
	
	if(Debug	&& BP_OE){
		A_d_PrintArray2(aOE,4,"CountIT_aOE");
		A_d_PrintArray2(d,4,"CountIT_d");
		A_d_PrintArray2(A_Filter,"CountIT_filt");
	}
	
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