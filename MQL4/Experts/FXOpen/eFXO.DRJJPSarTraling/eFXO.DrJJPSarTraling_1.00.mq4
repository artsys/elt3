//+------------------------------------------------------------------+
//|                                         eFXO.DrJJPSarTraling.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| TEMPLATE
//+------------------------------------------------------------------+
#define SAVE_EXPERT_INFO
struct expert_info_struct{};
expert_info_struct expert_info={};

//+------------------------------------------------------------------+
//|INPUT
//+------------------------------------------------------------------+
input double SARStep=0.02;
input double SARMaximum=0.2;
input int DeltaBuy=0;
input int DeltaSell=0;

//+------------------------------------------------------------------+
//|TEMPLATE
//+------------------------------------------------------------------+
void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

#include <sysBase.mqh>

void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      //EXP_EventClosed(ti);
   }
}


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
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
	B_Start("SARTraling");
	DAIdPRINTALL5(aTO,"aTO ______");
	SAR_Traling();
}

void SAR_Traling(){
	bool isUp=SAR_isUP("",0,SARStep,SARMaximum,0);
	double pr=SAR_get("",0,SARStep,SARMaximum,0);
	string f="";
	if(isUp){
		pr=pr+DeltaBuy*Point;
		f=OE_TY+"=="+OP_BUYSTOP;
		SELECT(aTO,f);
		for(int i=0;i<ROWS(aI);i++){
			TR_MoveOrder(AId_Get2(aTO,aI,i,OE_TI),pr,TR_MODE_PRICE);
		}
		f=OE_DTY+"=="+OE_DTY_SELL;
		SELECT2(aTO,aI,f);
		for(int i=0;i<ROWS(aI);i++){
			TR_ModifySL(AId_Get2(aTO,aI,i,OE_TI),pr,TR_MODE_PRICE);
		}
	}else{
		pr=pr-DeltaSell*Point;
		f=OE_TY+"=="+OP_SELLSTOP;
		SELECT(aTO,f);
		for(int i=0;i<ROWS(aI);i++){
			TR_MoveOrder(AId_Get2(aTO,aI,i,OE_TI),pr,TR_MODE_PRICE);
		}
		f=OE_DTY+"=="+OE_DTY_BUY;
		SELECT2(aTO,aI,f);
		for(int i=0;i<ROWS(aI);i++){
			TR_ModifySL(AId_Get2(aTO,aI,i,OE_TI),pr,TR_MODE_PRICE);
		}
	}
}

//{ === SAR ====================================================================
int SAR_getNearestChange(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   
   if(sy=="")sy=Symbol();
   bool isUP=SAR_isUP(sy,tf,step,maximum,shift);
   int bar=shift;
   while((isUP==SAR_isUP(sy,tf,step,maximum,bar) && bar<Bars)){
      bar++;
   }
   bar--;
   return(bar);
}

bool SAR_isUP(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   bool res=false;
   if(sy=="")sy=Symbol();
   
   if(shift>Bars){
      return(false);
   }
   
   double sar=SAR_get(sy,tf,step,maximum,shift);
 
   if(sar>=(High[shift]+Low[shift])/2)res=true;
   return(res);
}

bool SAR_isDW(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   bool res=false;
   
   if(shift>Bars){
      return(false);
   }
   
   if(sy=="")sy=Symbol();
   double sar=SAR_get(sy,tf,step,maximum,shift);
   
   if(sar<=(High[shift]-Low[shift])/2)res=true;
   return(res);
}

double SAR_get(string sy="", int tf=0, double step=0.02, double maximum=0.2, int shift=1){
   if(sy=="")sy=Symbol();
   return(iSAR(sy,tf,step,maximum,shift));
}

//} -----------------------------------------------------------------------------