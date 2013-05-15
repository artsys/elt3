/**
	\version	0.0.0.42
	\date		2013.05.15
	\author		Morochin <artamir> Artiom
	\details	Detailed description
	\internal
		>Hist:																																										
				 @0.0.0.42@2013.05.15@artamir	[]	SQL_CloseLastHandle
				 @0.0.0.41@2013.05.15@artamir	[]	SQL_setStandartCloseDataByTI
				 @0.0.0.40@2013.05.15@artamir	[]	SQL_Init
				 @0.0.0.39@2013.05.15@artamir	[]	SQL_getColType
				 @0.0.0.38@2013.05.15@artamir	[]	SQL_setStandartDataByTI
				 @0.0.0.37@2013.05.15@artamir	[]	SQL_InitColsArray
				 @0.0.0.36@2013.05.14@artamir	[]	SQL_Select
				 @0.0.0.35@2013.05.14@artamir	[]	SQL_setStandartCloseDataByTI
				 @0.0.0.34@2013.05.14@artamir	[]	SQL_Select
				 @0.0.0.33@2013.05.14@artamir	[]	SQL_AddKeyVal
				 @0.0.0.32@2013.05.14@artamir	[]	SQL_AddKeyValOP
				 @0.0.0.31@2013.05.14@artamir	[]	sqlite_set_journal_mode
				 @0.0.0.30@2013.05.14@artamir	[]	SQL_UPDATEORINSERT
				 @0.0.0.29@2013.05.14@artamir	[+]	SQL_UpdateOrInsertByTI
				 @0.0.0.28@2013.05.14@artamir	[+]	SQL_Update v1
				 @0.0.0.27@2013.05.14@artamir	[+]	SQL_Insert v1
		>Rev:0
*/


// * SQLite interface for MT4
#import "sqlite3_wrapper.dll"	//{
int sqlite_exec (string db_fname, string sql);
int sqlite_table_exists (string db_fname, string table);
int sqlite_query (string db_fname, string sql, int& cols[]);
int sqlite_next_row (int handle);
string sqlite_get_col (int handle, int col);
int sqlite_free_query (int handle);
string sqlite_get_fname (string db_fname);
void sqlite_set_busy_timeout (int ms);
void sqlite_set_journal_mode (string mode);
#import	//}

#define SQLVER		"0.0.0.42_2013.05.15"

#define SQLSTRUC_HA		0	//Handle
#define SQLSTRUC_COLS	1	//COUNT COLS
#define SQLSTRUC_ROWS	2	//COUNT ROWS
#define SQLSTRUC_MAX	3	//MAX ROWS IN STRUC

#define	SQL_TI	0	//OrderTicket()
#define	SQL_TY	1	//OrderType()
#define	SQL_OOP	2	//OrderOpenPrice()
#define	SQL_OOT	3	//OrderOpenTime()
#define	SQL_TP	4	//OrderTakeProfit()
#define	SQL_SL	5	//OrderStopLoss()
#define	SQL_MN	6	//OrderMagicNumber()
#define	SQL_LOT	7	//OrderLots()
#define	SQL_SY	8	//OrderSymbol()
#define SQL_OP	9	//OrderProfit()
#define	SQL_IW	10	//Is in Terminal() if order is in terminal
#define	SQL_IM	11	//IsMarket() if order type is OP_BUY || OP_SELL
#define	SQL_IP	12	//IsPending() if order type >= 2
#define SQL_IC	13	//IsClosed()

//{ === Close data
#define SQL_OCT	14	//CloseTime()
#define SQL_OCP	15	//ClosePrice()
#define SQL_CM	16	//CloseMethod()
//}

//{ === Profit data
#define SQL_PIP	17	//Profit in pips
#define SQL_PID	18	//Profit in deposit curency
//}

#define SQL_MAX 19	//MAX COLS


string	SQL_DB = "";
int	SQL_Handles[];
string SQL_ColsDesc[];
string SQL_aKeyVal[];

