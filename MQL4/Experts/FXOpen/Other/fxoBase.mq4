//+------------------------------------------------------------------+
//|                                                      fxoBase.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#define EXP "eFXO"
#define VER "3.1.0.0_2014.03.07"
#include <sysBase.mqh>

extern string ea_s="=== EXPERT PROPERTIES ===";
extern	short SL=50;
extern	short TP=50;
extern	float LOT=0.01;
extern	bool Autolot_use=false; //��������� ������������ �������������� ������ ������ ������������ �������.
extern	float MaxRisk=1; //������� �� ��������� �������, ������� ����� ������������ ��� �������� �������.

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   startext();
}
//+------------------------------------------------------------------+

void startext(){
	/**
		\version	0.0.0.0
		\date		2014.04.22
		\author		Morochin <artamir> Artiom
		\details	��������� ������� �����.
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="startext";
	
	B_Start();
	
	Autoopen();
}

void Autoopen(){
	/**
		\version	0.0.0.3
		\date		2014.01.31
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2014.01.31@artamir	[!]	�������� �������.
					 @0.0.0.2@2013.12.31@artamir	[*]	���������� �������� , ��� ����� ��������� �� ������� ����.
					 @0.0.0.1@2013.12.13@artamir	[+]	�������� ����� ������ ������.
			>Rev:0
	*/
	
	string fn="Autoopen";
	//Print(fn,"-> GetSignal()");
	int op=GetSignal();
	
	//-------------------------------------------
	if(op<0) return;
	
	string f="";
	if(use_Revers){
		if(op==OP_BUY)op=OP_SELL;
		else
			if(op==OP_SELL)op=OP_BUY;
	}	
	
	f=OE_IT+"==1 AND "+OE_IM+"==1 AND "+OE_FOTY+"=="+op+" AND "+OE_FOOT+"=="+Time[BarsShift];
	
	int aI[];
	
	//Print(fn,"-> ArrayResize(aI,0)");
	ArrayResize(aI,0);
	
	//Print(fn,"-> AId_Init2(aOE, aI)");
	AId_Init2(aOE, aI);
		
	//-------------------------------------------
	
	//Print(fn,"-> Select(aOE, aI, f)");
	Select(aOE, aI, f);
	if(ArrayRange(aI,0)>0) return; //���� ������, �������� �� ����� ������� �� ���. ����. 
	
	int ti=-1;
	
	//Print(fn,"-> isNewBar()");
	if(isNewBar()){ 
		
		if(!MOIS_check(op))return;
		
		ti=TR_SendMarket(op, GetLot());
		
		if(ti<=0){
			Print(fn,": Cant send order");
			Print(fn,".err=",GetLastError());
			Print(fn,".op=",op);
			return;
		}
		
		TR_ModifyTP(ti,TP,TR_MODE_PIP);
		TR_ModifySL(ti,SL,TR_MODE_PIP);
		OE_setFODByTicket(ti);
		OE_setFOOTByTicket(ti, Time[BarsShift]);
		
		MOIS_main(op);
	}
}
