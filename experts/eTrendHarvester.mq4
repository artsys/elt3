/*
		>Ver	:	0.0.7
		>Date	:	2012.09.10
		>History:
			@0.0.7@2012.09.10@artamir	[+] Сохранение массива array_dExtraOrders в файл.
			@0.0.6@2012.09.10@artamir	[+] libMAIN.mqh
			@0.0.4@2012.09.05@artamir	[*] libTrendHarvester.mqh
			@0.0.3@2012.09.04@artamir	[+] libStructure.mqh
			@0.0.2@2012.09.04@artamir	[*] libArray.mqh
			@0.0.1@2012.09.03@artamir	[+] libTrendHarvester.mqh
			
		>Description:
			Помошник реализации различных стратегий сопровождения открытых позиций
*/	

/*
		>Ver	:	0.0.22
		>Date	:	2012.09.10

			@0.0.22@2012.09.10@artamir	[]
			@0.0.21@2012.09.05@artamir	[]
			@0.0.20@2012.09.04@artamir	[]
			@0.0.19@2012.09.04@artamir	[]
			@0.0.18@2012.09.03@artamir	[]
*/	

#define	EXP "eLT3.TH"		
#define	VER	"0.0.7_2012.09.10"
//==================================================================================================
// VARS:
//
string fnExtra = "";

bool useDebuging = true;

bool isStart = true;
//==================================================================================================
#include <libMAIN.mqh>
#include <WinUser32.mqh>
#include <libDebug.mqh>
#include <libStructure.mqh>
#include <libInfo.mqh>
#include <libArray.mqh>
#include <libNormalize.mqh>
#include <libOrders.mqh>
#include <libTP.mqh>
#include <libMarketInfo.mqh>
#include <libTerminal.mqh>
#include <libEvents.mqh>
//==================================================================================================
#include <libCONVOY.mqh>
//#include <libSignalManager.mqh>
//==================================================================================================
#include <libInd_ZigZag.mqh>
#include <libInd_MA.mqh>

//==================================================================================================
int init(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.09.10
		>Hist:
			@0.0.1@2012.09.10@artamir	[]
	*/
	
	
	//------------------------------------------------------
	fnExtra = libMain.getExtraFN();
	
	//------------------------------------------------------
	libA.double_ReadFromFile2(libT.array_dExtraOrders, fnExtra);
	
	//------------------------------------------------------
	libT.checkExtraIsClosedStatuses();
	
	//------------------------------------------------------
	start();
}//.

//==========================================================
int deinit(){//..
	Alert(fnExtra);
	libA.double_SaveToFile2(libT.array_dExtraOrders, fnExtra,8);
}//.

//==================================================================================================
int start(){//..
	/*
		>Ver	:	0.0.2
		>Date	:	2012.08.10
		>History:
			@0.0.2@2012.08.10@artamir	[]
		>Description:
			start function of EA.
	*/
	//if(!isStart) return;
	Comment(VER);
	if(isStart) isStart = false;

	//------------------------------------------------------
	libT.Start();
	
	//------------------------------------------------------
	int ticket = libT.CurTicketByIndex();
	
	//------------------------------------------------------
	libCY.Main();										//Главная функция модуля сопровождения ордеров.
	
	//------------------------------------------------------
	libT.End();												//Обязательно терминал заканчивать в эксперте!
}//.


double iif( bool condition, double ifTrue, double ifFalse ){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.04
		>History:
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}
