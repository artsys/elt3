//+------------------------------------------------------------------+
//|                                                  sysTerminal.mqh |
//|                                                          artamir |
//|                                          http://forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forexmd.ucoz.org"
#property strict

int T_SendedTI=0;

double aTO[][OE_MAX];

void T_Start(){
   DAIdPRINTALL4(aOE,"__________");
   //ѕеречитывает ордера из терминала, создава€ из них массив
   
   int t=OrdersTotal();
   ArrayResize(aTO,0); //ќбнулили массив ордеров терминала.
   for(int i=0;i<=t;i++){
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()!=Symbol())continue;
      #ifdef SYSTRADES
         if(OrderMagicNumber()!=TR_MN)continue;
      #endif 
      
      DAIdPRINTALL3(aOE,"before setSTD aOE.ti="+OrderTicket());
      int idx=OE_setSTD(OrderTicket());
      if(T_SendedTI==OrderTicket()){
         OE_setFSTDByIDX(idx);
         OE_aDataSetInOE(idx);
         T_SendedTI=0;
      }
      
      DAIdPRINTALL3(aOE,"after setSTD aOE.ti="+OrderTicket());
      AId_CopyRow2(aOE,aTO,idx);
     
      DAIdPRINTALL3(aOE,"after CopyRow aOE.ti="+OrderTicket());
      
   }
   
}