	/**
		\version	0.0.0.11
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	База данных ордеров. драйвер - sqlite3
					библиотека sysSQLite.mqh должна быть прилеплена в основной программе.
					например в sysELT.mqh
		\internal
			>Hist:											
					 @0.0.0.11@2013.09.25@artamir	[]	SQL_FieldAsDouble
					 @0.0.0.10@2013.09.25@artamir	[+]	SQL_start
					 @0.0.0.9@2013.09.25@artamir	[+]	SQL_setAllOrdersData
					 @0.0.0.8@2013.09.25@artamir	[+]	SQL_setAllOrdersData
					 @0.0.0.7@2013.09.25@artamir	[+]	SQL_FieldAsInt
					 @0.0.0.6@2013.09.24@artamir	[+]	SQL_FieldAsDouble
					 @0.0.0.5@2013.09.24@artamir	[+]	SQL_FieldAsString
					 @0.0.0.4@2013.09.24@artamir	[+]	SQL_INSERT
					 @0.0.0.3@2013.09.24@artamir	[+]	SQL_getTableCreate
					 @0.0.0.2@2013.09.24@artamir	[+]	SQL_init
					 @0.0.0.1@2013.09.24@artamir	[+]	
			>Rev:0
			>TODO:
				Процедура INSERT
				Процедура UPDATE
				Процедура SELECT
	*/

#define SQLVER		"0.0.0.11_2013.09.25"

#define SQLSTRUC_HA		0	//Handle
#define SQLSTRUC_COLS	1	//COUNT COLS
#define SQLSTRUC_ROWS	2	//COUNT ROWS
#define SQLSTRUC_MAX	3	//MAX ROWS IN STRUC

//{		=== Standart order data
#define	SQL_TI	0	//OrderTicket()
#define	SQL_TY	1	//OrderType()
#define	SQL_OOP	2	//OrderOpenPrice()
#define	SQL_OOT	3	//OrderOpenTime()
#define SQL_OCP	4	//ClosePrice() - цена по которой будет закрыт ордер. Существует всегда.
#define	SQL_TP	5	//OrderTakeProfit()
#define	SQL_SL	6	//OrderStopLoss()
#define	SQL_MN	7	//OrderMagicNumber()
#define	SQL_LOT	8	//OrderLots()
#define	SQL_SY	9	//OrderSymbol()
#define SQL_OP	10	//OrderProfit()
#define	SQL_IT	11	//Is in Terminal() if order is in terminal
#define	SQL_IM	12	//IsMarket() if order type is OP_BUY || OP_SELL
#define	SQL_IP	13	//IsPending() if order type >= 2
#define SQL_IC	14	//IsClosed()

//..	=== Close data Существует после закрытия ордера.
#define SQL_OCT	15	//CloseTime() - существует после закрытия ордера.
#define SQL_CM	16	//CloseMethod()- Метод, которым был закрыт ордер.


//.. 	=== Profit data Существует всегда
#define SQL_PIP	17	//Profit in pips
#define SQL_PID	18	//Profit in deposit curency

//..	=== First open data Данные, какими был открыт ордер. Заполняется после открытия ордера.
#define	SQL_FTY	19	//First type - тип, которым был выставлен ордер.

//..
#define	SQL_AOM	20	//Autoopen method
//}

#define SQL_MAX 21	//MAX COLS


string	sSQL_DB_name = "";
int		SQL_DB = 0;		//хэндл базы данных.
int		SQL_QRY = 0;	//хэндл запроса.

int		aSQL_DB[];
string 	aSQL_Cols[];
string 	aSQL_NameVal[];
		
