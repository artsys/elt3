//+------------------------------------------------------------------+ 
//|                                              eSignalSell_TMA.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "2.00"
#property strict

extern string ao1             = "=== MA SETTINGS ===";
input int                 MAPer=50;
input ENUM_MA_METHOD      MAMethod=MODE_EMA;
input ENUM_APPLIED_PRICE  MAAppliedPrice=PRICE_CLOSE;
input int                 MALevel=30;

extern string  s1    ="=== EXPERT SETTINGS ===";
extern double  Lot   =0.1;
extern int     SL    =50;
extern int     TP    =50;
extern int     MN    =1;

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
      
      
      for(int i=0; i<=5000; i=i+500){
         Print("i="+i);
         Print("i="+i);
         int minus=1;
         for(int j=0;j<2;j++){
            minus=minus*-1;
            int Signal=getMASignal(i*minus);
            Comment("Signal sell=",Signal);
            
            if(Signal==OP_SELL && OrdersTotal()<=0){
               double _pr=Bid;
               double _sl=_pr+SL*Point;
               _sl=NormalizeDouble(_sl,Digits);
               
               double _tp=_pr-TP*Point;
               _tp=NormalizeDouble(_tp,Digits);
               
               int _res = TR_SendSELL(Lot,MN,_sl,_tp);
            }
            
            if(Signal==OP_BUY && OrdersTotal()<=0){
               double _pr=Ask;
               double _sl=_pr-SL*Point;
               _sl=NormalizeDouble(_sl,Digits);
               
               double _tp=_pr+TP*Point;
               _tp=NormalizeDouble(_tp,Digits);
               
               int _res = TR_SendBUY(Lot,MN,_sl,_tp);
            } 
         }   
      }    
  }
//+------------------------------------------------------------------+

int getMASignal(int level){
   
   int Signal=-1;
   int buffer=2;
   if(level<0)buffer=3; //Ќа случай, если мы хотим найти проколы конверта ниже ма.
   double fb=iCustom(Symbol(),0,"iMALevelseFB",MAPer,MAMethod, MAAppliedPrice, level,buffer,1);
   if(fb!=EMPTY_VALUE){
      //MessageBox("fb="+(string)fb);
      if(level<0)Signal=OP_BUY;
      else Signal=OP_SELL;
   }
   
   return(Signal);
}

int TR_SendSELL(double vol = 0.01, int mn=0, double sl=0.0, double tp=0.0){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.12.24
		>Hist:	
				 @0.0.0.2@2013.12.24@artamir	[+]	ƒобавлено выставление магика дл€ ордера.
	*/
	string comm="";
	int ticket = _OrderSend(Symbol(), OP_SELL, vol,0,0,sl,tp,comm,mn);
	
	//------------------------------------------------------
	return(ticket);
}

int TR_SendBUY(double vol = 0.01, int mn=0, double sl=0.0, double tp=0.0){
	/*
		>Ver	:	0.0.0.2
		>Date	:	2013.12.24
		>Hist:	
				 @0.0.0.2@2013.12.24@artamir	[+]	ƒобавлено выставление магика дл€ ордера.
	*/
	string comm="";
	int ticket = _OrderSend(Symbol(), OP_BUY, vol,0,0,sl,tp,comm,mn);
	
	//------------------------------------------------------
	return(ticket);
}

int TR_MaxOrdersCount=0;
int _OrderSend(string symbol = "", int cmd = OP_BUY, double volume= 0.0, double price = 0.0, int slippage = 0, double stoploss = 0.0, double takeprofit = 0.0, string comment="", int magic=-1, datetime expiration=0, color arrow_color=CLR_NONE){
	/*
		>Ver	:	0.0.0.8
		>Date	:	2014.03.05
		>History:			
					@0.0.0.8@2014.03.05@artamir	[]	ƒобавлена проверка на максимальное количество ордеров.
					@0.0.0.7@2013.09.05@artamir	[*]	_OrderSend ƒобавил установку FOD
					@0.0.6@2013.04.22@artamir	[]	_OrderSend
		>Description:
			‘ункци€ отправки закроса на открытие ордера на сервер.
		>«ависимости заголовков:
			libMarketInfo
			libNormalize
	*/
	
	//-----------------------------------------------------------
	// ѕредопределенные переменные
	//-----------------------------------------------------------
	
	string fn="_OrderSend";
	if(OrdersTotal()>=TR_MaxOrdersCount&&TR_MaxOrdersCount>0) return(-1);
	//-----------------------------------------------------------
	// Ѕлок проверок на правильность переданных параметров.
	//-----------------------------------------------------------
	
	//=============================================
	// Check symbol
	//=============================================
	if(symbol == ""){
					//если не задан нструмент, тогда используем текущий
		symbol = Symbol();
	}
	
	//------------------------------------------------------
	double dBid = MarketInfo(symbol, MODE_BID);
	double dAsk = MarketInfo(symbol, MODE_ASK);
	
	int STOPLEVEL = MarketInfo(symbol, MODE_STOPLEVEL);
	
	//=============================================
	// Check volume
	//=============================================
	double MINLOT = MarketInfo(symbol, MODE_MINLOT);
	double MAXLOT = MarketInfo(symbol, MODE_MAXLOT);
	
	//------------------------------------------------------
	int lMN = 0;
	
	//------------------------------------------------------
	if(volume < MINLOT){
		volume = MINLOT;
	}
	
	//------------------------------------------------------
	if(volume > MAXLOT){
		volume = MAXLOT;
	}
	
	//------------------------------------------------------
	if(price <= 0){
		
		//--------------------------------------------------
		if(cmd == OP_BUY){
			price = MarketInfo(symbol, MODE_ASK);
		}
		
		//--------------------------------------------------
		if(cmd == OP_SELL){
			price = MarketInfo(symbol, MODE_BID);
		}
	}
	
	//------------------------------------------------------
	if(slippage == 0){
		slippage = 0;
	}
	
	//------------------------------------------------------
	if(magic <= -1){
		lMN = MN;	
	}else{
		lMN = magic;
	}	
	
	//======================================================
	// Normalizing
	//======================================================
	price		= NormalizeDouble(price,Digits);
	stoploss	= NormalizeDouble(stoploss,Digits);
	takeprofit	= NormalizeDouble(takeprofit,Digits);
	
	//------------------------------------------------------
	//{	=== Checking ability to send order
	
		//--------------------------------------------------
		if(cmd == OP_BUYSTOP){
			if(price <= (dAsk + STOPLEVEL*Point)){
				
				price = dAsk + STOPLEVEL*Point;
				
				//return(-1);
			}
		}
		
		//--------------------------------------------------
		if(cmd == OP_SELLSTOP){
			if(price >= (dBid - STOPLEVEL*Point)){
				
				price = dBid - STOPLEVEL*Point;
				//return(-1);
			}
		}
	//}
	
	//------------------------------------------------------
	int res = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, lMN, expiration, arrow_color);
	
	//------------------------------------------------------
	int err = GetLastError();
	
	if(err>0 && res<=0){
		Print(fn,": ERR send order!");
		Print(fn,". ERR=",err);
	}
	
	//------------------------------------------------------
	if(err == 130){
		Print("Bad stop", " cmd = ", cmd, " price = ", price, "stoploss = ", stoploss, "takeprofit = ", takeprofit, " Ask = ",Ask, " Bid = ", Bid);
	}
	
	if(err==148){
		TR_MaxOrdersCount=OrdersTotal();
	}
	
	return(res);
}

