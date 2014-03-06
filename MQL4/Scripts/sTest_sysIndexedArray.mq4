//+------------------------------------------------------------------+
//|                                        sTest_sysIndexedArray.mq4 |
//|                                          Copyright 2014, artamir |
//|                                          http:\\forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, artamir"
#property link      "http:\\forexmd.ucoz.org"
#property version   "1.00"
#property strict


#property stacksize 1024
#include <sysIndexedArray.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
  double d[5][1];
  for(int i=0;i<5;i++){
   if(i==2||i==3)d[i][0]=2;
   else d[i][0]=i;
  } 
  
  Print("array{",0,",",1,",",2,",",2,",",4,"}");
  
  int aI[];ArrayResize(aI,0);AId_Init2(d,aI);
  
  Print("AId_SearchFirst2");
  for(int i=-1;i<6;i++){
   int j=AId_SearchFirst2(d,aI,0,i); 
   Print("val=",i,"->idx=",j);
  }
  
  Print("AId_SearchLast2");
  for(int i=-1;i<6;i++){
   int j=AId_SearchLast2(d,aI,0,i); 
   Print("val=",i,"->idx=",j);
  }
  
  Print("AId_SearchGreat2");
  for(int i=-1;i<6;i++){
   int j=AId_SearchGreat2(d,aI,0,i); 
   Print("val=",i,"->idx=",j);
  }
  
  Print("AId_SearchLess2"); 
  for(int i=-1;i<6;i++){
   int j=AId_SearchLess2(d,aI,0,i); 
   Print("val=",i,"->idx=",j);
  }
  
  Print("AId_Select2_EQ");
  AId_Print2(d,aI,4,"all_array"); 
  AIF_init();
  AIF_filterAdd_AND(0,AI_EQ, 2);
  AId_Select2(d,aI);
  Print("AId_Print2");
  AId_Print2(d,aI,4,"seleq2_array"); 
  
  Print("AId_Select2_GREAT");
  AId_Init2(d,aI);
  AIF_init();
  AIF_filterAdd_AND(0,AI_GREAT, 2);
  AId_Select2(d,aI);
  Print("AId_Print2");
  AId_Print2(d,aI,4,"selgreat2_array"); 
  
  Print("AId_Select2_LESS");
  AId_Init2(d,aI);
  AIF_init();
  AIF_filterAdd_AND(0,AI_LESS, 2);
  AId_Select2(d,aI);
  Print("AId_Print2");
  AId_Print2(d,aI,4,"selless2_array"); 
}
//+------------------------------------------------------------------+
