//+------------------------------------------------------------------+
//|                                                  iCandleProp.mq4 |
//|                                          Copyright 2014, artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   6
//--- plot Body
#property indicator_label1  "Body"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrOrange
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot High
#property indicator_label2  "High"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Low
#property indicator_label3  "Low"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Body
#property indicator_label4  "Body_avg"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrOrange
#property indicator_style4  STYLE_DOT
#property indicator_width4  1
//--- plot High
#property indicator_label5  "High_avg"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrBlue
#property indicator_style5  STYLE_DOT
#property indicator_width5  1
//--- plot Low
#property indicator_label6  "Low_avg"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrRed
#property indicator_style6  STYLE_DOT
#property indicator_width6  1

//--- input parameters
input int      AVG_Period=15;
input bool     DrawThis=true;
//--- indicator buffers
double         BodyBuffer[];
double         HighBuffer[];
double         LowBuffer[];

double         BodyMABuffer[];
double         HighMABuffer[];
double         LowMABuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   
   SetIndexBuffer(0,BodyBuffer);
   SetIndexBuffer(1,HighBuffer);
   SetIndexBuffer(2,LowBuffer);
   if(!DrawThis){
      SetIndexDrawBegin(0,Bars);
      SetIndexDrawBegin(1,Bars);
      SetIndexDrawBegin(2,Bars);
   }else{
      SetIndexDrawBegin(0,0);
      SetIndexDrawBegin(1,0);
      SetIndexDrawBegin(2,0);
   }
   

   SetIndexBuffer(3,BodyMABuffer);
   SetIndexBuffer(4,HighMABuffer);
   SetIndexBuffer(5,LowMABuffer);   
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
      double dO=iOpen(Symbol(),PERIOD_D1,day_shift);
      double dC=iClose(Symbol(),PERIOD_D1,day_shift);
      double dH=iHigh(Symbol(),PERIOD_D1,day_shift);
      double dL=iLow(Symbol(),PERIOD_D1,day_shift);
      BodyBuffer[i]=MathAbs(dO-dC)/Point;
      HighBuffer[i]=MathAbs(dH-MathMax(dO,dC))/Point;
      LowBuffer[i]=MathAbs(MathMin(dO,dC)-dL)/Point;
      
   } 
   
   for(int i=limit;i>0;i--){
      BodyMABuffer[i]=iMAOnArray(BodyBuffer,0,AVG_Period,0,MODE_SMA,i);
      HighMABuffer[i]=iMAOnArray(HighBuffer,0,AVG_Period,0,MODE_SMA,i);
      LowMABuffer[i]=iMAOnArray(LowBuffer,0,AVG_Period,0,MODE_SMA,i);
   }
   
   string body_assert="=";
   string high_assert="=";
   string low_assert="=";
   
   if(HighBuffer[1]>HighMABuffer[1]){
      high_assert=">";
   }else{
      if(HighBuffer[1]<HighMABuffer[1]){
         high_assert="<";
      }
   }

   if(BodyBuffer[1]>BodyMABuffer[1]){
      body_assert=">";
   }else{
      if(BodyBuffer[1]<BodyMABuffer[1]){
         body_assert="<";
      }
   }

   if(LowBuffer[1]>LowMABuffer[1]){
      low_assert=">";
   }else{
      if(LowBuffer[1]<LowMABuffer[1]){
         low_assert="<";
      }
   }   
   
   string iName="iCandleProp "+"("
                                      +"h"//+DoubleToString(HighBuffer[1],0)
                                          +high_assert
                                             +"h_avg; "//+DoubleToString(HighMABuffer[1],0)+"; "
                                      +"b:"//+DoubleToString(BodyBuffer[1],0)
                                          +body_assert
                                             +"b_avg; "//+DoubleToString(BodyMABuffer[1],0)+"; "
                                      +"l:"//+DoubleToString(LowBuffer[1],0)
                                          +low_assert
                                             +"l_avg"//+DoubleToString(LowMABuffer[1],0)
                                      +")";
   
   IndicatorShortName(iName);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

string iif(bool condition, string iftrue, string iffalse){
   if(condition)return(iftrue);
   
   return(iffalse);
}
