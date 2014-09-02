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
   
   //������������ ������ �� ���������, �������� �� ��� ������
   
   int t=OrdersTotal();
   ArrayResize(aTO,0); //�������� ������ ������� ���������.
   for(int i=0;i<=t;i++){
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()!=Symbol())continue;
      
      int idx=OE_setSTD(OrderTicket());
      if(T_SendedTI==OrderTicket()){
         OE_setFSTDByIDX(idx);
         OE_aDataSetInOE(idx);
         T_SendedTI=0;
      }
      if(OrderTicket()>=12){
         DAIdPRINTALL3(aOE,"before aOE.ti="+OrderTicket());
         DAIdPRINTALL3(aTO,"before aTO.ti="+OrderTicket());
      }
      AId_CopyRow2(aOE,aTO,idx);
      if(OrderTicket()>=12){
         DAIdPRINTALL3(aOE,"after aOE.ti="+OrderTicket());
         DAIdPRINTALL3(aTO,"after aTO.ti="+OrderTicket());
      }
   }
   
}