/*
		>Ver	:	0.0.51
		>Date	:	2012.10.02
		>History:
			@0.0.51@2012.10.02@artamir	[]
			@0.0.50@2012.10.01@artamir	[*] libOrders
										[+] Close on revers signal by MA+ZZ
			@0.0.49@2012.09.19@artamir	[*] libTerminal
			@0.0.48@2012.09.14@artamir	[+] plgStoptral.Close.MAZZ600.mqh
			@0.0.47@2012.09.14@artamir	[]
			@0.0.46@2012.09.13@artamir	[+] plgAO.MAENV
			@0.0.45@2012.09.11@artamir	[]
			@0.0.44@2012.09.11@artamir	[]
			@0.0.43@2012.09.10@artamir	[]
			@0.0.42@2012.09.10@artamir	[+] Autoopen by MA600 + ZZ600. :))
			@0.0.41@2012.09.10@artamir	[+] mngAutoOpen.mqh
										[*] libTerminal.mqh
			@0.0.40@2012.09.10@artamir	[+] libMAIN.mqh
			@0.0.39@2012.09.10@artamir	[*] correctred work with file, where store array_dExtraOrders
			@0.0.38@2012.09.10@artamir	[]
			@0.0.37@2012.09.10@artamir	[]
			@0.0.36@2012.09.10@artamir	[+] getExtraFN()
			@0.0.35@2012.09.07@artamir	[]
			@0.0.34@2012.09.07@artamir	[*] libTerminal, checkExtraIsClosedStatuses
			@0.0.33@2012.09.07@artamir	[*] Check is order closed.
			@0.0.32@2012.09.07@artamir	[*] libTerminal, libEvents
			@0.0.31@2012.09.07@artamir	[*] libSTOPTRAL.mqh
			@0.0.30@2012.09.07@artamir	[]
			@0.0.29@2012.09.03@artamir	[*] libSTOPTRAL.TP
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
			Имя файла для сохранения массива array_dExtraOrders[][]:
			ИмяЭксперта.Счет.Пара.extra.arr
*/	

/*
		>Ver	:	0.0.36
		>Date	:	2012.10.02
		>Hist	:
			@0.0.36@2012.10.02@artamir	[]
			@0.0.35@2012.10.01@artamir	[]
			@0.0.34@2012.09.19@artamir	[]
			@0.0.33@2012.09.14@artamir	[]
			@0.0.32@2012.09.14@artamir	[]
			@0.0.31@2012.09.13@artamir	[]
			@0.0.30@2012.09.11@artamir	[]
			@0.0.29@2012.09.11@artamir	[]
			@0.0.28@2012.09.10@artamir	[]
			@0.0.27@2012.09.10@artamir	[]
			@0.0.26@2012.09.10@artamir	[]
			@0.0.25@2012.09.10@artamir	[]
			@0.0.24@2012.09.07@artamir	[]
			@0.0.23@2012.09.07@artamir	[]
			@0.0.22@2012.09.07@artamir	[]
			@0.0.21@2012.09.07@artamir	[]
			@0.0.20@2012.09.07@artamir	[]
			@0.0.19@2012.09.07@artamir	[]
			
*/			

#define	EXP	"eLT3"
#define	VER	"0.0.51_2012.10.02"

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

//----------------------------------------------------------
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
//==========================================================
#include <mngAutoOpen.mqh>
//==================================================================================================
#include <libInd_ZigZag.mqh>
#include <libInd_MA.mqh>

//==================================================================================================
int init(){//..
	
	fnExtra = libMain.getExtraFN();

	libA.double_ReadFromFile2(libT.array_dExtraOrders, fnExtra);
	
	//------------------------------------------------------
	libT.checkExtraIsClosedStatuses();
}//.

//==========================================================
int deinit(){//..
	libA.double_SaveToFile2(libT.array_dExtraOrders, fnExtra,8);
}//.

//==================================================================================================
int start(){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.10
		>History:
			@0.0.3@2012.09.10@artamir	[+] autoopen manager.
			@0.0.2@2012.08.10@artamir	[]
		>Description:
			start function of EA.
	*/
	//if(!isStart) return;
	Comment(VER, "\n",
	"Sig = ", libSM.MAZZ600.Main());
	if(isStart) isStart = false;

	//------------------------------------------------------
	libT.Start();
	libT.End();	
	
	//------------------------------------------------------
	mngAO.Main();											//Main function of autoopen manager.
	
	//------------------------------------------------------
	libCY.Main();											//Main function of convoys manager.
	
	//------------------------------------------------------
	//if(ArrayRange(libE.array_dOrdersEvents, 0)) return(0);

}//.


//==========================================================
string getExtraFN(){//..
	/*
		>Ver	:	0.0.3
		>Date	:	2012.09.10
		>Hist:
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
		>Description:
	*/
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"Extra.arr";

	//------------------------------------------------------
	return(fn);
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
