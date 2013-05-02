/*
		>Ver	:	0.0.4
		>Date	:	2012.09.14
		>Hist:
			@0.0.4@2012.09.14@artamir	[]
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
		>Desc:
			Signal method on ZZ600 + MA600.
		>Dependings:
			#include <libInd_ZigZag.mqh>
			#include <libInd_MA.mqh>
*/

//extern string	libSM.MAZZ600 = ">>>>> Signal MA600+ZZ600";
//extern bool		libSM.MAZZ600.Use	= false;

int libSM.MAZZ600.Main(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[*]	alowing use from any part of expert.
	*/
	//------------------------------------------------------
	//if(!libSM.MAZZ600.Use) return(-1);
	
	//------------------------------------------------------
	int Signal = libSM.MAZZ600.getSignal();
	
	//------------------------------------------------------
	return(Signal);
}//.

//==========================================================
int libSM.MAZZ600.getSignal(){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.09.14
		>Hist:
			@0.0.2@2012.09.14@artamir	[*] changed zz to 30
			@0.0.1@2012.09.10@artamir	[]
	*/
	//------------------------------------------------------
	if(libI_ZZ.IsZZNewDraw("", 1, 30)){
		
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
	double thisZZ600 = libI_ZZ.GetZZExtrByNum(0,"",1, 30);
	
	//----------------------------------------------------------------------------------------------
	if(thisZZ600 < thisMA600){
		return(OP_BUY);
	}else{
		return(OP_SELL);
	}
}//.