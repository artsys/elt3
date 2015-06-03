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

#include <SQLite\sysNormalize.mqh>
#include <SQLite\sysTrades.mqh>

#define ROWS(a) ArrayRange(a,0)
#define LAST(a) ROWS(a)-1
#define ADDROW(a) ArrayResize(a,(ROWS(a)+1))
#define ADD(a,k,v) ADDROW(a); a[LAST(a)].key=k; a[LAST(a)].val=v;
#define DROP(a) ArrayResize(a,0);

enum ENUM_DTY{
	ENUM_DTY_BUY=100,
	ENUM_DTY_SELL=101
};

enum ENUM_CLOSE_TYPE{
	ENUM_CLOSED_TYPE_MANUAL=1,
	ENUM_CLOSED_TYPE_TP=2,
	ENUM_CLOSED_TYPE_SL=3
};

class CCell: public CSQLite3Cell{};
class CRow: public CSQLite3Row{};

//+------------------------------------------------------------------+
//|CLASS Tbl                                                                  |
//+------------------------------------------------------------------+
class CTbl: public CSQLite3Table{
	public:
		//--------------------------------------------------------------
		int ColCount(){
			return(ArrayRange(m_colname,0));
		}
		
		//--------------------------------------------------------------
		int RowCount(){
			return(ArrayRange(m_data,0));
		}
	
	public:
		//--------------------------------------------------------------
		string ColName(int icol){
			return(m_colname[icol]);
		}
		
		//--------------------------------------------------------------
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
	
		//--------------------------------------------------------------	
		string Cell(int irow, int icell){
			CSQLite3Row row;
			row=Row(irow);
			
			if(ArrayRange(row.m_data,0)<=icell){
				return("ERROR");	
			}
			
			string s=row.m_data[icell].GetString();
			return(s);
		}
	
		//--------------------------------------------------------------
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

//====================================================================
struct KeyVal{string key; string val;};

//====================================================================
string GET(string k,KeyVal &a[]){
	string r="";
	for(int i=0;i<ROWS(a);i++){
		if(a[i].key==k){
			return(a[i].val);
		}
	}
	return(r);
}

//+------------------------------------------------------------------+
//|CLSASS QUERY                                                                  |
//+------------------------------------------------------------------+
class CQuery: public CSQLite3Base{
	public:
		string m_query;
		string m_tblname;
	public:	
		CQuery(){sf ef};
		
		//------------------------------------
		void Text(string s){
			sf
			m_query=s;
			DPRINT("m_query="+m_query);
			ef
		}
		
		//------------------------------------
		template<typename T>
		void SetValue(string p, T val){
			sf
			StringReplace(m_query,p,(string)val);			
			ef
		}
		
		//------------------------------------
		int Run(CTbl &tbl){
			sf
			DPRINT("m_query="+m_query);
			int r=-1;
			if(StringLen(m_query)>0){
				r=Query(tbl,m_query);
				if(r!=SQLITE_DONE){
					Print(m_query);
					Print(ErrorMsg());
				}
			}
			ef
			return(r);
		}
		
		//------------------------------------
		int Run(){
			sf
			int r=-1;
			if(StringLen(m_query)>0){
				r=Exec(m_query);
				if(r!=SQLITE_DONE){
					Print(m_query);
					Print(ErrorMsg());
				}
			}
			ef
			return(r);
		}
	
	public:
		int RowsTotal(){
			sf
			CTbl tbl;
			Text("SELECT * FROM '"+m_tblname+"'");
			Run(tbl);
			
			ef
			return(tbl.RowCount());
		}
		
	public:
		//--------------------------------------------------------------
		string CalcDbFileName(){
			sf
			string res=MQLInfoString(MQL_PROGRAM_NAME)+"."+(string)AccountNumber()+".sqlite3";
			ef
			return(res);
		}	
		
		//-------------------------------------
		string CreateTable(string tbl_name, KeyVal &kv[]){
			sf
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
			ef
			return(q);
		}
		
