//+------------------------------------------------------------------+
//|                                                    eFXO.TH_3.mq4 |
//|                                                          artamir |
//|                                          http://forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "san, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "3.12"
#property strict

//#define DEBUG2
//#define TRACING

double fix_profit=0;
double dZeroPrice=0;
double dBalanceOst=0;
double dLastBuyLot=0;
double dLastSellLot=0;

input string s1="===== MAIN =====";
input int Step=100;	//Шаг между ордерами
input int TP=100; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input double Lot=0.1;
input double Multy=2;
input bool UseParentLot=true;
//input string e1="================";
//input bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
//input int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)
input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=false;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=500; 

#define EXP "eFXO.TH3"

#include <sysBase.mqh>
#define OE_PLOT OE_USR1
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
   FIXProfit();
   CheckRevers();
   CheckNets();
   Autoopen();
   
   Comment("Balance Ost=",DoubleToStr(dBalanceOst,2)
	      ,"\nFixProfit=",fix_profit
	      ,"\nZeroPrice=",DoubleToStr(dZeroPrice,Digits)
	      ,"\naOE=",ArrayRange(aOE,0)
	      ,"\naEC=",ArrayRange(aEC,0)
	      ,"\naTO=",ArrayRange(aTO,0)
	      ,"\nOrdersTotal="+OrdersTotal());	
}

bool FIXProfit(){
	/**
		\version	0.0.0.1
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Закрытие ордеров при достижении фикс профита.
		\internal
			>Hist:	
					 @0.0.0.1@2014.01.08@artamir	[]	FIXProfit
			>Rev:0
	*/
   zx
	string fn="FIXProfit";
	
	if(!FIXProfit_use)return(false);
	
	int aI[]; ArrayResize(aI,0,1000);AId_Init2(aOE,aI);
	fix_profit=AId_Sum2(aOE,aI,OE_OPR);
	DPRINT2("fix_profit="+fix_profit);
	if(fix_profit<FIXProfit_amount){xz return(false);}
	
	CloseAllOrders();
	OE_delClosed();
	bNeedDelClosed=true; 
	xz
	return(true);
}


void CloseAllOrders(){
	/**
		\version	0.0.0.0
		\date		2014.01.08
		\author		Morochin <artamir> Artiom
		\details	Закрывает все ордера.
		\internal
			>Hist:
			>Rev:0
	*/
	
	int rows=ArrayRange(aTO,0);
	for(int idx = 0; idx < rows; idx++){
		int ti = aTO[idx][OE_TI];
		
		TR_CloseByTicket(ti);
	}
		
}

void CheckNets(){
   zx
   if(CntTY(-1,-1)<=0){
      return;
   }
   
   double pr=0;
   int cnt=CntTY(OP_BUY,OP_BUYSTOP);
   DPRINT2("OP_BUY; cnt="+cnt);
   if(cnt==0){
      int iNearBuyLevel=((Bid-dZeroPrice)/Point)/Step+1;
      pr=dZeroPrice+iNearBuyLevel*Step*Point;
      dLastBuyLot=dLastBuyLot*Multy;
      TrendNetBuy(pr, dLastBuyLot);
   }
   
   cnt=CntTY(OP_SELL,OP_SELLSTOP);
   DPRINT2("OP_SELL; cnt="+cnt);
   if(cnt==0){
      int iNearBuyLevel=((dZeroPrice-Bid)/Point)/Step+1;
      DPRINT2("iNearBuyLevel="+iNearBuyLevel);
      pr=dZeroPrice-iNearBuyLevel*Step*Point;
      dLastSellLot=dLastSellLot*Multy;
      TrendNetSell(pr, dLastSellLot);
   }
}

int CntTY(int ty1=-1, int ty2=-1){
   int res=0;
   string f="";
   
   if(ty1==-1 && ty2==-1){
      return(ArrayRange(aTO,0));
   }
   
   if(ty2>-1){
      res=CntTY(ty2);
   }
   
   f=StringConcatenate(""
      , OE_TY,"==",ty1);
   
   SELECT(aTO,f);
   int rows=ROWS(aI);
   
   res+=rows;   
   return(res);
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
      double saved_lot=AId_Get2(aTO,aI,i,OE_PLOT);
      
      double open_lot=plot;
      if(!UseParentLot){
         if((Bid>dZeroPrice && pty==OP_BUY) || (Bid<dZeroPrice && pty==OP_SELL)){
            open_lot=Lot;
         }else{
            if(saved_lot>0){
               open_lot=saved_lot;
            }
         }   
      }   
      
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
         TR_SendPending_array(d, tyo,	oop, 0, open_lot, TP);
         
         int rows_d=ROWS(d);
         for(int j=0;j<rows_d;j++){
            int ti=d[j];
            OE_setPBT(ti,OE_PLOT,plot);
         }
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
      dLastBuyLot=Lot;
      dLastSellLot=Lot;
      TrendNetBuy(dZeroPrice+Step*Point);
      TrendNetSell(dZeroPrice-Step*Point);
   }
}

void TrendNetBuy(double start_price, double vol=-1){
   if(vol==-1)vol=Lot;
   for(int i=0; i<Levels; i++){
      double level_price=start_price+i*Step*Point;
      SELECT(aTO,OE_OOP+"=="+level_price);
      int rows=ArrayRange(aI,0);
      
      if(rows<=0){
         double d[];
         ArrayResize(d,0);
         TR_SendPending_array(d, OP_BUYSTOP,	level_price, 0, vol, TP);
      }
   }
}


void TrendNetSell(double start_price, double vol=-1){
   zx
   if(vol==-1)vol=Lot;
   for(int i=0; i<Levels; i++){
      double level_price=start_price-i*Step*Point;
      SELECT(aTO,OE_OOP+"=="+level_price);
      int rows=ArrayRange(aI,0);
      DPRINT2("level_price="+level_price+"; rows="+rows);
      if(rows<=0){
         double d[];
         ArrayResize(d,0);
         TR_SendPending_array(d, OP_SELLSTOP,	level_price, 0, vol, TP);
      }
   }
}
double GetLot(){
   return(Lot);
}