/*
		>Ver	:	0.0.5
		>Date	:	2012.11.14
	>Hist:
			@0.0.5@2012.11.14@artamir	[]
			@0.0.3@2012.09.13@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[+] Main func.
	>Desc:
		Manager of autoopen plugins
*/

//Unique keys for Autoopen methods 
#define AOM.MAZZ600.B	1									// MA600 + ZZ600 BUY
#define AOM.MAZZ600.S	2									// MA600 + ZZ600 SELL						

#include <plgAutoOpen.MAZZ600.mqh>

#define AOM.MAENV.B	3										//BUY
#define AOM.MAENV.S	4										//SELL
#include <plgAutoOpen.MAENV.mqh>						//Открытие, если цена вышла из конверта

#define AOM.MAZZ.B	5									// MA600 + ZZ600 BUY
#define AOM.MAZZ.S	6									// MA600 + ZZ600 SELL						

#include <plgAutoOpen.MAZZ.mqh>

#define AOM.3MA.B	7
#define AOM.3MA.S	8

#include <plgAutoOpen.3MA.mqh>

int mngAO.Main(){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.11.14
		>Hist:
			@0.0.3@2012.11.14@artamir	[]
			@0.0.2@2012.09.13@artamir	[+] plgAO.MAENV.Main
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	//------------------------------------------------------
	plgAO.MAZZ600.Main();
	
	//------------------------------------------------------
	plgAO.MAENV.Main();
	
	//------------------------------------------------------
	AO.MAZZ.Main();
	
	//------------------------------------------------------
	AO.3MA.Main();
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