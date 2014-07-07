//+------------------------------------------------------------------+
//|                                                    eFXO.PSar.mq4 |
//|                                                    DrJJ, artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "DrJJ, artamir"
#property link      "http://forum.fxopen.ru"
#property version   "1.00"
#property strict

#define EXP "eFXO.PSar"
#define OE_PTI OE_USR1
#define OE_LVL OE_USR2

#include <sysBase.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   B_Init(EXP);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   B_Deinit(EXP)
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   eFXOPSar_startext(); 
  }
//+------------------------------------------------------------------+

void eFXOPSar_startext()export{
   B_Start();
   
   
}