//{  Инициализация	
void	SQL_InitColsArray(){
	/**
		\version	0.0.0.2
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.15@artamir	[]	SQL_InitColsArray
					 @0.0.0.1@2013.05.15@artamir	[]	SQL_InitColsArray
			>Rev:0
	*/

	ArrayResize(aSQL_Cols, SQL_MAX);
	aSQL_Cols[SQL_TI]	= "@nTI@tINTEGER";
	aSQL_Cols[SQL_TY]	= "@nTY@tINTEGER";
	aSQL_Cols[SQL_OOP]	= "@nOOP@tFLOAT";
	aSQL_Cols[SQL_OOT]	= "@nOOT@tINTEGER";
	aSQL_Cols[SQL_TP]	= "@nTP@tFLOAT";
	aSQL_Cols[SQL_SL]	= "@nSL@tFLOAT";
	aSQL_Cols[SQL_MN]	= "@nMN@tINTEGER";
	aSQL_Cols[SQL_LOT]	= "@nLOT@tFLOAT";
	aSQL_Cols[SQL_SY]	= "@nSY@tTEXT";
	aSQL_Cols[SQL_OP]	= "@nOP@tREAL";
	//================
	aSQL_Cols[SQL_IT]	= "@nIT@tINTEGER";	//=1 if is in terminal
	aSQL_Cols[SQL_IM]	= "@nIM@tINTEGER";	//BUY or SELL (0,1)
	aSQL_Cols[SQL_IP]	= "@nIP@tINTEGER";	//STOP or LIMIT (2,3,4,5)
	aSQL_Cols[SQL_IC]	= "@nIC@tINTEGER";	//=1 if OCT > 0.
	//================
	aSQL_Cols[SQL_OCT]	= "@nOCT@tINTEGER";
	aSQL_Cols[SQL_OCP]	= "@nOCP@tREAL";
	aSQL_Cols[SQL_CM]	= "@nCM@tINTEGER";
	aSQL_Cols[SQL_PIP]	= "@nPIP@tFLOAT";
	aSQL_Cols[SQL_PID]	= "@nPID@tFLOAT";
	aSQL_Cols[SQL_AOM]	= "@nAOM@tINTEGER";
	aSQL_Cols[SQL_FTY]	= "@nFTY@tINTEGER";
}

//.. Приват

string SQL_getColName(int col){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_getColName
			>Rev:0
	*/

	string name = Struc_KeyValue_string(aSQL_Cols[col], "@n");
	
	return(name);
}

string SQL_getColType(int col){
	/**
		\version	0.0.0.2
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.15@artamir	[]	SQL_getColType
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_getColName
			>Rev:0
	*/

	string name = Struc_KeyValue_string(aSQL_Cols[col], "@t");
	
	return(name);
}

string SQL_getTableCreate(){
	/**
		\version	0.0.0.1
		\date		2013.09.24
		\author		Morochin <artamir> Artiom
		\details	Возвращает текст запроса создания таблицы main
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.24@artamir	[+]	SQL_getTableCreate
			>Rev:0
	*/

	string q = "CREATE TABLE main(";
	
	for(int i = 0; i < ArrayRange(aSQL_Cols,0); i++){
		if(i >= 1){
			q = q + ", ";
		} 
		
		q = q + SQL_getColName(i) + " " + SQL_getColType(i);
	}
	
	q = q + ")";

	return(q);
}



//.. Публичные
//{	    init/deinit
void SQL_init(){
	/**
		\version	0.0.0.1
		\date		2013.09.24
		\author		Morochin <artamir> Artiom
		\details	инициализация базы данных загрузка или создание таблицы main.
					вызывается при инициализации советника.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.24@artamir	[+]	SQL_init
			>Rev:0
	*/
	sSQL_DB_name = ":memory:"; //имя файла базы данных.
	SQL_DB = Sqlite_DB_Open(sSQL_DB_name); //хэндл открытой базы данных.
	Print("SQL_DB=",SQL_DB);
	SQL_InitColsArray();
	
	//написать загрузку базы из файла (LoadOrSave)
	string sTableCreate = SQL_getTableCreate();	//Получение строки запроса создания таблицы
	Sqlite_ExecSQL(SQL_DB,sTableCreate);
}

