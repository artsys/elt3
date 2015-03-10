//+------------------------------------------------------------------+
//|                                                     tiEvents.mqh |
//|                                                          artamir |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property link      ""
#property strict

#define E_TI	0
#define E_TY	1
#define E_OOP	2
#define E_OOT	3
#define E_OCT	4

#define E_MAX	5

string E_GetCell(CSQLite3Table &tbl, int irow, string scell){
	string s="";
	int cs=ArrayRange(tbl.m_colname,0);
	int icell=-1;
	for(int i=0;i<cs;i++){
		if(icell>=0){
			continue;
		}
		
		if(tbl.m_colname[i]==scell){
			icell=i;
		}
	}
	
	if(icell<0){
		return("");
	}
	
	CSQLite3Row row;
	row=tbl.Row(irow);
	
	s=row.m_data[icell].GetString();
	return(s);
}

class CTbl{
	private:
		CRow m_data[];
	public:
		CTbl(CTbl &tbl){
			ArrayResize(m_data,tbl.Count());
			for(int i=0; i<tbl.Count(); i++){
				m_data[i]=tbl.Get(i);
			}
		};
		CTbl(){};
		
		void operator = (CTbl &tbl){
			ArrayResize(m_data,tbl.Count());
			for(int i=0; i<tbl.Count(); i++){
				m_data[i]=tbl.Get(i);
			}
		};
	public:
		int Count(){
			return(ArrayRange(m_data,0));
		}
		
		void Add(CRow &row){
			ArrayResize(m_data,(ArrayRange(m_data,0)+1));
			int idx=ArrayRange(m_data,0)-1;
			m_data[idx]=row;
		};	
		
		CRow Get(int i){
			return(m_data[i]);
		};
};


//+------------------------------------------------------------------+
//|CLASS                                                                  |
//+------------------------------------------------------------------+
class CSqlEvents: public CSqlBase{
	private:
		string m_tblThis;
		string m_tblOld;
		CRow m_cols;
		CTbl m_rows;
		
	private:
		CTbl GetTiProps();
			
	public:
		CSqlEvents(){
			m_tblThis="EventsTiThis";
			m_tblOld="EventsTiOld";
			CSqlTickets oTi;
			m_cols=oTi.InitCols();
		};
		~CSqlEvents(){};
		
	public:
		void Init(void){
			this.CreateTable(m_tblThis,m_cols);
			this.CreateTable(m_tblOld,m_cols);
		}	
		void Start(void);
	
	public:
		void UpdateClosed();	
};

CSqlEvents::Start(void){
	m_rows=GetTiProps();
	this.DeleteAll(m_tblThis);
	
	int res=sql3.Exec("BEGIN");
	if(res!=SQLITE_DONE){
		Print(sql3.ErrorMsg());
	}
	
	for(int i=0; i<m_rows.Count();i++){
		this.UpdateOrInsert(m_tblThis, m_rows.Get(i));
	}
	
	res=sql3.Exec("COMMIT");
	if(res!=SQLITE_DONE){
		Print(sql3.ErrorMsg());
	}
	
	UpdateClosed();
}

CSqlEvents::UpdateClosed(void){
	CSQLite3Table sql_tbl;
	string q="SELECT `TI` FROM `"+m_tblOld+"` WHERE (TI NOT IN (SELECT TI FROM `"+m_tblThis+"`))";
	int res=sql3.Query(sql_tbl,q);
	if(res!=SQLITE_DONE){
		Print(sql3.ErrorMsg());
	}
	
	
	CTbl tbl;
	CSqlTickets oTi;
	
	int cr=ArrayRange(sql_tbl.m_data,0);
	for(int i=0; i<cr; i++){
		int ti=(int)E_GetCell(sql_tbl,i,"TI");
		
		if(!OrderSelect(ti,SELECT_BY_TICKET)) continue; // похорошему нужно удалить этот тикет.
		
		CRow row=oTi.SetSTD(OrderTicket());
		if(OrderCloseTime()>0){
			row.Add("IC",1);
			row.Add("OCT",OrderCloseTime());
		}
		
		tbl.Add(row);
	}
	
	int tc=tbl.Count();
	for(int i=0; i<tc; i++){
		this.UpdateOrInsert(m_tblThis,tbl.Get(i));
	}
}

CTbl CSqlEvents::GetTiProps(void){
	CTbl rows;
	CSqlTickets oTi;
	for(int i=0; i<OrdersTotal(); i++){
		if(!OrderSelect(i,SELECT_BY_POS, MODE_TRADES)) continue;
		
		CRow row=oTi.SetSTD(OrderTicket());
		rows.Add(row);
		
	}
	return(rows);
}