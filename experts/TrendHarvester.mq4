/*
		>Ver	:	0.0.28
		>Date	:	2012.08.30
		>History:
			@0.0.28@2012.08.30@artamir	[*] corect calc of sending price for open stop order.
			@0.0.27@2012.08.30@artamir	[*] changes to right sets of STOPORDERS TRAL
		
			@0.0.20@2012.08.30@artamir	[+]	libSignalManager, libSigMAZZ600
										[-] checkZZMA
			@0.0.19@2012.08.29@artamir	[*] libSOTRAL, libTerminal
			@0.0.16@2012.08.28@artamir	[*] libSOTRAL, libOrders, libTerminal
											libSOTRAL lerned to pull stoporder for the price.
			@0.0.15@2012.08.28@artamir	[+] libSOTRAL
			@0.0.13@2012.08.23@artamir	[]
			@0.0.12@2012.08.20@artamir	[+] libTP.mqh
			@0.0.11@2012.08.16@artamir	[+] libLIMITGRID.BLOCKS.TP 
			@0.0.10@2012.08.14@artamir	[*] libTerminal, libLIMITGRID.BLOCKS
			@0.0.9@2012.08.13@artamir	[-] libLIMITGRID
			@0.0.9@2012.08.13@artamir	[+] libCONVOY
			@0.0.8@2012.08.13@artamir	[+] Добавлена библиотека libLIMITGRID
			@0.0.7@2012.08.11@artamir	[+] добавлена библиотека libInfo
			@0.0.6@2012.08.11@artamir	[*] тестирование скрипта Version
			@0.0.5@2012.08.10@artamir	[*] libArray, libEvents, libTerminal
			@0.0.4@2012.08.03@artamir	[+] checkZZMA
			@0.0.3@2012.06.25@artamir	[*] тестирование скрипта изменения версии.
		>Description:
			Помошник реализации различных стратегий сопровождения открытых позиций
*/	

/*
		>Ver	:	0.0.17
		>Date	:	2012.08.30
		
			@0.0.17@2012.08.30@artamir	[]
			@0.0.16@2012.08.30@artamir	[]
			@0.0.15@2012.08.30@artamir	[]
			@0.0.14@2012.08.30@artamir	[]
			@0.0.13@2012.08.30@artamir	[]
			@0.0.12@2012.08.30@artamir	[]
			@0.0.11@2012.08.30@artamir	[]
			@0.0.10@2012.08.30@artamir	[]
			@0.0.9@2012.08.29@artamir	[]
			@0.0.8@2012.08.28@artamir	[]
			@0.0.7@2012.08.28@artamir	[]
			@0.0.6@2012.08.23@artamir	[]
			@0.0.5@2012.08.20@artamir	[]
			@0.0.4@2012.08.16@artamir	[]
			@0.0.3@2012.08.14@artamir	[]
			@0.0.2@2012.08.13@artamir	[]
			@0.0.1@2012.08.13@artamir	[]
*/			
#define	VER	"0.0.28_2012.08.30"
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
