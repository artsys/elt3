//+------------------------------------------------------------------+
//|                                              eFXOpen.Fractal.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#define EXP "eFXO.Fractal"
#define VER "1.00_2014.05.02"

int hf=0;

input string s1="===== MAIN =====";
input int SL=20;     //Stoploss
input int TP=50;     //Takeprofit
input string h1="Будет использоваться при Lot_percent=0";
input double Lot=0.1;
input string h2="Использовать процент от свободных средств для открытия позиции";
input double Lot_percent=0;
input string e1="================";

#include <sysBase.mqh>
#include <iFractal.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init();
   InitSignals();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit(); 
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
   zx
   
   B_Start();
   
   OE_delClosed();
   
   Autoopen();
      
   xz
}

void Autoopen(){
   int op=GetSignal();
   
   Comment(op);
   
   if(OrdersTotal()==0 && op>=0){
      int ti=TR_SendMarket(op,TR_Lot(Lot,Lot_percent));
      TR_ModifyTP(ti,TP,TR_MODE_PIP);
      TR_ModifySL(ti,SL,TR_MODE_PIP);
   }
}

int GetSignal(){
   int sig=-1;
   
   sig=GetFractalSignal();
   
   return(sig);
}

int GetFractalSignal(){
   int sig=-1;
   
   int aU[]={1,0};
   int aD[]={1,0};
   
   for(int i=0;i<2;i++){
      aU[i]=iFR_getNearestUpBar(hf,aU[0]+i);
      aD[i]=iFR_getNearestDwBar(hf,aD[0]+i);
   }
   
   if(aU[0]>1 && aU[0]<=3){
      if(High[aU[0]]<High[aU[1]])sig=OP_SELL;
   }

   if(aD[0]>1 && aD[0]<=3){
      if(Low[aD[0]]>Low[aD[1]])sig=OP_BUY;
   }   
   return(sig);
}

void InitSignals(){
   
   //Фракталы.
   aFR_init();
	hf=aFR_set(2, 2, 0);
}