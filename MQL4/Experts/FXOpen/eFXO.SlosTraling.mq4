//+------------------------------------------------------------------+
//|                                             eFXO.SlosTraling.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://forum.fxopen.ru"
#property version   "2.10"
#property strict
//--- input parameters
input bool     STR_Use=true;  //Slos traling
input int      STR_PosAmount=2; //Positions amount
input int      STR_PriceStart=25; //Price start
input int      STR_PriceStep=10; //Price step
input double   STR_SLKoef=0.5; //SL koef
//input int      STR_SLStep=5; //SL step //-artamir@2014.06.09
//input double   STR_SLMulti=1; //SL koef //-artamir@2014.06.09

#define  DEBUG false

#ifndef SYSBASE
   #define EXP "eFXO.SlosTraling"
   #include <sysBase.mqh>
#endif
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init();
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
void OnTick(){
//---
   if(IsTesting()){
      if(OrdersTotal()==0){
         TR_SendSELL();
      }
   }   

   startext();
}
//+------------------------------------------------------------------+
void startext(){
   bNeedDelClosed=true;
   
   B_Start();
   
   fSTR_Main();
}

void fSTR_Main(){
   if(!STR_Use) return;

   fSTR_Check(OP_BUY);
   
   fSTR_Check(OP_SELL);
}

void fSTR_Check(int op){
   string f=StringConcatenate(""
            ,OE_IT,"==1"
            ," AND "
            ,OE_TY,"==",op);
   SELECT(aEC,f);
   
   int rows=ArrayRange(aI,0);
   if(rows<STR_PosAmount)return; //Если меньше заданного количества позиций, тогда выходим.
   
   fSTR_CheckSelected(aI);
}

void fSTR_CheckSelected(int &aI[]){
   DAIdPRINT(aEC,aI,"aEC");
   int rows=ArrayRange(aI,0);
   if(rows<=0)return;
   
   int ty=AId_Get2(aEC,aI,0,OE_TY);
   DPRINT("ty="+(string)ty);
   
   double wlpr=fSTR_GetWLPrice(aI);
   DPRINT("wlpr="+(string)wlpr);
   
   double this_price = 0;
   
   if(ty==OP_BUY){this_price=MarketInfo(Symbol(),MODE_BID); DPRINT("ty==OP_BUY");}
   if(ty==OP_SELL){this_price=MarketInfo(Symbol(),MODE_ASK); DPRINT("ty==OP_SELL");}
   DPRINT("this_price="+(string)this_price);
   
   int profit_pips=(ty==OP_BUY)?((this_price-wlpr)/Point):((wlpr-this_price)/Point);
   DPRINT("profit_pips="+(string)profit_pips);
   
   //if(profit_pips<STR_PriceStep) return; //-artamir@2014.06.09
   if(profit_pips<STR_PriceStart) return; //+artamir@2014.06.09
   
   //int max_levels=(profit_pips)/STR_PriceStep; //-artamir@2014.06.09
   int max_levels=(profit_pips-STR_PriceStart)/STR_PriceStep; 
   DPRINT("max_levels="+(string)max_levels);
   
   int max_level_pips=STR_PriceStart+max_levels*STR_PriceStep;//+artamir@2014.06.09
   DPRINT("max_level_pips="+(string)max_level_pips);
   
   //int sl_pips=STR_SLStep*STR_SLMulti*max_levels; //-artamir@2014.06.09
   int sl_pips=max_level_pips*STR_SLKoef;
   
   int koef=(ty==OP_BUY)?(1.00):(-1.00);
   double max_level_price=wlpr+max_level_pips*Point*koef;
   DPRINT("max_level_price="+(string)max_level_price);
   koef=(ty==OP_BUY)?(-1):(1);
   double sl_price=max_level_price+sl_pips*Point*koef;
   
   fSTR_SetSL(aI, sl_price); 
}

double fSTR_GetWLPrice(int &aI[]){
   double wl_pr=0, lots=0; 
   int rows=ArrayRange(aI,0);
   if(rows<=0) return(0);
   
   for(int i=0; i<rows; i++){
      double _lot=AId_Get2(aEC,aI,i,OE_LOT);
      lots+=_lot;
      wl_pr+=AId_Get2(aEC,aI,i,OE_OOP)*_lot;
   }
   
   wl_pr=wl_pr/lots;
   return(wl_pr);
}

void fSTR_SetSL(int &aI[], double sl_price){
   int rows=ArrayRange(aI,0);
   if(rows<=0)return;
   
   for(int i=0; i<rows; i++){
      int ti=AId_Get2(aEC,aI,i,OE_TI);
      TR_ModifySLInPlus(ti,sl_price,TR_MODE_PRICE);
   }
}