string 	SQL_getColName_v1(int col){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.29@2013.05.14@artamir	[]	sqlite_set_journal_mode
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_getColName
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_getColName
			>Rev:0
	*/

	
	if(col == 0){
		return("TI");
	}
	
	if(col == 1){
		return("TY");
	}
	
	if(col == 2){
		return("OOP");
	}
	
	if(col == 3){
		return("OOT");
	}
	
	if(col == 4){
		return("TP");
	}
	
	if(col == 5){
		return("SL");
	}
	
	if(col == 6){
		return("MN");
	}
	
	if(col == 7){
		return("LOT");
	}
	
	if(col == 8){
		return("SY");
	}
	
	if(col == 9){
		return("OP");
	}
	
	if(col == 10){
		return("IW");
	}
	
	if(col == 11){
		return("IP");
	}
	
	if(col == 12){
		return("IM");
	}
	
	if(col == 13){
		return("IC");
	}
	
	if(col == 14){
		return("CT");
	}
	
	if(col == 15){
		return("CP");
	}
	
}

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

	string name = Struc_KeyValue_string(SQL_ColsDesc[col], "@n");
	
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

	string name = Struc_KeyValue_string(SQL_ColsDesc[col], "@t");
	
	return(name);
}


void	SQL_InitColsArray(){
	/**
		\version	0.0.0.1
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.15@artamir	[]	SQL_InitColsArray
			>Rev:0
	*/

	ArrayResize(SQL_ColsDesc, SQL_MAX);
	SQL_ColsDesc[SQL_TI]	= "@nTI@tINTEGER";
	SQL_ColsDesc[SQL_TY]	= "@nTY@tINTEGER";
	SQL_ColsDesc[SQL_OOP]	= "@nOOP@tREAL";
	SQL_ColsDesc[SQL_OOT]	= "@nOOT@tINTEGER";
	SQL_ColsDesc[SQL_TP] = "@nTP@tREAL";
	SQL_ColsDesc[SQL_SL] = "@nSL@tREAL";
	SQL_ColsDesc[SQL_MN] = "@nMN@tINTEGER";
	SQL_ColsDesc[SQL_LOT] = "@nLOT@tREAL";
	SQL_ColsDesc[SQL_SY] = "@nSY@tTEXT";
	SQL_ColsDesc[SQL_OP] = "@nOP@tREAL";
	SQL_ColsDesc[SQL_IW] = "@nIW@tINTEGER";
	SQL_ColsDesc[SQL_IM] = "@nIM@tINTEGER";
	SQL_ColsDesc[SQL_IP] = "@nIP@tINTEGER";
	SQL_ColsDesc[SQL_IC] = "@nIC@tINTEGER";
	SQL_ColsDesc[SQL_OCT] = "@nOCT@tINTEGER";
	SQL_ColsDesc[SQL_OCP] = "@nOCP@tREAL";
	SQL_ColsDesc[SQL_CM] = "@nCM@tINTEGER";
	SQL_ColsDesc[SQL_PIP] = "@nPIP@tINTEGER";
	SQL_ColsDesc[SQL_PID] = "@nPID@tREAL";
	
}

void 	SQL_AddHandle(int h){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_AddHandle
			>Rev:0
	*/
	
	int ROWS = ArrayRange(SQL_Handles, 0);
	int New_ROWS = ROWS+1;
	ArrayResize(SQL_Handles, New_ROWS);
	SQL_Handles[New_ROWS-1] = h;
}

void	SQL_CloseLastHandle(){
	/**
		\version	0.0.0.1
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.15@artamir	[]	SQL_CloseLastHandle
			>Rev:0
	*/

	int last_handle = SQL_Handles[ArrayRange(SQL_Handles,0)-1];
	sqlite_free_query(last_handle);
	int new_size = ArrayRange(SQL_Handles,0)-1;
	ArrayResize(SQL_Handles, new_size);

}

void	SQL_AddKeyVal(string key, string val){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_AddKeyVal
			>Rev:0
	*/

	int ROWS = ArrayRange(SQL_aKeyVal,0);
	int NewROWS = ROWS+1;
	int LastRow = NewROWS-1;
	ArrayResize(SQL_aKeyVal, NewROWS);
	
	SQL_aKeyVal[LastRow] = "@n"+key+"@v"+val;
}

