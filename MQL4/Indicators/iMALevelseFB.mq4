//+------------------------------------------------------------------+
//|                                                 iMALevelseFB.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrBlue
#property indicator_color2 clrGray
#property indicator_color3 clrBlue
#property indicator_color4 clrRed
//--- input parameters
input int      MAPer=50;
input int      MAMethod=1;
input int      MAAppliedPrice=0;
input int      MALevel=30;

double MA[];
double MAL[];
double FBH[];//содержит цену хая бара ложного пробития, когда тело свечи находится снизу.
double FBL[];//содержит цену лоу бара ложного пробития, когда тело свечи находится сверху.
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MA);
   
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,MAL);
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,217);
   SetIndexBuffer(2,FBH);
   
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,218);
   SetIndexBuffer(3,FBL);
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
   int limit=rates_total-prev_calculated;
   if(limit<0)limit=1;
   if(limit>1){
      ArrayInitialize(MA,EMPTY_VALUE);
      ArrayInitialize(MAL,EMPTY_VALUE);
      ArrayInitialize(FBH,EMPTY_VALUE);
      ArrayInitialize(FBL,EMPTY_VALUE);
      limit=rates_total;
   }
   
   for(int i=limit;i>=0; i--){
      double ma=iMA(Symbol(),0,MAPer,0,MAMethod,MAAppliedPrice,i);
      double ma_level=ma+MALevel*Point;
      
      MA[i]=ma;
      MAL[i]=ma_level;
      
      if(open[i]<close[i]){
         //закрытие находится выше открытия, значит проверим нахождение ценового уровня конверта ма внутри диапазона хай/закрытие.
         if(ma_level>=close[i] && ma_level<=high[i]){
            FBH[i]=high[i];
         }
         
         if(ma_level>=low[i] && ma_level<=open[i]){
            FBL[i]=low[i];
         }
      
      }
      if(close[i]<open[i]){
         //закрытие находится ниже открытие, тогда проверим нахождение ценового уровня конверта ма внутри диапазона закрытие/лоу.
         if(ma_level >= low[i] && ma_level<=close[i]){
            FBL[i]=low[i];
         }
         
         if(ma_level >= open[i] && ma_level<= high[i]){
            FBH[i]=high[i];
         }
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
