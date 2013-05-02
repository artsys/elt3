//+------------------------------------------------------------------+
//|                                                   iMA_HL_pip.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue
//#property indicator_color2 Green
//#property indicator_color3 Red
//--- input parameters
extern int       MA_pip=20;
//extern int       MA_Level_pip=20;
//extern int			 MA_per = 144;
//--- buffers
//double ExtMA[];
//double ExtH[];
//double ExtL[];
double inMA[];

double aH[];
double aL[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   //SetIndexStyle(0,DRAW_LINE);
   //SetIndexBuffer(0,ExtMA);
   //SetIndexStyle(1,DRAW_LINE);
   //SetIndexBuffer(1,ExtH);
   //SetIndexStyle(2,DRAW_LINE);
   //SetIndexBuffer(2,ExtL);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,inMA);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    ic=IndicatorCounted();
//----
   int limit = Bars - ic;
   for(int i = limit; i >= 0; i--){
      double h = iHigh(Symbol(),0,i);
      double l = iLow(Symbol(),0,i);
      double o = iOpen(Symbol(),0,i);
      double c = iClose(Symbol(),0,i);
      if(i >= Bars-1){
         if(o >= c){
            inMA[i-1] = l - MA_pip*Point;
         }else{
            inMA[i-1] = h + MA_pip*Point;
         }  
      }else{
         if((inMA[i]-h)/Point > MA_pip){
            //up trend
            inMA[i-1] = h + MA_pip*Point;
         }else{
            if((l-inMA[i])/Point > MA_pip){
               inMA[i-1] = l - MA_pip*Point;
            }else{
               inMA[i-1] = inMA[i];
            }
         }
      }
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+