		//--------------------------------------------------------------
		void Update(KeyVal &kv[]){
			sf
			int ti=GET("TI", kv);
			
			string q="UPDATE `"+m_tblname+"` SET ";
			for(int i=0; i<ROWS(kv); i++){
				q=q+""+kv[i].key+"='"+kv[i].val+"'";
				if(i<ROWS(kv)-1){
					q=q+", ";
				}
			}
			q=q+" WHERE TI='"+(string)ti+"'";
			m_query=q;
			Run();
			ef
		}
		
		//--------------------------------------------------------------
		void Insert(KeyVal &kv[]){
			sf
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
			ef
		}
		
		//--------------------------------------------------------------
		void UpdateOrInsert(KeyVal &kv[]){
			//должен передаватьс€ массив ключ::значение
			//где ключ - наименование пол€
			//значение - собственно и есть значение дл€ установки.
			//дл€ начала поиск будем производить по ключу TI
			//поэтому, значение тикета должно быть задано
			sf
			CTbl tbl;
			
			int ti=(int)GET("TI",kv);
			Text("SELECT * FROM '"+m_tblname+"' WHERE TI=&ti");
			SetValue("&ti","'"+ti+"'");
			Run(tbl);
			
			DPRINT(TablePrint(tbl));
			
			string q="";
			if(ROWS(tbl.m_data)<=0){
				Insert(kv);
			}else{
				Update(kv);
			}
			ef
		}	
		
		//--------------------------------------------------------------
		void UpdateOrInsert(CTbl &tbl){
			sf
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
			ef
		}
		
		//--------------------------------------------------------------
		void CopyTable(string tbl_from, string tbl_to){
			sf
			Text("SELECT * FROM '"+tbl_from+"'");
			CTbl tbl;
			Run(tbl);
			m_tblname=tbl_to;	
			DeleteAll();
			UpdateOrInsert(tbl);
			ef
		}
		
		void DeleteAll(){
			sf
			DPRINT("m_tblname="+m_tblname);
			Text("DELETE FROM '"+m_tblname+"'");
			Run();
			DPRINT("RowsTotal()="+RowsTotal());
			ef
		}
};

class CTickets: public CQuery{
	
	public:	
		CTickets(){
			sf
			m_tblname="TICKETS";
			ef
		};
		
	public:
		void Init(){
			sf
			DPRINT("CalcDbFileName()="+CalcDbFileName());
			Connect(CalcDbFileName());
			KeyVal kv[];
			ADD(kv,"system_id","INT");
			CreateTable(m_tblname,kv);
		
			CreateStdFields();
			ef
		}	
		
		//--------------------------------------------------------------
		void AddCol(string name, string type=""){
			sf
			string r="ALTER TABLE "+m_tblname+" ADD COLUMN "+name+" "+type;
			
			Text(r);
			Run();
			ef
		}
		
	public:
		void CreateStdFields(){
			sf
			AddCol("TI","INT");
			AddCol("PID","INT");
			AddCol("TY","INT");
			AddCol("LOT","FLOAT");
			AddCol("MN","INT");
			AddCol("OOP","FLOAT");
			AddCol("OOT","INT");
			AddCol("SY","TEXT");
			AddCol("COMM","TEXT");
			AddCol("FOOP","FLOAT");
			AddCol("OPR","FLOAT");
			AddCol("OCP","FLOAT");
			AddCol("DTY","INT");
			AddCol("OCP2OOP","INT");
			AddCol("IM","INT");
			AddCol("IP","INT");
			AddCol("IT","INT");
			AddCol("IC","INT");
			AddCol("OCT","INT");
			AddCol("OCTY","INT");
			ef
		}	
		
