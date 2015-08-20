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
//|Структура КлючЗначение и выборка по ключу из массива                                                                  |
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
private: //--- Приватные свойства
   string            db_file;
   CSQLite           db;
   
private: //--- Приватные методы 
   bool              CheckProperty(string prop,string name="");

public:  //--- Публичные свойства 
   string            rev;              //номер ревизии в репозитарии
   
   string            tbl_tickets;
   string            tbl_tickets_old;
   string            tbl_tickets_new;

public:  //--- Конструктор и деструктор
                     CSQLite_Tickets();
                    ~CSQLite_Tickets();

   void              Start(void);
   void              UpdateClosed(void);
   void              UpdateNew(void);
   
public:  //--- Запросы
   void              Query(string q,sql_results &r[]);
   void              Exec(string q);

public:  //--- Insert & Update
   void              Insert(const string tbl, KeyVal &kv[]);
   void              Update(const string tbl, KeyVal &kv[]);
   void              UpdateOrInsert(const string tbl, KeyVal &kv[]);

public:  //--- Delete
   void              DeleteAll(const string tbl);

public:  //--- Создание таблиц и колонок
   void              CreateTable(const string tbl);

   void              CreateColumn(const string tbl,const string col,const string type="FLOAT");
   void              CreateColumns(const string tbl, KeyVal &kv[]);
   void              CreateStdColumns(const string tbl); //создает стандартные поля таблицы

public:  //--- Получение данных о таблице
   bool              IsColumnExists(const string tbl,const string col);
   void              GetTableStruct(const string tbl, KeyVal &kv[]);

public:  //--- Работа с таблицами
   void              CopyTable(const string tbl_from, const string tbl_to);
   void              PrintResult(sql_results &r[]);
public:  //--- Работа с тикетами
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
   
   //----------------------------------------------------
   CreateTable(tbl_tickets);  //создали таблицу тикетов.
   CreateStdColumns(tbl_tickets);  //создали стандартные поля таблицы
   
   //----------------------------------------------------                    
   CreateTable(tbl_tickets_new);
   CreateStdColumns(tbl_tickets_new);
   
   //----------------------------------------------------
   CreateTable(tbl_tickets_old);
   CreateStdColumns(tbl_tickets_old);                     
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
   Print(__FUNCSIG__);
   DeleteAll(tbl_tickets_new);            //Очистили таблицу текущих тикетов.
   
   KeyVal kv[];
   
   Exec("BEGIN");           //Начало транзакции заполнения таблицы текущих тикетов.
   
   for(int i=0; i<OrdersTotal(); i++){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      
      DROP(kv);
      GetStdData(OrderTicket(),kv);
      UpdateOrInsert(tbl_tickets_new, kv);
   }
   
   Exec("COMMIT");          //Запись транзакции таблицы текущих тикетов.
   
   UpdateClosed();
   UpdateNew();
   //UpdateIT();

   DeleteAll(tbl_tickets_old);
   
   CopyTable(tbl_tickets_new,tbl_tickets_old);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateClosed(void){
   Print(__FUNCSIG__);
   KeyVal kv[];
   sql_results r[];
   //Выборка тикетов, которые есть в таблице старых или в таблице тикетов и нет в таблице текущих тикетов.
   string q="SELECT TI FROM `"+tbl_tickets_old+"` WHERE (TI NOT IN (SELECT TI FROM `"+tbl_tickets_new+"`))";
			 q+=" UNION ";
			 q+="SELECT TI FROM '"+tbl_tickets+"' WHERE (IC='0' AND TI NOT IN (SELECT TI FROM `"+tbl_tickets_new+"`))";
			
	Query(q, r);
	
	//Результат будет содержать только одну колонку TI
	Exec("BEGIN");
	for(int i=0; i<ROWS(r); i++){
	   int ti=(int)r[i].value[0];
	   
	   DROP(kv);          //очищаем массив КлючЗначение
	   GetStdData(ti,kv); //собираем стандартную инфу по тикету
	   
	   UpdateOrInsert(tbl_tickets,kv); //обновляем строку, соответствующую данному тикету в таблице тикетов.
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
      
      UpdateOrInsert(tbl_tickets,kv);
   }
   Exec("COMMIT");
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Выполнение запроса с возвращением результата
//|Заодно заполняем названия колонок результата.                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Query(string q,sql_results &r[])
  {
  
   Print(__FUNCSIG__);
   db.get_array(q,r);
   
   Print(q);
   if(ROWS(r)>=0)DROP(r[0].colname);
   
   for(int i=0; i<ROWS(db.db_column_names); i++)
     {
      ADDROW(r[0].colname);
      r[0].colname[i]=db.db_column_names[i];
     }
  }


//+------------------------------------------------------------------+
//|Запрос без возврата результата. Может подходить и для Insert Update Delete                                                                   |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Exec(string q){
   Print(__FUNCSIG__);
   db.exec(q);
   //sql_results r[];
   //Query(q,r);
}

//+------------------------------------------------------------------+
//|Insert                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Insert(const string tbl, KeyVal &kv[])
  {
   string q="INSERT INTO `"+tbl+"` ";
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
   Exec(q);
  }
