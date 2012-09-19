/*
		>Ver	:	0.0.24
		>Date	:	2012.09.19
		>History:
			@0.0.24@2012.09.19@artamir	[]
			@0.0.23@2012.09.19@artamir	[]
			@0.0.22@2012.09.19@artamir	[]
			@0.0.21@2012.09.19@artamir	[]
			@0.0.20@2012.09.17@artamir	[*] libTrendHarvester
			@0.0.19@2012.09.17@artamir	[]
			@0.0.18@2012.09.17@artamir	[*] libEvents
			@0.0.17@2012.09.17@artamir	[]
			@0.0.16@2012.09.17@artamir	[]
			@0.0.15@2012.09.17@artamir	[]
			@0.0.14@2012.09.17@artamir	[]
			@0.0.13@2012.09.17@artamir	[+] Выставление фикс. тейкпрофита.
			@0.0.12@2012.09.14@artamir	[*] Проверка сетки противонаправленного ордера.
			@0.0.11@2012.09.14@artamir	[]
			@0.0.10@2012.09.14@artamir	[]
			@0.0.9@2012.09.14@artamir	[*] Изменения в связи с переходом на eLT3 0.0.45
			@0.0.8@2012.09.13@artamir	[]
			@0.0.7@2012.09.10@artamir	[+] Сохранение массива array_dExtraOrders в файл.
			@0.0.6@2012.09.10@artamir	[+] libMAIN.mqh
			@0.0.4@2012.09.05@artamir	[*] libTrendHarvester.mqh
			@0.0.3@2012.09.04@artamir	[+] libStructure.mqh
			@0.0.2@2012.09.04@artamir	[*] libArray.mqh
			@0.0.1@2012.09.03@artamir	[+] libTrendHarvester.mqh
			
		>Description:
			Помошник реализации различных стратегий сопровождения открытых позиций
		
		>eLT3 0.0.45
*/	

/*
		>Ver	:	0.0.32
		>Date	:	2012.09.19

			@0.0.32@2012.09.19@artamir	[]
			@0.0.31@2012.09.19@artamir	[]
			@0.0.30@2012.09.19@artamir	[]
			@0.0.29@2012.09.17@artamir	[]
			@0.0.28@2012.09.17@artamir	[]
			@0.0.27@2012.09.14@artamir	[]
			@0.0.26@2012.09.14@artamir	[]
			@0.0.25@2012.09.14@artamir	[]
			@0.0.24@2012.09.14@artamir	[]
			@0.0.23@2012.09.13@artamir	[]
			@0.0.22@2012.09.10@artamir	[]
			@0.0.21@2012.09.05@artamir	[]
			@0.0.20@2012.09.04@artamir	[]
			@0.0.19@2012.09.04@artamir	[]
			@0.0.18@2012.09.03@artamir	[]
*/	

#define	EXP "eLT3.TH"		
#define	VER	"0.0.24_2012.09.19"
//==================================================================================================
// VARS:
//
string fnExtra = "";

bool useDebuging = true;

bool isStart = true;

//==================================================================================================
#include <libMAIN.mqh>										// Main lib of expert.

//----------------------------------------------------------
#include <libSignalInclude.mqh>								//Signal plugins includer

//==================================================================================================
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

//----------------------------------------------------------

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
	libA.double_SaveToFile2(libT.array_dExtraOrders, fnExtra,8);
}//.

//==================================================================================================
int start(){//..
	/*
		>Ver	:	0.0.5
		>Date	:	2012.09.19
		>History:
			@0.0.5@2012.09.19@artamir	[]
			@0.0.4@2012.09.17@artamir	[]
			@0.0.3@2012.09.17@artamir	[+] Добавил автооткрытие бай ордера, если нет ни одного ордера на счете.
			@0.0.2@2012.08.10@artamir	[]
		>Description:
			start function of EA.
	*/
	//if(!isStart) return;
	
	libT.checkExtraIsClosedStatuses();
	
	if(OrdersTotal() == 0){
		libO.SendBUY(0.1);
	}
	
	Comment(VER);
	if(isStart) isStart = false;

	//------------------------------------------------------
	libT.Start();
	libT.End();	
	//------------------------------------------------------
	int ticket = libT.CurTicketByIndex();
	
	//------------------------------------------------------
	libCY.Main();										//Главная функция модуля сопровождения ордеров.
	
	//------------------------------------------------------
												//Обязательно терминал заканчивать в эксперте!
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