	public:
		void GetStdData(int ti, KeyVal &kv[]){
			sf
			if(!OrderSelect(ti, SELECT_BY_TICKET)) return;
			
			ADD(kv,"TI",	(string)	OrderTicket());
			ADD(kv,"TY",	(string)	OrderType());
			ADD(kv,"LOT",	(double) OrderLots());
			ADD(kv,"MN",	(string)	OrderMagicNumber());
			ADD(kv,"OOP",	(string)	OrderOpenPrice());
			ADD(kv,"OOT",	(int)		OrderOpenTime());
			ADD(kv,"SY", 				OrderSymbol());
			ADD(kv,"COMM",				OrderComment());
			ADD(kv,"OPR",	(string) (OrderProfit()+OrderSwap()+OrderCommission()));
			ADD(kv,"OCP",	(string) OrderClosePrice());
			
			ENUM_DTY _dty=(OrderType()==0||OrderType()==2||OrderType()==4)?ENUM_DTY_BUY:ENUM_DTY_SELL;
			ADD(kv,"DTY", _dty);
			
			ADD(kv,"IM",(OrderType()<=1)?1:0);
			ADD(kv,"IP",(OrderType()>=2)?1:0);
			
			ADD(kv,"IT",(OrderCloseTime()>0)?0:1);
			ADD(kv,"IC",(OrderCloseTime()>0)?1:0);
			
			int _ocp2oop=((_dty==ENUM_DTY_BUY)?(Bid-OrderOpenPrice()):(OrderOpenPrice()-Ask))/Point;
			ADD(kv,"OCP2OOP",_ocp2oop);
			ef
		}	
		
	public:
		void UpdateITTickets(){
			CTbl tbl;
			Text("SELECT TI FROM '&tbl' WHERE IT=1");
			SetValue("&tbl",m_tblname);
			Run(tbl);
			
			KeyVal kv[];
			
			int rc=tbl.RowCount();
			for(int i=0; i<rc;i++){
				DROP(kv);
				GetStdData(tbl.Cell(i,"TI"),kv);
				UpdateOrInsert(kv);
			} 
			
			
		}	
};		

class CEvents: public CTickets{
	public:
		string m_tblthis;
		string m_tblold;
		
	public:
		bool FilterSymbol;
		bool FilterMN;
		
	public:
		CEvents(){
			sf
			m_tblthis="THIS_TICKETS";
			m_tblold="OLD_TICKETS";
			
			FilterSymbol=true;
			FilterMN=true;
			ef
		}
		
		void Init(){
			sf
			DPRINT("CalcDbFileName()="+CalcDbFileName());
			Connect(CalcDbFileName());
			KeyVal kv[];
			ADD(kv,"system_id","INT");
			CreateTable(m_tblthis,kv);
			CreateTable(m_tblold,kv);
			
			m_tblname=m_tblthis;
			CreateStdFields();
			
			m_tblname=m_tblold;
			CreateStdFields();
			ef
		}
		
		void Start(){
			sf
			m_tblname=m_tblthis;
			DeleteAll();
			
			KeyVal kv[];
			
			Exec("BEGIN");
			for(int i=0; i<OrdersTotal(); i++){
				DROP(kv);
				
				if(!OrderSelect(i, SELECT_BY_POS,MODE_TRADES)) continue;
				
				if(FilterSymbol){
					if(OrderSymbol()!=Symbol())continue;
				}
				
				if(FilterMN){
					if(OrderMagicNumber()!=TR_MN)continue;
				}
				GetStdData(OrderTicket(),kv);
				UpdateOrInsert(kv);
			}
			Exec("COMMIT");
			
			UpdateClosed();
			UpdateNew();
			//UpdateCHTY();
			m_tblname=m_tblold;
			DeleteAll();
			
			CopyTable(m_tblthis,m_tblold);
			CTickets t;
			t.UpdateITTickets();
			ef
			
		}
		
