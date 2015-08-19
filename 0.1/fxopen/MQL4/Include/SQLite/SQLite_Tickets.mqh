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
void PrintKV(KeyVal &kv[]){
   for(int i=0;i<ROWS(kv);i++){
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

public:  //--- Конструктор и деструктор
                     CSQLite_Tickets();
                    ~CSQLite_Tickets();

public:  //--- Запросы
   void              Query(string q,sql_results &r[]);
   void              Query(void);

public:  //--- Insert & Update

public:  //--- Создание таблиц и колонок
   void              CreateTable(const string tbl);
   void              CreateTable(void);

   void              CreateColumn(const string tbl,const string col,const string type="FLOAT");
   void              CreateColumn2(const string col,const string type="FLOAT");
   void              CreateColumns(KeyVal &kv[]);

public:  //--- Получение данных о таблице
   bool              IsColumnExists(const string tbl,const string col);
   
   void              GetTableStruct(KeyVal &kv[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSQLite_Tickets::CSQLite_Tickets()
  {
//sf
   rev="$REVISION$";

   ProgramInfo info;
   GetProgramInfo(info);

   db_file=info.path+"."+(string)AccountNumber()+"."+Symbol()+".sqlite3";
   db.connect(db_file);

   text="";
   table="Tickets";

   CreateTable(table);
//ef
  }
//+------------------------------------------------------------------+  

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSQLite_Tickets::~CSQLite_Tickets()
  {
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
   if(!CheckProperty(table,"table"))return;
   
   for(int i=0;i<ROWS(kv);i++){
      CreateColumn2(kv[i].key, kv[i].val);
   }
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
   for(int i=0;i<ROWS(q_results);i++){
      ADD(kv,q_results[i].value[1],q_results[i].value[2]);
   }
}
//+------------------------------------------------------------------+