//+------------------------------------------------------------------+
//|                                             eFXO.SlosTraling.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://forum.fxopen.ru"
#property version   "6.00"
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
input int      STR_XStepsBefore=2; //XStepsBefore
      int         _XStepsBefore=2;           
input double   STR_SLKoefMinus=0.1; //SLKoefMinus
      double      _SLKoefMinus=0.1;           
input double   STR_SLMinimum=0.1; //SLMin
      double      _SLMinimum=0.1;           
      
      
//input int      STR_SLStep=5; //SL step //-artamir@2014.06.09
//input double   STR_SLMulti=1; //SL koef //-artamir@2014.06.09

//#define  DEBUG2 false

#ifndef SYSBASE
   void EXP_EventMNGR(int ti, int event){}
   #define EXP "eFXO.SlosTraling"
   #include <sysBase.mqh>
#endif

//{ === Для вызова из других советников.

void PrintParams()export{
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

void eFXOSlosTraling_XStepsBefore(int val)export{
  _XStepsBefore=val;
}

void eFXOSlosTraling_SLKoefMinus(double val)export{
  _SLKoefMinus=val;
}

void eFXOSlosTraling_SLMinimum(double val)export{
  _SLMinimum=val;
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
   eFXOSlosTraling_XStepsBefore(STR_XStepsBefore);
   eFXOSlosTraling_SLKoefMinus(STR_SLKoefMinus);
   eFXOSlosTraling_SLMinimum(STR_SLMinimum);
   
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

   fSTR_Check();
   
   //fSTR_Check(OP_SELL);
}

void fSTR_Check(){
   zx
   DAIdPRINTALL2(aTO,"before");
   string f=StringConcatenate(""
            ,OE_IT,"==1");
   SELECT(aEC,f);
   DAIdPRINT2(aTO,aI,"after");
   DPRINT2(f);
   int rows=ArrayRange(aI,0);
   if(rows<_PosAmount)return; //Если меньше заданного количества позиций, тогда выходим.
   
   fSTR_CheckSelected(aI);
}

void fSTR_CheckSelected(int &aI[]){
   DAIdPRINT(aTO,aI,"aEC");
   
   double tickval=MarketInfo(Symbol(),MODE_TICKVALUE);
   
   int rows=ArrayRange(aI,0);
   if(rows<=0)return;
   
   int ty=-1;//AId_Get2(aEC,aI,0,OE_TY);
   DPRINT("ty="+(string)ty);
   
   wl_struct wl_buy=fSTR_GetWLPrice(aI, OE_DTY_BUY);
   wl_struct wl_sell=fSTR_GetWLPrice(aI, OE_DTY_SELL);
   
   double wlpr=0;
   double netto_lots=MathAbs(wl_buy.lot-wl_sell.lot);
   if(wl_buy.lot>wl_sell.lot){
   	wlpr=wl_buy.pr+(wl_buy.pr-wl_sell.pr)*wl_sell.lot/netto_lots;
   	ty=OP_BUY;
   }

	if(wl_buy.lot<wl_sell.lot){
   	wlpr=wl_sell.pr-(wl_sell.pr-wl_buy.pr)*wl_buy.lot/netto_lots;
   	ty=OP_SELL;
   }   
   
   if(netto_lots==0)return;
   
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
   
   int max_decrease_level=max_levels-_XStepsBefore;
   
   //int sl_pips=STR_SLStep*STR_SLMulti*max_levels; //-artamir@2014.06.09
   int sl_pips=0;
      if(max_decrease_level<=0){
         sl_pips=max_level_pips*_SLKoef;
      }else{
         double dsl_koef=_SLKoef-(max_decrease_level*_SLKoefMinus);
         if(dsl_koef<_SLMinimum){
            dsl_koef=_SLMinimum;
         }
         sl_pips=max_level_pips*dsl_koef;
      }   
   
   int koef=(ty==OP_BUY)?(1.00):(-1.00);
   double max_level_price=wlpr+max_level_pips*Point*koef;
   DPRINT("max_level_price="+(string)max_level_price);
   koef=(ty==OP_BUY)?(-1):(1);
   double sl_price=max_level_price+sl_pips*Point*koef;
   
   fSTR_SetSL(aI, sl_price); 
}

struct wl_struct{
	double pr;
	double lot;
};

wl_struct fSTR_GetWLPrice(int &aI[], OE_DIRECTION dty){
   
   wl_struct wl;
   int a2I[];
   ArrayCopy(a2I,aI);
   SELECT2(aTO,a2I,OE_DTY+"=="+dty);
   
   double wl_pr=0, lots=0; 
   
   int rows=ROWS(a2I);
   if(rows<=0) return(wl);
   
   for(int i=0; i<rows; i++){
      double _lot=AId_Get2(aTO,aI,i,OE_LOT);
      lots+=_lot;
      wl_pr+=AId_Get2(aTO,aI,i,OE_OOP)*_lot;
   }
   wl_pr=wl_pr/lots;
   
   wl.pr=wl_pr;
   wl.lot=lots;
   return(wl);
}

void fSTR_SetSL(int &aI[], double sl_price){
   int rows=ArrayRange(aI,0);
   if(rows<=0)return;
   
   for(int i=0; i<rows; i++){
      int ti=AId_Get2(aTO,aI,i,OE_TI);
      TR_ModifySLInPlus(ti,sl_price,TR_MODE_PRICE);
   }
}