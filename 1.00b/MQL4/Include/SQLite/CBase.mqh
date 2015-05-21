//+------------------------------------------------------------------+
//|                                                        CBase.mqh |
//|                                                          artamir |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      "http://www.mql5.com"
#property strict

#include <SQLite\MQH\Lib\SQLite3\SQLite3Base.mqh>
#define VER ver="$Revision$"

#define ROWS(a) ArrayRange(a,0)
#define LAST(a) ROWS(a)-1
#define ADD(a) ArrayResize(a,(ROWS(a)+1))


class CCell: public CSQLite3Cell{};

class CRow: public CSQLite3Row{};

class CTbl: public CSQLite3Table{};

struct KeyVal{string key; string val;};

class CQuery: public CSQLite3Base{
	public:
		string m_query;
	public:	
		CQuery(){};
		
		//------------------------------------
		void Text(string s){
			m_query=s;
		}
		//------------------------------------
		template<typename T>
		void SetValue(string p, T val){
			StringReplace(m_query,p,(string)val);			
		}
		//------------------------------------
		int Run(CTbl &tbl){
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
		
		//-------------------------------------
		string CreateTable(string tbl_name, KeyVal &kv[]){
			string q="CREATE TABLE IF NOT EXISTS '"+tbl_name+"'(";
			for(int i=0;i<ROWS(kv);i++){
				q+="'"+kv[i].key+"' "+kv[i].val;
				if(i<LAST(kv)){
					q+=",";
				}
			}
			q+=")";
			
			m_query=q;
			
			CTbl tbl;
			Run(tbl);
			
			return(q);
		}
};

class CTickets: public CQuery{
	public:
		string m_tblname;
			
	public:	
		CTickets(){
			m_tblname="'TICKETS'";
			Connect(CalcDbFileName());
		};
		
	public:
		void Init(){
			CreateStdFields();
		}	
		
		void AddCol(string name){
			string r="ALTER TABLE "+m_tblname+" ADD COLUMN `"+name+"`";
			Text(r);
			CTbl tbl;
			Run(tbl);
		}
		
	public:
		void CreateStdFields(){
			AddCol("TI");
			AddCol("TY");
			AddCol("MN");
			AddCol("OOP");
			AddCol("OOT");
			AddCol("SY");
			AddCol("COMM");
			AddCol("FOOP");
			AddCol("OPR");
			AddCol("OCP");
			AddCol("DTY");
			AddCol("OCP2OOP");
			AddCol("IM");
			AddCol("IP");
			AddCol("IC");
			AddCol("OCT");
			AddCol("OCTY");
		}	
};		

class CEvents: public CTickets{
	public:
		string m_tblthis;
		string m_tblold;
	public:
		CEvents(){
			m_tblthis="THIS_TICKETS";
			m_tblold="OLD_TICKETS";
			Connect(CalcDbFileName());
		}
		
		void Init(){
			KeyVal kv[];
			ADD(kv);
			kv[LAST(kv)].key="system_id";
			kv[LAST(kv)].val="INT";
			CreateTable(m_tblthis,kv);
			CreateTable(m_tblold,kv);
			
			m_tblname=m_tblthis;
			CreateStdFields();
			
			m_tblname=m_tblold;
			CreateStdFields();
		}
};