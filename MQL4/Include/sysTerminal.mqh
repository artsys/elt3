//+------------------------------------------------------------------+
//|                                                  sysTerminal.mqh |
//|                                                          artamir |
//|                                          http://forexmd.ucoz.org |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://forexmd.ucoz.org"
#property strict

double aTO[][OE_MAX];

void T_Start(){
   //������������ ������ �� ���������, �������� �� ��� ������
   
   int t=OrdersTotal();
   ArrayResize(aTO,0); //�������� ������ ������� ���������.
   for(int i=0;i<=t;i++){
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()!=Symbol())continue;
      
      int idx=OE_setSTD(OrderTicket());
      AId_CopyRow2(aOE,aTO,idx);
   }
}