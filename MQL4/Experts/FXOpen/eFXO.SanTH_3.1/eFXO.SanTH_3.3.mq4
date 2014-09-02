//+------------------------------------------------------------------+
//|                                               eFXO.SanTH_3.1.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "3.30"
#property strict

#define DEBUG3
#define TRACING

input string s1="===== MAIN =====";
input int LevelStep=10;	//Шаг между ордерами
input int TP=15; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=2; //Кол. уровней от позиции.
input double Lot=0.1;
input double Multy=2;
input bool UseParentLot=true;

#include <sysBase.mqh>

#define OE_LVLPR OE_USR1
#define OE_FOP OE_USR2

struct expert_info_struct{
   double last_buy_lot;
   double last_buy_pr;
  
   double last_sell_lot;
   double last_sell_pr;
   
   double zero_pr;
   bool autoopen;
};

expert_info_struct expert_info={0,0,0,0,0,false};
double gdFOP=0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init("eFXO.SanTH");
   Debug=false;
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

void startext(){
   DAIdPRINTALL3(aOE,"___________________");
   B_Start("eFXO.SanTH");
   
   //Закрытие позиций
   //Открытие позиций
      Autoopen();
   //Проверка сетки
      Checking();
   
   Comment(""
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
      expert_info.last_buy_lot*=Multy;
      expert_info.autoopen=true;
      
      Debug=false;
      double _nearest_buy_level=GetNearestBuyLevel();
      DPRINT3("NBL="+_nearest_buy_level);
      TrendNetBuy(_nearest_buy_level,expert_info.last_buy_lot);   

      double _nearest_sell_level=GetNearestSellLevel();
      TrendNetSell(_nearest_sell_level,expert_info.last_buy_lot); 
      Debug=False;  
   }else{
      //Если байевые еще не закрыты,
      //То проверим байевые позиции.
      SELECT2(aTO,aI,OE_IM+"==1");
      for(int i=0; i<ROWS(aI);i++){
         int pti=AId_Get2(aTO,aI,i,OE_TI);
         double plot=AId_Get2(aTO,aI,i,OE_LOT);
         double ppr=AId_Get2(aTO,aI,i,OE_LVLPR);
         Debug=false;
         TrendNetSell(ppr-LevelStep*Point, plot);
         Debug=false;
      }
   }
   
   //Проверяем, если закрылись селл сетки.
   dty=OE_DTY_SELL;
   SELECT2(aTO,aI,OE_DTY+"=="+dty);
   if(ROWS(aI)<=0){
      //Если закрылись байевые сетки.
      //Выставляем новую сетку увеличенным объемом.
      expert_info.last_sell_lot*=Multy;
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
   int _levels=Levels;
   
   int fl=1;
   int cmd=OP_BUYSTOP;
   if(Bid<expert_info.zero_pr){
      _levels=GetLevels();
   }
   
   if(dty==OE_DTY_SELL){
      fl=-1;
      cmd=OP_SELLSTOP;
      if(Bid>expert_info.zero_pr){
         _levels=GetLevels();
      }
   }
   
   for(int i=0; i<_levels; i++){
      _lvl_pr=start_level+fl*i*LevelStep*Point;
      
      if(expert_info.autoopen){
         DPRINT3("_lvl_pr="+_lvl_pr);
      }
      
      if(dty==OE_DTY_BUY){
         if(_lvl_pr>expert_info.zero_pr){
            if(!expert_info.autoopen && _lvl_pr>expert_info.last_buy_pr){
               continue;
            }
            _lvl_lot=expert_info.last_buy_lot;
         }else{
            _lvl_lot=start_lot;
         }
      }else{
         if(_lvl_pr<expert_info.zero_pr){
            _lvl_lot=expert_info.last_sell_lot;
            if(!expert_info.autoopen && _lvl_pr<expert_info.last_sell_pr){
               continue;
            }
         }else{
            _lvl_lot=start_lot;
         }
      }
     // DAIdPRINTALL3(aTO,"aTO_______________________________");
      string f=OE_DTY+"=="+dty+" AND "+OE_LVLPR+"=="+_lvl_pr;
      SELECT(aTO,f);
     // DAIdPRINT3(aTO,aI,"aTO_f "+f);
      if(ROWS(aI)<=0){
         zx
         OE_aDataSetProp(OE_FOP,gdFOP);
         OE_aDataSetProp(OE_LVLPR,_lvl_pr);
         gsComment="PR"+(string)_lvl_pr+" SL"+(string)start_level+" DTY"+dty;
         double d[];
         Debug=true;
         TR_SendPending_array(d,cmd,_lvl_pr,0,_lvl_lot,TP);
         if(ROWS(d)>0&&d[0]>=12){
            bool tDebug=Debug;
            Debug=true;
            DAIdPRINTALL3(aTO,"aTO_________ti="+(int)d[0]);
            Debug=tDebug;
            
            
         }
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