void SQL_deinit(){
	Sqlite_LoadOrSave_db(SQL_DB,"c:\\test_oe.db",1);
	Sqlite_DB_Close(SQL_DB);
}
//..    Insert/Update   
int	SQL_Insert(string select = ""){
	/**
		\version	0.0.1.3
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Create new row and fill cols
					if select != "" then insert used with select
					фиксирует массив aSQL_NameVal в таблице как новую строку.
		\internal
			>Hist:			
					 @0.0.1.3@2013.05.14@artamir	[]	SQL_Insert Изменился входной массив aKeyVal
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Insert
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Insert
			>Rev:0
	*/

	int ROWS = ArrayRange(aSQL_NameVal,0);
	int idx = 0;
	
	string q = "INSERT OR REPLACE INTO main ";
	string q_cols = "(";
	string q_vals = "VALUES (";
	
	for(idx = 0; idx < ROWS; idx++){
		if(StringLen(aSQL_NameVal[idx]) == 0) continue;
		
		if(idx >= 1){
			q_cols = q_cols + ", ";
			q_vals = q_vals + ", ";
		}
		
		q_cols = q_cols + Struc_KeyValue_string(aSQL_NameVal[idx],"@n");
		q_vals = q_vals + Struc_KeyValue_string(aSQL_NameVal[idx],"@v");
	}
	
	q_cols = q_cols + ")";
	q_vals = q_vals + ")";
	
	q = q + q_cols +" "+ q_vals;
	
	if(StringLen(select) > 0){
		q = select;
	}
	
	Sqlite_ExecSQL(SQL_DB, q);
	return(0);	
}

int SQL_Update(string where = ""){
	/**
		\version	0.0.1.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.1.1@2013.05.14@artamir	[]	SQL_Update Изменился входной массив aKeyVal
			>Rev:0
	*/
	string q = "UPDATE OR REPLACE main SET ";
	string exp = "";
	
	int ROWS = ArrayRange(aSQL_NameVal,0);
	
	for(int idx = 0; idx < ROWS; idx++){
		
		if(StringLen(aSQL_NameVal[idx]) == 0) continue;
		
		if(idx > 0){
			exp = exp + ",";
		}
		
		exp = exp + Struc_KeyValue_string(aSQL_NameVal[idx],"@n") +"="+ Struc_KeyValue_string(aSQL_NameVal[idx],"@v");
	}
	
	q = q + exp + " WHERE " + where;
	Sqlite_ExecSQL(SQL_DB, q);
	return(0);
}

void SQL_InsertOrUpdate(string where="", int ti = -1){
	/**
		\version	0.0.0.0
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	Выбирает метод добавления информации в таблицу базы данных
		\internal
			>Hist:
			>Rev:0
			Параметр where может быть представлен след. образом "TI="+OrderTicket()
			если where не задан, то выбирается вся таблица.
	*/

	string q="";
	q=q+" SELECT * FROM main ";
	
	if(StringLen(where)>0){
		q=q+" WHERE ";
		q=q+where;
	}
	
	SQL_QRY = Sqlite_Query(SQL_DB,q);
	int rows = Sqlite_RowCount(SQL_QRY);
	Sqlite_DestroyQuery(SQL_QRY);
	
	if(rows>=1){
		SQL_Update(where);
	}else{
		if(ti>-1){
			q=" INSERT INTO main (TI) VALUES ("+ti+")";
		}else{q="";}
		SQL_Insert(q);
		SQL_Update(where);
	}
}
    
void SQL_addNameVal(int i_name, string s_val=""){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Добавляет структуру name@value к массиву aSQL_NameVal
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_AddKeyVal
			>Rev:0
	*/

	int ROWS = ArrayRange(aSQL_NameVal,0);
	int NewROWS = ROWS+1;
	int LastRow = NewROWS-1;
	ArrayResize(aSQL_NameVal, NewROWS);
	
	aSQL_NameVal[LastRow] = "@n"+SQL_getColName(i_name)+"@v"+s_val;
}

//..    start()
void SQL_start(){
	/**
		\version	0.0.0.1
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	вызывается на каждом тике. Устанавливаются/обновляются данные по ордерам.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.25@artamir	[+]	SQL_start
			>Rev:0
	*/
	SQL_setAllOrdersData();
}

