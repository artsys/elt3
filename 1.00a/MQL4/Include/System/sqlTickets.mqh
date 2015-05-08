//+------------------------------------------------------------------+
//|                                                    arTickets.mqh |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property strict

//¬ызываетс€ только после инклуда sqlBase.mqh

//+------------------------------------------------------------------+
//| CLASS                                                                  |
//+------------------------------------------------------------------+
class CSqlTickets :public CSqlBase{
	protected:
		string cls;
		CRow  cols;
	public:
		string TblName;
		CSqlTickets();
		~CSqlTickets(){};
	//-----------------------------------------
	public:
		CRow InitCols(void);
	public:
		CRow SetSTD(int ti);	
	
	public:	
		void Init(void);
		void Start(void);
	
	public:
		void UpdateOrInsert(CRow &row);
		
	public:	
		void ToFile(const string file_name, const string callfrom);	
};

CSqlTickets::CSqlTickets(void){
	cls="CSqlTickets";
	TblName="tickets";
}

enum ENUM_DTY{
	ENUM_DTY_BUY=100,
	ENUM_DTY_SELL=101
};

//=====================================================================
CRow CSqlTickets::SetSTD(int ti){
	CRow row;
	if(!OrderSelect(ti,SELECT_BY_TICKET)) return(row);
	
	row.Add("TI",OrderTicket());
	row.Add("TY",OrderType());
	row.Add("MN",OrderMagicNumber());
	row.Add("OOP",OrderOpenPrice());
	row.Add("OOT",(int)OrderOpenTime());
	row.Add("SY","'"+Symbol()+"'");
	row.Add("COMM","'"+OrderComment()+"'");
	row.Add("OPR",OrderProfit()+OrderSwap()+OrderCommission());
	row.Add("IM",(OrderType()<=1)?1:0);
	row.Add("IP",(OrderType()>=2)?1:0);
	row.Add("OCP",OrderClosePrice());
	
	ENUM_DTY _dty=(OrderType()==0||OrderType()==2||OrderType()==4)?ENUM_DTY_BUY:ENUM_DTY_SELL;
	row.Add("DTY",_dty);
	int _ocp2oop=((_dty==ENUM_DTY_BUY)?(Bid-OrderOpenPrice()):(OrderOpenPrice()-Ask))/Point;
	row.Add("OCP2OOP",_ocp2oop);
	return(row);
}

//=======================================================================
CSqlTickets::UpdateOrInsert(CRow &row){
	DPRINT("-------------------");
	CSQLite3Table tbl;
	string q="";
	
	string ti=row.Get("TI");
	sql3.Query(tbl, "SELECT * FROM `"+TblName+"` WHERE `TI`="+ti);
	if(ArrayRange(tbl.m_data,0)>0){
		q="UPDATE `"+TblName+"` SET ";
		for(int i=0; i<row.Count(); i++){
			q=q+"'"+row.Get(i).Name+"'="+row.Get(i).Value;
			if(i<row.Count()-1){
				q=q+",";
			}
		}
		q=q+" WHERE `TI`="+ti;
	}else{
		q="INSERT INTO `"+TblName+"` ";
		string col_set="(";
		string val_set="(";
		for(int i=0; i<row.Count(); i++){
			col_set=col_set+"`"+row.Get(i).Name+"`";
			val_set=val_set+row.Get(i).Value;
			if(i<row.Count()-1){
				col_set=col_set+",";
				val_set=val_set+",";
			}
		}
		col_set=col_set+")";
		val_set=val_set+")";
		q=q+col_set+" VALUES "+val_set;
	}
	
	int res=sql3.Query(q);
	
	if(res!=SQLITE_DONE){
		SQLITE_ERR;
		//Print(sql3.ErrorMsg());
	}
}


//======================================================================
CRow CSqlTickets::InitCols(void){
	CRow _cols;
	_cols.Add("TI","INTEGER");
	_cols.Add("TY","INTEGER");
	_cols.Add("MN","INTEGER");
	_cols.Add("OOP","FLOAT");
	_cols.Add("OOT","INTEGER");
	_cols.Add("SY","TEXT");
	_cols.Add("COMM","TEXT");
	_cols.Add("FOOP","FLOAT");//цена по которой тикет впервые попал на рынок
	_cols.Add("OPR","FLOAT");//профит по позиции+своп
	_cols.Add("OCP","FLOAT");//÷ена закрыти€ тикета. —уществует всегда
	_cols.Add("DTY","INTEGER");//Ќаправление тикета
	_cols.Add("OCP2OOP","INTEGER");// оличество пунктов от цены до цены открыти€ ордера с учетом направлени€.
	_cols.Add("IM","INTEGER");//рыночный (бай или селл) = 1 иначе 0
	_cols.Add("IP","INTEGER");//отложенный=1 иначе 0
	_cols.Add("IC","INTEGER");//закрыт/удален=1 иначе 0
	_cols.Add("OCT","INTEGER");//¬рем€ закрыти€/удалени€ тикета
	_cols.Add("OCTY","INTEGER");//тип закрыти€ ордера. если ордер закрыт/удален.
	return(_cols);
}

//======================================================================
CSqlTickets::Init(void){
	DPRINT("--------------------");
	cols = InitCols();
	this.CreateTable(TblName,cols);
}

//=====================================================================
CSqlTickets::Start(void){
	DPRINT("--------------------");
	int t=OrdersTotal();
	sql3.Exec("BEGIN");
	for(int i=0;i<t;i++){
		if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
		
		CRow row=SetSTD(OrderTicket());
		
		UpdateOrInsert(row);	
	}
	sql3.Exec("COMMIT");
}

//======================================================================
CSqlTickets::ToFile(const string file_name, const string callfrom=""){
	CSqlBase base(this);
	base.ToFile(file_name,this.cls);
	
	Print(__FUNCTION__);
	Print("CntToFile="+CntToFile);
	CntToFile++;
	int f=FileOpen((string)CntToFile+"."+((callfrom!="")?callfrom+".":"")+"CSqlTickets.ToFile."+file_name,FILE_TXT|FILE_READ|FILE_WRITE);
	
	FileWrite(f,__FUNCTION__,"\n");
	
	string s="";
	
	//--------------------------------------------
	s="cls = "+(string)cls;
	FileWrite(f,s,"\n");

	s="TblName = "+(string)TblName;
	FileWrite(f,s,"\n");
		
	FileFlush(f);
	FileClose(f);
}

