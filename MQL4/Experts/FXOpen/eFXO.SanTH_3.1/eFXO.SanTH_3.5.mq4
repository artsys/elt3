//+------------------------------------------------------------------+
//|                                               eFXO.SanTH_3.1.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "3.50"
#property strict

#define SAVE_EXPERT_INFO
struct expert_info_struct{
   double last_buy_lot;
   double last_buy_pr;
  
   double last_sell_lot;
   double last_sell_pr;
   
   double zero_pr;
   bool autoopen;
   double closed_profit;
};

expert_info_struct expert_info={0,0,0,0,0,false,0};


//#define DEBUGERR
//#define DEBUG5
//#define TRACING

input string s1="===== MAIN =====";
input int LevelStep=10;	//Шаг между ордерами
input int TP=15; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=2; //Кол. уровней.
input double Lot=0.1;
input double Multy=2;
input double Plus=0.1;
input bool UseParentLot=true;

input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=true;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=10; 

void EXP_EventMNGR_forward(int ti, int event){
   EXP_EventMNGR(ti, event);
}

#include <sysBase.mqh>

#define OE_LVLPR OE_USR1
#define OE_FOP OE_USR2

double gdFOP=0;
double fix_profit=0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(FIXProfit_use)bNeedDelClosed=false;
   B_Init("eFXO.SanTH");
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

   B_Deinit("eFXO.SanTH");
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

void EXP_EventMNGR(int ti, int event){
   if(event==EVT_CLS){
      //EXP_EventClosed(ti);
   }
}


void startext(){
   DAIdPRINTALL3(aOE,"___________________");
   B_Start("eFXO.SanTH");
   
   //Закрытие позиций
      //Фикс профит
      if(FIXProfit()){
         bNeedDelClosed=true;
         expert_info.closed_profit=0.0;
         DAIdPRINTALL5(aOE,"aOE after fix profit");
         return;
      }else{
         bNeedDelClosed=false;
      }
   //Открытие позиций
      Autoopen();
   //Проверка сетки
      Checking();
   
   Comment(""
      ,"\nfix_profit=",fix_profit
      ,"\naOE=",ROWS(aOE)
      ,"\naTO=",ROWS(aTO)
      ,"\nexp.closed_profit=",expert_info.closed_profit
      ,"\nexp.zero_pr=",expert_info.zero_pr
      ,"\nexp.autoopen=",expert_info.autoopen
      ,"\nexp.last_buy_lot=",expert_info.last_buy_lot
      ,"\nexp.last_buy_pr=",expert_info.last_buy_pr
      ,"\nexp.last_sell_lot=",expert_info.last_sell_lot
      ,"\nexp.last_sell_pr=",expert_info.last_sell_pr);
      
}

