//+------------------------------------------------------------------+
//|                                              eFXO.Volatility.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.10"
#property strict

//#define DEBUG3

struct signal_struct{
         int type;
         int cmd;
    datetime time;
    double   price;
    datetime last_time;
}; 

struct expert_info_struct{
   double profit;
   double last_lot;
};

double aVol3[7][24][2];
double aVol2[7][24];
datetime gdtLastRecheckTime=0;
int giThisHVTY=0;
int giTickVol=0;


double aTicks[][2];

input int               TPFix=20;
      int              _TPFix=20;
input int               SLFix=20;
      int              _SLFix=20;      
      
input double            LotFix=0.1;
      double           _LotFix=0.1;

input int               Delta_Time=3;
      int              _Delta_Time=3;
input int               Delta_Pips=3;
      int              _Delta_Pips=3;

input double            KMulty=1.2;
      double           _KMulty=1.2;      


input int               VTYWeeksCount=5;
      int                 _WeeksCount=5;
input ENUM_TIMEFRAMES   VTYRecheckPeriod=PERIOD_H4;
      ENUM_TIMEFRAMES     _RecheckPeriod=PERIOD_H4;
input double            VTYRangePercent=70;
      double              _RangePercent=70;
      
input string            e2="Signal";
input double            KTrendSize1 = 100;
      double           _KTrendSize1 = 100;
input double            KTrendSize2 = 80;
      double           _KTrendSize2 = 80;
      
input int               TrendTime=30;
      int              _TrendTime=30;



#include <sysBase.mqh>

#define OE_SIGTYPE OE_USR1
#define OE_SIGCMD OE_USR2
#define OE_SIGTIME OE_USR3
#define OE_MAINSIGTIME OE_USR4


signal_struct last_signal={0,0,0,0,0};
signal_struct last_main_sig={0,0,0,0,0};

expert_info_struct expert_info={0,0};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   bNeedDelClosed=false;
   B_Init("eFXO.VTY");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit("eFXO.VTY"); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   VTY_startext();
}

void VTY_startext()export{
   DAIdPRINTALL3(aTO,"__________");
   B_Start("eFXO.VTY");
   GetTick();
   
   CheckIfNetClosed();
   
   if(iTime(Symbol(),VTYRecheckPeriod,0)>gdtLastRecheckTime){
      gdtLastRecheckTime=iTime(Symbol(),VTYRecheckPeriod,0);
      if(!VolatilityCalcs()){
         Print("No history");
         return;
      }   
   }
   
   
   int iMaxVTY=GetMaxVTY();
   int iMinVTY=iMaxVTY*VTYRangePercent/100;
   //Проверяем, можно ли работать сове.
   int d=TimeDayOfWeek(TimeCurrent());
   int h=TimeHour(iTime(Symbol(),PERIOD_H1,0));
   
   double vty=aVol2[d][h];
   
   if(vty<iMinVTY){
      return; //Этот час не подходит для торговли.
   }
   
   //Далее: торговля разрешена.
   giThisHVTY=vty;
   
   //Определяем текущую тиковую влоатильность.
   signal_struct sig=GetSignal();
   CheckTIBySignal(sig);
   Comment(  "d=",d,"; h=",h
            ,"\nMaxVTY=",iMaxVTY
            ,"\nMinVTY=",iMinVTY
            ,"\nVTY=",vty
            ,"\nTickVTY=",giTickVol
            ,"\nKTS1=",giThisHVTY*KTrendSize1/100
            ,"\nKTS2=",giThisHVTY*KTrendSize2/100
            ,"\nlast_main_sig.time=",last_main_sig.time
            ,"\nlast_main_sig.type=",last_main_sig.type
            ,"\nlast_main_sig.cmd=",last_main_sig.cmd
            ,"\nlast_main_sig.price=",last_main_sig.price
            ,"\nlast_main_sig.last_time=",last_main_sig.last_time
            ,"\nsig.time=",sig.time
            ,"\nsig.type=",sig.type
            ,"\nsig.cmd=",sig.cmd
            ,"\nsig.price=",sig.price
            ,"\nsig.last_time=",sig.last_time
            ,"\n"
            ,"\nexp.profit=",expert_info.profit
            ,"\nexp.last_lot=",expert_info.last_lot
            ,"\naTO=",ROWS(aTO)
            ,"\naOE=",ROWS(aOE));
            
   if(sig.type==0){
      return; //Текущая тиковая волатильность меньше среднечасовой.
   }
   
   
}

