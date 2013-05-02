/*
		>Ver	:	0.0.72
		>Date	:	2013.01.20
		>History:
			@0.0.72@2013.01.20@artamir	[*] iFractal
			@0.0.71@2013.01.16@artamir	[*] SOFF  -	Определение фрактала по Вильямсу.
			@0.0.70@2012.11.21@artamir	[]
			@0.0.69@2012.11.20@artamir	[]
			@0.0.68@2012.11.16@artamir	[+] FIXSL
			@0.0.67@2012.11.15@artamir	[+] AO.3MA
			@0.0.66@2012.11.14@artamir	[]
			@0.0.65@2012.11.14@artamir	[]
			@0.0.64@2012.11.13@artamir	[]
			@0.0.63@2012.11.13@artamir	[]
			@0.0.62@2012.11.13@artamir	[]
			@0.0.61@2012.11.12@artamir	[]
			@0.0.60@2012.10.26@artamir	[]
			@0.0.59@2012.10.25@artamir	[]
			@0.0.58@2012.10.25@artamir	[]
			@0.0.57@2012.10.23@artamir	[]
			@0.0.56@2012.10.22@artamir	[]
			@0.0.55@2012.10.15@artamir	[]
			@0.0.54@2012.10.15@artamir	[]
			@0.0.53@2012.10.15@artamir	[]
			@0.0.52@2012.10.15@artamir	[]
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
		>Ver	:	0.0.52
		>Date	:	2013.01.20
		>Hist	:
			@0.0.52@2013.01.20@artamir	[]
			@0.0.51@2013.01.16@artamir	[]
			
*/			

#define	EXP	"eLT3"
#define	VER	"0.0.72_2013.01.20"

//==========================================================
// VARS:
//

string fnExtra = "";
bool useDebuging = true;

bool isStart = true;
//==========================================================
#include <libMAIN.mqh>										// Main lib of expert.

//----------------------------------------------------------
#include <oLines.mqh>
#include <iFractal.mqh>
#include <iSar.mqh>
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
#include <libMarketInfo.mqh>
#include <libTerminal.mqh>
#include <libEvents.mqh>
#include <libTP.mqh>
#include <libSL.mqh>
#include <libDelOrders.mqh>
#include <libOE.mqh>
//==========================================================
#include <libCONVOY.mqh>
//#include <libSignalManager.mqh>
//==========================================================
#include <mngAutoOpen.mqh>
//==========================================================
#include <libInd_ZigZag.mqh>
#include <libInd_MA.mqh>

//==========================================================
int init(){
	
	fnExtra = libMain.getExtraFN();

	libA.double_ReadFromFile2(libT.array_dExtraOrders, fnExtra);
	
	//------------------------------------------------------
	libT.checkExtraIsClosedStatuses();
}

//==========================================================
int deinit(){
	libA.double_SaveToFile2(libT.array_dExtraOrders, fnExtra,8);
}

//==================================================================================================
int start(){
	/*
		>Ver	:	0.0.5
		>Date	:	2012.11.15
		>History:
			@0.0.5@2012.11.15@artamir	[]
			@0.0.4@2012.11.13@artamir	[]
			@0.0.3@2012.09.10@artamir	[+] autoopen manager.
			@0.0.2@2012.08.10@artamir	[]
		>Description:
			start function of EA.
	*/
	//if(!isStart) return;
	if(isStart) isStart = false;

	//------------------------------------------------------
	int StartCircle = TimeLocal();

	//------------------------------------------------------
	libT.Start();
	libT.End();	
	
	//------------------------------------------------------
	mngAO.Main();											//Main function of autoopen manager.
	
	//------------------------------------------------------
	libCY.Main();											//Main function of convoys manager.
	
	//------------------------------------------------------
	libTP.Main();
	libSL.Main();
	
	DPO.DeleteOrders();
	
	OE.ClearHistory();
	//------------------------------------------------------
	//if(ArrayRange(libE.array_dOrdersEvents, 0)) return(0);
	int EndCircle = TimeLocal();
	int TIMER = EndCircle - StartCircle;
	
	static double maxDD;
	static datetime dtMaxDD;
	
	double DD = (AccountEquity() - AccountBalance())*100/(AccountBalance());
	
	if(DD < maxDD){
		dtMaxDD	= TimeCurrent();
		maxDD = DD;
	}
	
	string sDateMaxDD = TimeToStr(dtMaxDD, TIME_DATE);
	
	Comment(	VER, "\n"
			,	"HIST = ",ArrayRange(libT.array_dExtraOrders,0), "\n"
			,	"TIMER = ", TIMER, "\n"
			,	"DD = ", DoubleToStr(maxDD, 2), "\n"
			,	"DT = ", sDateMaxDD,"\n"
			,	"3MA = ", s3MA.getSignal(), "\n"
			,	"isPrAbove = ",	iEMA.isPriceAbove(s3MA.MAM.per, iClose(NULL, 0, 1), 1), "\n"
			,	"cb = ", iEMA.getLastCrossBar(s3MA.MAF.per, s3MA.MAM.per, 1), "\n");
}


//==========================================================
string getExtraFN(){
	/*
		>Ver	:	0.0.5
		>Date	:	2012.10.15
		>Hist:
			@0.0.5@2012.10.15@artamir	[]
			@0.0.4@2012.10.15@artamir	[]
			@0.0.3@2012.09.10@artamir	[]
			@0.0.2@2012.09.10@artamir	[]
			@0.0.1@2012.09.10@artamir	[]
		>Description:
	*/
	
	string fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"Extra.arr";

	//------------------------------------------------------
	return(fn);
}

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