void	SQL_AddKeyValOp(string key, string val, string op = ""){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_AddKeyValOP
			>Rev:0
	*/

	int ROWS = ArrayRange(SQL_aKeyVal,0);
	int NewROWS = ROWS+1;
	int LastRow = NewROWS-1;
	ArrayResize(SQL_aKeyVal, NewROWS);
	
	SQL_aKeyVal[LastRow] = "@n"+key+"@v"+val+"@o"+op;
}


bool	SQL_IsTableExist(string db, string table){
	/**
		\version	0.0.0.1
		\date		2013.05.07
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_IsTableExist
			>Rev:0
	*/
	
	int res = sqlite_table_exists (db, table);

    if (res < 0) {
        Print ("Check for table existence failed with code " + res);
        return (false);
    }

    return (res > 0);
}

int		SQL_Exec(string db, string exp){
	/**
		\version	0.0.0.3
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.08@artamir	[]	SQL_Exec
					 @0.0.0.2@2013.05.07@artamir	[]	SQL_Exec
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_Exec
			>Rev:0
	*/
	
	int res = sqlite_exec (db, exp);
    
    if (res != 0)
        Print ("Expression '" + exp + "' failed with code " + res);
		
	return(res);	
}

int		SQL_Query(string db, string sql, int& cols[]){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Exec sqlite query and return handle of the query
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_Query
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Query
			>Rev:0
	*/
	
	int handle = sqlite_query(db, sql, cols);
	
	SQL_AddHandle(handle);
	
	return(handle);
}

void	SQL_CheckTable(string db){
	/**
		\version	0.0.0.2
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_CheckTable
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_CheckTable
			>Rev:0
	*/

	
	if(SQL_IsTableExist(db, "OE")){
		return;
	}
	
	string q = "CREATE TABLE OE (";
	q = q + " "+SQL_getColName(0)+" INTEGER";	//TI
	q = q + ", "+SQL_getColName(1)+" INTEGER";	//TY
	q = q + ", "+SQL_getColName(2)+" REAL";		//OOP
	q = q + ", "+SQL_getColName(3)+" INTEGER";	//OOT
	q = q + ", "+SQL_getColName(4)+" REAL";		//TP
	q = q + ", "+SQL_getColName(5)+" REAL";		//SL
	q = q + ", "+SQL_getColName(6)+" INTEGER";	//MN
	q = q + ", "+SQL_getColName(7)+" REAL";		//LOT
	q = q + ", "+SQL_getColName(8)+" TEXT";		//SY
	q = q + ", "+SQL_getColName(9)+" REAL";		//OP
	q = q + ", "+SQL_getColName(10)+" INTEGER";	//** is working
	q = q + ", "+SQL_getColName(11)+" INTEGER";	//** is pending
	q = q + ", "+SQL_getColName(12)+" INTEGER";	//** is market
	q = q + ", "+SQL_getColName(13)+" INTEGER";	//** is closed
	q = q + ", "+SQL_getColName(14)+" INTEGER";	//** close time
	q = q + ", "+SQL_getColName(15)+" REAL";		//** close price
	
	q = q + ")";
	
	SQL_Exec(db, q);
		
}

void	SQL_CheckTable_v1(string db){
	/**
		\version	0.0.0.0
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	if(SQL_IsTableExist(db, "OE")) return;
	
	string q = "CREATE TABLE OE(";
	
	for(int i = 0; i < ArrayRange(SQL_ColsDesc,0); i++){
		if(i >= 1){
			q = q + ", ";
		} 
		
		q = q + SQL_getColName(i) + " " + SQL_getColType(i);
	}
	
	q = q + ")";
	
	SQL_Exec(db, q);
	
}

void	SQL_Init(){
	/**
		\version	0.0.0.3
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:			
					 @0.0.0.3@2013.05.15@artamir	[]	SQL_Init
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Main
					 @0.0.0.1@2013.05.07@artamir	[]	SQL_Main
			>Rev:0
	*/
	
	
	string _fn = EXP+"."+AccountNumber()+"."+Symbol()+"."+"OE.db";
	
	SQL_DB = TerminalPath()+"\\experts\\files\\"+_fn;
	
	SQL_InitColsArray();
	SQL_CheckTable_v1(SQL_DB);
}

void	SQL_Deinit(){
	/**
		\version	0.0.0.0
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Деинициализация SQLite
		\internal
			>Hist:
			>Rev:0
	*/

	int ROWS = ArrayRange(SQL_Handles,0);
	for(int i = 0; i<ROWS; i++){
		sqlite_free_query(SQL_Handles[i]);
	}
	
}

