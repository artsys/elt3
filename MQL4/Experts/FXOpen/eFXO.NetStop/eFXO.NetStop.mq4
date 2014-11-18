//+------------------------------------------------------------------+
//|                                                 eFXO.NetStop.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Основные дефайны                                                 |
//+------------------------------------------------------------------+
#define SAVE_EXPERT_INFO
struct expert_info_struct{
	double buy_lot;
	double buy_tp;
	double buy_pr;
	double sell_lot;
	double sell_tp;
	double sell_pr;
	double start_pr;
	bool Autostart;
};
expert_info_struct expert_info;

//+------------------------------------------------------------------+
//|INPUTS                                                                  |
//+------------------------------------------------------------------+
input int S=20; //Шаг сетки
input int TP=100; //Тейкпрофит
input double Lot=0.1;
input double Multy=2;
input double Plus=0;
input bool LotRevers=true;


//+------------------------------------------------------------------+
//|ИНКЛЮДЫ                                                          |
//+------------------------------------------------------------------+
#include <sysBase.mqh>

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
	B_Init("NetStop");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit("NetStop");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   startext();
  }
//+------------------------------------------------------------------+

void startext(){
	B_Start("NetStop");
	
	if(ROWS(aTO)<=0){
		expert_info.start_pr=(Bid+Ask)/2;
		expert_info.buy_lot=0;
		expert_info.buy_tp=0;
		expert_info.buy_pr=expert_info.start_pr;
		expert_info.sell_lot=0;
		expert_info.sell_tp=0;
		expert_info.sell_pr=expert_info.start_pr;
		expert_info.Autostart=true;
	}
	
	
	CheckNet(OE_DTY_BUY);
	
	CheckNet(OE_DTY_SELL);
	
	expert_info.Autostart=false;
}

void CheckNet(OE_DIRECTION dty){
	double start_pr=GetStartPrice(dty);
	double tp_pr=GetTPPrice(dty);	
	int cnt=MathAbs(((start_pr-tp_pr)/Point)/S);
	for(int i=1; i<=cnt; i++){
	
	}
}

double GetTPPrice(OE_DIRECTION dty){
	double _tp=(dty==OE_DTY_BUY)?(expert_info.buy_pr+TP*Point)
											:(expert_info.sell_pr-TP*Point);
	return(_tp);											
}

double GetStartPrice(OE_DIRECTION dty){
	
	double start_pr=expert_info.start_pr;
	
	if(expert_info.Autostart){
		return(expert_info.start_pr);
	}
	
	string f=OE_DTY+"=="+dty;
	SELECT(aTO,f);
	
	//------------------------------------------------------------
	if(ROWS(aI)<=0){	
		double _pr=(Bid+Ask)/2;
		int _lvl=MathAbs(((_pr-expert_info.start_pr)/Point)/S);
		start_pr=_lvl*S*Point;
		if(dty==OE_DTY_BUY){
			expert_info.buy_pr=start_pr;
		}else{
			expert_info.sell_pr=start_pr;
		}
		return(start_pr);
	}
	
	//------------------------------------------------------------
	OE_DIRECTION rev_dty=(dty==OE_DTY_BUY)?OE_DTY_SELL:OE_DTY_BUY;
	f=OE_DTY+"=="+rev_dty+" AND "+OE_IM+"==1";
	SELECT2(aTO,aI,f);
	if(ROWS(aI)>0){
		AId_InsertSort2(aTO,aI,OE_FOOP);
		
		start_pr=(dty==OE_DTY_BUY)?AId_Get2(aTO,aI,(ROWS(aI)-1),OE_FOOP)
											:AId_Get2(aTO,aI,0,OE_FOOP);
	}
	
	return(start_pr);
}