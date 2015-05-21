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
   
   
   KeyVal kv[];
   ADD(kv);
   kv[LAST(kv)].key="system_id";
   kv[LAST(kv)].val="INTEGER";
   
   CEvents e;
   e.Init();
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
//+------------------------------------------------------------------+
//| Comment Table                                                    |
//+------------------------------------------------------------------+
string TablePrint(CSQLite3Table &tbl)
  {
   string str="";
   int cs=ArraySize(tbl.m_colname);
   for(int c=0; c<cs; c++)
      str+=tbl.m_colname[c]+" | ";
   str+="\n";

   int rs=ArraySize(tbl.m_data);
   for(int r=0; r<rs; r++)
     {
      str+=string(r)+": ";
      CSQLite3Row *row=tbl.Row(r);
      if(CheckPointer(row))
        {
         str+="----error row----\n";
         continue;
        }
      cs=ArraySize(row.m_data);
      for(int c=0; c<cs; c++)
         str+=string(row.m_data[c].GetString())+" | ";
      str+="\n";
     }
   return(str);
  }
//+------------------------------------------------------------------+