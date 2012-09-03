bool useDebuging = true;
//===================================================================
#include <WinUser32.mqh>
#include <libDebug.mqh>
#include <libNormalize.mqh>
#include <libOrders.mqh>
#include <libMarketInfo.mqh>
int start(){//..
	/*
		>Ver	:	0.0.1
		>Date	:	2012.06.25
		>History:
		>Description:
			Стартовая функция советника.
	*/
	double SP = Bid;
	int AddPip = 0;
	
	for(int i=1; i<=3; i++){
		AddPip = AddPip + 10;
		
		libO.SendBUYSTOP(SP, AddPip, 0.1, 50, 150, i, 1);
	}
	
}//.							