//+------------------------------------------------------------------+
//|Update                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Update(const string tbl, KeyVal &kv[])
  {
   int ti=(int)GET("TI",kv);

   string q="UPDATE `"+tbl+"` SET ";
   for(int i=0; i<ROWS(kv); i++)
     {
      q=q+""+kv[i].key+"='"+kv[i].val+"'";
      if(i<ROWS(kv)-1)
        {
         q=q+", ";
        }
     }
   q=q+" WHERE TI='"+(string)ti+"'";
   Exec(q);
  }
//+------------------------------------------------------------------+
//|Update or insert                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateOrInsert(const string tbl, KeyVal &kv[])
  {
//CTbl tbl;
   sql_results r[];

   int ti=(int)GET("TI",kv);
   string q="SELECT * FROM '"+tbl+"' WHERE TI="+(string)ti;

   Query(q, r);

   q="";
   if(ROWS(r)<=0)
     {
      Insert(tbl,kv);
     }else{
      Update(tbl,kv);
     }
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::DeleteAll(const string tbl){
   Print(__FUNCSIG__);
   Exec("DELETE FROM "+tbl);
}  
//+------------------------------------------------------------------+
//|Проверяет свойство на пустое значение.                                                                  |
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
//| Создает таблицу базы данных, если таблицы еще не существует.                                                                 |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateTable(const string tbl)
  {
   string q="CREATE TABLE IF NOT EXISTS "+tbl+"(_ID INT)";
   db.exec(q);
  }
//+------------------------------------------------------------------+  


//+------------------------------------------------------------------+
//|Создает новый столбец в таблице                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumn(const string tbl,const string col,const string type="FLOAT")
  {
   if(IsColumnExists(tbl, col))return;

   string q="ALTER TABLE "+tbl+" ADD COLUMN "+col+" "+type;
   Exec(q);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|Создает колонки по переданному массиву КлючЗначение                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumns(const string tbl, KeyVal &kv[])
  {
   Print(__FUNCSIG__);

   for(int i=0;i<ROWS(kv);i++)
     {
      CreateColumn(tbl, kv[i].key,kv[i].val);
     }
  }
//+------------------------------------------------------------------+
//|Создание стандартных полей таблицы                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateStdColumns(const string tbl)
  {
   Print(__FUNCSIG__);
   KeyVal kv[];
   ADD(kv,"TI","INT");  //номер тикета
   ADD(kv,"PID","INT"); //ИД позиции (группы тикетов)
   ADD(kv,"TY","INT");  //тип тикета
   ADD(kv,"LOT","FLOAT");  //лот тикета
   ADD(kv,"MN","INT");     //магик номер
   ADD(kv,"OOP","FLOAT");  //цена открытия ордера
   ADD(kv,"OOT","INT");    //время открытия ордера
   ADD(kv,"SY","TEXT");    //инструмент
   ADD(kv,"COMM","TEXT");  //комментарий
   ADD(kv,"FOOP","FLOAT"); //цена по которой ордер должен был быть открыт
   ADD(kv,"OPR","FLOAT");  //профит в валюте депозита-своп-комиссион
   ADD(kv,"OCP","FLOAT");  //цена закрытия ордера. существует всегда.
   ADD(kv,"DTY","INT");    //направление ордера. 100 - вверх, 101 - вниз
   ADD(kv,"OCP2OOP","INT");//расстояние от цены закрытия до цены открытия в пунктах
   ADD(kv,"IM","INT");     //если тикет рыночный. Бай или Селл
   ADD(kv,"IP","INT");     //если тикет отложенный
   ADD(kv,"IT","INT");     //если тикет живой. т.е. находится на вкладке терминал
   ADD(kv,"IC","INT");     //если тикет закрыт/удален
   ADD(kv,"OCT","INT");    //время закрытия тикета. 
   ADD(kv,"OCTY","INT");   //тип закрытия тикета. тп, сл или с рынка.

   CreateColumns(tbl, kv);
  }
//+------------------------------------------------------------------+
//|Проверяет если существует столбец                                                                  |
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
         res=true;
        }
     }

   return(res);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Получает данные о структуре таблицы                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::GetTableStruct(const string tbl, KeyVal &kv[])
  {
   
   sql_results r[];
   string q="PRAGMA table_info('"+tbl+"');";
   Query(q,r);
   
   for(int i=0;i<ROWS(r);i++)
     {
      ADD(kv,r[i].value[1],r[i].value[2]);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Копирует таблицу из одной в другую                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CopyTable(const string tbl_from,const string tbl_to){
   KeyVal kv[];
   string q="select * from "+tbl_from;
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
     
      UpdateOrInsert(tbl_to,kv);
   }
   Exec("COMMIT");
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::PrintResult(sql_results &r[]){
   Print(__FUNCSIG__);
   for(int i=0;i<ROWS(r);i++){
      string s="";
      for(int j=0;j<ROWS(r[i].value); j++){
         s+=r[i].value[j] +"|";
      }
      Print(s);
   }
}


//+------------------------------------------------------------------+
//|Получение стандартной инфы о тикете средствами MQL4                                                                  |
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