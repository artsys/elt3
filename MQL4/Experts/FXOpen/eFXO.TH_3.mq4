//+------------------------------------------------------------------+
//|                                                    eFXO.TH_3.mq4 |
//|                                                          artamir |
//|                                          http://forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "san, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "3.00"
#property strict

//#define DEBUG2
//#define TRACING

double fix_profit=0;
double dZeroPrice=0;
double dBalanceOst=0;

input string s1="===== MAIN =====";
input int Step=100;	//Шаг между ордерами
input int TP=100; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input double Lot=0.1;
input double Multy=2;
input string e1="================";
input bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
input int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)
input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=false;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=500; 

#define EXP "eFXO.TH3"

#include <sysBase.mqh>

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
   if(!IsTesting())B_Deinit();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   eFXOTH_startext();
  }
//+------------------------------------------------------------------+

void eFXOTH_startext()export{
   B_Start();
   //CMFB();
   //FIXProfit();
   CheckRevers();
   Autoopen();
}

void CheckRevers(){
   string f=StringConcatenate("",OE_IM,"==1");
   SELECT(aTO,f);
   int rows=ArrayRange(aI,0);
   for(int i=0;i<rows;i++){
      int pti=AId_Get2(aTO,aI,i,OE_TI);
      int pty=AId_Get2(aTO,aI,i,OE_TY);
      double poop=AId_Get2(aTO,aI,i,OE_OOP);
      double plot=AId_Get2(aTO,aI,i,OE_LOT);
      
      double oop=poop-Step*Point*iif(pty==OP_BUY,1,-1);
      
      int tyo=-1,typ=-1;
      if(pty==OP_BUY){
         tyo=OP_SELLSTOP;
         typ=OP_SELL;
      }else{
         tyo=OP_BUYSTOP;
         typ=OP_BUY;
      }
      
      int cnt_orders=CntTIOnPrice(tyo,oop);
      int cnt_pos=CntTIOnPrice(typ,oop);
      
      if(cnt_orders<=0 && cnt_pos<=0){
         double d[];
         ArrayResize(d,0);
         TR_SendPending_array(d, tyo,	oop, 0, plot, TP);
      }
      
   }
}

int CntTIOnPrice(int ty, double oop){
   string f=StringConcatenate(""
                       ,OE_TY,"==",ty
                       ," AND "
                       ,OE_OOP,"==",oop
                       ," AND "
                       ,OE_IT,"==1");
                       
   SELECT(aTO,f);
   int rows=ROWS(aI);
   return(rows);                       
}
 
void Autoopen(){
   if(OrdersTotal()==0){
      dZeroPrice=Bid;
     // int ti=TR_SendBUYSTOP(dZeroPrice,Step,GetLot());
      TrendNetBuy(dZeroPrice+Step*Point);
      TrendNetSell(dZeroPrice-Step*Point);
   }
}

void TrendNetBuy(double start_price){
   for(int i=0; i<Levels; i++){
      double level_price=start_price+i*Step*Point;
      SELECT(aTO,OE_OOP+"=="+level_price);
      int rows=ArrayRange(aI,0);
      
      if(rows<=0){
         double d[];
         ArrayResize(d,0);
         TR_SendPending_array(d, OP_BUYSTOP,	level_price, 0, GetLot(), TP);
      }
   }
}


void TrendNetSell(double start_price){
   for(int i=0; i<Levels; i++){
      double level_price=start_price-i*Step*Point;
      SELECT(aTO,OE_OOP+"=="+level_price);
      int rows=ArrayRange(aI,0);
      
      if(rows<=0){
         double d[];
         ArrayResize(d,0);
         TR_SendPending_array(d, OP_SELLSTOP,	level_price, 0, GetLot(), TP);
      }
   }
}
double GetLot(){
   return(Lot);
}