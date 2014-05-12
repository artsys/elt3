//+------------------------------------------------------------------+
//|                                              eFXOpen.Fractal.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.10"
#property strict

#define EXP "eFXO.Fractal"
#define VER "1.1_2014.05.02"

int hf=0;

input string s1="===== MAIN =====";
input int SL=20;     //SL fix
input double SL_percent = 0; // SL in percent
input int TP=50;     //TP fix
input double TP_percent = 0; // TP in percent
input string h1="Будет использоваться при Lot_percent=0";
input double Lot=0.1;
input string h2="Использовать процент от свободных средств для открытия позиции";
input double Lot_percent=0; // Lot in percent
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
      double _lot=TR_Lot(Lot,Lot_percent);
      
      int _sl=SL,_tp=TP;
      
      if(SL_percent>0)
         _sl=TR_PercentInPips(SL_percent,_lot,TR_PM_Balance);

      if(SL_percent>0)
         _tp=TR_PercentInPips(TP_percent,_lot,TR_PM_Balance);
   
      int ti=TR_SendMarket(op,_lot);
      TR_ModifyTP(ti,_tp,TR_MODE_PIP);
      TR_ModifySL(ti,_sl,TR_MODE_PIP);
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