void	SQL_Main(){
	/**
		\version	0.0.0.0
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Вызывается на каждом тике. обновляет стандартные данные о текущих ордерах.
		\internal
			>Hist:
			>Rev:0
	*/

	for(int i = 0; i<= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		//---------------------------------
		SQL_setStandartDataByTI(OrderTicket());
	}
}

//{ === Insert / Update v0
int	SQL_Insert_v0(string& aKeyVal[][], string select = ""){
	/**
		\version	0.0.0.2
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Create new row and fill cols
					if select != "" then insert used with select
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Insert
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Insert
			>Rev:0
	*/

	int ROWS = ArrayRange(aKeyVal,0);
	int idx = 0;
	
	string q = "INSERT OR REPLACE INTO OE ";
	string q_cols = "(";
	string q_vals = "VALUES (";
	
	for(idx = 0; idx < ROWS; idx++){
		//BP("SQL_Insert", "aKeyVal["+idx+"][0] = ", aKeyVal[idx][0], "StringLen() = ", StringLen(aKeyVal[idx][0]));
		if(StringLen(aKeyVal[idx][0]) == 0) continue;
		
		if(idx >= 1){
			q_cols = q_cols + ", ";
			q_vals = q_vals + ", ";
		}
		
		q_cols = q_cols + aKeyVal[idx][0];
		q_vals = q_vals + aKeyVal[idx][1];
	}
	
	q_cols = q_cols + ")";
	q_vals = q_vals + ")";
	
	q = q + q_cols +" "+ q_vals;
	//BP("SQL_Insert","SQL_DB = ", SQL_DB);
	
	if(StringLen(select) > 0){
		q = select;
	}
	
	return(SQL_Exec(SQL_DB, q));	
}

int SQL_Update_v0(string& aKeyVal[][], string where = ""){
	/**
		\version	0.0.0.0
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/
	string q = "UPDATE OE SET ";
	string exp = "";
	
	int ROWS = ArrayRange(aKeyVal,0);
	
	for(int idx = 0; idx < ROWS; idx++){
		
		if(StringLen(aKeyVal[idx][0]) == 0) continue;
		
		if(idx > 0){
			exp = exp + ",";
		}
		
		exp = exp + aKeyVal[idx][0] +"="+ aKeyVal[idx][1];
	}
	
	q = q + exp + " WHERE " + where;
	
	return(SQL_Exec(SQL_DB, q));
}

//}

int	SQL_Insert(string& aKeyVal[], string select = ""){
	/**
		\version	0.0.1.3
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Create new row and fill cols
					if select != "" then insert used with select
		\internal
			>Hist:			
					 @0.0.1.3@2013.05.14@artamir	[]	SQL_Insert Изменился входной массив aKeyVal
					 @0.0.0.2@2013.05.08@artamir	[]	SQL_Insert
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_Insert
			>Rev:0
	*/

	int ROWS = ArrayRange(aKeyVal,0);
	int idx = 0;
	
	string q = "INSERT OR REPLACE INTO OE ";
	string q_cols = "(";
	string q_vals = "VALUES (";
	
	for(idx = 0; idx < ROWS; idx++){
		//BP("SQL_Insert", "aKeyVal["+idx+"][0] = ", aKeyVal[idx][0], "StringLen() = ", StringLen(aKeyVal[idx][0]));
		if(StringLen(aKeyVal[idx]) == 0) continue;
		
		if(idx >= 1){
			q_cols = q_cols + ", ";
			q_vals = q_vals + ", ";
		}
		
		q_cols = q_cols + Struc_KeyValue_string(aKeyVal[idx],"@n");
		q_vals = q_vals + Struc_KeyValue_string(aKeyVal[idx],"@v");
	}
	
	q_cols = q_cols + ")";
	q_vals = q_vals + ")";
	
	q = q + q_cols +" "+ q_vals;
	//BP("SQL_Insert","SQL_DB = ", SQL_DB);
	
	if(StringLen(select) > 0){
		q = select;
	}
	
	return(SQL_Exec(SQL_DB, q));	
}

