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
   KeyVal kv[];
   for(int i=0; i<OrdersTotal(); i++){
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))continue;
      
      DROP(kv);
      db.GetStdData(OrderTicket(),kv);
      
      db.table="Tickets";
      db.UpdateOrInsert(kv);
   }   
   
   
   
   db.table=db.tbl_tickets;
   //db.DeleteAll();                                                          //Работает
   //db.text="select * from "+db.table+" where TI in (95727617.00,95730370)"; //Работает
   //db.text="select * from "+db.table+" where OPR<0";                        //Работает
   db.text="select * from "+db.table+" where sy='"+Symbol()+"'";              //Работает
   db.Query();
   CommentResult();
  }
//+------------------------------------------------------------------+


void CommentResult(){
   string s="";
   s+="db.table : "+db.table+"\n";
   s+="db.text : "+db.text+"\n";
   for(int i=0;i<ROWS(db.q_column_names); i++){
      s+=db.q_column_names[i]+"|";
   }
   s+="\n";
   for(int i=0; i<ROWS(db.q_results);i++){
      for(int j=0;j<ROWS(db.q_results[i].value); j++){
         s+=db.q_results[i].value[j]+"|";
      }
      s+="\n";
   }
   
   Comment(s);
}