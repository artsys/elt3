//+------------------------------------------------------------------+
//|                                                           EA.mqh |
//|                                                          artamir |
//|                                           http://forum.fxopen.ru |
//+------------------------------------------------------------------+
#property copyright "artamir"
#property strict

//====================================================================
#ifdef DEBUG
   #define DPRINT(text) Print(__FUNCTION__+" :: "+(string)text);
   #define DAIdPRINT(a,aI,text) AId_Print2(a,aI,4,__FUNCTION__+"_"+text);
   #define DAIdPRINTALL(a,text) Print("DAIdPRINTALL"); int atI[]; ArrayResize(atI,0,1000); AId_Init2(a,atI); AId_Print2(a,atI,4,__FUNCTION__+"_"+text);
#else 
   #define DPRINT(text)
   #define DAIdPRINT(a,aI,text)
   #define DAIdPRINTALL(a,text)
#endif 

#define SQLITE_ERR Print("FN:"+__FUNCTION__); Print("LN:"+__LINE__); Print("SQL_ERR:"+sql3.ErrorMsg());

//=====================================================================
string db_file_name="";
int CntToFile=0;

//=====================================================================

//+------------------------------------------------------------------+
//|CLASS                                                                  |
//+------------------------------------------------------------------+
class CCell{	
	public:
		string Name;
		string Type;
		string Value;
		
	public:	
		CCell(const CCell &cell){
			Name=cell.Name;
			Value=cell.Value;
			Type=cell.Type;
		};	
		CCell(){};
	
	void operator	=(const CCell &cell){
		Name=cell.Name;
		Value=cell.Value;
		Type=cell.Type;
	};
	
};

//+------------------------------------------------------------------+
//|CLASS                                                                  |
//+------------------------------------------------------------------+
class CRow {
	private:
		CCell m_data[];
	public:
		CRow(CRow &row){
			ArrayResize(m_data,row.Count());
			for(int i=0;i<row.Count();i++){
				m_data[i]=row.Get(i);
			}
		};
		CRow(){};
		
		void operator = (CRow &row){
			ArrayResize(m_data,row.Count());
			for(int i=0;i<row.Count();i++){
				m_data[i]=row.Get(i);
			}
		}
	public:	
		void Erase(){ArrayResize(m_data,0);}; 
		int Count(){return(ArrayRange(m_data,0));}; 
		void Add(string name, string val){
			int idx=Find(name);
			if(idx==-1){
				ArrayResize(m_data,(ArrayRange(m_data,0)+1));
				idx=ArrayRange(m_data,0)-1;
			}
			m_data[idx].Name=name;
			m_data[idx].Value=val;
		};
		
		int Find(string name){
			int res=-1;
			for(int i=0; i<ArrayRange(m_data,0);i++){
				if(m_data[i].Name==name){
					res=i;
					break;
				}
			}
			return(res);
		};	
		
		string Get(string name){
			string res="";
			int i=Find(name);
			res=m_data[i].Value;
			return(res);
		};
		
		CCell Get(int i){
			return(m_data[i]);
		}
		
};

//+------------------------------------------------------------------+
//|CLASS                                                                  |
//+------------------------------------------------------------------+
class CSqlBase{
	protected:
		string cls;
	public:
	  		string DbFileName;
	public:
			CSqlBase(){};
			CSqlBase(const CSqlBase &base);
			~CSqlBase(){};
	public:
		virtual void CreateTable(const string tbl_name, CRow &cols);
		virtual void AddColumn(const string tbl_name, const string col_name, const string col_type);
	
	public: 
		void UpdateOrInsert(const string tbl_name, CRow &row);
		void DeleteAll(const string tbl_name);
	public:
		virtual void ToFile(const string file_name, const string callfrom=""){
						Print(__FUNCTION__);
						CntToFile++;
						Print("CntToFile="+CntToFile);
						int f=FileOpen((string)CntToFile+"."+((callfrom!="")?callfrom+".":"")+"CSqlBase.ToFile."+file_name,FILE_TXT|FILE_WRITE);
						
						FileWrite(f,__FUNCTION__,"\n");
						
						string s="";
						
						//--------------------------------------------
						s="cls = "+(string)cls;
						FileWrite(f,s,"\n");
						
						s="DbFileName = "+(string)DbFileName;
						FileWrite(f,s,"\n");
						
						FileFlush(f);
						FileClose(f);
					};
						
};

//=====================================================================
CSqlBase::CSqlBase(const CSqlBase &base){
	cls="CSqlBase";
	DbFileName=base.DbFileName;
}

//=====================================================================
CSqlBase::CreateTable(const string tbl_name, CRow &cols){
	DPRINT("__________");
	string q="CREATE TABLE IF NOT EXISTS `"+tbl_name+"` (";
	for(int i=0; i<cols.Count();i++){
		q=q+"`"+cols.Get(i).Name+"` "+cols.Get(i).Value;
		
		if(i==0){
			q=q+" UNIQUE";
		}
		
		if(i<cols.Count()-1){
			q=q+",";
		}
		
	}
	q=q+")";
	
	int res=sql3.Query(q);
	if(res!=SQLITE_DONE){
		SQLITE_ERR;
		//Print(sql3.ErrorMsg());
	}
	
	//Ќа вс€кий случай проверим существование колонок
	for(int i=1;i<cols.Count();i++){
		this.AddColumn(tbl_name,cols.Get(i).Name,cols.Get(i).Value);
	}
}

//=====================================================================
CSqlBase::AddColumn(const string tbl_name, const string col_name, const string col_type="INTEGER"){
	DPRINT("_________");
	string q="ALTER TABLE `"+tbl_name+"` ADD COLUMN `"+col_name+"` "+col_type;
	int res=sql3.Query(q);
	
	if(res!=SQLITE_DONE){
		SQLITE_ERR;
		//Print(sql3.ErrorMsg());
	}
	DPRINT("res="+res);
}

//=======================================================================
CSqlBase::UpdateOrInsert(const string tbl_name, CRow &row){
	DPRINT("-------------------");
	CSQLite3Table tbl;
	string q="";
	
	string ti=row.Get("TI");
	sql3.Query(tbl, "SELECT * FROM `"+tbl_name+"` WHERE `TI`="+ti);
	if(ArrayRange(tbl.m_data,0)>0){
		q="UPDATE `"+tbl_name+"` SET ";
		for(int i=0; i<row.Count(); i++){
			q=q+"'"+row.Get(i).Name+"'="+row.Get(i).Value;
			if(i<row.Count()-1){
				q=q+",";
			}
		}
		q=q+" WHERE `TI`="+ti;
	}else{
		q="INSERT INTO `"+tbl_name+"` ";
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


CSqlBase::DeleteAll(const string tbl_name){	
	int res=sql3.Query("DELETE FROM `"+tbl_name+"`");
	
	if(res!=SQLITE_DONE){
		SQLITE_ERR;
		//Print(sql3.ErrorMsg());
	}
}

//=====================================================================
#ifndef EXP
	#define EXP MQLInfoString(MQL_PROGRAM_NAME) 
#endif

void B_Init(){
	
	db_file_name=B_GetDbFileName(EXP);
}

string B_GetDbFileName(string exp_name=""){
	string res=exp_name+"."+AccountNumber()+".sqlite3";
	return(res);
}