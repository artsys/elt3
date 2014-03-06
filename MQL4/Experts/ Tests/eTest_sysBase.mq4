//+------------------------------------------------------------------+
//|                                                eTest_sysBase.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict

#define EXP "eTest_sysBase"
#include <sysBase.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit(); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   B_Start();
  }
//+------------------------------------------------------------------+
