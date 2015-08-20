//+------------------------------------------------------------------+
//|                                               SQLite_Tickets.mqh |
//|                                          Copyright 2015, artamir |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, artamir"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|DEFINES                                                                  |
//+------------------------------------------------------------------+
#define ROWS(a) ArrayRange(a,0)
#define LAST(a) ROWS(a)-1
#define ADDROW(a) ArrayResize(a,(ROWS(a)+1))
#define ADD(a,k,v) ADDROW(a); a[LAST(a)].key=k; a[LAST(a)].val=v;
#define DEL(a,k) int _KeyValIdx=GET_IDX(k,a);if(_KeyValIdx>=0){for(int _idx=_KeyValIdx+1;_idx<ROWS(a);_idx++){a[_idx-1].key=a[_idx].key;a[_idx-1].val=a[_idx].val;} ArrayResize(a,(ROWS(a)-1));} 
#define DROP(a) ArrayResize(a,0);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_DTY{
	ENUM_DTY_BUY=100,
	ENUM_DTY_SELL=101
};

enum ENUM_CLOSE_TYPE{
	ENUM_CLOSED_TYPE_MANUAL=1,
	ENUM_CLOSED_TYPE_TP=2,
	ENUM_CLOSED_TYPE_SL=3
};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct ProgramInfo
  {
   string            path;
   string            name;
  };
//+------------------------------------------------------------------+
//|��������� ������������ � ������� �� ����� �� �������                                                                  |
//+------------------------------------------------------------------+
struct KeyVal
  {
   string            key;
   string            val;
  };
//====================================================================
string GET(string k,KeyVal &a[])
  {
   string r="";
   for(int i=0;i<ROWS(a);i++)
     {
      if(a[i].key==k)
        {
         return(a[i].val);
        }
     }
   return(r);
  }
  
