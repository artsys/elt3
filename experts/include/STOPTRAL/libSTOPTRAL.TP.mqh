/*
		>Ver	:	0.0.14
		>Date	:	2012.11.13
		>Hist:
			@0.0.14@2012.11.13@artamir	[]
			@0.0.13@2012.10.26@artamir	[]
			@0.0.12@2012.10.23@artamir	[]
			@0.0.11@2012.10.22@artamir	[]
			@0.0.10@2012.10.22@artamir	[]
			@0.0.9@2012.10.15@artamir	[]
			@0.0.8@2012.09.20@artamir	[]
			0.0.5: [+] user defined EMA for calc TP price.
			0.0.4: [+] checking if parent order is market.
		>Desc:
			check tp for STOPORDER TRAL
		>Depends: 
			#include <libInd_MA.mqh>
			#include <libOrders.mqh>
*/
//----------------------------------------------------------
extern string libSOTr.TP.MA600 = ">>>>> TP.MA600 >>>>>";
extern bool libSOTr.TP.UseMA600 = false;

//----------------------------------------------------------
extern string libSOTr.TP.EMAUD = ">>>>> TP.EMAUD >>>>>";
extern bool libSOTr.TP.UseEMAUD	= false;					//User defined EMA
extern int		libSOTr.TP.EMAUD.Per = 14;					// Period of UD EMA

//----------------------------------------------------------
extern string 	SOTr.TP.4EMA = ">>>>> TP.4MA >>>>>";
extern bool 	SOTr.TP.Use4EMA		= false;				//User defined EMA
extern int			SOTr.TP.4EMA_1.Per	= 64;				// Period of UD EMA
extern int			SOTr.TP.4EMA_2.Per	= 128;				// Period of UD EMA
extern int			SOTr.TP.4EMA_3.Per	= 256;				// Period of UD EMA
extern int			SOTr.TP.4EMA_4.Per	= 512;				// Period of UD EMA


int libSOTr.TP.Main(){

	//----------------------------------------------------------
	if(libSOTr.TP.UseMA600){
		libSOTr.TP.onMA600();
	}
	
	//----------------------------------------------------------
	if(libSOTr.TP.UseEMAUD){
		libSOTr.TP.onEMAUD();
	}
	
	//----------------------------------------------------------
	if(SOTr.TP.Use4EMA){
		SOTr.TP.on4EMA();
	}
}

//==========================================================
int libSOTr.TP.onMA600(){//..
	double aParents[][libT.OE_MAX];
	libT.SelectExtraParents(aParents);
	
	//------------------------------------------------------
	double ma600 = libI_MA.GetEMA(600);
	
	//------------------------------------------------------
	int rows = ArrayRange(aParents, 0);

	//------------------------------------------------------
	for(int idx = 0; idx < rows; idx++){//..
		
		//--------------------------------------------------
		int parent.ticket = aParents[idx][libT.OE_TI];
		
		if(libT.getExtraIsClosedTicket(parent.ticket) >= 1) continue;
		//BP("TP","rows = ", rows, "ma600 = ", ma600, "idx = ", idx, "parent.ticket = ", parent.ticket);
		//--------------------------------------------------
		libO.ModifyTP(parent.ticket, ma600);
		
		//--------------------------------------------------
		libSOTr.TP.checkChildTP(parent.ticket, ma600);
	}//.
}//.

//==========================================================
#define libSOTr.TP.MODE_PRICE	1					
#define libSOTr.TP.MODE_Pipi	2					

int libSOTr.TP.checkChildTP(int parent.ticket, double tp, int mode = 1){//..
	
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.20
		>Hist:
			@0.0.1@2012.09.20@artamir	[]
	*/
	double d[][libT.OE_MAX];
	int count = libT.getOrdersByParent(parent.ticket, d);
	
	//------------------------------------------------------
	if(count >= 1){//..
	
		for(int idx = 0; idx < count; idx++){//..
			int child.ticket = d[idx][libT.OE_TI];
			
			//----------------------------------------------
			if(libT.getExtraIsClosedTicket(child.ticket) >= 1) continue;
			
			//--------------------------------------------------
			if(child.ticket == parent.ticket) continue;
			
			//--------------------------------------------------
			if(mode == libSOTr.TP.MODE_PRICE){
				libO.ModifyTP(parent.ticket, tp);
			}	
		}//.
	}//.
}//.

