//+------------------------------------------------------------------+
//|                                              eFXOpen.Fractal.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.3"
#property strict

#define EXP "eCandleCode"
#define VER "1.3_2014.05.02"
#define DEBUG false

#define input_PRC_TPSL

int hf=0;

input string s1="===== MAIN =====";
input int SL=20;     //SL fix

#ifdef input_PRC_TPSL
input double SL_percent = 0; // SL in percent
#else 
double SL_percent = 0; // SL in percent   
#endif 

input int TP=50;     //TP fix

#ifdef input_PRC_TPSL
input double TP_percent = 0; // TP in percent
#else
double TP_percent = 0; // TP in percent
#endif 

input string h1="Будет использоваться при Lot_percent=0";
input double Lot=0.1;
input string h2="Использовать процент от свободных средств для открытия позиции";
input double Lot_percent=0; // Lot in percent
input string e1="================";

#include <sysBase.mqh>

#define iFr
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
   
   int aU[]={0,0,0};
   int aD[]={0,0,0};
   
   for(int i=0;i<3;i++){
      int bar_u=1,bar_d;
      if(i==0){
         bar_u=1;
         bar_d=1;
      }else{
         bar_u=aU[i-1];
         bar_d=aD[i-1];
      }
      aU[i]=iFR_getNearestUpBar(hf,bar_u+1);
      aD[i]=iFR_getNearestDwBar(hf,bar_d+1);
   }
   
   if(aU[0]>1 && aU[0]<=3){
      if(High[aU[0]]<High[aU[1]])sig=OP_SELL;
   }

   if(aD[0]>1 && aD[0]<=3){
      if(Low[aD[0]]>Low[aD[1]])sig=OP_BUY;
   }  
   
   int last_u=aU[0];
   int last_d=aD[0];
   int cnt=0;
   for(int i=1; i<3; i++){
      if(aU[i]==last_u){
         cnt++;
      }
      last_u=aU[i];
      
      if(aD[i]==last_d){
         cnt++;
      }   
      last_d=aD[i];
   }
   
   if(cnt>0)sig=-1;
    
   return(sig);
}

void InitSignals(){
   
   //Фракталы.
#ifdef iFr  
   aFR_init();
	hf=aFR_set(2, 2, 0);
#endif 

	
	
}