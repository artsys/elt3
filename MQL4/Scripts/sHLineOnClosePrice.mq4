//+------------------------------------------------------------------+
//|                                           sHLineOnClosePrice.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   datetime dt_dropped=ChartTimeOnDropped();
   int bar_number=iBarShift(Symbol(),0,dt_dropped);
   double close_price=iClose(Symbol(),0,bar_number);
   string name="#"+(int)dt_dropped;
   HLine(name, close_price);
  }
//+------------------------------------------------------------------+
 void HLine(string name, double price){
   if(ObjectFind(name)==-1){
      ObjectCreate(name,OBJ_HLINE,0,0,price);
   }
 }