		void UpdateClosed(){
			sf
			CTickets t;
			CTbl tbl;
			string q="SELECT TI FROM `"+m_tblold+"` WHERE (TI NOT IN (SELECT TI FROM `"+m_tblthis+"`))";
			q+=" UNION ";
			q+="SELECT TI FROM '"+t.m_tblname+"' WHERE (IC='0' AND TI NOT IN (SELECT TI FROM `"+m_tblthis+"`))";
			Text(q);
			Run(tbl);
			DPRINT("tbl.RowsCount()="+tbl.RowCount());
			if(tbl.RowCount()>0){
				DPRINT(TablePrint(tbl));
			}
			
			Exec("BEGIN");
			int cr=tbl.RowCount();
			for(int i=0; i<cr; i++){
				int ti=(int)tbl.Cell(i,"TI");
				
				if(!OrderSelect(ti,SELECT_BY_TICKET)) continue; // похорошему нужно удалить этот тикет.
				
				KeyVal kv[];
				DROP(kv);
				GetStdData(OrderTicket(),kv);
	
				if(OrderCloseTime()>0){
					ADD(kv,"IC",1);
					ADD(kv,"OCT",(int)OrderCloseTime());
					
					ENUM_CLOSE_TYPE close_type;
					if(OrderClosePrice()==OrderStopLoss()){
						close_type=ENUM_CLOSED_TYPE_SL;
					}else{
						if(OrderClosePrice()==OrderTakeProfit()){
							close_type=ENUM_CLOSED_TYPE_TP;
						}else{
							close_type=ENUM_CLOSED_TYPE_MANUAL;
						}
					}
					ADD(kv,"OCTY",close_type);
				}
				
				//m_tblname=m_tblthis;
				//UpdateOrInsert(kv);
				
				m_tblname=t.m_tblname;
				UpdateOrInsert(kv);
			}
			Exec("COMMIT");
			ef
		}
		
		void UpdateNew(){
			CTickets t;
			CTbl tbl;
			string q="SELECT `TI` FROM `"+m_tblthis+"` WHERE (TI NOT IN (SELECT TI FROM `"+m_tblold+"`))";
			Text(q);
			Run(tbl);
			
			int rc=tbl.RowCount();
			for(int i=0;i<rc;i++){
				int ti=(int)tbl.Cell(i,"TI");
				
				if(!OrderSelect(ti,SELECT_BY_TICKET)) continue; // похорошему нужно удалить этот тикет.
				
				KeyVal kv[];
				DROP(kv);
				GetStdData(OrderTicket(),kv);
				
				m_tblname=t.m_tblname;
				UpdateOrInsert(kv);
			}
		}
};

//+------------------------------------------------------------------+
//|CLASS CTRADES                                                     |
//+------------------------------------------------------------------+
//»де€:
//ѕосле трейда, будет сформированный массив выставленных тикетов.
//ѕо запросу пользовател€ дл€ этих тикетов будет установлено 
//заданное пользователем значение.
//
//ѕример:
//CTrades tr;
//SendBuy(tr.d,5);	//тикеты будут выставл€тьс€ до тех пор, пока не получим заданный объем.
//t.Set("LVL",3);	//после этого дл€ всех выставленных тикетов будет установленно значение LVL=3
class CTrades :public CTickets{
	public:
		double d[]; //результат выставлени€ тикетов.
		
	public:
		void Clear(){
			DROP(d);
		}
		
		template<typename T>
		void Set(string key, T val){
			KeyVal kv[];
			
			if(ROWS(d)<=0){
				return;
			}
			
			for(int i=0;i<ROWS(d); i++){
				DROP(kv);
				ADD(kv,"TI",(int)d[i]);
				ADD(kv,key,val);
				
				//после создани€ объекта, у нас m_tblname="TICKETS"
				UpdateOrInsert(kv);
			}
		}
		
		void Set(KeyVal &pkv[]){
			KeyVal kv[];
			
			if(ROWS(d)<=0){
				return;
			}
			
			for(int i=0;i<ROWS(d); i++){
				DROP(kv);
				ADD(kv,"TI",(int)d[i]);
				for(int k=0;k<ROWS(pkv); k++){
					
					ADD(kv,pkv[k].key,pkv[k].val);
				}
				//после создани€ объекта, у нас m_tblname="TICKETS"
				UpdateOrInsert(kv);
			}
		}
		
		void SetFOOP(){
			KeyVal kv[];
			for(int i=0;i<ROWS(d);i++){
				DROP(kv);
				OrderSelect((int)d[i],SELECT_BY_TICKET);
				ADD(kv,"TI",(int)d[i]);
				ADD(kv,"FOOP",OrderOpenPrice());
				ADD(kv,"PID",(int)TimeCurrent());
				UpdateOrInsert(kv);
			}
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