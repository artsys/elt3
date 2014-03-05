	/**
		\version	3.1.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Собиратель тренда (Trend Harvester)
		\internal
			>Hist:	
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
input string e1="================";

#define EXP "eTH"\
#define VER "3.1.0.1_2014.03.06"
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
	
	TN();
	
	Autoopen();
	
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
	f=StringConcatenate(""
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IT,"==1"
		," AND "
		,OE_IM,"==1");
		
	B_Select(aOE,aI,f);

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
		\version	0.0.0.0
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

}

void Autoopen(){
	/**
		\version	0.0.0.0
		\date		2014.03.05
		\author		Morochin <artamir> Artiom
		\details	Автооткрытие позиций/ордеров.
		\internal
			>Hist:
			>Rev:0
	*/
	string fn="Autoopen";
	
	if(OrdersTotal()==0){
		int ti=TR_SendBUY();
		TR_ModifyTP(ti,TP,TR_MODE_PIP);
	}	
}