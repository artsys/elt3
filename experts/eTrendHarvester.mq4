/*
		>Ver	:	0.0.32
		>Date	:	2012.09.20
		>History:
			@0.0.32@2012.09.20@artamir	[!] libTerminal, libTrendHarvester.
			@0.0.31@2012.09.20@artamir	[]
			@0.0.30@2012.09.20@artamir	[]
			@0.0.29@2012.09.20@artamir	[]
			@0.0.28@2012.09.20@artamir	[]
			@0.0.27@2012.09.20@artamir	[]
			@0.0.26@2012.09.20@artamir	[]
			@0.0.25@2012.09.20@artamir	[]
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
			@0.0.13@2012.09.17@artamir	[+] ����������� ����. �����������.
			@0.0.12@2012.09.14@artamir	[*] �������� ����� �������������������� ������.
			@0.0.11@2012.09.14@artamir	[]
			@0.0.10@2012.09.14@artamir	[]
			@0.0.9@2012.09.14@artamir	[*] ��������� � ����� � ��������� �� eLT3 0.0.45
			@0.0.8@2012.09.13@artamir	[]
			@0.0.7@2012.09.10@artamir	[+] ���������� ������� array_dExtraOrders � ����.
			@0.0.6@2012.09.10@artamir	[+] libMAIN.mqh
			@0.0.4@2012.09.05@artamir	[*] libTrendHarvester.mqh
			@0.0.3@2012.09.04@artamir	[+] libStructure.mqh
			@0.0.2@2012.09.04@artamir	[*] libArray.mqh
			@0.0.1@2012.09.03@artamir	[+] libTrendHarvester.mqh
			
		>Description:
			�������� ���������� ��������� ��������� ������������� �������� �������
		
		>eLT3 0.0.45
*/	

/*
		>Ver	:	0.0.39
		>Date	:	2012.09.20

			@0.0.39@2012.09.20@artamir	[]
			@0.0.38@2012.09.20@artamir	[]
			@0.0.37@2012.09.20@artamir	[]
			@0.0.36@2012.09.20@artamir	[]
			@0.0.35@2012.09.20@artamir	[]
			@0.0.34@2012.09.20@artamir	[]
			@0.0.33@2012.09.20@artamir	[]
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
#define	VER	"0.0.32_2012.09.20"
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
		>Ver	:	0.0.6
		>Date	:	2012.09.20
		>History:
			@0.0.6@2012.09.20@artamir	[]
			@0.0.5@2012.09.19@artamir	[]
			@0.0.4@2012.09.17@artamir	[]
			@0.0.3@2012.09.17@artamir	[+] ������� ������������ ��� ������, ���� ��� �� ������ ������ �� �����.
			@0.0.2@2012.08.10@artamir	[]
		>Description:
			start function of EA.
	*/
	//if(!isStart) return;
	
	//libT.checkExtraIsClosedStatuses();
	
	if(OrdersTotal() == 0){
		libO.SendBUY(0.1);
	}
	
	Comment(VER,"\n"
			,"NO = ", OrdersTotal(), "\n"
			,"AR = ", ArrayRange(libT.array_dExtraOrders,0),"\n"
			,"CurProfit = ",DoubleToStr(libA.double_Sum2(libT.array_dCurOrders, libT.O_PROFIT),2), "\n"
			,"OrdProfit = ",DoubleToStr(getOrdersProfit(),2),"\n"
			,"AE = ",AccountEquity(),"\n"
			,"CO profit = ", DoubleToStr(libA.double_Sum2(libT.array_dExtraOrders, libT.OE_PROFIT),2));
	if(isStart) isStart = false;
	
	//libA.double_PrintArray2(libT.array_dExtraOrders, 4, "EO_");
	//------------------------------------------------------
	libT.Start();
	libT.End();	
	
	if(ArrayRange(libE.array_dOrdersEvents,0) <= 0){
		return(0);
	}
	//------------------------------------------------------
	
	
	//if(ArrayRange(libT.array_dExtraOrders, 0)>=95){//..
	//	libA.double_PrintArray2(libE.array_dOrdersEvents, 4, "libE.Events_");
	//	libA.double_PrintArray2(libT.array_dCurOrders, 4, "libT.Cur_");
	//	libA.double_PrintArray2(libT.array_dOldOrders, 4, "libT.Old_");
	//}//.
	
	
	//------------------------------------------------------
	int ticket = libT.CurTicketByIndex();
	
	//------------------------------------------------------
	libCY.Main();										//������� ������� ������ ������������� �������.
	
	//------------------------------------------------------
												//����������� �������� ����������� � ��������!
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

double getOrdersProfit(){//..
	int t = OrdersTotal();
	double sum = 0;
	
	for(int i = 0; i <= t; i++){
		
		//--------------------------------------------------
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		//--------------------------------------------------
		sum = sum + OrderProfit();
	}
	
	//------------------------------------------------------
	return(sum);
}//.