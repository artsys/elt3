//+------------------------------------------------------------------+
//|                                                 iFXO.MACDRev.mq4 |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot MACD
#property indicator_label1  "MACD"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot MACDREV
#property indicator_label2  "MACDREV"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         MACDBuffer[];
double         MACDREVBuffer[];

input int MAfPer=13;
ENUM_MA_METHOD MAfMethod=MODE_SMA;
ENUM_APPLIED_PRICE MAfAppPrice=PRICE_CLOSE;
input int MAsPer=55;
ENUM_MA_METHOD MAsMethod=MODE_SMA;
ENUM_APPLIED_PRICE MAsAppPrice=PRICE_CLOSE;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,MACDBuffer);
   SetIndexBuffer(1,MACDREVBuffer);
   
   SetIndexDrawBegin(0,MathMax(MAfPer,MAsPer));
   SetIndexDrawBegin(1,MathMax(MAfPer,MAsPer));
   
   IndicatorDigits(Digits+2);
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
  if(rates_total<Bars)return(0);

  int lim=rates_total-prev_calculated;
  
  if(lim>1){
   ArrayInitialize(MACDBuffer,0.0);
   ArrayInitialize(MACDREVBuffer,0.0);
  }
  
  if(lim<0)lim=1;
  
  if(lim>1)lim=rates_total;
  
  lim--;
  int _shift=1;
  
  for(int i=lim;i>=0;i--){
   double maf=iMA(Symbol(),0,MAfPer,0,MAfMethod,MAfAppPrice,i);
   double mas=iMA(Symbol(),0,MAsPer,0,MAsMethod,MAsAppPrice,i);
   MACDBuffer[i]=maf-mas;
   MACDREVBuffer[i]=0-MACDBuffer[i];
  } 
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
