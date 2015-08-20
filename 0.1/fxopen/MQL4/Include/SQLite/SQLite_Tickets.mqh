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
   string            q_column_names[]; //массив имен колонок результатов запроса
   sql_results       q_results[];      //массив результатов запроса
   string            table;            //Имя текущей таблицы
   string            text;             //Текст запроса
   
   string            tbl_tickets;
   string            tbl_tickets_old;
   string            tbl_tickets_new;

public:  //--- Конструктор и деструктор
                     CSQLite_Tickets();
                    ~CSQLite_Tickets();

   void              Start(void);
   
public:  //--- Запросы
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

public:  //--- Создание таблиц и колонок
   void              CreateTable(const string tbl);
   void              CreateTable(void);

   void              CreateColumn(const string tbl,const string col,const string type="FLOAT");
   void              CreateColumn2(const string col,const string type="FLOAT");
   void              CreateColumns(KeyVal &kv[]);
   void              CreateStdColumns(void); //создает стандартные поля таблицы

public:  //--- Получение данных о таблице
   bool              IsColumnExists(const string tbl,const string col);
   
   void              GetTableStruct(KeyVal &kv[]);
   
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
   CreateTable(table);  //создали таблицу тикетов.
   CreateStdColumns();  //создали стандартные поля таблицы
   
   //----------------------------------------------------                    
   table=tbl_tickets_new;  //таблица текущих тикетов
   CreateTable(table);
   CreateStdColumns();
   
   //----------------------------------------------------
   table=tbl_tickets_old; //таблица тикетов с прошлого тика.
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
   table=tbl_tickets_new;
   DeleteAll();            //Очистили таблицу текущих тикетов.
   
   KeyVal kv[];
   
   text="BEGIN";           //Начало транзакции заполнения таблицы текущих тикетов.
   Query();
   
   for(int i=0; i<OrdersTotal(); i++){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      
      DROP(kv);
      GetStdData(OrderTicket(),kv);
      UpdateOrInsert(kv);
   }
   
   text="COMMIT";          //Запись транзакции таблицы текущих тикетов.
   Query();
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|Выполнение запроса с возвращением результата
//|Заодно заполняем названия колонок результата.                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Query(string q,sql_results &r[])
  {
   db.get_array(q,r);
   for(int i=0; i<ArraySize(db.db_column_names); i++)
     {
      ArrayResize(q_column_names,i+1);
      q_column_names[i]=db.db_column_names[i];
     }
  }

//+------------------------------------------------------------------+
//|Выполнение запроса                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Query(void)
  {
   if(!CheckProperty(text,"text"))
     {
      return;
     }

   DROP(q_results);
   Query(text,q_results);
  }

//+------------------------------------------------------------------+
//|Запрос без возврата результата. Может подходить и для Insert Update Delete                                                                   |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Exec(string q){
   db.exec(q);
}

//+------------------------------------------------------------------+
//|Должен быть предустановлен текст запроса                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::Exec(void){
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
   Query();
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
   text=q;
   Query();
  }
//+------------------------------------------------------------------+
//|Update or insert                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::UpdateOrInsert(KeyVal &kv[])
  {
//CTbl tbl;
   sql_results r;

   int ti=(int)GET("TI",kv);
   text="SELECT * FROM '"+table+"' WHERE TI="+(string)ti;
//SetValue("&ti","'"+ti+"'");
   Query();

   string q="";
   if(ROWS(q_results)<=0)
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
   
   if(!CheckProperty(table,"table"))return;
   
   text="DELETE FROM "+table;
   Query();
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
//| Создает таблицу по свойству table.                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateTable(void)
  {

   if(!CheckProperty(table,"table")) return;

   CreateTable(table);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|Создает новый столбец в таблице                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumn(const string tbl,const string col,const string type="FLOAT")
  {
   if(IsColumnExists(tbl, col))return;

   string q="ALTER TABLE "+tbl+" ADD COLUMN "+col+" "+type;
   db.exec(q);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|Создает столбец в таблице, заданной в свойстве table                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateColumn2(const string col,const string type="FLOAT")
  {
   if(!CheckProperty(table,"table")) return;

   CreateColumn(table,col,type);
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|Создает колонки по переданному массиву КлючЗначение                                                                  |
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
//|Создание стандартных полей таблицы                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::CreateStdColumns(void)
  {
   Print(__FUNCTION__);
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

   CreateColumns(kv);
  }
//+------------------------------------------------------------------+
//|Проверяет если существует столбец                                                                  |
//+------------------------------------------------------------------+
bool CSQLite_Tickets::IsColumnExists(const string tbl,const string col)
  {
   bool res=false;

   string query="PRAGMA table_info('"+tbl+"');";

   sql_results columns[];
   db.get_array(query,columns);

   for(int i=0; i<ArraySize(columns) && !res; i++)
     {
      string vals[];
      ArrayCopy(vals,columns[i].value);

      if(columns[i].value[1]==col)
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
//|Получает данные о структуре таблицы                                                                  |
//+------------------------------------------------------------------+
void CSQLite_Tickets::GetTableStruct(KeyVal &kv[])
  {
   if(!CheckProperty(table, "table")) return;

   text="PRAGMA table_info('"+table+"');";
   Query();
   for(int i=0;i<ROWS(q_results);i++)
     {
      ADD(kv,q_results[i].value[1],q_results[i].value[2]);
     }
  }
//+------------------------------------------------------------------+

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
			ADD(kv,"IC",   IntegerToString((OrderCloseTime()>0)?1:0));
			
			int _ocp2oop=(int)(((_dty==ENUM_DTY_BUY)?(Bid-OrderOpenPrice()):(OrderOpenPrice()-Ask))/Point);
			ADD(kv,"OCP2OOP",IntegerToString(_ocp2oop));
			
		}	