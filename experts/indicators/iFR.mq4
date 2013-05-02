//+------------------------------------------------------------------+
//|                                                          iFR.mq4 |
//|                                          Copyright 2012, artamir |
//|                                                 forexmd.ucoz.org |
//|                                                 	elt.ucoz.org |
//|                                                   eltth.ucoz.org |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, artamir"
#property link      "forexmd.ucoz.org"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LightGreen
#property indicator_color2 Red

#include <iFractal.mqh>

//--- input parameters
extern int		Left=2;
extern int 		Right=2;
extern int		Mode=1; //1 - классика, 2 - последовательные хай лоу
extern int		Price=1; //Тип цены поиска фрактала 1 - хай/лоу, 2 - закрытие
//--- buffers
double U[];
double D[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexBuffer(0,U);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,218);
   SetIndexBuffer(1,D);
   SetIndexEmptyValue(1,0.0);
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
   iFR.Set(Left, Right, Mode, Price);
  
   int    ic=IndicatorCounted();
//----
   int lim = Bars - ic + Right;
   
   for(int i = lim; i >= 0; i--){
      if(iFR.IsUp(i)){
         U[i] = iHigh(NULL, 0, i)+5*Point;
      }
      
      if(iFR.IsDw(i)){
         D[i] = iLow(NULL, 0, i)-5*Point;
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+