void Checking(){
   //Проверяем, если закрылись бай сетки.
   
   OE_DIRECTION dty=OE_DTY_BUY;
   SELECT(aTO,OE_DTY+"=="+dty);
   if(ROWS(aI)<=0){
      //Если закрылись байевые сетки.
      //Выставляем новую сетку увеличенным объемом.
      expert_info.last_buy_lot=expert_info.last_buy_lot*Multy+Plus;
      expert_info.autoopen=true;
      
      double _nearest_buy_level=GetNearestBuyLevel();
      DPRINT3("NBL="+_nearest_buy_level);
      TrendNetBuy(_nearest_buy_level,expert_info.last_buy_lot);   

      double _nearest_sell_level=GetNearestSellLevel();
      TrendNetSell(_nearest_sell_level,expert_info.last_buy_lot);  
   }else{
      //Если байевые еще не закрыты,
      //То проверим байевые позиции.
      SELECT2(aTO,aI,OE_IM+"==1");
      for(int i=0; i<ROWS(aI);i++){
         int pti=AId_Get2(aTO,aI,i,OE_TI);
         double plot=AId_Get2(aTO,aI,i,OE_LOT);
         double ppr=AId_Get2(aTO,aI,i,OE_LVLPR);
         TrendNetSell(ppr-LevelStep*Point, plot);
      }
   }
   
   //Проверяем, если закрылись селл сетки.
   dty=OE_DTY_SELL;
   SELECT2(aTO,aI,OE_DTY+"=="+dty);
   if(ROWS(aI)<=0){
      //Если закрылись байевые сетки.
      //Выставляем новую сетку увеличенным объемом.
      expert_info.last_sell_lot=expert_info.last_sell_lot*Multy+Plus;
      expert_info.autoopen=true;    
      double _nearest_sell_level=GetNearestSellLevel();
      TrendNetSell(_nearest_sell_level,expert_info.last_sell_lot);   
      
      double _nearest_buy_level=GetNearestBuyLevel();
      TrendNetBuy(_nearest_buy_level,expert_info.last_sell_lot);   
   }else{
      //Если байевые еще не закрыты,
      //То проверим байевые позиции.
      SELECT2(aTO,aI,OE_IM+"==1");
      for(int i=0; i<ROWS(aI);i++){
         int pti=AId_Get2(aTO,aI,i,OE_TI);
         double plot=AId_Get2(aTO,aI,i,OE_LOT);
         double ppr=AId_Get2(aTO,aI,i,OE_LVLPR);
         TrendNetBuy(ppr+LevelStep*Point, plot);
      }
   }
}

int GetLevels(const double start_pr=-1){
   double _pr=CheckPr(start_pr);
   DPRINT3("_pr"+_pr);
   int res = MathCeil(MathAbs(expert_info.zero_pr-_pr)/Point/LevelStep);
   return(res);
}

double CheckPr(const double pr){
   double res=pr;
   if(res<=0){
      res=Bid;
   }
   return(res);
}

double CalcPr(int levels, int fl){
   double res=expert_info.zero_pr;
   
   res+=fl*levels*Point*LevelStep;
   
   return(res);
}

double GetNearestBuyLevel(const double start_pr=-1){
   double res=0;
   double _pr=CheckPr(start_pr);
   DPRINT3("_pr="+_pr);
   
   
   int i=GetLevels(_pr);
   DPRINT3("L="+i);
   
   int fl=1;
   if(_pr<expert_info.zero_pr){
      i--;
      fl=-1;
   }
   
   res=CalcPr(i,fl);
   DPRINT3("RES="+res);
   return(res);
}

double GetNearestSellLevel(const double start_pr=-1){
   double res=0;
   double _pr=CheckPr(start_pr);
   
   int i=GetLevels(_pr);
   
   int fl=-1;
   if(_pr>expert_info.zero_pr){
      i--;
      fl=1;
   }
   
   res=CalcPr(i,fl);
   
   return(res);
}

void Autoopen(){
   if(ROWS(aTO)>0){
      return;
   }
   
   gdFOP=Bid;
   expert_info.zero_pr=gdFOP;
   expert_info.last_buy_lot=Lot;
   expert_info.last_sell_lot=Lot;
   
   expert_info.autoopen=true;
   TrendNetBuy(gdFOP+LevelStep*Point, Lot);
   
   expert_info.autoopen=true;
   TrendNetSell(gdFOP-LevelStep*Point, Lot);
}

