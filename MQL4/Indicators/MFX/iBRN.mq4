//+------------------------------------------------------------------+
//|                                                         iBRN.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//--- input parameters
input int      AmountLevels=10;

double aLVLUp[];
double aLVLDw[];
string lvl_name="RL";

int d=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
  ArrayResize(aLVLUp,AmountLevels,1000); 
  ArrayResize(aLVLDw,AmountLevels,1000);
//---
   d=Digits>=4?2:1;
   DrawLevels();

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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void DrawLevels(void){
   double _bid=MarketInfo(Symbol(),MODE_BID);
   
   double norm_bid=NormalizeDouble(_bid,d);
   double step=1;
   
   for(int i=0;i<d;i++){
      step=step/10;
   }
   
   for(int i=0;i<AmountLevels; i++){
      double up=norm_bid+i*step;
      double dw=norm_bid-i*step;
      
      DrawLine(up);
      DrawLine(dw);
      
      aLVLUp[i]=up;
      aLVLDw[i]=dw;
   }
}

void DrawLine(double pr){
   
   color clr=clrGreen;
   int w=1;
   
   datetime t_start=Time[0]+86400*5;
   datetime t_end=Time[0]+86400*20;
   string n=lvl_name+(string)pr;
   if(ObjectFind(0,n)<0){
      ObjectCreate(0,n,OBJ_TREND,0,t_start,pr,t_end,pr);
   }
   
   if(MathAbs(pr-NormalizeDouble(pr,d-1))<=1*Point){
      clr=clrOrchid;
      w=2;
   }   
   
   ObjectSet(n,OBJPROP_TIME1,t_start);
   ObjectSet(n,OBJPROP_TIME2,t_end);
   ObjectSet(n,OBJPROP_COLOR,clr);
   ObjectSet(n,OBJPROP_WIDTH,w);
}