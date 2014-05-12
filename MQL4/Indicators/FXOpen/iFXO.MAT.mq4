//+------------------------------------------------------------------+
//|                                                     iFXO.MAT.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot MAT
#property indicator_label1  "MAT"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- input parameters
input int                  Step=1;
input int                  MA_per=50;  //Period
input ENUM_MA_METHOD       MA_mode=1;  //Method
input ENUM_APPLIED_PRICE   MA_applied_price=0; //Applied Price
//--- indicator buffers
double         MATBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,MATBuffer);
   
   SetIndexEmptyValue(0,0.0);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
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
   if(rates_total<MA_per)return(0);

  int lim=rates_total-prev_calculated-1;
  if(lim<0)lim=1;
  
  int _shift=1;
  
  for(int i=lim-_shift;i>=0;i--){
   double ma0=iMA(Symbol(),0,MA_per,0,MA_mode,MA_applied_price,i);
   double ma1=iMA(Symbol(),0,MA_per,0,MA_mode,MA_applied_price,(i+_shift));
   
   if(MathAbs((ma0-ma1)/Point)>= Step){
      MATBuffer[i]=ma0;
   }
   
  } 
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

class CDebuggerFix { } ExtDebuggerFix;