void TrendNet(const double start_level, const double start_lot, const OE_DIRECTION dty){
   double _lvl_pr=0, _lvl_lot=0;
   DPRINT3("DIRECTION ==== "+dty);
   DAIdPRINTALL3(aOE,"_________");
   
   int _levels=Levels;
   int fl=0;
   int cmd=-1;
   
   if(dty==OE_DTY_BUY){
      fl=1;
      cmd=OP_BUYSTOP;
      if(Bid<expert_info.zero_pr){
         _levels=GetLevels();
      }
   }   
   
   if(dty==OE_DTY_SELL){
      fl=-1;
      cmd=OP_SELLSTOP;
      if(Bid>expert_info.zero_pr){
         _levels=GetLevels();
      }
   }
   if(expert_info.autoopen && dty==OE_DTY_SELL){
      DPRINT5("_levels = "+_levels);
   }
   
   for(int i=0; i<_levels; i++){
      _lvl_pr=start_level+fl*i*LevelStep*Point;
      
      if(expert_info.autoopen){
         DPRINT3("_lvl_pr="+_lvl_pr);
      }
      
      if(dty==OE_DTY_BUY){
         if(_lvl_pr<Bid)continue; //все равно не сможем выставить байстоп ниже цены
         if(_lvl_pr>expert_info.zero_pr){
            if(!expert_info.autoopen && _lvl_pr>expert_info.last_buy_pr){
               continue;
            }
            _lvl_lot=expert_info.last_buy_lot;
         }else{
            _lvl_lot=start_lot;
         }
      }else{
         if(_lvl_pr>Bid)continue; //все равно не сможем выставить селлстоп выше цены
         if(_lvl_pr<expert_info.zero_pr){
            _lvl_lot=expert_info.last_sell_lot;
            if(!expert_info.autoopen && _lvl_pr<expert_info.last_sell_pr){
               continue;
            }
         }else{
            _lvl_lot=start_lot;
         }
      }
      
      string f=OE_DTY+"=="+dty+" AND "+OE_LVLPR+"=="+_lvl_pr;
      SELECT(aTO,f);
  
      if(ROWS(aI)<=0){
         zx
         OE_aDataSetProp(OE_FOP,gdFOP);
         OE_aDataSetProp(OE_LVLPR,_lvl_pr);
         gsComment="PR"+(string)_lvl_pr+" SL"+(string)start_level+" DTY"+dty;
         double d[];
         TR_SendPending_array(d,cmd,_lvl_pr,0,_lvl_lot,TP);
         DAIdPRINTALL3(aOE,"after TR_SendPending_array");   
         if(expert_info.autoopen){
            if(dty==OE_DTY_BUY){
               expert_info.last_buy_pr=_lvl_pr;
            }else{
               expert_info.last_sell_pr=_lvl_pr;
            }
            
         }
         xz   
      }
   }
   expert_info.autoopen=false;
}

void TrendNetBuy(const double start_level, const double start_lot){
   TrendNet(start_level,start_lot,OE_DTY_BUY);
}

void TrendNetSell(const double start_level, const double start_lot){
   TrendNet(start_level,start_lot,OE_DTY_SELL);
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
   DAIdPRINTALL4(aOE,"________");
	string fn="FIXProfit";
	
	if(!FIXProfit_use)return(false);
	
	T_Start();   
	int aI[]; ArrayResize(aI,0,1000);AId_Init2(aOE,aI);
	fix_profit=AId_Sum2(aOE,aI,OE_OPR)+expert_info.closed_profit;
	DPRINT2("fix_profit="+fix_profit);
	if(fix_profit<FIXProfit_amount){xz
	   SELECT2(aOE,aI,OE_IC+"==1"); 
	   DAIdPRINT4(aOE,aI,"aOE after select");
	   expert_info.closed_profit+=AId_Sum2(aOE,aI,OE_OPR);
	   OE_delClosed();
	   return(false);
	}
	
	DAIdPRINTALL5(aOE,"aOE before closeAll");
	CloseAllOrders();
	T_Start();
	OE_delClosed();
	expert_info.closed_profit=0;
	DAIdPRINTALL5(aOE, "aOE after closeALL");
	xz
	return(true);
}

void CloseAllOrders(){
   int rows=ROWS(aTO);
   for(int i=0; i<rows; i++){
      int ti=aTO[i][OE_TI];
      TR_CloseByTicket(ti);
      OE_setSTD(ti);
   }
   T_Start();
}