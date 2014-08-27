//+------------------------------------------------------------------+
//|                                               eFXO.ArtTH_2.1.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "2.40"
#property strict

input string s1="===== MAIN =====";
input int LevelStep=20;	//Шаг между ордерами
input int TP=40; //Тейкпрофит (на каждый ордер отдельно)
input int Levels=5; //Кол. уровней от позиции.
input int EQLevels=3; //Кол. екви уровней.
input double Lot=0.1;
input double Multy=2;
input bool UseParentLot=true;
input string e1="================";
input bool		CMFB_use=false; //закрывать минусовые ордера из средств баланса.
input int		CMFB_pips=50; //закрывать ордера, ушедшие в минуз больше заданного значения (в пунктах)
input string e2="================";
//Закрывать все ордера при достижении заданного профита.
input	bool FIXProfit_use=false;	
//Значение фиксированного профита для закрытия всех ордеров.
input	double FIXProfit_amount=500; 

//Глобальные переменные.
double gdFOP=0.0; //уровень открытия первого ордера.

#include <sysBase.mqh>

#define OE_MAIN OE_USR1
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
  B_Init("artTH");

  SELECT(aTO,(string)OE_MAIN+"==1");
  int rows=ROWS(aI);
  if(rows<=0){
   return(0);
  }
  
  gdFOP=AId_Get2(aTO,aI,0,OE_FOOP);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit("artTH");
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
   B_Start("artTH");
   
   //Закрытие позиций
   
   //Открытие позиций
      //Проверка сетки
      TN();
      //Автооткрытие
      Autoopen();
      
   Comment(""
      ,"\ngdFOP="+gdFOP
   );
}

void TN(){
   //Проверка видимой части сетки.
   
   //Проверка сетки в направлении
   
   //Выбираем все бай ордера.
   
   SELECT(aTO,OE_IM+"==1");
   int rows=ROWS(aI);
   for(int i=0; i<rows; i++){
      int ti=AId_Get2(aTO,aI,i,OE_TI);
      CheckNet(ti);
      CheckNet(ti,true);
      
   }
   
}

void CheckNet(const int pti, const bool revers=false){
   SELECT(aTO,OE_TI+"=="+pti);
   int      pdty=    AId_Get2(aTO,aI,0,OE_DTY);
   int      pty=     AId_Get2(aTO,aI,0,OE_TY);
   double   pfoop=   AId_Get2(aTO,aI,0,OE_FOOP);
   double   plot=    AId_Get2(aTO,aI,0,OE_LOT);
   
   int _op=1;
   int _dty=1;
   double _lvl_lot=0.0;
   
   int _start_counter=1;
   int _add_revers=0;
   
   if(revers){
      _start_counter=0;
      _add_revers=1;
   }
   
   for(int i=_start_counter; i<Levels; i++){
      
      if(pdty==OE_DTY_BUY){
         _op=1;
         _dty=OE_DTY_BUY;
         if(revers){
            _op=-1;
            _dty=OE_DTY_SELL;
         }
      }else{
         _op=-1;
         _dty=OE_DTY_SELL;
         if(revers){
            _op=1;
            _dty=OE_DTY_BUY;
         }
      }
      double _lvl_pr=pfoop+(i+_add_revers)*_op*(LevelStep*Point);
      
      int _cnt=0;
      if(_dty==OE_DTY_BUY){
         if(_lvl_pr>=gdFOP){
            _cnt=NormalizeDouble(((_lvl_pr-gdFOP)/Point),0)/LevelStep;
         }
      }else{
         if(_lvl_pr<gdFOP){
            _cnt=NormalizeDouble(((gdFOP-_lvl_pr)/Point),0)/LevelStep;
         }
      }
      
      if(_cnt>0){
         if(revers){
            _cnt--;
         }
         
         _lvl_lot=GetLvlLot(_cnt);
      }else{
         if(UseParentLot){
            _lvl_lot=plot;
         }else{
            _lvl_lot=Lot;
         }
      }
      
      SELECT(aTO,OE_FOOP+"=="+_lvl_pr+" AND "+OE_DTY+"=="+_dty);
      if(ROWS(aI)<=0){
         double d[];
         int cmd=-1;
         if(_dty==OE_DTY_BUY){
            cmd=OP_BUYSTOP;
         }else{
            cmd=OP_SELLSTOP;
         }
         TR_SendPending_array(d,cmd,_lvl_pr,0,_lvl_lot,TP);
      }
      
   }
}

double GetLvlLot(int cnt){
   double res=Lot;
   
   for(int i=1;i<=cnt;i++){
      
      if(i%EQLevels==0){
         res+=Lot;
      }
   }
   
   return(res);
}

void Autoopen(){
   if(ArrayRange(aTO,0)>0){
      return; //Есть ордера принадлежащие советнику.
   }
   
   OE_aDataSetProp(OE_MAIN,1);
   int ti=TR_SendBUY(Lot);
   SELECT(aTO,OE_TI+"=="+ti);
   int rows=ROWS(aI);
   if(rows<=0){
      return; //Почему то не нашли тикет в ордерах терминала.
   }
   gdFOP=AId_Get2(aTO,aI,0,OE_FOOP);
}