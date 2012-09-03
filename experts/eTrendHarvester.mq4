/*
		>Ver	:	0.0.1
		>Date	:	2012.09.03
		>History:
			@0.0.1@2012.09.03@artamir	[+] libTrendHarvester.mqh
			
		>Description:
			Помошник реализации различных стратегий сопровождения открытых позиций
*/	

/*
		>Ver	:	0.0.18
		>Date	:	2012.09.03

			@0.0.18@2012.09.03@artamir	[]
*/			
#define	VER	"0.0.1_2012.09.03"
//==================================================================================================
// VARS:
//
bool useDebuging = true;

bool isStart = true;
//==================================================================================================
#include <WinUser32.mqh>
#include <libDebug.mqh>
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
