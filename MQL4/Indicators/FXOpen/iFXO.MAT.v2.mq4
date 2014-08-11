//+------------------------------------------------------------------+
//|                                                     iFXO.MAT.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "forum.fxopen.ru"
#property link      "http://forum.fxopen.ru"
#property version   "2.10"
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
input int                  NormDigits=4; //Digits
input bool                 DelPropsOnDeinit=true;
//--- indicator buffers
double         MATBuffer[];
double         MA[];

string         objName="";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(2);
//--- indicator buffers mapping
   SetIndexBuffer(0,MATBuffer);
   //IndicatorSetInteger(INDICATOR_DIGITS,NormDigits);
   
   SetIndexBuffer(1,MA);
   SetIndexArrow(0,159);
   
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   //PlotIndexSetInteger(0,PLOT_ARROW,159);
//---
   string sParams= "@1p"+(string)Step
                  +"@2p"+(string)MA_per
                  +"@3p"+(string)MA_mode
                  +"@4p"+(string)MA_applied_price
                  +"@5p"+(string)NormDigits;
                  
   objName="MAT"+(string)Period();               
   if(ObjectFind(objName)==-1){
      ObjectCreate(objName,OBJ_LABEL,0,0,0,0,0);
      ObjectSetText(objName,sParams,0);
   }               
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason){
   if(!DelPropsOnDeinit)return;
   
   if(ObjectFind(objName)>-1){
      ObjectDelete(objName);
   }
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
//--
   if(rates_total<Bars)return(0);

  int lim=rates_total-prev_calculated;
  
  if(lim>1){
   ArrayInitialize(MATBuffer,0.0);
  }
  
  if(lim<0)lim=1;
  
  if(lim>1)lim=rates_total;
  
  lim--;
  int _shift=1;
  
  for(int i=lim;i>=0;i--){
   double ma0=iMA(Symbol(),0,MA_per,0,MA_mode,MA_applied_price,i);
   MA[i]=ma0;
  } 
  
  for(int i=lim-_shift;i>=0;i--){
   double ma0=MA[i];
   ma0=NormalizeDouble(ma0,NormDigits);
   double ma1=MA[i+_shift];
   ma1=NormalizeDouble(ma1,NormDigits);
   if(MathAbs((ma0-ma1)/Point)>= Step){
      MATBuffer[i]=ma0;
   }
   
  } 
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

class CDebuggerFix { } ExtDebuggerFix;