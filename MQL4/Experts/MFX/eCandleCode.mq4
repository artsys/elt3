//+------------------------------------------------------------------+
//|                                              eFXOpen.Fractal.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.4"
#property strict

#define EXP "eCandleCode"
#define VER "1.3_2014.05.26"

#define DEBUG false
#define CANDLECODE

int thisCandleCode=0;

//COMPILER DEFINES
//#define input_PRC_TPSL

int hf=0;
int signal=-1;

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

input bool   CloseOnRevers=false;//Close revers
input string e1="================";

#include <sysBase.mqh>

//#define iFr
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
   signal=GetSignal();
   int op=signal;
   
   if(thisCandleCode==118||thisCandleCode==3||thisCandleCode==57||thisCandleCode==96||thisCandleCode==32){
      if(op==OP_BUY)op==OP_SELL;
      if(op==OP_SELL)op==OP_BUY;
   }
   
   if(CloseOnRevers){
      fCloseRevers(signal);
   }
   
   Comment(op);
   
   if(OrdersCount()<=0 && op>=0){
      double _lot=TR_Lot(Lot,Lot_percent);
      
      int _sl=SL,_tp=TP;
      
      if(SL_percent>0)
         _sl=TR_PercentInPips(SL_percent,_lot,TR_PM_Balance);

      if(SL_percent>0)
         _tp=TR_PercentInPips(TP_percent,_lot,TR_PM_Balance);
   
      int ti=TR_SendMarket(op,_lot);
      TR_ModifyTP(ti,_tp,TR_MODE_PIP);
      TR_ModifySL(ti,_sl,TR_MODE_PIP);
      
      OE_setSTD(ti);
      B_Start();
   }
}


int OrdersCount(){
   zx
   int res=0;
   DAIdPRINTALL(aOE,(int)iTime(Symbol(),0,0));
   DPRINT("iTime="+(int)iTime(Symbol(),0,0)); 
   string f=StringConcatenate(""
            ,OE_IT,"==1");
            //," AND "
            //,OE_OOT,">="+(int)iTime(Symbol(),0,0));
   
   SELECT(aOE,f);
   res=ArrayRange(aI,0);
   
   xz
   return(res);
}

int GetSignal(){
   int sig=-1;
   
   #ifdef FRACTAL
   sig=GetFractalSignal();
   #endif 
   
   #ifdef CANDLECODE
   sig=GetCandleCodeSignal();
   #endif 
   
   return(sig);
}

int GetCandleCodeSignal(){
   int sig=-1;
   
   double cd1=iCustom(Symbol(),PERIOD_D1,"iCandlesPropHBL_2.0",15,0,1);
   double cd2=iCustom(Symbol(),PERIOD_D1,"iCandlesPropHBL_2.0",15,0,2);
   
   thisCandleCode=cd1;
   
  // PrintFormat("cd1=%f",cd1);
  // PrintFormat("cd2=%f",cd2);
   
   if(cd1>cd2)sig=OP_BUY;
   if(cd1<cd2)sig=OP_SELL;
   
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
   #ifdef iFr  
      aFR_init();
   	hf=aFR_set(2, 2, 0);
   #endif 
}

void fCloseRevers(int op){
   int rev_op=TR_GetReversOP(op);
   
   string f=StringConcatenate(""
            ,OE_IT,"==1"
            ," AND "
            ,OE_TY,"==",rev_op);
            
   SELECT(aEC,f);
   int rows=ArrayRange(aI,0);
   for(int i=0;i<rows;i++){
      int rev_ti=AId_Get2(aEC,aI,i,OE_TI);
      TR_CloseByTicket(rev_ti);
   }
               
}