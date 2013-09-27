	/**
		\version	0.0.0.1
		\date		2013.09.24
		\author		Morochin <artamir> Artiom
		\details	Подключение SQLite wrapper
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.24@artamir	[+] 	
			>Rev:0
	*/

#import "SQLiteMQ4.dll" //{
double Test(double s);
double ver();
//===================
int		Sqlite_DB_Open(string db);							//открытие соединения с бд
void	Sqlite_DB_Close(int db_id);							//закрытие соединения с бд
//===================
void	Sqlite_ExecSQL(int db_id, string sql);				//Выполнить инструкцию SQL
//===================
int		Sqlite_Query(int db_id, string query);				//возвращает хэндл результата запроса.
void	Sqlite_DestroyQuery(int query_id);					//деструктор результата запроса. Вызывать перед закрытием базы.
void	EraseArray_aQR();									//Вызыват в функции старт.
//===================
bool	Sqlite_Next(int query_id);							//Перевод указателя на следующую строку результата запроса.
int		Sqlite_ColCount(int query_id);						//возвращает количество полей в запросе.
int		Sqlite_RowCount(int query_id);						//возвращает количество строк в запросе.
string	Sqlite_FieldByName(int query_id, string field_name);//возвращает значение поля заданного по имени в виде строки.
int		Sqlite_FieldIndex(int query_id, string field_name);	//возвращает индекс колонки в результате запроса.
//===================
string	Sqlite_FieldAsString(int query_id, int field_id); 	//Возвращает значение поля как строку.
int		Sqlite_FieldAsInt(int query_id, int field_id); 		//Возвращает значение поля как строку.
double	Sqlite_FieldAsDouble(int query_id, int field_id); 	//Возвращает значение поля как строку.
//===================
int		Sqlite_LoadOrSave_db(int in_memory_db_id, string file_db_name, int isSave ); //Загружает или выгружает базу из памяти в файл.
#import	 //}

