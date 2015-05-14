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

class CQuery: public CSQLite3Base{
	public:
		string m_query;
	
	public:	
		CQuery(){};
		
		void Text(string s){
			m_query=s;
		}
		
		template<typename T>
		void SetValue(string p, T val){
			StringReplace(m_query,p,(string)val);			
		}
		
		int Run(CSQLite3Table &tbl){
			int r=-1;
			if(StringLen(m_query)>0){
				r=Query(tbl,m_query);
				if(r!=SQLITE_DONE){
					Print(ErrorMsg());
				}
			}
			return(r);
		}
		
	public:
		string CalcDbFileName(){
			string res=MQLInfoString(MQL_PROGRAM_NAME)+"."+AccountNumber()+".sqlite3";
			return(res);
		}	
		
};

void OnStart()
  {
//---
   CQuery q;
   q.Connect(q.CalcDbFileName());
   q.Text("SELECT * FROM &tbl WHERE DTY=&dty");
   q.SetValue("&tbl","Tickets");
   q.SetValue("&dty",101);
   Print(q.m_query);
   CSQLite3Table tbl;
   q.Run(tbl);
   
   Print(TablePrint(tbl));
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