int SQL_Update(string& aKeyVal[], string where = ""){
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
	string q = "UPDATE OE SET ";
	string exp = "";
	
	int ROWS = ArrayRange(aKeyVal,0);
	
	for(int idx = 0; idx < ROWS; idx++){
		
		if(StringLen(aKeyVal[idx]) == 0) continue;
		
		if(idx > 0){
			exp = exp + ",";
		}
		
		exp = exp + Struc_KeyValue_string(aKeyVal[idx],"@n") +"="+ Struc_KeyValue_string(aKeyVal[idx],"@v");
	}
	
	q = q + exp + " WHERE " + where;
	
	return(SQL_Exec(SQL_DB, q));
}

int SQL_Select(string table_name, string& awhere[], int& struc[], string free_select = ""){
	/**
		\version	0.0.0.2
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Открывает запрос по заданным параметрам
					По умолчанию возвращает все строки таблицы.
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.14@artamir	[]	SQL_Select
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_Select
			>Rev:0
	*/
	
	string select = "";
	select = select + "SELECT * FROM "+table_name+" ";
	
	int ROWS = ArrayRange(awhere, 0);
	
	if(ROWS >= 1){
		select = select + "WHERE"+" ";
		
		for(int i = 0; i < ROWS; i++){
			select = select + Struc_KeyValue_string(awhere[i], "@o")+" ";
			select = select + Struc_KeyValue_string(awhere[i], "@n")+"=";
			select = select + Struc_KeyValue_string(awhere[i], "@v")+" ";
		}
	}
	
	select = select + free_select;
	
	int cols[1];
	Print(select);
	int handle = SQL_Query(SQL_DB, select, cols);
	
	ROWS = 0;
	while(sqlite_next_row(handle) == 1){
		ROWS++;
	}
	
	struc[0] = handle;
	struc[1] = cols[0];
	struc[2] = ROWS;
	
	return(ROWS);
}

int SQL_SelectByTI(int ti /** ticket*/, int& struc[]	/** array 0 - handle 1 - row counts	*/){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Return handle of query by col TI
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_SelectByTI
			>Rev:0
	*/

	string select = "SELECT * FROM OE WHERE TI = "+ti;
	
	int cols[1];
	
	int handle = SQL_Query(SQL_DB, select, cols);
	
	int rows = 0;
	while(sqlite_next_row(handle) == 1){
		rows++;
	}
	
	struc[0] = handle;
	struc[1] = cols[0];
	struc[2] = rows;
	
	//------------------------------------
	return(rows);
}

//{ === SET STANDART DATA v0
int SQL_setStandartDataByTI_v0(int ti){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Устанавливает стандартные данные по тикету
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_setStandartDataByTI
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_setStandartDataByTI
			>Rev:0
	*/

	int struc[SQLSTRUC_MAX];
	
	if(!OrderSelect(ti, SELECT_BY_TICKET)) return(-1);
	
	int ROWS = SQL_SelectByTI(ti, struc);
	
	string aKeyVal[SQL_MAX][2];
	
	int r = -1;
	
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TI); 	aKeyVal[r][1] = OrderTicket();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TY); 	aKeyVal[r][1] = OrderType();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OOP); 	aKeyVal[r][1] = Norm_symb(OrderOpenPrice(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OOT); 	aKeyVal[r][1] = OrderOpenTime();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_TP); 	aKeyVal[r][1] = Norm_symb(OrderTakeProfit(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_SL); 	aKeyVal[r][1] = Norm_symb(OrderStopLoss(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_MN); 	aKeyVal[r][1] = OrderMagicNumber();
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_LOT); 	aKeyVal[r][1] = Norm_symb(OrderLots(), Symbol(), 2);
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_SY); 	aKeyVal[r][1] = "'"+OrderSymbol()+"'";
	r++;
	aKeyVal[r][0] = SQL_getColName(SQL_OP); 	aKeyVal[r][1] = Norm_symb(OrderProfit(), Symbol(), 2);
	
	int res = -1;
	
	if(ROWS >= 1){
		res = SQL_Update(aKeyVal, "TI="+ti);
	}else{
		res = SQL_Insert(aKeyVal);
	}
	
	Print("SQL_setStandartDataByTI res = "+res);
} 
//}

