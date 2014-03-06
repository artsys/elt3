//+------------------------------------------------------------------+
//|                                                  eTest_sysOE.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict

#include <sysIndexedArray.mqh>
#include <sysOE.mqh>
#include <sysEvents.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   OE_init();
   E_Init();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   E_Start();
   int aIE[];
   ArrayResize(aIE,0);
   AId_Init2(aE,aIE);
   AId_Print2(aE,aIE,4,"aE_all");
   
   int aI[];
   ArrayResize(aI,0);
   AId_Init2(aOE,aI);
   AId_Print2(aOE,aI,4,"aOE_all");
  }
//+------------------------------------------------------------------+