void CheckIfNetClosed(){
   string f=OE_MAINSIGTIME+"=="+(int)last_main_sig.time;
   DAIdPRINTALL3(aTO,"__________");
   SELECT(aTO,f);
   DAIdPRINT3(aTO,aI,"MST_"+(int)last_main_sig.time);
   if(ROWS(aI)<=0){
      
      CheckNetProfit();
      
      OE_delClosed();
      
      last_main_sig.cmd=0;
      last_main_sig.time=0;
      last_main_sig.type=0;
      last_main_sig.price=0;
      last_main_sig.last_time=0;
      
      last_signal.cmd=0;
      last_signal.time=0;
      last_signal.type=0;
   }     
      
}

void CheckNetProfit(){
   string f=OE_MAINSIGTIME+"=="+(int)last_main_sig.time;
   DAIdPRINTALL3(aOE,"_____________________");
   SELECT(aOE,f);
   DAIdPRINT3(aOE,aI,"selected");
   expert_info.profit=AId_Sum2(aOE,aI,OE_OPR);
    
}

void CheckTIBySignal(signal_struct &sig){
   
   if(last_main_sig.time==0){
      if(sig.type==1){
         last_main_sig=sig;
      }else{
         return; //Не было основного сигнала
      }
   }else{
      //Был основной сигнал.
      //Работаем только с сигналом тип=2
      if(sig.type<2){
         return;
      }
   }
   
   if(sig.cmd != last_main_sig.cmd){
      return; //Не совпадают направления сигнала.
   }
   
   if(sig.time-last_main_sig.last_time < Delta_Time){
      return; //Дельта времени поступления сигнала меньше заданного.
   }
   
   if(sig.cmd==OP_BUY){
      if((Bid-last_main_sig.price)/Point<Delta_Pips){
         return; //Ценовая разница между сигналами меньше заданной.
      }
   }
   
   if(sig.cmd==OP_SELL){
      if(((last_main_sig.price-Ask)/Point<Delta_Pips) && (last_main_sig.price>0.00001)){
         return; //Ценовая разница между сигналами меньше заданной.
      }
   }
   
   string f=   OE_SIGTYPE+"=="+sig.type
              +" AND "
              +OE_SIGTIME+"=="+(int)sig.time
              +" AND "
              +OE_SIGCMD+"=="+sig.cmd;
              
   SELECT(aTO,f);
   
   if(ROWS(aI)<=0){
      OE_aDataSetProp(OE_SIGTYPE,sig.type);
      OE_aDataSetProp(OE_SIGTIME,(int)sig.time);
      OE_aDataSetProp(OE_SIGCMD,sig.cmd);
      OE_aDataSetProp(OE_MAINSIGTIME, last_main_sig.time);
      DAIdPRINTALL3(aOEData,"aOEData");
      
      double _lot=GetLot(sig);
      int ti=TR_SendMarket(sig.cmd,_lot); 
      if(ti>0){
         SELECT(aTO,OE_TI+"=="+ti);
         int rows=ROWS(aI);
         last_main_sig.price=AId_Get2(aTO,aI,0,OE_OOP);
         last_main_sig.last_time=(datetime)AId_Get2(aTO,aI,0,OE_OOT);
         TR_ModifySL(ti,SLFix,TR_MODE_PIP);
         TR_ModifyTP(ti,TPFix,TR_MODE_PIP);
      }
   }           
}

double GetLot(signal_struct &sig){
   double res=0;
   if(sig.type==1){
      if(expert_info.profit<0){
         res=expert_info.last_lot*KMulty;
      }else{
         res=LotFix;
      }
      expert_info.last_lot=res;
   }else{
      res=expert_info.last_lot;
   }
   
   return(res);
}

