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
#define ADDROW(a) ArrayResize(a,(ROWS(a)+1))
#define ADD(a,k,v) ADDROW(a); a[LAST(a)].key=k; a[LAST(a)].val=v;
#define DROP(a) ArrayResize(a,0);

class CCell: public CSQLite3Cell{};

class CRow: public CSQLite3Row{};

class CTbl: public CSQLite3Table{
	public:
		int ColCount(){
			return(ArrayRange(m_colname,0));
		}
		
		int RowCount(){
			return(ArrayRange(m_data,0));
		}
	
	public:
		string ColName(int icol){
			return(m_colname[icol]);
		}
	
		int ColName(string scol){
			int r=-1;
			for(int i=0; i<ROWS(m_colname); i++){
				if(m_colname[i]==scol){
					r=i;
					break;
				}
			}
			return(r);
		}
	
		string Cell(int irow, int icell){
			CSQLite3Row row;
			row=Row(irow);
			
			string s=row.m_data[icell].GetString();
			return(s);
		}
	
		string Cell(int irow, string scell){
			string s="";
			int cs=ArrayRange(m_colname,0);
			int icell=-1;
			for(int i=0;i<cs;i++){
				if(icell>=0){
					continue;
				}
				
				if(m_colname[i]==scell){
					icell=i;
				}
			}
			
			if(icell<0){
				return("");
			}
			
			CSQLite3Row row;
			row=Row(irow);
			
			s=row.m_data[icell].GetString();
			return(s);
		}
};

struct KeyVal{string key; string val;};

string GET(string k,KeyVal &a[]){
	string r="";
	for(int i=0;i<ROWS(a);i++){
		if(a[i].key==k){
			return(a[i].val);
		}
	}
	return(r);
}

class CQuery: public CSQLite3Base{
	public:
		string m_query;
		string m_tblname;
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
					Print(m_query);
					Print(ErrorMsg());
				}
			}
			return(r);
		}
		//------------------------------------
		int Run(){
			int r=-1;
			if(StringLen(m_query)>0){
				r=Query(m_query);
				if(r!=SQLITE_DONE){
					Print(m_query);
					Print(ErrorMsg());
				}
			}
			return(r);
		}
		
	public:
		string CalcDbFileName(){
			string res=MQLInfoString(MQL_PROGRAM_NAME)+"."+(string)AccountNumber()+".sqlite3";
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
			
			Run();
			
			return(q);
		}
		
		void Update(KeyVal &kv[]){
			int ti=GET("TI", kv);
			
			string q="UPDATE `"+m_tblname+"` SET ";
			for(int i=0; i<ROWS(kv); i++){
				q=q+"'"+kv[i].key+"'="+kv[i].val;
				if(i<ROWS(kv)-1){
					q=q+",";
				}
			}
			q=q+" WHERE `TI`="+(string)ti;
			m_query=q;
			Run();
		}
		
		void Insert(KeyVal &kv[]){
			string q="INSERT INTO `"+m_tblname+"` ";
			string col_set="(";
			string val_set="(";
			
			for(int i=0; i<ROWS(kv); i++){
				col_set=col_set+"`"+kv[i].key+"`";
				val_set=val_set+"'"+kv[i].val+"'";
				
				if(i<ROWS(kv)-1){
					col_set=col_set+",";
					val_set=val_set+",";
				}
			}
			
			col_set=col_set+")";
			val_set=val_set+")";
			q=q+col_set+" VALUES "+val_set;
			m_query=q;
			Run();
		}
		
		void UpdateOrInsert(KeyVal &kv[]){
			//должен передаваться массив ключ::значение
			//где ключ - наименование поля
			//значение - собственно и есть значение для установки.
			//для начала поиск будем производить по ключу TI
			//поэтому, значение тикета должно быть задано
			CTbl tbl;
			
			int ti=(int)GET("TI",kv);
			m_query="SELECT * FROM "+m_tblname+" WHERE TI=&ti";
			SetValue("&ti",ti);
			Run(tbl);
			
			Comment(TablePrint(tbl));
			
			string q="";
			if(ROWS(tbl.m_data)<=0){
				Insert(kv);
			}else{
				Update(kv);
			}
		}	
		
		void UpdateOrInsert(CTbl &tbl){
			Exec("BEGIN");
			KeyVal kv[];
			for(int i=0;i<tbl.RowCount();i++){
				DROP(kv);
				for(int c=0; c<tbl.ColCount(); c++){
					ADD(kv,tbl.ColName(c),tbl.Cell(i,c));
				}
				UpdateOrInsert(kv);
			}
			Exec("COMMIT");
		}
		
		void CopyTable(string tbl_from, string tbl_to){
			Text("SELECT * FROM "+tbl_from);
			CTbl tbl;
			Run(tbl);
			m_tblname=tbl_to;
			UpdateOrInsert(tbl);
		}
};

class CTickets: public CQuery{
	
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
			Run();
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
		
	public:
		void SetStdData(int ti){
			KeyVal kv[];
			
			if(!OrderSelect(ti, SELECT_BY_TICKET)) return;
			
			ADD(kv,"TI",	(string)	OrderTicket());
			ADD(kv,"TY",	(string)	OrderType());
			ADD(kv,"MN",	(string)	OrderMagicNumber());
			ADD(kv,"OOP",	(string)	OrderOpenPrice());
			ADD(kv,"OOT",	(int)		OrderOpenTime());
			ADD(kv,"SY", 				OrderSymbol());
			ADD(kv,"COMM",				OrderComment());
			ADD(kv,"OPR",	(string) (OrderProfit()+OrderSwap()+OrderCommission()));
			
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
			ADD(kv,"system_id","INT");
			CreateTable(m_tblthis,kv);
			CreateTable(m_tblold,kv);
			
			m_tblname=m_tblthis;
			CreateStdFields();
			
			m_tblname=m_tblold;
			CreateStdFields();
		}
};

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
         //continue;
        }
      cs=ArraySize(row.m_data);
      for(int c=0; c<cs; c++)
         str+=string(row.m_data[c].GetString())+" | ";
      str+="\n";
     }
   return(str);
  }