//{ === SET STANDART DATA
int SQL_setStandartDataByTI(int ti){
	/**
		\version	0.0.1.4
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Устанавливает стандартные данные по тикету
		\internal
			>Hist:				
					 @0.0.1.4@2013.05.15@artamir	[]	SQL_setStandartDataByTI
					 @0.0.1.3@2013.05.14@artamir	[]	SQL_setStandartDataByTI - Изменился входной массив SQL_Update и SQL_Insert
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_setStandartDataByTI
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_setStandartDataByTI
			>Rev:0
	*/

	int struc[SQLSTRUC_MAX];
	
	if(!OrderSelect(ti, SELECT_BY_TICKET)) return(-1);
	
	int ROWS = SQL_SelectByTI(ti, struc);
	
	ArrayResize(SQL_aKeyVal, 0);
	
	int r = -1;
	
	SQL_AddKeyVal(SQL_getColName(SQL_TI), OrderTicket());
	SQL_AddKeyVal(SQL_getColName(SQL_TY), OrderType());
	SQL_AddKeyVal(SQL_getColName(SQL_OOP), Norm_symb(OrderOpenPrice(), Symbol(), 2));
	SQL_AddKeyVal(SQL_getColName(SQL_OOT), OrderOpenTime());
	SQL_AddKeyVal(SQL_getColName(SQL_OCP), Norm_symb(OrderClosePrice(), Symbol(), 2));
	SQL_AddKeyVal(SQL_getColName(SQL_OCT), OrderCloseTime());
	SQL_AddKeyVal(SQL_getColName(SQL_TP), Norm_symb(OrderTakeProfit(), Symbol(), 2));
	SQL_AddKeyVal(SQL_getColName(SQL_SL), Norm_symb(OrderStopLoss(), Symbol(), 2));
	SQL_AddKeyVal(SQL_getColName(SQL_MN), OrderMagicNumber());
	SQL_AddKeyVal(SQL_getColName(SQL_LOT), Norm_symb(OrderLots(), Symbol(), 2));
	SQL_AddKeyVal(SQL_getColName(SQL_SY), "'"+OrderSymbol()+"'");
	SQL_AddKeyVal(SQL_getColName(SQL_OP), Norm_symb(OrderProfit(), Symbol(), 2));
	
	//{ 	=== Extra data
	SQL_AddKeyVal(SQL_getColName(SQL_IP), OI_isPendingByType(OrderType()));
	SQL_AddKeyVal(SQL_getColName(SQL_IM), OI_isMarketByType(OrderType()));
	SQL_AddKeyVal(SQL_getColName(SQL_IW), OI_isWorkedBySelected());
	SQL_AddKeyVal(SQL_getColName(SQL_IC), OI_isClosedBySelected());
	//..	=== Profit
	SQL_AddKeyVal(SQL_getColName(SQL_PIP), OI_ProfitInPipsBySelected());
	SQL_AddKeyVal(SQL_getColName(SQL_PID), OrderProfit());
	//}
	
	int res = -1;
	
	if(ROWS >= 1){
		res = SQL_Update(SQL_aKeyVal, "TI="+ti);
	}else{
		res = SQL_Insert(SQL_aKeyVal);
	}
	
	Print("SQL_setStandartDataByTI res = "+res);
} 
//}

void SQL_UpdateOrInsertByTI(int ti){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_UpdateOrInsertByTI
			>Rev:0
	*/
	
	int struc[SQLSTRUC_MAX];
	int ROWS = SQL_SelectByTI(ti, struc);
	
	if(struc[SQLSTRUC_ROWS] == 0){
		SQL_setStandartDataByTI(ti);
	}
	
	SQL_Update(SQL_aKeyVal, "TI="+ti);
	
	
}

//{ === SET STANDART CLOSE DATA
void SQL_setStandartCloseDataByTI(int ti){
	/**
		\version	0.0.0.2
		\date		2013.05.15
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.15@artamir	[]	SQL_setStandartCloseDataByTI
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_setStandartCloseDataByTI
			>Rev:0
	*/

	SQL_setStandartDataByTI(ti);
	
	//Предыдущей процедурой был выбран ордер, его и используем
	ArrayResize(SQL_aKeyVal, 0);
	SQL_AddKeyVal(SQL_getColName(SQL_OCP), DoubleToStr(OrderClosePrice(), Digits));
	SQL_AddKeyVal(SQL_getColName(SQL_OCT), OrderCloseTime());
	SQL_AddKeyVal(SQL_getColName(SQL_CM), OI_CloseMethodBySelected());
	
	int res = SQL_Update(SQL_aKeyVal, "TI="+ti);
}
//}

