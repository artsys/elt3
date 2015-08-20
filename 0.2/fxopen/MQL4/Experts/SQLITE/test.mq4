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
   Print(__FUNCSIG__);
   db.Start();   
   
   db.table=db.tbl_tickets;
   //db.DeleteAll();                                                          //Работает
   //db.text="select * from "+db.table+" where TI in (95727617.00,95730370)"; //Работает
   //db.text="select * from "+db.table+" where OPR<0";                        //Работает
   //db.text="select * from "+db.table+" where sy='"+Symbol()+"'";            //Работает
   
   db.text="select * from "+db.table;
   db.Query();
   string s=CommentResult();
   
   db.table=db.tbl_tickets_new;
   db.text="select * from "+db.table;
   db.Query();
   s+=CommentResult();
   
   db.table=db.tbl_tickets_old;
   db.text="select * from "+db.table;
   db.Query();
   s+=CommentResult();
   
   Comment(s);
  }
//+------------------------------------------------------------------+


string CommentResult(){
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
   
   return(s);
}