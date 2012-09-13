/*
		>Ver	:	0.0.2
		>Date	:	2012.09.10
	>Hist:
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[+] Main func.
	>Desc:
		Manager of autoopen plugins
*/

//Unique keys for Autoopen methods 
#define AOM.MAZZ600.B	1									// MA600 + ZZ600 BUY
#define AOM.MAZZ600.S	2									// MA600 + ZZ600 SELL						

#include <plgAutoOpen.MAZZ600.mqh>

int mngAO.Main(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	//------------------------------------------------------
	plgAO.MAZZ600.Main();
}//.

//==========================================================
int mngAO.IsOrderByMethod(int method){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	double d[][libT.OE_MAX];
	
	//------------------------------------------------------
	int ROWS = libT.SelectExtraAOM(d, method);
	
	//------------------------------------------------------
	return(ROWS);
}//.