//{	=== TESTS
void	SQL_TESTS(){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_TESTS
			>Rev:0
	*/

	//=== INSERT OR REPLACE
		
		/*
			static int test_insert;
			if(test_insert <= 0){//
				SQL_TEST_INSERT();
				test_insert++;
			}//

			static int test_update;
			if(test_update <= 0){//
				SQL_TEST_UPDATE();
				test_update++;
			}//
			
			static int test_select;
			if(test_select <= 10){//
				SQL_TEST_SELECT();
				test_select++;
			}//
		*/
	
	static int test_updateorinsert;
	if(test_updateorinsert <= 1){
		test_updateorinsert++;
		
		SQL_TEST_UPDATEORINSERT();
	}
	
	static int test_setstandartdata;
	if(test_setstandartdata <= 1){
		test_setstandartdata++;
		
		SQL_TEST_SETSTANDARTDATA();
	}
	
	static int test_selectByTI;
	if(test_selectByTI <= 1){
		SQL_TEST_SELECTBYTI();
		test_selectByTI++;
	}
}

int SQL_TEST_INSERT(){
	/**
		\version	0.0.0.1
		\date		2013.05.08
		\author		Morochin "artamir" Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.08@artamir	[]	SQL_TEST_INSERT
			>Rev:0
	*/
	
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		string a[10][2];
		a[0][0] = "TI";
		a[0][1] = OrderTicket();
		
		//a[1][0] = "TY";
		//a[1][1] = OrderType();
		
		int res = SQL_Insert(a);
	}
}	

int SQL_TEST_UPDATE(){
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		string a[10][2];
		a[0][0] = "TY";
		a[0][1] = OrderType();
		
		a[1][0] = "LOT";
		a[1][1] = OrderLots();
		
		a[2][0] = "SY";
		a[2][1] = "'"+OrderSymbol()+"'";
		
		string where = "TI="+OrderTicket();
		
		int res = SQL_Update(a, where);
	}
}

int SQL_TEST_SELECT(){
	/**
		\version	0.0.0.0
		\date		2013.05.09
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:
			>Rev:0
	*/

	string select = "SELECT * FROM OE";
	int cols[1];
	
	int handle = sqlite_query(SQL_DB, select, cols);
	
	while(sqlite_next_row(handle) == 1){
		for(int i = 0; i < cols[0]; i++){
			Print(sqlite_get_col(handle, i));
		}
	}
	
	sqlite_free_query(handle);
}

int SQL_TEST_SELECTBYTI(){
	/**
		\version	0.0.0.2
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:		
					 @0.0.0.2@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_TEST_SELECTBYTI
			>Rev:0
	*/

	int struc[3];
	
	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		SQL_SelectByTI(OrderTicket(), struc);
		A_d_PrintArray1(struc, 0, "SelectByTI_struc");
	}
	
	SQL_SelectByTI(1234567, struc);
	A_d_PrintArray1(struc, 0, "SelectByTI_struc");

}



int SQL_TEST_SETSTANDARTDATA(){
	/**
		\version	0.0.0.1
		\date		2013.05.10
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.10@artamir	[]	SQL_TEST_SETSTANDARTDATA
			>Rev:0
	*/

	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		SQL_setStandartDataByTI(OrderTicket());
	}

}	

int SQL_TEST_UPDATEORINSERT(){
	/**
		\version	0.0.0.1
		\date		2013.05.14
		\author		Morochin <artamir> Artiom
		\details	Detailed description
		\internal
			>Hist:	
					 @0.0.0.1@2013.05.14@artamir	[]	SQL_UPDATEORINSERT
			>Rev:0
	*/

	for(int i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		
		ArrayResize(SQL_aKeyVal,0);
		
		SQL_AddKeyVal("IP", OI_isPendingByType(OrderType()));
		SQL_UpdateOrInsertByTI(OrderTicket());
	}
}
//}