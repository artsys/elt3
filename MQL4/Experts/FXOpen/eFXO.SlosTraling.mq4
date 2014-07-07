//+------------------------------------------------------------------+
//|                                             eFXO.SlosTraling.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://forum.fxopen.ru"
#property version   "3.11"
#property strict
//--- input parameters
input bool     STR_Use=true;  //Slos traling
      bool        _Use=true;
input int      STR_PosAmount=2; //Positions amount
      int         _PosAmount=2; 
input int      STR_PriceStart=250; //Price start
      int         _PriceStart=250;
input int      STR_PriceStep=100; //Price step
      int         _PriceStep=100;
input double   STR_SLKoef=0.5; //SL koef
      double      _SLKoef=0.5;
//input int      STR_SLStep=5; //SL step //-artamir@2014.06.09
//input double   STR_SLMulti=1; //SL koef //-artamir@2014.06.09

//#define  DEBUG2 false

#ifndef SYSBASE
   #define EXP "eFXO.SlosTraling"
   #include <sysBase.mqh>
#endif

//{ === Для вызова из других советников.

void PrintParams(){
   Print("STR_Use="+_Use);
   Print("STR_PosAmount="+_PosAmount);
   Print("STR_PriceStart="+_PriceStart);
   Print("STR_PriceStep="+_PriceStep);
   Print("STR_SLKoef="+_SLKoef);
}

//{ === Блок установки инпут параметров
void eFXOSlosTraling_Use(bool val)export{
   _Use=val;
}

void eFXOSlosTraling_PosAmount(int val)export{
   _PosAmount=val;
}

void eFXOSlosTraling_PriceStart(int val)export{
   _PriceStart=val;
}

void eFXOSlosTraling_PriceStep(int val)export{
  _PriceStep=val;
}

void eFXOSlosTraling_SLKoef(double val)export{
  _SLKoef=val;
}

void eFXOSlosTraling_MN(int val)export{
   TR_MN=val;
}
//}

void eFXOSlosTraling_startext()export{
   startext();
}
//}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   eFXOSlosTraling_Use(STR_Use);
   eFXOSlosTraling_PosAmount(STR_PosAmount);
   eFXOSlosTraling_PriceStart(STR_PriceStart);
   eFXOSlosTraling_PriceStep(STR_PriceStep);
   eFXOSlosTraling_SLKoef(STR_SLKoef);

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
   //if(IsTesting()){
   //   if(OrdersTotal()==0){
   //      TR_SendSELL();
   //   }
   //}   

   startext();
}
//+------------------------------------------------------------------+
void startext(){
   zx
   
   //PrintParams();
   
   bNeedDelClosed=true;
   
   B_Start();
   
   fSTR_Main();
}

void fSTR_Main(){
   if(!_Use) return;

   fSTR_Check(OP_BUY);
   
   fSTR_Check(OP_SELL);
}

void fSTR_Check(int op){
   zx
   DAIdPRINTALL2(aEC,"before");
   string f=StringConcatenate(""
            ,OE_IT,"==1"
            ," AND "
            ,OE_TY,"==",op);
   SELECT(aEC,f);
   DAIdPRINT2(aEC,aI,"after");
   DPRINT2(f);
   int rows=ArrayRange(aI,0);
   if(rows<_PosAmount)return; //Если меньше заданного количества позиций, тогда выходим.
   
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
   if(profit_pips<_PriceStart) return; //+artamir@2014.06.09
   
   //int max_levels=(profit_pips)/STR_PriceStep; //-artamir@2014.06.09
   int max_levels=(profit_pips-_PriceStart)/_PriceStep; 
   DPRINT("max_levels="+(string)max_levels);
   
   int max_level_pips=_PriceStart+max_levels*_PriceStep;//+artamir@2014.06.09
   DPRINT("max_level_pips="+(string)max_level_pips);
   
   //int sl_pips=STR_SLStep*STR_SLMulti*max_levels; //-artamir@2014.06.09
   int sl_pips=max_level_pips*_SLKoef;
   
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