	/**
		\version	3.1.0.4
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Собиратель тренда (Trend Harvester)
		\internal
			>Hist:				
					 @3.1.0.4@2014.03.06@artamir	[]	TN_checkCO
					 @3.1.0.3@2014.03.06@artamir	[]	Autoopen
					 @3.1.0.2@2014.03.06@artamir	[]	GetLot
					 @3.1.0.1@2014.03.06@artamir	[+]	TN
			>Rev:0
	*/

#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "310.0"
#property strict

input string s1="===== MAIN =====";
input int Step=20;	//Шаг между ордерами
input int TP=50; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input double Lot=0.1;
input string e1="================";

#define EXP "eTH"\
#define VER "3.1.0.4_2014.03.06"
#include <sysBase.mqh>

int OnInit(){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Инициализация советника
		\internal
			>Hist:
			>Rev:0
	*/
	B_Init();
	
	//--------------------------------------
	return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Деинициализация
		\internal
			>Hist:
			>Rev:0
	*/
	B_Deinit();
}

void OnTick(){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Раньше была start()
		\internal
			>Hist:
			>Rev:0
	*/
	
	startext();
}

int startext(void){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Расширение OnTick()
		\internal
			>Hist:
			>Rev:0
	*/

	string fn="startext";
	
	B_Start();
	TN();
	
	Autoopen();
	
	int aI[]; ArrayResize(aI,0);
	AId_Init2(aEC,aI);
	AId_Print2(aEC,aI,4,"aEC_all");

   ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	AId_Print2(aOE,aI,4,"aOE_all");	
	return(0);
}

void TN(){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Трендовая сетка.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	TN
			>Rev:0
	*/
	string fn="TN";
	
	int aI[]; ArrayResize(aI,0);
	AId_Init2(aEC,aI);
	string f=StringConcatenate(""
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IT,"==1"
		," AND "
		,OE_IM,"==1");
		
 	B_Select(aEC,aI,f);

	int rows=ArrayRange(aI,0);
	
	if(rows<=0) return;
	
	for(int i=0;i<rows;i++){
		int 	pti =AId_Get2(aEC,aI,i,OE_TI);
		int 	pty =AId_Get2(aEC,aI,i,OE_TY);
		double 	poop=AId_Get2(aEC,aI,i,OE_OOP);
		
		TN_checkCO(pti);
	}
}

void TN_checkCO(int pti){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	TN_checkCO
			>Rev:0
	*/
	string fn="TN_checkCO";
	
	OrderSelect(pti,SELECT_BY_TICKET);
	int pty=OrderType();
	double poop=OrderOpenPrice();
	
	for(int lvl=1;lvl<=Levels;lvl++){
		int ty=-1;
		double lvloop=poop+iif((pty==OP_BUY||pty==OP_BUYSTOP),1,-1)*Step*lvl*Point;
		
		if(pty==OP_BUY||pty==OP_BUYSTOP){
			ty=OP_BUYSTOP;
			if(lvloop<Ask)continue;
		}
		
		if(pty==OP_SELL||pty==OP_SELLSTOP){
			ty=OP_SELLSTOP;
			if(lvloop>Bid)continue;
		}
		
		int aI[];ArrayResize(aI,0);
		AId_Init2(aEC,aI);
		string f=StringConcatenate(""
			,OE_IT,"==1"
			," AND "
			,OE_OOP,"==",lvloop);
		
		B_Select(aEC,aI,f);
		
		int rows=ArrayRange(aI,0);
		double d[];
		if(rows<=0){
			ArrayResize(d,0);
			int AddPips=Step*lvl;
			TR_SendPending_array(d, ty,	poop, AddPips, GetLot(), TP);
		}
	}		
}

void Autoopen(){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Автооткрытие позиций/ордеров.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	Autoopen
			>Rev:0
	*/
	string fn="Autoopen";
	
	if(OrdersTotal()==0){
		int ti=TR_SendBUY();
		TR_ModifyTP(ti,TP,TR_MODE_PIP);
	}	
}

double GetLot(){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Определение объема выставляемой позиции.
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	GetLot
			>Rev:0
	*/

	return(Lot);
}