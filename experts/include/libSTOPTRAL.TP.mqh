/*
		>Ver	:	0.0.4
		>Date	:	2012.08.29
		>Hist:
			0.0.4: [+] checking if parent order is market.
		>Desc:
			check tp for STOPORDER TRAL
		>Depends: 
			#include <libInd_MA.mqh>
			#include <libOrders.mqh>
*/

extern bool libSOTr.TP.UseMA600 = false;

int libSOTr.TP.Main(){//..

	//----------------------------------------------------------
	if(libSOTr.TP.UseMA600){
		libSOTr.TP.onMA600();
	}

	//----------------------------------------------------------

}//.

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
		
		//BP("TP","rows = ", rows, "ma600 = ", ma600, "idx = ", idx, "parent.ticket = ", parent.ticket);
		//--------------------------------------------------
		libO.ModifyTP(parent.ticket, ma600);
	}//.
}//.