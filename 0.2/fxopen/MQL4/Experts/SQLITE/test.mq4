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
   
   //db.DeleteAll();                                                          //Работает
   //db.text="select * from "+db.table+" where TI in (95727617.00,95730370)"; //Работает
   //db.text="select * from "+db.table+" where OPR<0";                        //Работает
   //db.text="select * from "+db.table+" where sy='"+Symbol()+"'";            //Работает
   sql_results r[];
   string q="select * from "+db.tbl_tickets;
   db.Query(q, r);
   string s=CommentResult(r);
   
   q="select * from "+db.tbl_tickets_new;
   db.Query(q, r);
   s+=CommentResult(r);
   
   
   q="select * from "+db.tbl_tickets_old;
   db.Query(q, r);
   s+=CommentResult(r);
   
   Comment(s);
  }
//+------------------------------------------------------------------+


string CommentResult(sql_results &r[]){
   string s="";
   
   for(int i=0;i<ROWS(r[0].colname); i++){
      s+=r[0].colname[i]+"|";
   }
   s+="\n";
   for(int i=0; i<ROWS(r);i++){
      for(int j=0;j<ROWS(r[i].value); j++){
         s+=r[i].value[j]+"|";
      }
      s+="\n";
   }
   
   return(s);
}