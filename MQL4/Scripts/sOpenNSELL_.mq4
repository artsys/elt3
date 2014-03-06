//+------------------------------------------------------------------+
//|                                                    sOpenNBUY.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict
#property script_show_inputs

#define EXP "sOpenNSELL"

//--- input parameters
input int      Kol=10;
input double   Lot=0.01;
input int      TP=11;

#include <sysBase.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   for(int i=0;i<Kol;i++){
      int ti=TR_SendSELL(Lot);
      TR_ModifyTP(ti,TP,TR_MODE_PIP);
   }
  }
//+------------------------------------------------------------------+