int GET_IDX(string k, KeyVal &kv[]){
   int r=-1;
   for(int i=0; i<ROWS(kv); i++){
      if(kv[i].key==k){
         return(i);
      }
   }
   
   return(r);
}  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintKV(KeyVal &kv[])
  {
   for(int i=0;i<ROWS(kv);i++)
     {
      Print(kv[i].key+"|"+kv[i].val);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetProgramInfo(ProgramInfo &r)
  {

   r.path=MQLInfoString(MQL_PROGRAM_PATH);
   r.name=MQLInfoString(MQL_PROGRAM_NAME);

  }

#include <SQLite\csqlite.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSQLite_Tickets
  {
private: //--- ��������� ��������
   string            db_file;
   CSQLite           db;
   
private: //--- ��������� ������ 
   bool              CheckProperty(string prop,string name="");

public:  //--- ��������� �������� 
   string            rev;              //����� ������� � �����������
   string            q_column_names[]; //������ ���� ������� ����������� �������
   sql_results       q_results[];      //������ ����������� �������
   string            table;            //��� ������� �������
   string            text;             //����� �������
   
   string            tbl_tickets;
   string            tbl_tickets_old;
   string            tbl_tickets_new;

public:  //--- ����������� � ����������
                     CSQLite_Tickets();
                    ~CSQLite_Tickets();

   void              Start(void);
   void              UpdateClosed(void);
   void              UpdateNew(void);
   
public:  //--- �������
   void              Query(string q,sql_results &r[]);
   void              Query(void);
   void              Exec(string q);
   void              Exec(void);

public:  //--- Insert & Update
   void              Insert(KeyVal &kv[]);
   void              Update(KeyVal &kv[]);
   void              UpdateOrInsert(KeyVal &kv[]);

public:  //--- Delete
   void              DeleteAll(void);

public:  //--- �������� ������ � �������
   void              CreateTable(const string tbl);
   void              CreateTable(void);

   void              CreateColumn(const string tbl,const string col,const string type="FLOAT");
   void              CreateColumn2(const string col,const string type="FLOAT");
   void              CreateColumns(KeyVal &kv[]);
   void              CreateStdColumns(void); //������� ����������� ���� �������

public:  //--- ��������� ������ � �������
   bool              IsColumnExists(const string tbl,const string col);
   void              GetTableStruct(KeyVal &kv[]);

public:  //--- ������ � ���������
   void              CopyTable(const string tbl_from, const string tbl_to);
   void              PrintResult(void);
   void              PrintResult(sql_results &r[]);
public:  //--- ������ � ��������
   void              GetStdData(int ti, KeyVal &kv[]);   
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSQLite_Tickets::CSQLite_Tickets()
  {
//sf
   Print(__FUNCSIG__);
   rev="$Revision$";

   ProgramInfo info;
   GetProgramInfo(info);

   db_file=info.path+"."+(string)AccountNumber()+"."+Symbol()+".sqlite3";
   db.connect(db_file);

   tbl_tickets="Tickets";
   tbl_tickets_new="Tickets_New";
   tbl_tickets_old="Tickets_Old";

   text="";
   
   //----------------------------------------------------
   table=tbl_tickets;
   CreateTable(table);  //������� ������� �������.
   CreateStdColumns();  //������� ����������� ���� �������
   
   //----------------------------------------------------                    
   table=tbl_tickets_new;  //������� ������� �������
   CreateTable(table);
   CreateStdColumns();
   
   //----------------------------------------------------
   table=tbl_tickets_old; //������� ������� � �������� ����.
   CreateTable(table);
   CreateStdColumns();                     
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSQLite_Tickets::~CSQLite_Tickets()
  {
  }


//+------------------------------------------------------------------+
//|Start                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Start(void){
   Print(__FUNCTION__);
   
   table=tbl_tickets_new;
   DeleteAll();            //�������� ������� ������� �������.
   
   KeyVal kv[];
   
   Exec("BEGIN");           //������ ���������� ���������� ������� ������� �������.
   
   for(int i=0; i<OrdersTotal(); i++){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      
      DROP(kv);
      GetStdData(OrderTicket(),kv);
      UpdateOrInsert(kv);
   }
   
   Exec("COMMIT");          //������ ���������� ������� ������� �������.
   
   UpdateClosed();
   UpdateNew();
   //UpdateIT();
   
//   db.reset();
   table=tbl_tickets_old;
   DeleteAll();
   
   text="select * from "+tbl_tickets_new;
   Query();
   
   
   CopyTable(tbl_tickets_new,tbl_tickets_old);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateClosed(void){
   Print(__FUNCSIG__);
   KeyVal kv[];
   sql_results r[];
   //������� �������, ������� ���� � ������� ������ ��� � ������� ������� � ��� � ������� ������� �������.
   string q="SELECT TI FROM `"+tbl_tickets_old+"` WHERE (TI NOT IN (SELECT TI FROM `"+tbl_tickets_new+"`))";
			 q+=" UNION ";
			 q+="SELECT TI FROM '"+tbl_tickets+"' WHERE (IC='0' AND TI NOT IN (SELECT TI FROM `"+tbl_tickets_new+"`))";
			
	Query(q, r);
	
	//��������� ����� ��������� ������ ���� ������� TI
	Exec("BEGIN");
	for(int i=0; i<ROWS(r); i++){
	   int ti=(int)r[i].value[0];
	   
	   DROP(kv);          //������� ������ ������������
	   GetStdData(ti,kv); //�������� ����������� ���� �� ������
	   
	   table=tbl_tickets;
	   UpdateOrInsert(kv); //��������� ������, ��������������� ������� ������ � ������� �������.
	}		 
	Exec("COMMIT");
}

//+------------------------------------------------------------------+
//|Update New                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateNew(){
   Print(__FUNCSIG__);
   KeyVal kv[];
   
   sql_results r[];
   string q="SELECT TI,FOOP,OOP FROM `"+tbl_tickets_new+"` WHERE (TI NOT IN (SELECT TI FROM `"+tbl_tickets_old+"`))";
   
   Query(q,r);
   
   Exec("BEGIN");
   for(int i=0;i<ROWS(r);i++){
      int ti      =(int)r[i].value[0];
      double foop =(double)r[i].value[1];
      double oop =(double)r[i].value[2];
            
      DROP(kv);
      GetStdData(ti, kv);
      
      if(foop==0){
         DEL(kv, "FOOP");
         ADD(kv,"FOOP",DoubleToStr(oop,Digits));   
      }
      
      table=tbl_tickets;
      UpdateOrInsert(kv);
   }
   Exec("COMMIT");
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|���������� ������� � ������������ ����������
//|������ ��������� �������� ������� ����������.                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Query(string q,sql_results &r[])
  {
  
   Print(__FUNCSIG__);
   db.get_array(q,r);
   
   Print(q);
   PrintResult(r);
   if(ROWS(r)>=0)DROP(r[0].colname);
   
   for(int i=0; i<ROWS(db.db_column_names); i++)
     {
      ADDROW(r[0].colname);
      r[0].colname[i]=db.db_column_names[i];
     }
  }

//+------------------------------------------------------------------+
//|���������� �������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Query(void)
  {
   Print(__FUNCSIG__);
   if(!CheckProperty(text,"text"))
     {
      return;
     }

   DROP(q_results);
   Query(text,q_results);
  }

//+------------------------------------------------------------------+
//|������ ��� �������� ����������. ����� ��������� � ��� Insert Update Delete                                                                   |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Exec(string q){
   Print(__FUNCSIG__);
   db.exec(q);
}

//+------------------------------------------------------------------+
//|������ ���� �������������� ����� �������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Exec(void){
   Print(__FUNCSIG__);
   if(!CheckProperty(text,"text")) return;
   
   Exec(text);
}

//+------------------------------------------------------------------+
//|Insert                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Insert(KeyVal &kv[])
  {
   string q="INSERT INTO `"+table+"` ";
   string col_set="(";
   string val_set="(";

   for(int i=0; i<ROWS(kv); i++)
     {
      col_set=col_set+"`"+kv[i].key+"`";
      val_set=val_set+"'"+kv[i].val+"'";

      if(i<ROWS(kv)-1)
        {
         col_set=col_set+",";
         val_set=val_set+",";
        }
     }

   col_set=col_set+")";
   val_set=val_set+")";
   q=q+col_set+" VALUES "+val_set;
   text=q;
   Exec();
  }
//+------------------------------------------------------------------+
//|Update                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Update(KeyVal &kv[])
  {
   int ti=(int)GET("TI",kv);

   string q="UPDATE `"+table+"` SET ";
   for(int i=0; i<ROWS(kv); i++)
     {
      q=q+""+kv[i].key+"='"+kv[i].val+"'";
      if(i<ROWS(kv)-1)
        {
         q=q+", ";
        }
     }
   q=q+" WHERE TI='"+(string)ti+"'";
   //text=q;
   Exec(q);
  }
//+------------------------------------------------------------------+
//|Update or insert                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateOrInsert(KeyVal &kv[])
  {
//CTbl tbl;
   sql_results r[];

   int ti=(int)GET("TI",kv);
   string q="SELECT * FROM '"+table+"' WHERE TI="+(string)ti;

   Query(q, r);

   q="";
   if(ROWS(r)<=0)
     {
      Insert(kv);
     }else{
      Update(kv);
     }
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::DeleteAll(void){
   Print(__FUNCSIG__);
   if(!CheckProperty(table,"table"))return;
  
   Exec("DELETE FROM "+table);
}  
//+------------------------------------------------------------------+
//|��������� �������� �� ������ ��������.                                                                  |
//+------------------------------------------------------------------+
bool CSQLite_Tickets::CheckProperty(string prop,string name="")
  {
   bool res=true;
   if(prop=="")
     {
      res=false;
      Print("WARNING: Property "+name+" is empty");
     }

   return(res);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| ������� ������� ���� ������, ���� ������� ��� �� ����������.                                                                 |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateTable(const string tbl)
  {
   string q="CREATE TABLE IF NOT EXISTS "+tbl+"(_ID INT)";
   db.exec(q);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//| ������� ������� �� �������� table.                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateTable(void)
  {

   if(!CheckProperty(table,"table")) return;

   CreateTable(table);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|������� ����� ������� � �������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumn(const string tbl,const string col,const string type="FLOAT")
  {
   if(IsColumnExists(tbl, col))return;

   string q="ALTER TABLE "+tbl+" ADD COLUMN "+col+" "+type;
   Exec(q);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|������� ������� � �������, �������� � �������� table                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumn2(const string col,const string type="FLOAT")
  {
   if(!CheckProperty(table,"table")) return;

   CreateColumn(table,col,type);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|������� ������� �� ����������� ������� ������������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumns(KeyVal &kv[])
  {
   Print(__FUNCTION__);
   if(!CheckProperty(table,"table"))return;

   for(int i=0;i<ROWS(kv);i++)
     {
      CreateColumn2(kv[i].key,kv[i].val);
     }
  }
//+------------------------------------------------------------------+
//|�������� ����������� ����� �������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateStdColumns(void)
  {
   Print(__FUNCTION__);
   KeyVal kv[];
   ADD(kv,"TI","INT");  //����� ������
   ADD(kv,"PID","INT"); //�� ������� (������ �������)
   ADD(kv,"TY","INT");  //��� ������
   ADD(kv,"LOT","FLOAT");  //��� ������
   ADD(kv,"MN","INT");     //����� �����
   ADD(kv,"OOP","FLOAT");  //���� �������� ������
   ADD(kv,"OOT","INT");    //����� �������� ������
   ADD(kv,"SY","TEXT");    //����������
   ADD(kv,"COMM","TEXT");  //�����������
   ADD(kv,"FOOP","FLOAT"); //���� �� ������� ����� ������ ��� ���� ������
   ADD(kv,"OPR","FLOAT");  //������ � ������ ��������-����-���������
   ADD(kv,"OCP","FLOAT");  //���� �������� ������. ���������� ������.
   ADD(kv,"DTY","INT");    //����������� ������. 100 - �����, 101 - ����
   ADD(kv,"OCP2OOP","INT");//���������� �� ���� �������� �� ���� �������� � �������
   ADD(kv,"IM","INT");     //���� ����� ��������. ��� ��� ����
   ADD(kv,"IP","INT");     //���� ����� ����������
   ADD(kv,"IT","INT");     //���� ����� �����. �.�. ��������� �� ������� ��������
   ADD(kv,"IC","INT");     //���� ����� ������/������
   ADD(kv,"OCT","INT");    //����� �������� ������. 
   ADD(kv,"OCTY","INT");   //��� �������� ������. ��, �� ��� � �����.

   CreateColumns(kv);
  }
//+------------------------------------------------------------------+
//|��������� ���� ���������� �������                                                                  |
//+------------------------------------------------------------------+
bool CSQLite_Tickets::IsColumnExists(const string tbl,const string col)
  {
   bool res=false;

   string q="PRAGMA table_info('"+tbl+"');";

   sql_results cols[];
   Query(q,cols);

   for(int i=0; i<ROWS(cols) && !res; i++)
     {
      string vals[];
      ArrayCopy(vals,cols[i].value);

      if(cols[i].value[1]==col)
        {
         string s="";
         for(int j=0;j<ROWS(vals); j++)
           {
            s+=vals[j]+"|";
           }
         Print(s);
         res=true;
        }
     }

   return(res);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|�������� ������ � ��������� �������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::GetTableStruct(KeyVal &kv[])
  {
   if(!CheckProperty(table, "table")) return;
   
   sql_results r[];
   string q="PRAGMA table_info('"+table+"');";
   Query(q,r);
   
   for(int i=0;i<ROWS(r);i++)
     {
      ADD(kv,r[i].value[1],r[i].value[2]);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|�������� ������� �� ����� � ������                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CopyTable(const string tbl_from,const string tbl_to){
   KeyVal kv[];
   string q="select * from "+tbl_from;
   text=q;
   sql_results r[];
   Query(q,r);
   
   string cols[];
   ArrayCopy(cols,r[0].colname);
   
   PrintResult(r);
   
   Exec("BEGIN");
   for(int i=0;i<ROWS(r);i++){
      DROP(kv);
      for(int j=0;j<ROWS(r[i].value);j++){
         ADD(kv, cols[j], r[i].value[j]);
      }
      table=tbl_to;
      UpdateOrInsert(kv);
   }
   Exec("COMMIT");
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::PrintResult(void){
   Print("Table : "+table);
   Print("text  : "+text);
   for(int i=0;i<ROWS(q_results);i++){
      string s="";
      for(int j=0;j<ROWS(q_results[i].value); j++){
         s+=q_results[i].value[j] +"|";
      }
      Print(s);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::PrintResult(sql_results &r[]){
   Print("Table : "+table);
   Print("text  : "+text);
   for(int i=0;i<ROWS(r);i++){
      string s="";
      for(int j=0;j<ROWS(r[i].value); j++){
         s+=r[i].value[j] +"|";
      }
      Print(s);
   }
}


//+------------------------------------------------------------------+
//|��������� ����������� ���� � ������ ���������� MQL4                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::GetStdData(int ti, KeyVal &kv[]){
			
			if(!OrderSelect(ti, SELECT_BY_TICKET)) return;
			
			ADD(kv,"TI",	(string)	OrderTicket());
			ADD(kv,"TY",	(string)	OrderType());
			ADD(kv,"LOT",	(string) OrderLots());
			ADD(kv,"MN",	(string)	OrderMagicNumber());
			ADD(kv,"OOP",	(string)	OrderOpenPrice());
			ADD(kv,"OOT",	IntegerToString((int) OrderOpenTime()));
			ADD(kv,"SY", 				OrderSymbol());
			ADD(kv,"COMM",				OrderComment());
			ADD(kv,"OPR",	(string) (OrderProfit()+OrderSwap()+OrderCommission()));
			ADD(kv,"OCP",	(string) OrderClosePrice());
			
			ENUM_DTY _dty=(OrderType()==0||OrderType()==2||OrderType()==4)?ENUM_DTY_BUY:ENUM_DTY_SELL;
			ADD(kv,"DTY",  (string) _dty);
			
			ADD(kv,"IM",   IntegerToString((OrderType()<=1)?1:0));
			ADD(kv,"IP",   IntegerToString((OrderType()>=2)?1:0));
			
			ADD(kv,"IT",   IntegerToString((OrderCloseTime()>0)?0:1));
			
			int _ocp2oop=(int)(((_dty==ENUM_DTY_BUY)?(Bid-OrderOpenPrice()):(OrderOpenPrice()-Ask))/Point);
			ADD(kv,"OCP2OOP",IntegerToString(_ocp2oop));
			
			if(OrderCloseTime()>0){
					ADD(kv,"IC","1");
					ADD(kv,"OCT",IntegerToString((int)OrderCloseTime()));
					
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
					ADD(kv,"OCTY",(string)close_type);
				}
		}	