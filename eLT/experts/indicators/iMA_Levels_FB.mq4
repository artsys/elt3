//+------------------------------------------------------------------+
//|                                                          		 |
//|                                          Copyright 2012, artamir |
//|                                                 forexmd.ucoz.org |
//|                                                 	elt.ucoz.org |
//|                                                   eltth.ucoz.org |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, artamir"
#property link      "forexmd.ucoz.org"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightGreen
#property indicator_color2 Red
#property indicator_color2 Green

#include	<sysNormalize.mqh>								//Pref: Norm
#include	<sysStructure.mqh>								//Pref: Struc
#include	<sysOther.mqh>									
#include	<sysMarketInfo.mqh>								//Pref:	MI

#include <iMA.mqh>

//--- input parameters
extern int		Per=2;
extern int 		Mode=1; //EMA
extern int		AP=0; //0-Close
extern int     Level=20;
//--- buffers
double L[];
double PA[];
double PB[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
	
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,217);
   SetIndexBuffer(1,PA);
   SetIndexEmptyValue(1,0.0);
   
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,218);
   SetIndexBuffer(2,PB);
   SetIndexEmptyValue(2,0.0);
   
   SetIndexBuffer(0,L);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexEmptyValue(0,0.0);
   
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
      aMA_Init();
      
      int hma = aMA_set(Per, Mode, AP);
      
      int ic = IndicatorCounted();
      int lim = Bars - ic - 1;
      for(int i = lim; i > 0; i--){
         L[i] = iMA_getLevel(hma, i, Level);
         if(iMA_isPinAbove(hma, i, Level)){
            PA[i] = Low[i];
         }
         
         if(iMA_isPinBelow(hma, i, Level)){
            PB[i] = High[i];
         }
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+
double iif( bool condition, double ifTrue, double ifFalse ){
	/*
		>Ver	:	0.0.1
		>Date	:	2012.04.04
		>History:
	*/
	if( condition ) return( ifTrue );
	//---
	return( ifFalse );
}


