	/**
		\version	3.1.0.9
		\date		2014.03.07
		\author		Morochin <artamir> Artiom
		\details	Собиратель тренда (Trend Harvester)
		\internal
			>Hist:									
					 @3.1.0.9@2014.03.07@artamir	[*]	CMFB
					 @3.1.0.7@2014.03.06@artamir	[+]	TI_count
					 @3.1.0.6@2014.03.06@artamir	[+]	TN_checkRev
					 @3.1.0.4@2014.03.06@artamir	[+]	TN_checkCO
					 @3.1.0.3@2014.03.06@artamir	[+]	Autoopen
					 @3.1.0.2@2014.03.06@artamir	[+]	GetLot
					 @3.1.0.1@2014.03.06@artamir	[+]	TN
			>Rev:0
	*/

#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "310.0"
#property strict
#property stacksize 1024

bool bDebug=false;
bool bNeedDelClosed();

input string s1="===== MAIN =====";
input int Step=20;	//Шаг между ордерами
input int TP=50; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input double Lot=0.1;
input string e1="================";
extern bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
extern int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)

#define EXP "eTH"\
#define VER "3.1.0.9_2014.03.07"
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
	
	if(bDebug){
		Print("============================");
		Print(fn,"->B_Start()");
	}
	
	B_Start();
	
	if(bDebug){
		Print(fn,"->CMFB()");
	}
	CMFB();
	
	if(bDebug){
		Print(fn,"->TN()");
	}
	TN();
	
	if(bDebug){
		Print(fn,"->Autoopen()");
	}
	Autoopen();
	
	// int aI[]; ArrayResize(aI,0);
	// AId_Init2(aEC,aI);
	// AId_Print2(aEC,aI,4,"aEC_all");

   // ArrayResize(aI,0);
	// AId_Init2(aOE,aI);
	// AId_Print2(aOE,aI,4,"aOE_all");	
	return(0);
}

void CMFB(){
	/**
		\version	0.0.0.4
		\date		2014.03.07
		\author		Morochin <artamir> Artiom
		\details	Закрытие минусовых ордеров из средств баланса.
		\internal
			>Hist:				
					 @0.0.0.4@2014.03.07@artamir	[*]	Добавлен удаление закрытых ордеров из массива aOE после срабатывания закрытия по профиту.
					 @0.0.0.3@2014.03.06@artamir	[]	CMFB
					 @0.0.0.2@2014.01.15@artamir	[+]	Добавлено удаление закрытых ордеров, после закрытия хоть одного минусового ордера, если профит по закрытым ордерам не превышает 1.
					 @0.0.0.1@2014.01.15@artamir	[+]	CMFB
			>Rev:0
	*/

	string fn="CMFB";
	
	if(!CMFB_use)return;
	
	//Получаем сумму всех закрытых ордеров сессии.
	string f="";
	f=StringConcatenate(f
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IC,"==1");
		
	int aI[];
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	if(bDebug){
		Print(fn,"->B_Select() //profit");
	}
	B_Select(aOE,aI,f);
	
	int rows=ArrayRange(aI,0);
	
	if(rows<=0)return; //Значит у нас нет профита для закрытия минусов.
	
	double profit=AId_Sum2(aOE, aI, OE_OPR);
	//Comment("Closed profit=",profit);
	
	//Выбираем ордера которые ушли в минус больше заданного значения.
	f="";
	f=StringConcatenate(f
		,OE_MN,"==",TR_MN
		," AND "
		,OE_IT,"==1"
		," AND "
		,OE_IM,"==1"
		," AND "
		,OE_CP2OOP,"<<",-CMFB_pips);
	ArrayResize(aI,0);
	AId_Init2(aOE,aI);
	
	if(bDebug){
		Print(fn,"->B_Select() //in minus");
		//AId_Print2(aOE,aI,4,"aOE_B_Select_in minus");
		B_BSEL=true;
	}
	B_Select(aOE,aI,f);
	if(bDebug){
		Print(fn,"->B_Select() //in minus end");
		B_BSEL=false;
	}
	rows=ArrayRange(aI,0);
	Comment("Count orders in minus=",rows,"\n"
			,"profit=",profit);
			
	if(profit<=0)return;		
	if(rows<=0)return; //нет таких ордеров.
	int i=0;
	while(profit>0&&i<rows){
		int ti=aOE[aI[i]][OE_TI];
		double opr=aOE[aI[i]][OE_OPR];
		if(MathAbs(opr)<=profit){
			if(TR_CloseByTicket(ti)){
				profit=profit-MathAbs(opr);
				bNeedDelClosed=true;
			}	
		}else{
			break;
		}
		i++;
	}
	
	if(bNeedDelClosed){
		OE_delClosed();
		bNeedDelClosed=false;
	}
	
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
		TN_checkRev(pti);
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

void TN_checkRev(int pti){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Проверка противоположных ордеров.
		\internal
			>Hist:		
					 @0.0.0.1@2014.03.06@artamir	[+]	TN_checkRev
			>Rev:0
	*/
	string fn="TN_checkRev";
	
	OrderSelect(pti,SELECT_BY_TICKET);
	int pty=OrderType();
	double poop=OrderOpenPrice();
	
	int typ=-1,tyo=-1;
	double roop=-1;
	if(pty==OP_BUY){
		typ=OP_SELL;
		tyo=OP_SELLSTOP;
		roop=poop-Step*Point;
		
		if(Ask<=poop) return;
	}

	if(pty==OP_SELL){
		typ=OP_BUY;
		tyo=OP_BUYSTOP;
		roop=poop+Step*Point;
		if(Bid>=poop)return;
	}
	
	if(TI_count(typ,roop)<=0&&TI_count(tyo,roop)<=0){		
		double d[];
		ArrayResize(d,0);
		int AddPips=Step;
		TR_SendPending_array(d, tyo, poop, AddPips, GetLot(), TP);
		
		int rows=ArrayRange(d,0);
		for(int i=0;i<rows;i++){
			TN_checkCO(d[i]);
		}
	}	
}

int TI_count(int ty, double oop){
	/**
		\version	0.0.0.1
		\date		2014.03.06
		\author		Morochin <artamir> Artiom
		\details	Возвращает количество ордеров по заданной цене и типу
		\internal
			>Hist:	
					 @0.0.0.1@2014.03.06@artamir	[+]	TI_count
			>Rev:0
	*/

	string fn="TI_count";
	
	int aI[];ArrayResize(aI,0);
	AId_Init2(aEC,aI);
	string f=StringConcatenate(""
		,OE_IT,"==1"
		," AND "
		,OE_OOP,"==",oop
		," AND "
		,OE_TY,"==",ty);
		
	B_Select(aEC,aI,f);
		
	int rows=ArrayRange(aI,0);
	
	return(rows);
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