//..    Получение значеня поля таблицы запроса.
string SQL_FieldAsString(int query_id, int col_id /** индекс колонки из массива колонок */){
	/**
		\version	0.0.0.1
		\date		2013.09.24
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение поля таблицы результата запроса как строку.
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.24@artamir	[+]	SQL_FieldAsString
			>Rev:0
			>Пример: string sy = SQL_FieldAsString(q_id, SQL_SY); // в запросе должна быть эта колонка.
	*/

	string	sField_name = SQL_getColName(col_id);		//Получаем имя колонки по индексу ее значения в массиве колонок.
	int		iField_id	= Sqlite_FieldIndex(query_id, sField_name);	//Получаем индекс колонки в таблице результата запроса.
	string	res = "";
			res = Sqlite_FieldAsString(query_id, iField_id);		//Получаем значение поля в таблице результата запроса в виде строки. 
	return(res);
}

double SQL_FieldAsDouble(int query_id, int col_id, int addDigits = 0){
	/**
		\version	0.0.0.2
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	Возвращает значение поля таблицы результата запроса в виде реального числа.
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.25@artamir	[*]	Изменилось получение значения поля.
					 @0.0.0.1@2013.09.24@artamir	[+]	SQL_FieldAsDouble
			>Rev:0
	*/
	string fn="SQL_FieldAsDouble.";
	string	field_name = SQL_getColName(col_id);
	int		field_id = Sqlite_FieldIndex(query_id, field_name);
	double	d_res = Sqlite_FieldAsDouble(query_id, field_id);
			d_res = Norm_symb(d_res, addDigits);

	return(d_res);
}

int SQL_FieldAsInt(int qry_id, int col_id){
	/**
		\version	0.0.0.1
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.09.25@artamir	[+]	SQL_FieldAsInt
			>Rev:0
	*/

	string field_name = SQL_getColName(col_id);
	int field_id = Sqlite_FieldIndex(qry_id, field_name);
	int i_res = Sqlite_FieldAsInt(qry_id,field_id);
	return(i_res);
}

//..    Установка стандартных значений ордеров.
void SQL_setAllOrdersData(){
	/**
		\version	0.0.0.2
		\date		2013.09.25
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.09.25@artamir	[]	SQL_setAllOrdersData
					 @0.0.0.1@2013.09.25@artamir	[+]	SQL_setAllOrdersData
			>Rev:0
	*/

	int t = OrdersTotal();
	for(int i=0; i<=t; i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){continue;}
		
		ArrayResize(aSQL_NameVal,0);
		
		SQL_addNameVal(SQL_TI	, OrderTicket());
		SQL_addNameVal(SQL_TY	, OrderType());
		SQL_addNameVal(SQL_OOP	, OrderOpenPrice());
		SQL_addNameVal(SQL_OOT	, OrderOpenTime());
		SQL_addNameVal(SQL_OCP	, OrderClosePrice());
		SQL_addNameVal(SQL_TP	, OrderTakeProfit());
		SQL_addNameVal(SQL_SL	, OrderStopLoss());
		SQL_addNameVal(SQL_MN	, OrderMagicNumber());
		SQL_addNameVal(SQL_LOT	, OrderLots());
		SQL_addNameVal(SQL_SY	, "'"+OrderSymbol()+"'");
		SQL_addNameVal(SQL_OP	, OrderProfit());
		
		SQL_addNameVal(SQL_PID	, OrderProfit());
		SQL_addNameVal(SQL_PIP	, (OrderOpenPrice()-OrderClosePrice()));
		
		if(OrderCloseTime()>0){
			SQL_addNameVal(SQL_IC,1);
			SQL_addNameVal(SQL_IT,0);
		}
		
		if(OrderCloseTime()==0){
			SQL_addNameVal(SQL_IC,0);
			SQL_addNameVal(SQL_IT,1);
		}
		
		if(OrderType()==OP_BUY || OrderType()==OP_SELL){
			SQL_addNameVal(SQL_IM,1);
			SQL_addNameVal(SQL_IP,0);
		}else{
			SQL_addNameVal(SQL_IM,0);
			SQL_addNameVal(SQL_IP,1);
		}
		
		SQL_InsertOrUpdate("TI="+OrderTicket(), OrderTicket());
		
	}
}
//}
//}