signal_struct GetSignal(){
   signal_struct res={0,0,0};
   
   int aI[];
   AId_Init2(aTicks,aI);
   AId_InsertSort2(aTicks,aI,0);
   
   DAIdPRINT2(aTicks,aI,"sorted");
   
   int size=ROWS(aTicks);
   double dMaxTickPr=AId_Get2(aTicks,aI,(size-1),0);
   datetime dtMaxTickPr=AId_Get2(aTicks,aI,(size-1),1);
   double dMinTickPr=AId_Get2(aTicks,aI,0,0);
   datetime dtMinTickPr=AId_Get2(aTicks,aI,0,1);
   
   giTickVol=(dMaxTickPr-dMinTickPr)/Point;
   
   if(giTickVol >= giThisHVTY*KTrendSize1/100){
      res.type=1;
   }else{
      if(giTickVol >= giThisHVTY*KTrendSize2/100){
         res.type=2;
      }else{
         return(res);
      }   
   }
   
   
   
   if(dtMaxTickPr>dtMinTickPr){
      res.cmd=OP_BUY;
      res.time=dtMinTickPr;
   }else{
      res.cmd=OP_SELL;
      res.time=dtMaxTickPr;
   }
   
   return(res);
}

int GetMaxVTY(){
   //Получаем максимальное значение волатильности
   double _max=0;
   for(int i=0;i<7;i++){
      for(int j=0;j<24;j++){
         double val=aVol2[i][j];
         _max=MathMax(_max,val);
      }
   }
   
   return((int)_max);
}

void GetTick() {
//---
   int s=ArrayRange(aTicks,0);
   
   ArrayResize(aTicks,s+1);
   aTicks[s][0]=Bid;
   aTicks[s][1]=TimeCurrent();
   DAIdPRINTALL2(aTicks,"");
   
   bool bNeedDelFirstTick=(MathAbs(aTicks[0][1]-aTicks[(s)][1])>TrendTime);
   while(bNeedDelFirstTick){
      DelFirstTick();
      s=ArrayRange(aTicks,0)-1;
      bNeedDelFirstTick=(MathAbs(aTicks[0][1]-aTicks[(s)][1])>TrendTime);
   }
   
   
}
  
void DelFirstTick(){
   int s=ArrayRange(aTicks,0);
   for(int i=0;i<s-1;i++){
      aTicks[i][0]=aTicks[(i+1)][0];
      aTicks[i][1]=aTicks[(i+1)][1];
   }
   
   ArrayResize(aTicks,(s-1));
}  
//+------------------------------------------------------------------+

bool VolatilityCalcs(){
//---
   ArrayInitialize(aVol3,0);
   ArrayInitialize(aVol2,0);
   datetime dtStartThisH1=iTime(Symbol(), PERIOD_H1,0);
   datetime dtStartH1_5WeksAgo=dtStartThisH1-VTYWeeksCount*7*24*60*60;
   int iStartH1_5WeeksAgo=iBarShift(Symbol(),PERIOD_H1,dtStartH1_5WeksAgo,true);
   
   if(iStartH1_5WeeksAgo==-1){
      Alert("Закачайте историю!!!!");
      return(false);
   }
   
   for(int i =iStartH1_5WeeksAgo; i>0; i--){
      datetime dtThis=iTime(Symbol(),PERIOD_H1,i);
      int iD=TimeDayOfWeek(dtThis);
      int iH=TimeHour(dtThis);
      int iVolatility=( iHigh(Symbol(),PERIOD_H1,i)
                        -  iLow(Symbol(),PERIOD_H1,i))/Point;
                              
      aVol3[iD][iH][0]+=iVolatility;
      aVol3[iD][iH][1]+=1;  
      
      DPRINT2((string)dtThis+"|d:"+iD+"|h:"+iH+"|vol:"+iVolatility+"|vt:"+(int)aVol3[iD][iH][0]+"|c:"+(int)aVol3[iD][iH][1]);                   
   }
   
   for(int d=0; d<7;d++){
      for(int h=0; h<24; h++){
         int vol=aVol3[d][h][0];
         int cnt=aVol3[d][h][1];
         
         if(cnt>0){
            aVol2[d][h]=(int)vol/cnt;
         }   
         
      }
   }
   
   DAIdPRINTALL2(aVol2,"");
   return(true);
}