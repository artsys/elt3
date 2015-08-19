//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <SQLite\SQLite_Tickets.mqh>
CSQLite_Tickets db;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   db.table="Tickets_test";
   db.CreateTable();
   
   Print(db.IsColumnExists(db.table,"_ID"));
   db.CreateColumn2("TI","INT");
   db.CreateColumn2("TY","INT");
   db.CreateColumn2("OOP","FLOAT");
   
   KeyVal kv[];
   db.GetTableStruct(kv); //Получаем структуру таблицы Tickets_test
   PrintKV(kv);
   
   db.table="Tickets_old";
   db.CreateTable();
   
   db.CreateColumns(kv);
   
   sql_results r[];
   string s="";
   
   //db.Query("select * from "+db.table,r);
   db.Query();
   for(int i=0;i<ArraySize(db.q_column_names);i++)
   {
      s+=db.q_column_names[i]+"|";
   }
   
   Print(s);
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
   
  }
//+------------------------------------------------------------------+
