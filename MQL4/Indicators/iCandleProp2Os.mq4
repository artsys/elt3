//+------------------------------------------------------------------+
//|                                                  iCandleProp.mq4 |
//|                                          Copyright 2014, artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property version   "1.10"
#property strict
#property indicator_separate_window

#property indicator_levelcolor clrSilver
#property indicator_level1 30
#property indicator_level2 50
#property indicator_level3 70 

#property indicator_buffers 2
#property indicator_color1 clrOrchid
#property indicator_color2 clrRed
//#property indicator_color3 clrBlue
//#property indicator_color4 clrRed

#define NAME "CandleProp2Os"

string sName="";
string sUsedMode="";

enum CANDLE_PROP{
   CP_HIGH=0,
   CP_BODY=1,
   CP_LOW=2,
};

//--- input parameters
input int      AVG_Period=15;
input string   sMode="0-high, 1-body, 2-low";
input CANDLE_PROP Mode=CP_HIGH;
input bool     DrawThis=true;
//--- indicator buffers
double         ThisBuffer[];
double         AVGBuffer[];
double         MaxBuffer[];
double         MinBuffer[];

double         MainBuffer[];
double         SigBuffer[];

double         SigUp[];
double         SigDw[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   IndicatorBuffers(6);
   
   SetIndexBuffer(0, MainBuffer);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   
   SetIndexBuffer(1, SigBuffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT,1);
   
   SetIndexBuffer(2,ThisBuffer);
   SetIndexBuffer(3,AVGBuffer);
   SetIndexBuffer(4,MaxBuffer);
   SetIndexBuffer(5,MinBuffer);
   
      
   //SetIndexEmptyValue(0,EMPTY_VALUE);
   //SetIndexEmptyValue(1,0.0);
   //SetIndexEmptyValue(2,0.0);
   //SetIndexEmptyValue(3,0.0);
   //SetIndexEmptyValue(4,0.0);
   //SetIndexEmptyValue(5,0.0);
   
   sUsedMode="";
   if(Mode==CP_HIGH)sUsedMode="HIGH";
   if(Mode==CP_BODY)sUsedMode="BODY";
   if(Mode==CP_LOW)sUsedMode="LOW";   
   sName="iCandleProp v2 Os (MODE-"+sUsedMode+")";
   IndicatorShortName(sName);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=rates_total-prev_calculated-1;
   if(limit<0)limit=1;
   
   for(int i=limit;i>0;i--){
      int day_shift=iBarShift(Symbol(),PERIOD_D1,iTime(Symbol(),0,i));
      double dO=iOpen(Symbol(),0,i);
      double dC=iClose(Symbol(),0,i);
      double dH=iHigh(Symbol(),0,i);
      double dL=iLow(Symbol(),0,i);
      
      
      double dMax=0,dMin=0;
      if(Mode==0){dMax=dH; dMin=MathMax(dO,dC);}
      if(Mode==1){dMax=dO; dMin=dC;}
      if(Mode==2){dMax=MathMin(dO,dC);dMin=dL;}
      
      double val=0;
      val=MathAbs((dMax-dMin)/Point);
      
      ThisBuffer[i]=val;
      
      MaxBuffer[i]=ThisBuffer[ArrayMaximum(ThisBuffer,AVG_Period,i)];
      MinBuffer[i]=ThisBuffer[ArrayMinimum(ThisBuffer,AVG_Period,i)];
      if(i<rates_total-AVG_Period){
         MainBuffer[i]=(ThisBuffer[i])/(MaxBuffer[i])*100;
      }   
      
      //if(MainBuffer[i]==0.0){
      //   PrintFormat("ThisBuffer[%i]=%f",i,ThisBuffer[i]);
      //}
      
   } 
   
   for(int i=limit;i>0;i--){
      AVGBuffer[i]=iMAOnArray(ThisBuffer,0,AVG_Period,0,MODE_SMA,i);
      SigBuffer[i]=iMAOnArray(MainBuffer,0,AVG_Period,0,MODE_SMA,i);
   }
   
   string txt=sName+": MAX "+sUsedMode+"="+DoubleToStr(MaxBuffer[1],0)+"; "+sUsedMode+"="+DoubleToStr(ThisBuffer[1],0)+"; MIN "+sUsedMode+"="+DoubleToStr(MinBuffer[1],0);
   IndicatorSetString(INDICATOR_SHORTNAME,txt);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

string iif(bool condition, string iftrue, string iffalse){
   if(condition)return(iftrue);
   
   return(iffalse);
}
