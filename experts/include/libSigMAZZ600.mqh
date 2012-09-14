/*
		>Ver	:	0.0.1
		>Date	:	2012.08.30
		>Hist:
		>Desc:
			Signal method on ZZ600 + MA600.
		>Dependings:
			#include <libInd_ZigZag.mqh>
			#include <libInd_MA.mqh>
*/

bool		libSM.MAZZ600.Use	= false;

int libSM.MAZZ600.Main(){//..

	//------------------------------------------------------
	if(!libSM.MAZZ600.Use) return(-1);
	
	//------------------------------------------------------
	int Signal = libSM.MAZZ600.getSignal();
	
	//------------------------------------------------------
	return(Signal);
}//.

//==========================================================
int libSM.MAZZ600.getSignal(){//..
	
	//------------------------------------------------------
	if(libI_ZZ.IsZZNewDraw("", 1, 600)){
		
		//--------------------------------------------------
		int Signal = libSM.MAZZ600.checkMAZZ();
		
		//--------------------------------------------------
		return(Signal);
	}else{
		return(-1);
	}
}//.

//==========================================================
int libSM.MAZZ600.checkMAZZ(){//..

	//------------------------------------------------------
	double thisMA600 = libI_MA.GetEMA(600);
	double thisZZ600 = libI_ZZ.GetZZExtrByNum(0,"",1, 600);
	
	//----------------------------------------------------------------------------------------------
	if(thisZZ600 < thisMA600){
		return(OP_BUY);
	}else{
		return(OP_SELL);
	}
}//.