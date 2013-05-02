	/*
		>Ver	:	0.0.27
		>Date	:	2013.03.06
		>Hist	:																							
					@0.0.27@2013.03.06@artamir	[]	
					@0.0.26@2013.03.06@artamir	[]	
			@0.0.25@2013.03.02@artamir	[]
			@0.0.24@2013.03.02@artamir	[]
			@0.0.23@2013.03.01@artamir	[]
					@0.0.22@2013.03.01@artamir	[+]	AO_PB2MA_FilterALL
					@0.0.21@2013.02.26@artamir	[]
					@0.0.6@2013.02.21@artamir	[]	AO_PB2MA_CheckPendOrders(): Добавлен трейлинг для МА2 и МА3 	
					@0.0.5@2013.02.21@artamir	[+] AO_PB2MA_CheckPendOrders()	
					@0.0.4@2013.02.21@artamir	[]	
					@0.0.3@2013.02.21@artamir	[*]	AO_PB2MA_OpenBySig: добавлены открытия по различным методам :)
					@0.0.2@2013.02.20@artamir	[]	AO_PB2MA_OpenBySig
						исправлен контроль открытых ордеров по заданному методу
					@0.0.1@2013.02.20@artamir	[]	
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
extern	string	AO_PB2MA_1 = "=== START PRICE BETWEEN 2 MA ===";
extern	bool	AO_PB2MA_Use = false;
extern	int		AO_PB2MA_MA1_per	= 16;
extern	int		AO_PB2MA_MA2_per	= 64;
extern	int		AO_PB2MA_MA3_per	= 256;
extern	int		AO_PB2MA_MA4_per	= 1024;
extern	int		AO_PB2MA_TP = 50;
extern	int		AO_PB2MA_SL = 20;
extern	double	AO_PB2MA_Lot1	= 0.1;
extern	double	AO_PB2MA_Lot2	= 0.2;
extern	bool	AO_PB2MA_revers = false;

int		AO_PB2MA_OpenLastMinutes = -1;	//check if was open any orders last 10 min.
extern	string	AO_PB2MA_2 = "=== END   PRICE BETWEEN 2 MA ===";


//{	@VARS

//}

void AO_PB2MA_Main(){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.02.24
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	int ma1_per = AO_PB2MA_MA1_per;
	int ma2_per = AO_PB2MA_MA2_per;
	int ma3_per = AO_PB2MA_MA3_per;
	int ma4_per = AO_PB2MA_MA4_per;
	
	AO_PB2MA_CheckPendOrders(ma1_per, ma2_per, ma3_per);
	
	int signal12	= SG_PB2MA_Get(ma1_per, ma2_per, Close[1]);
	int signal23	= SG_PB2MA_Get(ma2_per, ma3_per, Close[1]);
	int signal34	= SG_PB2MA_Get(ma3_per, ma4_per, Close[1]);
	
	AO_PB2MA_OpenBySig(signal12, ma1_per, 1);
	AO_PB2MA_OpenBySig(signal23, ma2_per, 2);
	AO_PB2MA_OpenBySig(signal34, ma3_per, 3);
	
	AO_PB2MA_CheckBezUbitok();
	
	AO_PB2MA_DelUnused();
	
}

int AO_PB2MA_OpenBySig(int signal, int ma_per, int methodID = 1){
	/*
		>Ver	:	0.0.7
		>Date	:	2013.02.22
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	double d[][OE_MAX];
	double aTI[];
	int method = 0;
	double ma = iMA_getMA(ma_per);
	
	int ti = 0;
	int ROWS = 0;
	int idx = 0;
	int ti_rev = 0; 										//revers order.
	
	if(signal == OP_BUYSTOP){
		
		if(methodID == 1){
			method = AOM_PB2MA1_B;
		}
		
		if(methodID == 2){
			method = AOM_PB2MA2_B;
		}
		
		if(methodID == 3){
			method = AOM_PB2MA3_B;
		}
		
		AOM_getOrdersByMethod(d, method, AO_PB2MA_OpenLastMinutes);
		
		if(ArrayRange(d,0) == 0){
			
			if(!AO_PB2MA_revers){
				ROWS = TR_SendBUYSTOP_array(aTI , ma, 0, AO_PB2MA_Lot1 ,0 ,0 ,method);
			}else{
				ROWS = TR_SendSELLLIMIT_array(aTI , ma, 0, AO_PB2MA_Lot1, 0, 0, method);
			}	
		}
	}
	
	if(signal == OP_SELLSTOP){
		if(methodID == 1){
			method = AOM_PB2MA1_S;
		}
		
		if(methodID == 2){
			method = AOM_PB2MA2_S;
		}
		
		if(methodID == 3){
			method = AOM_PB2MA3_S;
		}
		AOM_getOrdersByMethod(d, method, AO_PB2MA_OpenLastMinutes);
		
		if(ArrayRange(d,0) == 0){
			if(!AO_PB2MA_revers){
				ROWS = TR_SendSELLSTOP_array(aTI, ma, 0, AO_PB2MA_Lot1 ,0 ,0 ,method);
			}else{
				ROWS = TR_SendBUYLIMIT_array(aTI, ma, 0, AO_PB2MA_Lot1, 0, 0, method);
			}	
		}	
	}
	
	if(ROWS > 0){
		for(idx = 0; idx < ROWS; idx++){
			ti = aTI[idx];
			TR_ModifyTP(ti, AO_PB2MA_TP, TR_MODE_PIP);
			TR_ModifySL(ti, AO_PB2MA_SL, TR_MODE_PIP);
			OE_setStandartDataByTicket(ti);
			OE_setAOMByTicket(ti, method);
			OE_setFODByTicket(ti);
			
			ti_rev = TR_SendREVERSOrder(ti, AO_PB2MA_Lot2);
			TR_ModifyTP(ti_rev, AO_PB2MA_TP, TR_MODE_PIP);
			TR_ModifySLOnTP(ti, ti_rev);
			OE_setStandartDataByTicket(ti_rev);
			OE_setAOMByTicket(ti_rev, method);
			OE_setMPByTicket(ti_rev, ti);
			OE_setLPByTicket(ti_rev, ti);
			OE_setGLByTicket(ti_rev, 1);
		}	
	}
}

int AO_PB2MA_CheckPendOrders(int ma1_per, int ma2_per, int ma3_per){
	/*
		>Ver	:	0.0.5
		>Date	:	2013.02.25
		>Hist	:
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/

	double ma1 = iMA_getMA(ma1_per);
	double ma2 = iMA_getMA(ma2_per);
	double ma3 = iMA_getMA(ma3_per);
	
	int idx_row;
	
	double d[][OE_MAX];
	double dd[][OE_MAX];
	
	//{ --- MA1
	ArrayResize(d,0);
	A_eraseFilter();
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA1_B	,-1, AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA1_S	,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MP, 0			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_LP, 0			,-1, AS_OP_EQ);
	A_d_Select(aOE, d);
	
	int ROWS = ArrayRange(d, 0);
	if(Debug && BP_PB2MA){
		A_d_PrintArray2(d, 4, "PB2MA1_B");
	}
	
	for(idx_row = 0; idx_row < ROWS; idx_row++){
		int ti = d[idx_row][OE_TI];
		TR_ModifyPrice(ti, ma1, TR_MODE_PRICE);
		TR_ModifyTP(ti, AO_PB2MA_TP, TR_MODE_PIP);
		TR_ModifySL(ti, AO_PB2MA_SL, TR_MODE_PIP);
		
		ArrayResize(dd,0);
		A_eraseFilter();
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA1_B	,-1, AS_OP_EQ);
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA1_S	,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_LP, Norm_symb(ti),-1, AS_OP_EQ);
		
		A_d_Select(aOE, dd);
		
		int dd_ROWS = ArrayRange(dd,0);
		
		if(Debug && BP_PB2MA){
			//BP("AO_PB2MA_CheckPendOrders", "dd_ROWS = ", dd_ROWS);
		}
		
		for(int dd_idx_row = 0; dd_idx_row < dd_ROWS; dd_idx_row++){
			int ti_rev = dd[dd_idx_row][OE_TI];
			TR_ModifyPriceByTicket(ti, ti_rev);
			TR_ModifyTP(ti_rev , AO_PB2MA_TP, TR_MODE_PIP);
			TR_ModifySLOnTP(ti, ti_rev);
		}
	}
	//}
	
	
	//{ --- MA2
	ArrayResize(d,0);
	A_eraseFilter();
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA2_B	,-1, AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA2_S	,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MP, 0			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_LP, 0			,-1, AS_OP_EQ);
	A_d_Select(aOE, d);
	
	ROWS = ArrayRange(d, 0);
	if(Debug && BP_PB2MA){
		A_d_PrintArray2(d, 4, "PB2MA2_B");
	}
	
	for(idx_row = 0; idx_row < ROWS; idx_row++){
		ti = d[idx_row][OE_TI];
		TR_ModifyPrice(ti, ma2, TR_MODE_PRICE);
		TR_ModifyTP(ti, AO_PB2MA_TP, TR_MODE_PIP);
		TR_ModifySL(ti, AO_PB2MA_SL, TR_MODE_PIP);
		
		ArrayResize(dd,0);
		A_eraseFilter();
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA2_B	,-1, AS_OP_EQ);
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA2_S	,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_LP, Norm_symb(ti),-1, AS_OP_EQ);
		
		A_d_Select(aOE, dd);
		
		dd_ROWS = ArrayRange(dd,0);
		
		if(Debug && BP_PB2MA){
			//BP("AO_PB2MA_CheckPendOrders", "dd_ROWS = ", dd_ROWS);
		}
		
		for(dd_idx_row = 0; dd_idx_row < dd_ROWS; dd_idx_row++){
			ti_rev = dd[dd_idx_row][OE_TI];
			TR_ModifyPriceByTicket(ti, ti_rev);
			TR_ModifyTP(ti_rev , AO_PB2MA_TP, TR_MODE_PIP);
			TR_ModifySLOnTP(ti, ti_rev);
		}
	}
	//}
	
	
	//{ --- MA3
	ArrayResize(d,0);
	A_eraseFilter();
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA3_B	,-1, AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM, AOM_PB2MA3_S	,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_MP, 0			,-1, AS_OP_EQ);
	A_FilterAdd_AND(OE_LP, 0			,-1, AS_OP_EQ);
	A_d_Select(aOE, d);
	
	ROWS = ArrayRange(d, 0);
	if(Debug && BP_PB2MA){
		A_d_PrintArray2(d, 4, "PB2MA3_B");
	}
	
	for(idx_row = 0; idx_row < ROWS; idx_row++){
		ti = d[idx_row][OE_TI];
		TR_ModifyPrice(ti, ma3, TR_MODE_PRICE);
		TR_ModifyTP(ti, AO_PB2MA_TP, TR_MODE_PIP);
		TR_ModifySL(ti, AO_PB2MA_SL, TR_MODE_PIP);
		
		ArrayResize(dd,0);
		A_eraseFilter();
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA3_B	,-1, AS_OP_EQ);
		A_FilterAdd_OR(OE_AOM, AOM_PB2MA3_S	,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IT, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_IP, 1			,-1, AS_OP_EQ);
		A_FilterAdd_AND(OE_LP, Norm_symb(ti),-1, AS_OP_EQ);
		
		A_d_Select(aOE, dd);
		
		dd_ROWS = ArrayRange(dd,0);
		
		if(Debug && BP_PB2MA){
			BP("AO_PB2MA_CheckPendOrders", "dd_ROWS = ", dd_ROWS);
		}
		
		for(dd_idx_row = 0; dd_idx_row < dd_ROWS; dd_idx_row++){
			ti_rev = dd[dd_idx_row][OE_TI];
			TR_ModifyPriceByTicket(ti, ti_rev);
			TR_ModifyTP(ti_rev , AO_PB2MA_TP, TR_MODE_PIP);
			TR_ModifySLOnTP(ti, ti_rev);
		}
	}
	//}
}

int AO_PB2MA_CheckBezUbitok(){
	/*
		>Ver	:	0.0.7
		>Date	:	2013.03.06
		>Hist	:
			@0.0.5@2013.03.02@artamir	[]
			@0.0.4@2013.03.01@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double d[][OE_MAX];
	int d_ROWS = 0;
	int d_row = 0;
	int mp = 0;
	int ti = 0;
	double op = 0.0;
	int method = 0;
	
	ArrayResize(d, 0);
	A_eraseFilter();
	//AO_PB2MA_FilterALL();
	A_FilterAdd_AND(OE_GL	,0				,-1	,AS_OP_ABOVE);
	A_FilterAdd_AND(OE_IC	,0				,-1	,AS_OP_EQ);
	A_d_Select(aOE, d);
	
	if(Debug && BP_PB2MA){
		A_d_PrintArray2(d, 4, "Selected_with_MP");
	}
	
	d_ROWS = ArrayRange(d, 0);
	for(d_row = 0; d_row < d_ROWS; d_row++){
		mp = d[d_row][OE_MP];
		ti = d[d_row][OE_TI];
		method = d[d_row][OE_AOM];
		if(OE_getICByTicket(mp) >= 1){
			op = OE_getOPByTicket(ti);
			TR_ModifySL(ti, op);
			if(OE_CountMP_NOT_LP(mp) > 0){
				continue;
			}
			
			double d_loa[];									//d_loa: d_ouble l_ike o_rder a_rray
			int loa_ROWS = TR_SendSTOPLikeOrder_array(d_loa, mp, 0, 2);
			
			if(Debug && BP_PB2MA){
				BP("AO_PB2MA_CheckBezUbitok", "loa_ROWS = ", loa_ROWS);
			}
			
			if(loa_ROWS > 0){
				for(int loa_row = 0; loa_row < loa_ROWS; loa_row++){
					int loa_ti = d_loa[loa_row];
					if(Debug && BP_LOA){
						BP("LOA", "loa_ti = ",loa_ti);
					}
					TR_ModifyTP(loa_ti, AO_PB2MA_TP, TR_MODE_PIP);
					TR_ModifySL(loa_ti, AO_PB2MA_SL, TR_MODE_PIP);
					OE_setStandartDataByTicket(loa_ti);
					//OE_setAOMByTicket(loa_ti, method);
					OE_setFODByTicket(loa_ti);
					OE_setMPByTicket(loa_ti, mp);
					OE_setLPByTicket(loa_ti, ti);
					
					int loa_rev = 0;
					loa_rev = TR_SendREVERSOrder(loa_ti, 0, 0.5);	//2 - lot_multi
					TR_ModifyTP(loa_rev, AO_PB2MA_TP, TR_MODE_PIP);
					TR_ModifySLOnTP(loa_ti, loa_rev);
					OE_setStandartDataByTicket(loa_rev);
					//OE_setAOMByTicket(loa_rev, method);
					OE_setMPByTicket(loa_rev, loa_ti);
					OE_setLPByTicket(loa_rev, loa_ti);
					OE_setGLByTicket(loa_rev, 1);
				}
			}
			
			if(Debug && BP_PB2MA){
				BP("STOP like order", "ti = ", mp);
			}
		}
	}
}

void AO_PB2MA_DelUnused(){
	/*
		>Ver	:	0.0.3
		>Date	:	2013.03.02
		>Hist	:
			@0.0.3@2013.03.02@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	double d[][OE_MAX];
	
	int d_ROWS = 0;
	int d_row = 0;
	int mp = 0;
	int ti = 0;
	int lp = 0;
	int	lp2 = 0;
	
	A_eraseFilter();
	AO_PB2MA_FilterALL();
	A_FilterAdd_AND(OE_LP	,0				,-1	,AS_OP_NOT);
	A_FilterAdd_AND(OE_IM	,1				,-1	,AS_OP_NOT);
	A_FilterAdd_AND(OE_IP	,1				,-1	,AS_OP_EQ);
	A_FilterAdd_AND(OE_IT	,1				,-1	,AS_OP_EQ);
	A_FilterAdd_AND(OE_IC	,1				,-1	,AS_OP_NOT);
	A_d_Select(aOE, d);
	
	d_ROWS = ArrayRange(d,0);
	
	if(Debug && BP_DelUnused){
	
		if(CircleCount > 900){
			A_d_PrintArray2(d, 4, "DelUnused");
		}	
	}
	
	for(d_row = 0; d_row < d_ROWS; d_row++){
		mp = d[d_row][OE_MP];
		lp = d[d_row][OE_LP];
		lp2 = d[d_row][OE_LP2];
		ti = d[d_row][OE_TI];
		
		if(OE_getICByTicket(lp) >= 1){
			TR_CloseByTicket(ti);
			OE_setCloseByTicket(ti);
		}
		
	}
	
}

void AO_PB2MA_FilterALL(){
	/*
		>Ver	:	0.0.1
		>Date	:	2013.03.01
		>Hist	:
			@0.0.1@2013.03.01@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA1_B	,-1	,AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA1_S	,-1	,AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA2_B	,-1	,AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA2_S	,-1	,AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA3_B	,-1	,AS_OP_EQ);
	A_FilterAdd_OR(OE_AOM	,AOM_PB2MA3_S	,-1	,AS_OP_EQ);
}