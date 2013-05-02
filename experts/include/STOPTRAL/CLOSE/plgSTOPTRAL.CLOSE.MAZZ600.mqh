/*
		>Ver	:	0.0.3
		>Date	:	2012.09.14
	>Hist:
			@0.0.3@2012.09.14@artamir	[]
			@0.0.2@2012.09.14@artamir	[]
			@0.0.1@2012.09.14@artamir	[]
*/

extern string plgSOTr.CL.MZ600R = ">>>>> MAZZ600 CLOSE ON REVERS";
extern bool	plgSOTr.CL.MZ600R.Use = false;				// Use close on revers signal.

//==========================================================
int plgSOTr.CL.MZ600R.Main(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.14
		>Hist:
			@0.0.1@2012.09.14@artamir	[]
	*/
	
	//------------------------------------------------------
	if(!plgSOTr.CL.MZ600R.Use) return(-1);
	
	//------------------------------------------------------
	int Signal = libSM.MAZZ600.getSignal();
	
	//------------------------------------------------------
	if(Signal > -1){
		plgSOTr.CL.MZ600R.ClRevOnSignal(Signal);
	}
}//.

//==========================================================
int plgSOTr.CL.MZ600R.ClRevOnSignal(int Signal){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.14
		>Hist:
			@0.0.1@2012.09.14@artamir	[]
		>Desc:
			Close revers orders on signal
	*/
	
	//------------------------------------------------------
	int OP_CLOSE = -1;
	
	//------------------------------------------------------
	if(Signal == OP_BUY){
		OP_CLOSE = OP_SELL;
	}
	
	//------------------------------------------------------
	if(Signal == OP_SELL){
		OP_CLOSE = OP_BUY;
	}
	
	//------------------------------------------------------
	libA.double_eraseFilter2();
	
	int f.COL = libT.OE_TY;
	double f.MAX = OP_CLOSE;
	double f.MIN = OP_CLOSE;
	int f.OP = libA.SOP.AND;
	
	//------------------------------------------------------
	libA.double_addFilter2(f.COL, f.MAX, f.MIN, f.OP);
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	libA.double_SelectArray2(libT.array_dExtraOrders,d);
	
	//------------------------------------------------------
	if(ArrayRange(d,0) > 0){
		plgSOTr.CloseOrdersInArray(d);
	}
}//.

//==========================================================
int plgSOTr.CloseOrdersInArray(double& d[][]){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.14
		>Hist:
			@0.0.1@2012.09.14@artamir	[]
	*/
	
	//------------------------------------------------------
	int ROWS = ArrayRange(d, 0);
	if(ROWS <= 0) return(-1);
	
	//------------------------------------------------------
	for(int idx = 0; idx < ROWS; idx++){//..
		int ticket = d[idx][libT.OE_TI];
		
		//--------------------------------------------------
		libO.CloseByTicket(ticket);
	}//.
}//.