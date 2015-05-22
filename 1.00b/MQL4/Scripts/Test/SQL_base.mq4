//+------------------------------------------------------------------+
//|                                                     SQL_base.mq4 |
//|                                                          artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict

#include <SQLite\CBase.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+


void OnStart()
  {
//---
   CEvents e;
   e.Init();
   for(int i=0; i<OrdersTotal(); i++){
   	if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
   	
   	KeyVal kv[];
   	
   	e.Exec("BEGIN");
   	
   	ADD(kv,"TI",(string)OrderTicket());
   	ADD(kv,"TY",(string)OrderType());
   	ADD(kv,"MN",(string)OrderMagicNumber());
   	ADD(kv,"OOP",(string)OrderOpenPrice());
   	ADD(kv,"OCP",(string)OrderClosePrice());
   	
   	e.m_tblname=e.m_tblthis;
   	e.UpdateOrInsert(kv);
   	e.Exec("COMMIT");
   }
   
   e.CopyTable(e.m_tblthis,e.m_tblold);
  
  	// e.Text(e.CreateTable(e.m_tblname,kv));
   //CTbl tbl;
   //e.Run(tbl);
   
   
   
   //q.Text("SELECT * FROM <tbl> WHERE DTY=&dty");
   //q.SetValue("&tbl","Tickets");
   //q.SetValue("&dty",101);
   //Print(q.m_query);
   //q.Run(tbl);
   
   //Print(TablePrint(tbl));
  }
//+------------------------------------------------------------------+