//==========================================================
int libSOTr.TP.onEMAUD(){//..
	double aParents[][libT.OE_MAX];
	libT.SelectExtraParents(aParents);
	
	//------------------------------------------------------
	double ma = libI_MA.GetEMA(libSOTr.TP.EMAUD.Per);
	
	//------------------------------------------------------
	int rows = ArrayRange(aParents, 0);
	
	//------------------------------------------------------
	for(int idx = 0; idx < rows; idx++){
		int parent.ticket = aParents[idx][libT.OE_TI];
		
		//--------------------------------------------------
		libO.ModifyTP(parent.ticket, ma);
		
		//--------------------------------------------------
		libSOTr.TP.checkChildTP(parent.ticket, ma);
	}
}//.

void SOTr.TP.CheckTPOnParents(int child.ti = -1, double tp = 0){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.10.22
		>Hist	:
			@0.0.2@2012.10.22@artamir	[]
			@0.0.1@2012.10.22@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	if(child.ti <= -1) return;
	
	//------------------------------------------------------
	int parent.ti = libT.getExtraPARENTByTicket(child.ti);
	
	//------------------------------------------------------
	if(parent.ti == child.ti || parent.ti == 0){//..
		
		//--------------------------------------------------
		libO.ModifyTP(child.ti, tp);
		
		//--------------------------------------------------
		return;												//end recursion
	}//.
	
	//------------------------------------------------------
	libO.ModifyTP(child.ti, tp);
	
	SOTr.TP.CheckTPOnParents(parent.ti, tp);
	
}//.

int SOTr.TP.on4EMA(){
	/*
		>Ver	:	0.0.4
		>Date	:	2012.11.13
		>Hist	:
			@0.0.4@2012.11.13@artamir	[]
			@0.0.3@2012.10.26@artamir	[]
			@0.0.2@2012.10.23@artamir	[]
			@0.0.1@2012.10.15@artamir	[]
		>Author	:	Morochin <artamir> Artiom
		>Desc	:
	*/
	
	//------------------------------------------------------
	double d[][libT.OE_MAX];
	
	//.. BUYSTOP TRAL
	//------------------------------------------------------
	int ROWS = CY.selectOByGT2(d, GT.BSTR, GT.BSFF);
	
	//------------------------------------------------------
	if(ROWS >= 1){
	
		//--------------------------------------------------
		pS4EMA.setEMA();									//seting default EMAs 
		
		//--------------------------------------------------
		int idx = libA.double_IndexByMax2(d, libT.OE_GL);
		int ti = d[idx][libT.OE_TI];
		
		//--------------------------------------------------
		int parent.ticket = d[idx][libT.OE_PARENT];
		
		double parent.op = libT.getExtraOPByTicket(parent.ticket);
		
		double tp = pS4EMA.getEMAAbovePrice(parent.op);
	
		SOTr.TP.CheckTPOnParents(ti, tp);
		
		
	}
	
	
	//.

	//.. SELLSTOP TRAL
	
	ArrayResize(d, 0);
	
	//------------------------------------------------------
	ROWS = CY.selectOByGT2(d, GT.SSTR, GT.SSFF);
	
	//------------------------------------------------------
	if(ROWS >= 1){//..
		
		pS4EMA.setEMA();
		
		//--------------------------------------------------
		idx = libA.double_IndexByMax2(d, libT.OE_GL);
		ti = d[idx][libT.OE_TI];
	
		//--------------------------------------------------
		parent.ticket = d[idx][libT.OE_PARENT];
		parent.op = libT.getExtraOPByTicket(parent.ticket);
		
		tp = pS4EMA.getEMAUnderPrice(parent.op);
		
		SOTr.TP.CheckTPOnParents(ti, tp);
		
	}//.
	
	//.
	
}